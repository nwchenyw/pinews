using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace piNews
{
  public partial class TestLogin : System.Web.UI.Page
  {

    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      if (Session["User_Id"] != null) Response.Redirect("/Admin.aspx");

      //this.Master.Page.Title = "登入 | 拍新聞";
      ((HiddenField)Master.FindControl("ContentPageTitle_HF")).Value = "登入 | ";

      if ((Request.QueryString["Hash"] != null && Request.QueryString["Random"] != null) ||
        (RouteData.Values["Hash"] != null && RouteData.Values["Random"] != null))
      {
        string Code = "";
        string id = "";
        if (Request.QueryString["Hash"] != null && Request.QueryString["Random"] != null)
        {
          Code = Request.QueryString["Hash"].ToString();
          id = Request.QueryString["Random"].ToString();
        }
        else
        {
          Code = HttpUtility.UrlDecode(RouteData.Values["Hash"].ToString());
          id = RouteData.Values["Random"].ToString();
        }

        string query = "Select TOP 1 * From UserLog ul Left Join Member m on m.id = ul.Modify_Id Where Modify_Id = @id and Modify_Action = 'Certify' Order By Operate_Time DESC";
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
                string guid = reader["Modify_Detail"].ToString();
                string county = reader["Addr_county"].ToString();
                string time = reader["Register_Time"].ToString();
                string guid_time = reader["Operate_Time"].ToString();
                string staffid = uc.StaffID(county, Convert.ToDateTime(time), int.Parse(id));
                reader.Close();
                if ((DateTime.Now - Convert.ToDateTime(guid_time)).TotalHours < 12)
                {
                  string verifyHash = uc.HmacSHA256(staffid, guid).Replace("+", " ");
                  if (verifyHash == Code)
                  {
                    string sql = "Update Member set Certification = 1 output inserted.Id Where Id = @id";
                    string[] paramN = { "@id" };
                    string[] paramVal = { id };
                    string certifyid = uc.PiNewsSql(sql, paramN, paramVal);
                    uc.UserLog("Member", certifyid, "Update", "認證會員資料", id, uc.UserIP());
                    uc.UserLog("", "", "Certified", "認證會員資料成功", id, uc.UserIP());
                    modal_header.Text = "Email認證";
                    modal_content.Text = "認證成功！";
                    uc.FrontEndDebug(this, "popup modal", "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');");
                    string q = "if not exists (select Url from User_Url where User_Id = @uid) Insert into User_Url output Inserted.Id select Id,Left(UserId, CHARINDEX('@',UserId)-1) from Member where Id = @uid";
                    string[] para = { "@uid" };

                    string Urlid = uc.PiNewsSql(q, para, paramVal);
                    if (Urlid != "-1")
                      uc.UserLog("User_Url", Urlid, "Insert", "新增使用者url", id, uc.UserIP());

                    query = "Select addr_county, Register_Time, Id from Member where Id = @id";
                    cmd.Parameters.Clear();
                    cmd.CommandText = query;
                    cmd.Parameters.AddWithValue("@id", id);
                    using (SqlDataReader reader1 = cmd.ExecuteReader())
                    {
                      if (reader1.HasRows)
                      {
                        while (reader1.Read())
                        {
                          DateTime dt = Convert.ToDateTime(reader1["Register_Time"].ToString());
                          //string id = reader1["Id"].ToString();
                          string sid = uc.StaffID(reader1["addr_county"].ToString(), dt, int.Parse(id));
                          query = "IF NOT Exists (Select s.User_Id from Staff_Id s where s.User_Id = @id) Begin Insert Into Staff_Id output Inserted.User_Id Values(@id, @sid) End";
                          string[] pa = { "@id", "@sid" };
                          string[] val = { id, sid };

                          uc.PiNewsSql(query, pa, val);
                          uc.UserLog("Staff_Id", id, "Insert", "新增會員編號", id, "");
                        }
                      }
                    }
                  }
                  else
                  {
                    uc.UserLog("", "", "Certify", "認證會員資料失敗", id, uc.UserIP());
                    modal_header.Text = "Email認證";
                    modal_content.Text = "認證錯誤！請確認網址是否有誤或登入帳號重新索取認證信。";
                    string script = "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');"
                      + string.Format("console.log('{0}', '{1}', '{2}');", verifyHash, Code, staffid);
                    uc.FrontEndDebug(this, "popup modal", script);

                  }
                }
                else
                {
                  uc.UserLog("", "", "Certify", "認證會員資料失效", id, uc.UserIP());
                  modal_header.Text = "Email認證";
                  modal_content.Text = "認證網址失效！請登入帳號重新索取認證信。";
                  uc.FrontEndDebug(this, "popup modal", "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');");
                }
              }
              else
              {
                int i = -1;
                int.TryParse(id, out i);
                uc.UserLog("", "", "Certify", "認證會員資料失敗", i == -1 ? "0" : id, uc.UserIP());
                modal_header.Text = "Email認證";
                modal_content.Text = "認證錯誤！請確認網址是否有誤或登入帳號重新索取認證信。";
                uc.FrontEndDebug(this, "popup modal", "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');");
              }
            }
            con.Close();
          }
        }
      }
    }

    protected void Send_Contact_Click(object sender, EventArgs e)
    {
      string id = Account.Text;
      string pass = Password.Text;
      UserClass userClass = new UserClass();

      string query = "Select Id, Name, Pinews_name, Pinews_class, Certification, IsAdmin from Member Where UserId = @uid and Password = @pwd";
      string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
      using (SqlConnection con = new SqlConnection(constr))
      {
        using (SqlCommand cmd = new SqlCommand(query, con))
        {
          con.Open();

          cmd.Parameters.Clear();
          cmd.Parameters.AddWithValue("@uid", id);
          cmd.Parameters.AddWithValue("@pwd", pass);

          using (SqlDataReader reader = cmd.ExecuteReader())
          {
            if (reader.HasRows)
            {
              reader.Read();
              Session["User_Id"] = reader["Id"].ToString();
              Session["Email"] = id;
              Session["Name"] = reader["Name"].ToString();
              Session["pname"] = reader["Pinews_name"].ToString();
              Session["IP"] = Session["IP"] == null ? userClass.UserIP() : Session["IP"];
              Session["Certification"] = reader["Certification"].ToString();
              Session["IsAdmin"] = reader["IsAdmin"].ToString();
              Session["Pinews_class"] = reader["Pinews_class"].ToString();

              //and something about authority :O

              if (Session["IsAdmin"].Equals("True"))
              {
                reader.Close();
                string sql = @"SELECT Name, LEFT (NULLIF (auth, ''), LEN(NULLIF (auth, '')) - 1) AS Authority 
FROM (SELECT Name, (SELECT TOP (100) PERCENT a.Name + ',' AS [text()] FROM User_Authority AS ua 
LEFT OUTER JOIN Authority AS a ON ua.User_Id = m.Id AND a.Id = ua.Authority_Id ORDER BY a.Id FOR XML PATH('')) AS auth 
FROM Member AS m Where m.Id = @id) AS u_auth";
                cmd.CommandText = sql;
                cmd.Parameters.Clear();
                cmd.Parameters.AddWithValue("@id", Session["User_Id"].ToString());

                using (SqlDataReader reader1 = cmd.ExecuteReader())
                {
                  reader1.Read();
                  Session["Authority"] = reader1["Authority"].ToString();
                };
              }

              // end authority :D
              uc.UserLog("", "", "Login", "登入", Session["User_Id"].ToString(), Session["IP"].ToString());
              con.Close();
              Response.Redirect("/Admin.aspx");
            }
            else
            {
              ScriptManager.RegisterStartupScript(this, this.GetType(), "show error", "$('.ui.form').form('add errors', {account: '帳號或密碼錯誤'})", true);
            }
          }
          con.Close();
        }
      }
    }

    protected void Send_Email_Click(object sender, EventArgs e)
    {
      string email1 = Account.Text;
      string query = "Select m.Id, Pinews_name, si.Staff_Id, Max(ul.Operate_Time) as send_time from Member m left join Staff_Id si on si.User_Id = m.Id left join UserLog ul on ul.Modify_Detail = si.Staff_Id Where UserId = @uid group by Pinews_name, Staff_Id";
      string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
      using (SqlConnection con = new SqlConnection(constr))
      {
        using (SqlCommand cmd = new SqlCommand(query, con))
        {
          con.Open();

          cmd.Parameters.Clear();
          cmd.Parameters.AddWithValue("@uid", email1);

          using (SqlDataReader reader = cmd.ExecuteReader())
          {
            if (reader.HasRows)
            {
              reader.Read();
              DateTime dt = Convert.ToDateTime(reader["send_time"].ToString());
              if (DateTime.Now.Subtract(dt).TotalMinutes > 2)
              {
                string sid = reader["Staff_Id"].ToString();
                string url = string.Format("http://pinews.asia/FindPassword.aspx?user_id={0}", sid);
                string body = String.Format(@"親愛的會員 {0} 您好！<br>
這封密碼修改認證信函是由拍新聞的系統發出，請於30分鐘內點閱先連結到您的會員帳戶，不需要回信。<br><br>
{1}
<br><br>
如果上面的超連結您無法使用，請複製上列網址，並開啓瀏覽器直接貼上網址進行帳號登入。<br>
此連結將於30分鐘後失效，若超過時間請登入帳號點選重新寄送認證信。造成不便敬請見諒！<br>
在此建議您定期更新密碼，讓您的帳號更安全有保障哦！<br><br>
拍新聞 感謝您", reader["Pinews_name"].ToString(), url);
                uc.SendEmail("ask.pinews@gmail.com", email1, "", body);

                uc.UserLog("", "", "ForgotPwd", sid, reader["Id"].ToString(), uc.UserIP());
                modal_header.Text = "忘記密碼";
                modal_content.Text = "已送出密碼修改認證信！";
                uc.FrontEndDebug(this, "popup modal", "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');");
              } else
              {
                modal_header.Text = "忘記密碼";
                modal_content.Text = "您已於剛剛發送密碼修改認證信！若尚無收到驗證信，請等待2分鐘再點選補寄認證信。";
                uc.FrontEndDebug(this, "popup modal", "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');");
              }
            }
            else
            {
              modal_header.Text = "忘記密碼";
              modal_content.Text = "找不到該帳號，請輸入正確帳號以取得密碼修改認證信。";
              uc.FrontEndDebug(this, "popup modal", "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');");
            }
          }
          con.Close();
        }
      }
    }
  }
}