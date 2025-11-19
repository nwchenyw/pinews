using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace piNews
{
  public partial class Admin_SiteSetting : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {

      if (Session["Authority"] == null) Response.Redirect("Admin.aspx");
      else if (Array.Find(Session["Authority"].ToString().Split(','), m => m == "網站資料") == "") Response.Redirect("Admin.aspx");

      this.Master.Page.Title = "網站資料管理 | 拍新聞";
    }

    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
      string id = GridView1.DataKeys[e.RowIndex].Values["Id"].ToString();
      string opt = GridView1.DataKeys[e.RowIndex].Values["Option"].Equals("Name") ? "Site_Name":
        GridView1.DataKeys[e.RowIndex].Values["Option"].Equals("Description") ? "Site_Desc":
        GridView1.DataKeys[e.RowIndex].Values["Option"].ToString();
      uc.UserLog("WebSite_Data", id, "Update", "更新網站資料", Session["User_Id"].ToString(), Session["IP"].ToString());
      Application[opt] = e.NewValues["Setting"].ToString();
    }
  }
}