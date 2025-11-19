using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace piNews
{
  public partial class Admin : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      if (Session["User_Id"] == null || Session["IsAdmin"] == null) Response.Redirect("Default.aspx");
      if (Session["Email"] == null)
        ScriptManager.RegisterStartupScript(this, this.GetType(), "session error", string.Format("alert('Session error');"), true);

      this.Master.Page.Title = "個人專頁總覽 | 拍新聞";

      string script = /*string.Format("v30chart.data = {0};", gen30dayVisit())*/ ""
        + string.Format("createv7Line('訪站人次', {0}, colors.getIndex(1));createv7Pie({1},  colors.getIndex(1));", gen7dayVisitLine(14), gen7dayVisitPie(14))//;
        + string.Format("createv7Line('文章總瀏覽人次', {0}, colors.getIndex(1));createv7Pie({1},  colors.getIndex(1));", gen7dayViewLine(14), gen7dayViewPie(14));
      string sql = "Select Member_Img_Id, Pinews_name, Format(Register_Time, 'yyyy-MM-dd') as Register_Time, Intro, COUNT(a.Id) as a_cnt From Member m left join Article a on m.UserId = a.Author_Email Where m.Id = @uid group by Member_Img_Id, Pinews_name,Register_Time,Intro";
      string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
      using (SqlConnection con = new SqlConnection(constr))
      {
        using (SqlCommand cmd = new SqlCommand(sql, con))
        {
          con.Open();
          cmd.Parameters.AddWithValue("@uid", Session["User_Id"].ToString());
          using (SqlDataReader reader = cmd.ExecuteReader())
          { 
            if (reader.HasRows)
            {
              reader.Read();

              if (reader["Member_Img_Id"].ToString() != "")
                P_Img.ImageUrl = "Image.aspx?ID="+reader["Member_Img_Id"].ToString();
              Name_L.Text = reader["Pinews_name"].ToString();
              Article_joindate.InnerText = reader["Register_Time"].ToString();
              Number_of_reports.InnerText = reader["a_cnt"].ToString();
              Intro.Text = reader["Intro"].ToString();
            }
          }
          con.Close();
        }
      }
      if (!IsPostBack)
        ScriptManager.RegisterStartupScript(this, this.GetType(), "visit site", script, true);
      else ScriptManager.RegisterStartupScript(this, this.GetType(), "visit", "$('.lazy').Lazy();", true);
    }

    public string gen30dayVisit()
    {
      DataTable dt = new DataTable();
      string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
      using (SqlConnection con = new SqlConnection(constr))
      {
        string sql = "select FORMAT(Operate_Time, 'yyyy-MM-dd') as d, count(distinct Operate_User_IP) as v from UserLog where Modify_Action = 'visit' and Operate_Time between DATEADD(DAY, -29, format(GETDATE(), 'yyyy-MM-dd')) and DateAdd(DAY, 1,format(GETDATE(), 'yyyy-MM-dd')) group by FORMAT(Operate_Time, 'yyyy-MM-dd')";
        using (SqlCommand cmd = new SqlCommand(sql, con))
        {
          con.Open();
          SqlDataAdapter da = new SqlDataAdapter(cmd);
          da.Fill(dt);
          con.Close();
          return ConvertDataTabletoString(dt, false);
        }
      }
    }

    public string gen7dayViewLine(int duration)
    {
      DataTable dt = new DataTable();
      string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
      using (SqlConnection con = new SqlConnection(constr))
      {
        //        string sql = @"
        //SELECT format(DATEADD(DAY, nbr - 1, DATEADD(DAY, -@du, format(GETDATE(), 'yyyy-MM-dd'))), 'yyyy-MM-dd') as date, k.c as value
        //FROM ( SELECT ROW_NUMBER() OVER ( ORDER BY c.object_id ) AS Nbr FROM sys.columns c ) nbrs left join
        //(select FORMAT(ul.Operate_Time, 'yyyy-MM-dd') as t, count(ul.id) as c from UserLog ul 
        //left join Article a on a.id = ul.Modify_Id where ul.Modify_Table = 'Article' and ul.Modify_Action = 'View' 
        //and Operate_Time between DATEADD(DAY, -@du, format(GETDATE(), 'yyyy-MM-dd')) and DateAdd(DAY, 1,format(GETDATE(), 'yyyy-MM-dd'))
        //and a.Author_Email = @email group by FORMAT(ul.Operate_Time, 'yyyy-MM-dd')) k 
        //on k.t = format(DATEADD(DAY, nbr - 1, DATEADD(DAY, -@du, format(GETDATE(), 'yyyy-MM-dd'))), 'yyyy-MM-dd')
        //WHERE   nbr - 1 <= DATEDIFF(DAY, DATEADD(DAY, -@du, format(GETDATE(), 'yyyy-MM-dd')), format(GETDATE(), 'yyyy-MM-dd'))";
        string sql = @"SELECT format(DATEADD(DAY, nbr - 1, DATEADD(DAY, -@du, format(GETDATE(), 'yyyy-MM-dd'))), 'yyyy-MM-dd') as date, k.c as value
FROM ( SELECT ROW_NUMBER() OVER ( ORDER BY c.object_id ) AS Nbr FROM sys.columns c ) nbrs left join
(select format(date, 'yyyy-MM-dd') as t, sum(visitor + [user]) as c from Article_View av left join Article a on a.Id = av.Id 
        where date between DATEADD(DAY, -@du, format(GETDATE(), 'yyyy-MM-dd')) and DateAdd(DAY, 1,format(GETDATE(), 'yyyy-MM-dd'))
        and a.User_Id = @id group by date) k
on k.t = format(DATEADD(DAY, nbr - 1, DATEADD(DAY, -@du, format(GETDATE(), 'yyyy-MM-dd'))), 'yyyy-MM-dd')
WHERE   nbr - 1 <= DATEDIFF(DAY, DATEADD(DAY, -@du, format(GETDATE(), 'yyyy-MM-dd')), format(GETDATE(), 'yyyy-MM-dd'))";
        using (SqlCommand cmd = new SqlCommand(sql, con))
        {
          con.Open();
          cmd.Parameters.AddWithValue("@du", duration - 1);
          //cmd.Parameters.AddWithValue("@email", Session["Email"]);
          cmd.Parameters.AddWithValue("@id", Session["User_Id"]);
          SqlDataAdapter da = new SqlDataAdapter(cmd);
          da.Fill(dt);
          con.Close();
          return ConvertDataTabletoString(dt, true);
        }
      }
    }

    public string gen7dayViewPie(int duration)
    {
      DataTable dt = new DataTable();
      string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
      using (SqlConnection con = new SqlConnection(constr))
      {
//        string sql = @"select t as category, count(c) as value from 
//(select distinct ul.Operate_User_IP as c, case when ul.Operate_User_IP in 
//(Select distinct u.Operate_User_IP from Member m left join UserLog u on u.Operate_User_Id = m.Id 
//and m.UserId = a.Author_Email and u.Modify_Action = 'Login') then '使用者' else '訪客' end as t from UserLog ul 
//left join Article a on a.id = ul.Modify_Id where ul.Modify_Table = 'Article' and ul.Modify_Action = 'View' 
//and Operate_Time between DATEADD(DAY, -@du, format(GETDATE(), 'yyyy-MM-dd')) and DateAdd(DAY, 1,format(GETDATE(), 'yyyy-MM-dd'))
//and a.Author_Email = @email) f group by t";
        string sql = @"select '使用者' as category, sum([user]) as value from Article_View av left join Article a on a.Id = av.Id where a.User_Id = @id
and av.date between DATEADD(DAY, -@du, format(GETDATE(), 'yyyy-MM-dd')) and DateAdd(DAY, 1,format(GETDATE(), 'yyyy-MM-dd'))
union all select '訪客' as category, sum(visitor) as value from Article_View av left join Article a on a.Id = av.Id where a.User_Id = @id 
and av.date between DATEADD(DAY, -@du, format(GETDATE(), 'yyyy-MM-dd')) and DateAdd(DAY, 1,format(GETDATE(), 'yyyy-MM-dd'))";
        using (SqlCommand cmd = new SqlCommand(sql, con))
        {
          con.Open();
          cmd.Parameters.AddWithValue("@du", duration - 1);
          cmd.Parameters.AddWithValue("@id", Session["User_Id"]);
          SqlDataAdapter da = new SqlDataAdapter(cmd);
          da.Fill(dt);
          con.Close();
          return ConvertDataTabletoString(dt, true);
        }
      }
    }

    public string gen7dayVisitLine(int duration)
    {
      DataTable dt = new DataTable();
      string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
      using (SqlConnection con = new SqlConnection(constr))
      {
        string sql = "select FORMAT(Operate_Time, 'yyyy-MM-dd') as date, count(distinct Operate_User_IP) as value from UserLog where Modify_Action = 'visit' and Operate_Time between DATEADD(DAY, -@du, format(GETDATE(), 'yyyy-MM-dd')) and DateAdd(DAY, 1,format(GETDATE(), 'yyyy-MM-dd')) group by FORMAT(Operate_Time, 'yyyy-MM-dd')";
        using (SqlCommand cmd = new SqlCommand(sql, con))
        {
          con.Open();
          cmd.Parameters.AddWithValue("@du", duration - 1);
          SqlDataAdapter da = new SqlDataAdapter(cmd);
          da.Fill(dt);
          con.Close();
          return ConvertDataTabletoString(dt, true);
        }
      }
    }

    public string gen7dayVisitPie(int duration)
    {
      DataTable dt = new DataTable();
      string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
      using (SqlConnection con = new SqlConnection(constr))
      {
        string sql = @"select '使用者' as category, count(p) as value from
(select distinct Operate_User_IP as p from UserLog where Modify_Action = 'Login' and Operate_Time between DATEADD(DAY, -@du, format(GETDATE(), 'yyyy-MM-dd')) and DateAdd(DAY, 1,format(GETDATE(), 'yyyy-MM-dd'))) as a
 union select '訪客', count(p) from
(select distinct Operate_User_IP as p from UserLog where Modify_Action = 'View' and Operate_Time between DATEADD(DAY, -@du, format(GETDATE(), 'yyyy-MM-dd')) and DateAdd(DAY, 1,format(GETDATE(), 'yyyy-MM-dd'))) as b
where p not in (select distinct Operate_User_IP as p from UserLog where Modify_Action = 'Login' and Operate_Time between DATEADD(DAY, -@du, format(GETDATE(), 'yyyy-MM-dd')) and DateAdd(DAY, 1,format(GETDATE(), 'yyyy-MM-dd')))";
        using (SqlCommand cmd = new SqlCommand(sql, con))
        {
          con.Open();
          cmd.Parameters.AddWithValue("@du", duration - 1);
          SqlDataAdapter da = new SqlDataAdapter(cmd);
          da.Fill(dt);
          con.Close();
          return ConvertDataTabletoString(dt, false);
        }
      }
    }

    public string ConvertDataTabletoString(DataTable dt, bool isOpac)
    {
      System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
      List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
      Dictionary<string, object> row;
      foreach (DataRow dr in dt.Rows)
      {
        row = new Dictionary<string, object>();
        foreach (DataColumn col in dt.Columns)
        {
          row.Add(col.ColumnName, dr.IsNull(col) ? 0 : dr[col]);
        }
        
        if (dt.Rows.IndexOf(dr) == dt.Rows.Count - 1)
        {
          if (isOpac)
          {
            row.Add("opacity", 1);
          }
          rows.Add(row);
        }else
        {
          rows.Add(row);
        }
      }
      row = new Dictionary<string, object>();
      return serializer.Serialize(rows);
    }

    protected void Article_Search_TextChanged(object sender, EventArgs e)
    {
      uc.FrontEndDebug(this, "search", string.Format("console.log('{0}');", Article_Search.Text));
      SqlDataSource1.SelectCommand = @"SELECT Title, Category, Format(DateTime, 'yyyy/MM/dd tthh:mm') AS DateTime, Status, Recommand_Category, a.Id, Front_Img_Id, count(ul.Id) as cnt 
FROM Article a LEFT JOIN UserLog ul on ul.Modify_Id = a.Id and ul.Modify_Table = 'Article' and ul.Modify_Action = 'View' 
WHERE (Author_Email = @email) and (Title like '%' + @search + '%' OR Keyword like '%' + @search + '%') GROUP BY TItle,Category,DateTime,Status,Recommand_Category,a.Id,Front_Img_Id";

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
  }
}