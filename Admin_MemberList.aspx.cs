using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace piNews
{
  public partial class Admin_MemberList : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      if (Session["Authority"] == null) Response.Redirect("Admin.aspx");
      else if (!Array.Exists(Session["Authority"].ToString().Split(','), m => m == "會員總覽")) Response.Redirect("Admin.aspx");

      //uc.FrontEndDebug(this, "bug", string.Format("alert('{0}');", !Array.Exists(Session["Authority"].ToString().Split(','), m => m == "會員總覽")));

      this.Master.Page.Title = "會員資料總覽 | " + Application["Site_Name"];
    }

    protected void GridView1_PreRender(object sender, EventArgs e)
    {
      if (GridView1.Rows.Count > 0)
      {
        GridView1.HeaderRow.TableSection = TableRowSection.TableHeader;
      }
    }

    protected void Search_LB_Click(object sender, EventArgs e)
    {
      if (Search_TB.Text != "")
      {
        SqlDataSource1.SelectCommand = @"SELECT m.Id, ac.Class_Name, m.Pinews_pfr, m.Name, m.Phone, m.IsAdmin, sid.Staff_Id FROM Member AS m LEFT OUTER JOIN 
  Authority_Class AS ac ON ac.Id = m.Pinews_class LEFT OUTER JOIN Staff_Id AS sid ON sid.User_Id = m.Id
  where Staff_Id like '%' + @input + '%' or Name like  '%' + @input + '%' or Pinews_name like '%' + @input + '%'
  order by m.Id DESC";

        SqlDataSource1.SelectParameters.Clear();
        SqlDataSource1.SelectParameters.Add("input", TypeCode.String, Search_TB.Text);
        SqlDataSource1.SelectParameters["input"].DefaultValue = Search_TB.Text;
      }
      else
      {
        SqlDataSource1.SelectCommand = @"SELECT m.Id, ac.Class_Name, m.Pinews_pfr, m.Name, m.Phone, m.IsAdmin, sid.Staff_Id FROM Member AS m LEFT OUTER JOIN 
  Authority_Class AS ac ON ac.Id = m.Pinews_class LEFT OUTER JOIN Staff_Id AS sid ON sid.User_Id = m.Id order by m.Id DESC";
        SqlDataSource1.SelectParameters.Clear();
      }
    }

    protected void Search_TB_TextChanged(object sender, EventArgs e)
    {
      if (Search_TB.Text != "")
      {
        SqlDataSource1.SelectCommand = @"SELECT m.Id, ac.Class_Name, m.Pinews_pfr, m.Name, m.Phone, m.IsAdmin, sid.Staff_Id FROM Member AS m LEFT OUTER JOIN 
  Authority_Class AS ac ON ac.Id = m.Pinews_class LEFT OUTER JOIN Staff_Id AS sid ON sid.User_Id = m.Id
  where Staff_Id like '%' + @input + '%' or Name like  '%' + @input + '%' or Pinews_name like '%' + @input + '%'
  order by m.Id DESC";

        SqlDataSource1.SelectParameters.Clear();
        SqlDataSource1.SelectParameters.Add("input", TypeCode.String, Search_TB.Text);
        SqlDataSource1.SelectParameters["input"].DefaultValue = Search_TB.Text;
      }
      else
      {
        SqlDataSource1.SelectCommand = @"SELECT m.Id, ac.Class_Name, m.Pinews_pfr, m.Name, m.Phone, m.IsAdmin, sid.Staff_Id FROM Member AS m LEFT OUTER JOIN 
  Authority_Class AS ac ON ac.Id = m.Pinews_class LEFT OUTER JOIN Staff_Id AS sid ON sid.User_Id = m.Id order by m.Id DESC";
        SqlDataSource1.SelectParameters.Clear();
      }
    }
  }
}