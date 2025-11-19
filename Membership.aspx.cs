using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;

namespace piNews
{
  public partial class Membership : System.Web.UI.Page
  {

    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      if (Session["User_Id"] == null) Response.Redirect("Login.aspx");
      else if (!IsPostBack)
      {
        member_info_init();
      }
    }

    private void member_info_init()
    {
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

              username.Value = reader["Name"].ToString();
              phone.Value = reader["Phone"].ToString();
              address.Value = reader["Address"].ToString();
              zipcode.Attributes.Add("data-value", reader["AddressCode"].ToString());
              county_HF.Value = uc.CodeCity(reader["Addr_County"].ToString());
              district_HF.Value = reader["Addr_district"].ToString();
              zipcode_HF.Value = reader["AddressCode"].ToString();
              SendCertifyMail.Visible = reader["Certification"].Equals(false);
              Cover_Img.ImageUrl = "Image.aspx?ID=" + reader["Member_Img_Id"].ToString();
              Member_Img.ImageUrl = "Image.aspx?ID="+reader["Member_Img_Id"].ToString();
              if (reader["Certification"].Equals(true))
                uc.FrontEndDebug(this, "is certify", "$('#Certify').children('i').removeClass('exclamation triangle').addClass('user check'); $('#Certify').html($('#Certify').html().replace('未', '已')); $('#Certify').removeClass('red').addClass('yellow');");
            }
          }
          con.Close();
        }
      }
    }

    protected void change_pwd_Click(object sender, EventArgs e)
    {
      string query = "Select * from Member Where Id = @uid and Password = @pwd";
      string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
      using (SqlConnection con = new SqlConnection(constr))
      {
        using (SqlCommand cmd = new SqlCommand(query, con))
        {
          con.Open();

          cmd.Parameters.Clear();
          cmd.Parameters.AddWithValue("@uid", Session["User_Id"]);
          cmd.Parameters.AddWithValue("@pwd", old_pwd.Value);

          using (SqlDataReader reader = cmd.ExecuteReader())
          {
            if (reader.HasRows)
            {
              reader.Close();
              cmd.CommandText = "Update Member set Password = @pwd output inserted.Id Where Id = @uid";
              cmd.Parameters.Clear();
              cmd.Parameters.AddWithValue("@uid", Session["User_Id"].ToString());
              cmd.Parameters.AddWithValue("@pwd", new_pwd.Value);
              var id = cmd.ExecuteScalar().ToString();
              uc.UserLog("Member", id, "Update", "修改會員密碼", Session["User_Id"].ToString(), Session["IP"].ToString());
            }
            else
            {
              uc.FrontEndDebug(this, "password error", "$('#pwd_setting').form('add errors', {oldPassword: '密碼錯誤'});");
            }
          }
          con.Close();
        }
      }
    }

    protected void change_data_Click(object sender, EventArgs e)
    {

      string query = @"Update Member set Name = @n, Addr_County = @addr_c, Addr_District = @addr_d,
AddressCode = @acode, Address = @a, Phone = @p output inserted.Id Where Id = @uid";
      string[] paramN = { "@n", "@addr_c", "@addr_d", "@acode", "@a", "@p", "@uid" };
      string[] paramVal = { username.Value, uc.CityCode(county_HF.Value),
        district_HF.Value, zipcode_HF.Value, address.Value,
        phone.Value, Session["User_Id"].ToString() };
      string id = uc.PiNewsSql(query, paramN, paramVal);
      uc.UserLog("Member", id, "Update", "修改會員資料", Session["User_Id"].ToString(), Session["IP"].ToString());
    }

    protected void SendCertifyMail_Click(object sender, EventArgs e)
    {
      string guid = Guid.NewGuid().ToString();
      string id = Session["User_Id"].ToString();
      string county = "", time = "", n = Session["Name"].ToString(), o_time = "",
        email = Session["Email"].ToString(), ip = Session["IP"].ToString();
      DateTime t;
      string query = "Select TOP 1 * From UserLog ul Left Join Member m on m.id = ul.Modify_Id Where Modify_Id = @id and Modify_Action = 'Certify' Order By Operate_Time DESC";
      string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
      using (SqlConnection con = new SqlConnection(constr))
      {
        using (SqlCommand cmd = new SqlCommand(query, con))
        {
          con.Open();

          cmd.Parameters.Clear();
          cmd.Parameters.AddWithValue("@id", Session["User_Id"]);

          using (SqlDataReader reader = cmd.ExecuteReader())
          {
            if (reader.HasRows)
            {
              reader.Read();

              county = reader["Addr_County"].ToString();
              time = reader["Register_Time"].ToString();
              o_time = reader["Operate_Time"].ToString();
            }
          }
          con.Close();
        }
      }
      t = Convert.ToDateTime(time);
      if ((DateTime.Now - Convert.ToDateTime(o_time)).TotalMinutes >= 2)
      {
        string staffid = uc.StaffID(county, t, int.Parse(id));
        string hash = uc.HmacSHA256(staffid, guid);
        uc.SendCertifyEmail(hash, id, n, email);
        uc.UserLog("Member", id, "Certify", guid, "", ip);
        modal_header.Text = "會員認證";
        modal_content.Text = "已送出認證信！";
        uc.FrontEndDebug(this, "popup modal", "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');");
      }
      else
      {
        modal_header.Text = "會員認證";
        modal_content.Text = "您已於剛剛發送驗證信！若尚無收到驗證信，請等待2分鐘再點選補寄認證信。";
        uc.FrontEndDebug(this, "popup modal", "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');");
      }
    }

    protected void Upload_picture_Click(object sender, EventArgs e)
    {
      string fimgid = "";
      string query2 = "Update Member set Member_Img_id = @id output inserted.Id Where Id = @uid";
      string[] paramN2 = { "@id", "@uid" };

      if (Member_Img_FU.HasFile)
      {
        string fileExtension = Path.GetExtension(Member_Img_FU.PostedFile.FileName);

        string fileName = Guid.NewGuid() + fileExtension;
        string contentType = Member_Img_FU.PostedFile.ContentType;
        byte[] bytes;

        using (Stream fs = Member_Img_FU.PostedFile.InputStream)
        {
          using (BinaryReader br = new BinaryReader(fs))
          {
            bytes = br.ReadBytes((Int32)fs.Length);
          }
        }

        fimgid = uc.PiNewsInsertImg(contentType, fileName, Convert.ToDecimal(bytes.Length / 1024), Session["User_Id"].ToString(), bytes);
        uc.UserLog("Image", fimgid, "Insert", "新增會員照片", Session["User_Id"].ToString(), Session["IP"].ToString());
      }

      string[] paramVa2 = { fimgid, Session["User_Id"].ToString() };
      uc.PiNewsSql(query2, paramN2, paramVa2);
      member_info_init();
    }

  }
}