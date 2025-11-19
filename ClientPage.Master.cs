using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;

//使用了 MasterPage 情況， MasterPage 與 ContentPage 事件順序：
//ContentPage.PreInit
//Master.Init
//ContentPage.Init
//ContentPage.InitComplete
//ContentPage.PreLoad
//ContentPage.Load
//Master.Load
//ContentPage.LoadComplete
//ContentPage.PreRender
//Master.PreRender
//ContentPage.PreRenderComplete

namespace piNews
{
  public partial class ClientPage : System.Web.UI.MasterPage
  {
    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      if (Session["User_Id"] != null && Session["Name"] != null)
      {
        Member.Visible = true;
        Logout.Visible = true;
        Login.Visible = false;
        User_info.Text = "歡迎回來，" + Session["Name"].ToString();
        //User_info.CssClass = "item";
        //if (Session["IsAdmin"].Equals("True")) Admin_a.Visible = true;
      }
      else
      {
        Member.Visible = false;
        Logout.Visible = false;
        Login.Visible = true;
      }


      Page.Title = ContentPageTitle_HF.Value + Application["Site_Name"].ToString();

      if (og_description.Attributes["content"] == null)
        og_description.Attributes.Add("content", Application["Site_Desc"].ToString());

    }

    protected void Logout_Click(object sender, EventArgs e)
    {
      if (Session["User_Id"] != null)
      {
        uc.UserLog("", "", "Logout", "登出", Session["User_Id"].ToString(), Session["IP"].ToString());
        Session.Clear();
      }
      FormsAuthentication.RedirectToLoginPage();
      Member.Visible = false;
      Logout.Visible = false;
      Login.Visible = true;
      Response.Redirect("/Default.aspx");
    }

    protected void Search_TB_TextChanged(object sender, EventArgs e)
    {
      if (Search_TB.Text != null && Search_TB.Text.Trim() != "")
        Response.Redirect(GetRouteUrl("SearchNewsRoute", new { Val = Search_TB.Text }));
      //uc.FrontEndDebug(this, "search txt", string.Format("console.log('{0}', {1});", Search_TB.Text.Trim(), (Search_TB.Text != null && Search_TB.Text.Trim() != "") ? "true" : "false"));
    }

    protected void Search1_TB_TextChanged(object sender, EventArgs e)
    {
      if (Search1_TB.Text != null && Search1_TB.Text.Trim() != "")
        Response.Redirect(GetRouteUrl("SearchNewsRoute", new { Val = Search1_TB.Text }));
    }
  }
}