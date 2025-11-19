using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace piNews
{
  public partial class News_Info : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      if (Session["IP"] == null)
      {
        SqlDataSource6.SelectParameters["ip"].DefaultValue = uc.UserIP();
        ListView2.DataBind();
      }
      if (Request.QueryString["article_id"] != null || RouteData.Values["ArticleId"] != null)
      {
        if (RouteData.Values["ArticleId"] != null)
        {
          SqlDataSource2.SelectParameters["Modify_Id"].DefaultValue = RouteData.Values["ArticleId"].ToString();
          //SqlDataSource4.SelectParameters["aid"].DefaultValue = RouteData.Values["ArticleId"].ToString();
          SqlDataSource6.SelectParameters["aid"].DefaultValue = RouteData.Values["ArticleId"].ToString();
          //ListView1.DataBind();
          ListView2.DataBind();
          //Follow_btn.Visible = ListView1.Items.Count <= 0;
        }
        string id = Request.QueryString["article_id"] != null ? Request.QueryString["article_id"].ToString()
          : RouteData.Values["ArticleId"] != null ? RouteData.Values["ArticleId"].ToString() : "";
        string sql = "Select * From UserLog Where Modify_Action = 'View' and Operate_User_IP = @ip and Modify_Id = @aid and cast(Operate_Time as date) = cast(GETDATE() as date)";
        string[] param = { "@ip", "@aid" };
        string[] value = { uc.UserIP(), id };
        if (!uc.PiNewsHasRow(sql, param, value))
        {
          if (Session["User_Id"] == null)
            uc.UserLog("Article", id, "View", "瀏覽文章", "", uc.UserIP());
          else
            uc.UserLog("Article", id, "View", "瀏覽文章", Session["User_Id"].ToString(), Session["IP"].ToString());

          string q = @"if not exists (select * from Article_View where date = format(GETDATE(), 'yyyy/MM/dd') and Id = @aid)
begin
insert into Article_View
select Id, t, sum(case when u is null then 1 else 0 end) as v_cnt, sum(case when u is null then 0 else 1 end) u_cnt from
(select distinct a.Id, ul.Operate_User_IP as 'v', FORMAT(ul.Operate_Time, 'yyyy/MM/dd') as t from Article a 
left join UserLog ul on ul.Modify_Id = a.Id and ul.Modify_Table = 'Article' and ul.Modify_Action = 'View'
where Format(ul.Operate_Time, 'yyyy/MM/dd') = Format(GETDATE(), 'yyyy/MM/dd') and a.Id = @aid
)p left join (Select distinct u.Operate_User_IP as 'u' from Member m left join UserLog u on u.Operate_User_Id = m.Id 
and u.Modify_Action = 'Login') o on o.u = p.v group by t, Id
end
else 
begin
update Article_View set [visitor] = v_cnt,  [user] = u_cnt 
from (select Id, t, sum(case when u is null then 1 else 0 end) as v_cnt, sum(case when u is null then 0 else 1 end) u_cnt from
(select distinct a.Id, ul.Operate_User_IP as 'v', FORMAT(ul.Operate_Time, 'yyyy/MM/dd') as t from Article a 
left join UserLog ul on ul.Modify_Id = a.Id and ul.Modify_Table = 'Article' and ul.Modify_Action = 'View'
where Format(ul.Operate_Time, 'yyyy/MM/dd') = Format(GETDATE(), 'yyyy/MM/dd') and a.Id = @aid
)p left join (Select distinct u.Operate_User_IP as 'u' from Member m left join UserLog u on u.Operate_User_Id = m.Id 
and u.Modify_Action = 'Login') o on o.u = p.v group by t, Id) f where Article_View.id = f.Id and Article_View.date = f.t
end";
          string[] n = { "@aid" };
          string[] v = { id };

          uc.PiNewsSql(q, n, v);
        }
        string uid = "";
        string query = @"Select Keyword, Content, a.Front_Img_Id, Title ,m.Member_Img_Id, m.Pinews_name, m.Name ,m.Register_Time, m.Id as User_Id, uu.Url, a.Description, m.isAdmin
from Article a 
left join User_Url uu on uu.User_Id = a.User_Id
left join Member m on m.UserId = a.Author_Email  where a.Id = @id";
        string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
        using (SqlConnection con = new SqlConnection(constr))
        {
          using (SqlCommand cmd = new SqlCommand(query, con))
          {
            con.Open();

            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@id", id);

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
              if (reader.HasRows)
              {
                reader.Read();
                DateTime oDate = Convert.ToDateTime(reader["Register_Time"].ToString());
                //this.Master.Page.Title = HttpUtility.HtmlDecode(reader["Title"].ToString()) + " | 拍新聞";
                ((HiddenField)Master.FindControl("ContentPageTitle_HF")).Value = HttpUtility.HtmlDecode(reader["Title"].ToString()) + " | ";
                og_title.Attributes.Add("content", HttpUtility.HtmlDecode(reader["Title"].ToString()));
                Title_Label.Text = HttpUtility.HtmlDecode(reader["Title"].ToString());
                ((HtmlMeta)Master.FindControl("og_description")).Attributes.Add("content", HttpUtility.HtmlDecode(reader["Description"].ToString()));
                ((HtmlMeta)Master.FindControl("description")).Attributes.Add("content", HttpUtility.HtmlDecode(reader["Description"].ToString()));
                og_img.Attributes.Add("content", string.Format("{0}://{1}/", Request.Url.Scheme, Request.Url.Authority) + "Image.aspx?ID=" + reader["Front_Img_Id"].ToString());
                Front_Image.ImageUrl = "Image.aspx?ID=" + reader["Front_Img_Id"].ToString();
                Article_Img.ImageUrl = "Image.aspx?ID=" + reader["Member_Img_Id"].ToString();
                Article_name.InnerHtml = reader["isAdmin"].Equals(false) ? "拍新聞聯合採訪中心" : reader["Pinews_name"].ToString();
                Article_name.HRef = reader["isAdmin"].Equals(false) ?  "FanPost":string.Format("User_Profile.aspx?User={0}&confirm={1}", reader["Url"].ToString(), reader["User_Id"].ToString());
                if (reader["isAdmin"].Equals(false))
                {
                  fan_post_tag.Text = string.Format("由拍粉 {0} 投稿", reader["Pinews_name"].ToString());
                  Article_joindate.Visible = false;
                }
                Article_joindate.InnerText = oDate.Year + "-" + oDate.Month + "-" + oDate.Day + "加入拍新聞";
                Content_Literal.Text = HttpUtility.HtmlDecode(reader["Content"].ToString());
                keyword.Attributes.Add("content", reader["Keyword"].ToString());
                news_keyword.Attributes.Add("content", reader["Keyword"].ToString());
                Keyword_Repeater.DataSource = reader["Keyword"].ToString().Split(',');
                Keyword_Repeater.DataBind();
                uid = reader["User_id"].ToString();
              }
              else
              {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "show error", "$('.ui.form').form('add errors', {account: '帳號或密碼錯誤'})", true);
              }
            }
            con.Close();
          }
        }
        string query2 = "select COUNT(*) as Number_of_reports from Member m left join Article a on m.Id = a.User_Id where m.Id = @id and a.status = '1'";
        using (SqlConnection con = new SqlConnection(constr))
        {
          using (SqlCommand cmd = new SqlCommand(query2, con))
          {
            con.Open();

            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@id", uid);

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
              if (reader.HasRows)
              {
                reader.Read();
                Number_of_reports.InnerHtml = reader["Number_of_reports"].ToString();
              }
            }
            con.Close();
          }
        }
      }
      else Response.Redirect("/News/1");
    }

    //protected void Follow_btn_Click(object sender, EventArgs e)
    //{
    //  uc.FrontEndDebug(UpdatePanel1, "follow start", "console.log('follow');");
    //  string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
    //  string query2 = "Select User_Id From Article Where Id = @aid";
    //  string auid = "";
    //  using (SqlConnection con = new SqlConnection(constr))
    //  {
    //    using (SqlCommand cmd = new SqlCommand(query2, con))
    //    {
    //      con.Open();
    //      string aid = Request.QueryString["article_Id"] == null ? (RouteData.Values["ArticleId"] == null ? "" 
    //        : RouteData.Values["ArticleId"].ToString()) : Request.QueryString["article_Id"].ToString();
          
    //      cmd.Parameters.Clear();
    //      cmd.Parameters.AddWithValue("@aid", aid);

    //      using (SqlDataReader reader = cmd.ExecuteReader())
    //      {
    //        if (reader.HasRows)
    //        {
    //          reader.Read();
    //          auid = reader["User_Id"].ToString();
    //        }
    //      }
    //      con.Close();
    //    }
    //  }
    //  if (auid != "" && Session["User_Id"] != null)
    //    uc.UserLog("Member", auid, "follow", "追蹤" + Article_name.InnerText, Session["User_Id"].ToString(), Session["IP"].ToString());

    //  if (Session["User_Id"] == null)
    //  {
    //    uc.FrontEndDebug(this, "err", "console.log('請登入後再使用追蹤功能');");
    //    Response.Redirect("Login.aspx");
    //  }
    //  uc.FrontEndDebug(this, "follow err", string.Format("console.log('{0}, {1}');", auid, Session["User_Id"] == null));
    //  SqlDataSource4.SelectParameters["aid"].DefaultValue = RouteData.Values["ArticleId"].ToString();
    //  ListView1.DataBind();
    //  Follow_btn.Visible = false;
    //}

    //protected void ListView1_ItemCommand(object sender, System.Web.UI.WebControls.ListViewCommandEventArgs e)
    //{
    //  if (e.CommandName == "Unfollow")
    //  {
    //    uc.UserLog("Member", ListView1.DataKeys[e.Item.DataItemIndex].Values["User_Id"].ToString(), "unfollow", "取消追蹤" + Article_name.InnerText, Session["User_Id"].ToString(), Session["IP"].ToString());
    //    Follow_btn.Visible = true;
    //  }
    //  ListView1.DataBind();
    //}


    protected void ListView2_ItemCommand(object sender, System.Web.UI.WebControls.ListViewCommandEventArgs e)
    {
      string aid = Request.QueryString["article_id"] != null ? Request.QueryString["article_id"].ToString() : "";
      if (RouteData.Values["ArticleId"] != null) aid = RouteData.Values["ArticleId"].ToString();
      if (e.CommandName == "likely")
      {
        if (ListView2.DataKeys[e.Item.DataItemIndex].Values["ip"].ToString() == "0")
          uc.UserLog("Article", aid, "like", "喜歡文章", Session["User_Id"] != null ? Session["User_Id"].ToString() : "", uc.UserIP());
        else uc.UserLog("Article", aid, "unlike", "取消喜歡文章", Session["User_Id"] != null ? Session["User_Id"].ToString() : "", uc.UserIP());
      }
      ListView2.DataBind();
    }

    //protected void ListView1_ItemDataBound(object sender, ListViewItemEventArgs e)
    //{
    //  LinkButton f_btn = (LinkButton)e.Item.FindControl("Follow_btn1");
    //  f_btn.Visible = false;
    //  f_btn.CssClass += 
    //    ListView1.DataKeys[e.Item.DataItemIndex].Values["Modify_Action"].Equals("unfollow") ? "":" hidden";
    //}
  }
}