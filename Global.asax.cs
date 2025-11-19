using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Routing;
using System.Web.Security;
using piNews;

namespace piNews
{
  public partial class Global : System.Web.HttpApplication
  {
    UserClass uc = new UserClass();
    protected void Application_Start(object sender, EventArgs e)
    {
      Application["Current_cnt"] = 0;
      //Application["Users"] = "";
      RegisterRoutes(RouteTable.Routes);
      string query = "Select case [Option] when 'Name' then 'Site_Name' when 'Description' then 'Site_Desc' else [Option] end as opt, Setting From WebSite_Data";
      string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
      using (SqlConnection con = new SqlConnection(constr))
      {
        using (SqlCommand cmd = new SqlCommand(query, con))
        {
          con.Open();

          cmd.Parameters.Clear();

          using (SqlDataReader reader = cmd.ExecuteReader())
          {
            if (reader.HasRows)
            {
              while (reader.Read())
              {
                Application[reader["opt"].ToString()] = reader["Setting"].ToString();
              }
            }
          }
          con.Close();
        }
      }
    }
    void RegisterRoutes(RouteCollection routes)
    {
      routes.MapPageRoute(
        "HomeRoute",
        "Home",
        "~/Default.aspx"
      );
      routes.MapPageRoute(
        "StaffIDEmptyRoute",
        "RID/Search",
        "~/UserAction/Staff_Id.aspx"
      );
      routes.MapPageRoute(
        "StaffIDRoute",
        "RID/Search/{Id}",
        "~/UserAction/Staff_Id.aspx"
      );
      routes.MapPageRoute(
        "TagEmptyRoute",
        "Tag/Search",
        "~/UserAction/Tag.aspx"
      );
      routes.MapPageRoute(
        "TagRoute",
        "Tag/Search/{Tag}",
        "~/UserAction/Tag.aspx"
      );
      routes.MapPageRoute(
        "MsgVerifyRoute",
        "Msg/Verify/{method}/{Hash}",
        "~/UserAction/MsgCheck.aspx"
        );
      routes.MapPageRoute(
        "NewsRoute",
        "News/{Id}",
        "~/News.aspx"
      );
      routes.MapPageRoute(
        "NewsCatDurRoute",
        "News/{group}/{cat}/{dur}/{type}",
        "~/News.aspx"
      );
      routes.MapPageRoute(
        "NewsCatRoute",
        "News/{group}/{cat}/time",
        "~/News.aspx"
      );
      routes.MapPageRoute(
        "SearchNewsRoute",
        "Search/{Val}",
        "~/News.aspx"
        );
      routes.MapPageRoute(
        "NewsInfoRoute",
        "News/Info/{ArticleId}",
        "~/News_Info.aspx"
      );
      routes.MapPageRoute(
        "ContactUsRoute",
        "ContactUs",
        "~/ContactUs.aspx"
      );
      routes.MapPageRoute(
        "LoginRoute",
        "Login",
        "~/Login.aspx"
      );
      routes.MapPageRoute(
        "VerifyRoute",
        "Verify/{Hash}/{Random}",
        "~/Login.aspx"
      );
      routes.MapPageRoute(
        "FanPost",
        "FanPost",
        "~/User_Profile.aspx"
      );
    }

    protected void Session_Start(object sender, EventArgs e)
    {
      Application.Lock();
      Application["Current_cnt"] = (int)Application["Current_cnt"] + 1;
      Application.UnLock();
      string ip = uc.UserIP();
      HttpContext.Current.Session["IP"] = ip;
      Session["IP"] = ip;

      uc.UserLog("", "", "Visit", "造訪拍新聞", "", uc.UserIP());
    }

    protected void Application_BeginRequest(object sender, EventArgs e)
    {

    }

    protected void Application_AuthenticateRequest(object sender, EventArgs e)
    {

    }

    protected void Application_Error(object sender, EventArgs e)
    {

    }

    protected void Session_End(object sender, EventArgs e)
    {
      Application.Lock();
      Application["Current_cnt"] = (int)Application["Current_cnt"] - 1;
      Application.UnLock();

      if (Session["User_Id"] != null)
      {
        uc.UserLog("", "", "Logout", "被動登出", Session["User_Id"].ToString(), Session["IP"].ToString());
      }
      FormsAuthentication.RedirectToLoginPage();
    }

    protected void Application_End(object sender, EventArgs e)
    {

    }
  }
}