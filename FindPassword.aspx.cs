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
  public partial class FindPassword : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      if (Request.QueryString["user_id"] != null && Request.QueryString["confirm"] != null)
      {
        string sql = @"Select m.Name, m.UserId, m.Id, Max(ul.Operate_Time) as forgot_t, datediff(MINUTE, Max(ul.Operate_Time), Max(ul1.Operate_Time)) as chgP from Staff_Id si left join Member m on m.Id = si.User_Id 
left join UserLog ul on ul.Operate_User_Id = m.Id
left join UserLog ul1 on ul1.Modify_Action = 'changePwd' and ul.Operate_User_Id = ul1.Operate_User_Id
where Staff_Id = @sid and ul.Modify_Detail = @code
group by m.Id, UserId, Name";

        string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
        using (SqlConnection con = new SqlConnection(constr))
        {
          using (SqlCommand cmd = new SqlCommand(sql, con))
          {
            con.Open();

            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@sid", Request.QueryString["user_id"].ToString());
            cmd.Parameters.AddWithValue("@code", Request.QueryString["confirm"].ToString());

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
              if (reader.HasRows)
              {
                reader.Read();
                DateTime dt = DateTime.Parse(reader["forgot_t"].ToString());
                if (!DBNull.Value.Equals(reader["chgP"]))
                {
                  if (int.Parse(reader["chgP"].ToString()) < 30 && int.Parse(reader["chgP"].ToString()) >= 0)
                  {
                    modal_header.Text = "忘記密碼";
                    modal_content.Text = "您已修改過密碼，請嘗試進行登入動作，若仍無法登入，請再次與忘記密碼申請密碼修改認證信。";
                    //uc.FrontEndDebug(this, "popup modal", "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');");
                    Confirm_LB.Visible = false;
                    uc.FrontEndDebug(this, "err", string.Format("alert('{0}');window.location = '/Home';", "您已修改過密碼，請嘗試進行登入動作，若仍無法登入，請於再次忘記密碼申請密碼修改認證信。"));
                    //Response.Redirect("Default.aspx");
                  }
                  else if (DateTime.Now.Subtract(dt).TotalMinutes < 30)
                  {
                    acc.Text = reader["UserId"].ToString();
                    name.Text = reader["Name"].ToString();
                    Session["forgotPwd_Id"] = reader["Id"].ToString();
                  }
                  else
                  {
                    Confirm_LB.Visible = false;
                    uc.FrontEndDebug(this, "err", string.Format("alert('{0}');window.location = '/Home';", "修改密碼認證信已失效， 請於忘記密碼再次申請密碼修改驗證信。"));
                    //Response.Redirect("Default.aspx");
                  }
                }
                else
                {
                  acc.Text = reader["UserId"].ToString();
                  name.Text = reader["Name"].ToString();
                  Session["forgotPwd_Id"] = reader["Id"].ToString();
                }
              }
              else
              {
                Confirm_LB.Visible = false;
                uc.FrontEndDebug(this, "err", string.Format("alert('{0}');window.location = '/Home';", "找不到帳號，請確認連結是否正確或重新寄送修改密碼認證信。"));
                //Response.Redirect("Default.aspx");
              }
            }
            con.Close();
          }
        }
      }
    }

    protected void Confirm_LB_Click(object sender, EventArgs e)
    {
      if (pwd_TB.Text == cfmPwd_TB.Text)
      {
        string sql = "Update Member set password = @pwd output Inserted.Id where Id = @id";
        string[] para = { "@pwd", "@id" };
        string[] val = { pwd_TB.Text, Session["forgotPwd_Id"].ToString() };

        uc.PiNewsSql(sql, para, val);
        uc.UserLog("", "", "changePwd", "忘記密碼進行密碼更改", Session["forgotPwd_Id"].ToString(), uc.UserIP());
        Session["forgotPwd_Id"] = null;
      }else if (Session["forgotPwd_Id"] == null)
      {
        uc.FrontEndDebug(this, "oh no", "alert('您已使用此信件修改過密碼！請至登入頁面進行登入動作，或重新寄送忘記密碼信件！');");
      }
      else
      {
        uc.FrontEndDebug(this, "oh no", "alert('確認密碼有誤！');");
      }
    }
  }
}