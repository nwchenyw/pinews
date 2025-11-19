using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

namespace piNews
{
    public partial class AdminPage : System.Web.UI.MasterPage
    {
        UserClass uc = new UserClass();
        protected void Page_Load(object sender, EventArgs e)
        {

            string strPage = Page.AppRelativeVirtualPath;
            string page = Regex.Match(strPage, @"\/.+\.aspx$").Value.Replace("/", "");
            uc.FrontEndDebug(this, "in what page", "console.log('" + page + "');");
            if (page != "Admin_articles.aspx" || page != "Admin_newArticle.aspx")
            {
                if (Session["User_Id"] == null || Session["IsAdmin"] == null) Response.Redirect("Default.aspx");
                //else if (!Session["IsAdmin"].Equals("True")) Response.Redirect("Default.aspx");
            }

            is_admin_or_not.InnerText = "拍粉";

            if (Session["Pinews_class"].Equals("1"))
            {
                is_admin_or_not.InnerText = "專業網記";
            }
            if (Session["Pinews_class"].Equals("2"))
            {
                is_admin_or_not.InnerText = "網記主任";
            }
            if (Session["Pinews_class"].Equals("3"))
            {
                is_admin_or_not.InnerText = "網記顧問";
            }
            if (Session["Pinews_class"].Equals("4"))
            {
                is_admin_or_not.InnerText = "網記講師";
            }
            if (Session["Pinews_class"].Equals("5"))
            {
                is_admin_or_not.InnerText = "網站管理員";
                allPayment.Visible = true;
            }




            string query = "Select * from Member Where Id = @uid";
            string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();

                    cmd.Parameters.Clear();
                    cmd.Parameters.AddWithValue("@uid", Session["User_Id"]);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.HasRows)
                        {
                            reader.Read();
                            if (reader["Member_Img_Id"].ToString() != "")
                            {
                                admin_img.Src = "Image.aspx?ID=" + reader["Member_Img_Id"].ToString();
                            }
                            admin_name.Text = Session["Name"].ToString();

                        }
                    }
                    con.Close();
                }
            }

            if (Session["Authority"] != null)
            {
                if (Array.Exists(Session["Authority"].ToString().Split(','), m => m == "設定權限"))
                {
                    authority.Visible = true;
                }
                if (Array.Exists(Session["Authority"].ToString().Split(','), m => m == "首頁橫幅"))
                    banner.Visible = true;
                if (Array.Exists(Session["Authority"].ToString().Split(','), m => m == "首頁跑馬燈"))
                    Marquee.Visible = true;
                if (Array.Exists(Session["Authority"].ToString().Split(','), m => m == "個人廣告"))
                    advertise.Visible = true;
                if (Array.Exists(Session["Authority"].ToString().Split(','), m => m == "網站廣告"))
                    site_ads.Visible = true;
                if (Array.Exists(Session["Authority"].ToString().Split(','), m => m == "網站資料"))
                    site_setting.Visible = true;
                if (Array.Exists(Session["Authority"].ToString().Split(','), m => m == "投稿分類"))
                    Menu.Visible = true;
                if (Array.Exists(Session["Authority"].ToString().Split(','), m => m == "引薦獎金"))
                    personal_referral.Visible = true;
                if (Session["pinews_class"] != null)
                if (Array.Exists(Session["Authority"].ToString().Split(','), m => m == "引薦總覽"))
                    all_referral.Visible = true;
                if (Array.Exists(Session["Authority"].ToString().Split(','), m => m == "首頁標題設定"))
                    homesetting.Visible = true;
                if (Array.Exists(Session["Authority"].ToString().Split(','), m => m == "會員總覽"))
                    memberlist.Visible = true;
                if (Array.Exists(Session["Authority"].ToString().Split(','), m => m == "開通會員"))
                    openMember.Visible = true;
                if (Array.Exists(Session["Authority"].ToString().Split(','), m => m == "會員文章總覽"))
                    allArticle.Visible = true;
                //Console.log();
                uc.FrontEndDebug(this, "a", string.Format("console.log('{0}');", Session["Authority"].ToString()));
            }
        }

        protected void Logout_LB_Click(object sender, EventArgs e)
        {
            if (Session["User_Id"] != null)
            {
                uc.UserLog("", "", "Logout", "登出", Session["User_Id"].ToString(), Session["IP"].ToString());
                Session.Clear();
            }
            Response.Redirect("Default.aspx");
        }
    }
}