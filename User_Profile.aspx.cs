using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace piNews
{
  public partial class User_Profile : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      var userurl = Request.QueryString["User"];

      if (userurl != "" && Request.QueryString["confirm"] != null) { 
        var url = Server.UrlDecode(userurl);
        uc.FrontEndDebug(this, "url", string.Format("console.log('{0}');", url));
        SqlDataSource3.SelectParameters["uurl"].DefaultValue = url;
        SqlDataSource3.SelectParameters["uid"].DefaultValue = Request.QueryString["confirm"].ToString();
        Sql3.SelectParameters["uurl"].DefaultValue = url;
        Sql3.SelectParameters["uid"].DefaultValue = Request.QueryString["confirm"].ToString();
        string sql = "Select Member_Img_Id, Pinews_name, Format(Register_Time, 'yyyy-MM-dd') as Register_Time, Intro, COUNT(a.Id) as a_cnt From Member m left join Article a on m.UserId = a.Author_Email left join User_Url uu on uu.User_Id = m.Id Where uu.Url = @uurl group by Member_Img_Id, Pinews_name,Register_Time,Intro";
        string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
        using (SqlConnection con = new SqlConnection(constr))
        {
          using (SqlCommand cmd = new SqlCommand(sql, con))
          {
            con.Open();
            cmd.Parameters.AddWithValue("@uurl", url);
            using (SqlDataReader reader = cmd.ExecuteReader())
            {
              if (reader.HasRows)
              {
                reader.Read();
                if (reader["Member_Img_Id"].ToString() != "")
                  P_Img.ImageUrl = "Image.aspx?ID=" + reader["Member_Img_Id"].ToString();
                Name_L.Text = reader["Pinews_name"].ToString();
                Article_joindate.InnerText = reader["Register_Time"].ToString();
                Number_of_reports.InnerText = reader["a_cnt"].ToString();
                Intro.Text = reader["Intro"].ToString();
              }
            }
            con.Close();
          }
        }
      }
      else {
        SqlDataSource3.SelectParameters.Clear();
        SqlDataSource3.SelectCommand = @"select Title, Category, Format(DateTime, 'yyyy/MM/dd tthh:mm') AS DateTime, Status, Recommand_Category
, a.Id, Front_Img_Id, COUNT(ul.Id) as cnt from article a left join Member m on m.Id = a.User_Id
left join UserLog ul on ul.Modify_Id = a.Id and ul.Modify_Table = 'Article' and ul.Modify_Action = 'View' where m.IsAdmin = 0 and a.Status = 1
group by Title, Category, DateTime, Status, Recommand_Category, a.Id, Front_Img_Id order by DateTime Desc";

        Sql3.SelectParameters.Remove(Sql3.SelectParameters["uurl"]);
        Sql3.SelectParameters.Remove(Sql3.SelectParameters["uid"]);
        Sql3.SelectCommand = @"select Title, Category, Format(DateTime, 'yyyy/MM/dd tthh:mm') AS DateTime, Status, Recommand_Category
, a.Id, Front_Img_Id, COUNT(ul.Id) as cnt from article a left join Member m on m.Id = a.User_Id
left join UserLog ul on ul.Modify_Id = a.Id and ul.Modify_Table = 'Article' and ul.Modify_Action = 'View' where m.IsAdmin = 0 and a.Status = 1
 and (Title like '%' + @search + '%' OR Keyword like '%' + @search + '%')
group by Title, Category, DateTime, Status, Recommand_Category, a.Id, Front_Img_Id order by DateTime Desc";

        //SqlDataSource3.Select(DataSourceSelectArguments.Empty);
        ////SqlDataSource3.DataBind();
        //ListView1.DataSourceID = SqlDataSource4.ID;
        //ListView1.DataBind();
        //Sql3.DataBind();

        string sql = @"Select Member_Img_Id, Pinews_name, Format(Register_Time, 'yyyy-MM-dd') as Register_Time, Intro, COUNT(a.Id) as a_cnt 
From Member m left join Article a on m.UserId = a.Author_Email Where m.Id = @uid 
group by Member_Img_Id, Pinews_name,Register_Time,Intro";
        string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
        using (SqlConnection con = new SqlConnection(constr))
        {
          using (SqlCommand cmd = new SqlCommand(sql, con))
          {
            con.Open();
            cmd.Parameters.AddWithValue("@uid", "45");
            using (SqlDataReader reader = cmd.ExecuteReader())
            {
              if (reader.HasRows)
              {
                reader.Read();
                if (reader["Member_Img_Id"].ToString() != "")
                  P_Img.ImageUrl = "Image.aspx?ID=" + reader["Member_Img_Id"].ToString();
                Name_L.Text = reader["Pinews_name"].ToString();
                Article_joindate.InnerText = reader["Register_Time"].ToString();
                Number_of_reports.InnerText = reader["a_cnt"].ToString();
                Intro.Text = reader["Intro"].ToString();
              }
            }
            con.Close();
          }
        }

      }


      if (IsPostBack)
        ScriptManager.RegisterStartupScript(this, this.GetType(), "visit", "$('.lazy').Lazy();", true);
      uc.FrontEndDebug(this, "sql", string.Format("console.log(`{0}`);", ListView1.Items.Count));
    }

    protected void Article_Search_TextChanged(object sender, EventArgs e)
    {
      uc.FrontEndDebug(ScriptManager1, "search", string.Format("console.log('{0}');", Article_Search.Text));
//      SqlDataSource3.SelectCommand = @"SELECT Title, Category, Format(DateTime, 'yyyy/MM/dd tthh:mm') AS DateTime, Status, Recommand_Category, a.Id, Front_Img_Id, count(ul.Id) as cnt 
//FROM Article a LEFT JOIN UserLog ul on ul.Modify_Id = a.Id and ul.Modify_Table = 'Article' and ul.Modify_Action = 'View' 
//WHERE (Author_Email = @email) and (Title like '%' + @search + '%' OR Keyword like '%' + @search + '%') GROUP BY TItle,Category,DateTime,Status,Recommand_Category,a.Id,Front_Img_Id";

      //Parameter param = new Parameter("search");
      //param.Type = TypeCode.String;
      //param.Name = "search";
      //param.DefaultValue = Article_Search.Text;
      //if (SqlDataSource1.SelectParameters.Contains(param)) SqlDataSource1.SelectParameters.Remove(param);

      //SqlDataSource1.SelectParameters.Add("@search",TypeCode.String,Article_Search.Text);
      //SqlDataSource1.SelectParameters.Add(param);
      //SqlDataSource1.SelectParameters["search"].DefaultValue = Article_Search.Text;

      Sql3.SelectParameters["search"].DefaultValue = Article_Search.Text;

      ListView1.DataSourceID = Sql3.ID;
      ListView1.DataBind();
    }

    protected void Repeater2_ItemDataBound(object sender, System.Web.UI.WebControls.RepeaterItemEventArgs e)
    {
      string a = DataBinder.Eval(e.Item.DataItem, "Name").ToString();
      this.Master.Page.Title = a + " | 拍新聞";
    }
  }
}