using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Security.Cryptography;

namespace piNews
{
  public partial class Member : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      this.Master.Page.Title = "會員中心 | 拍新聞";
      if (Session["User_Id"] == null) Response.Redirect("Login.aspx");
      else if (!IsPostBack)
      {
        member_info_init();
        if (Session["Pinews_class"].Equals(""))
        {
          pinews_name.InnerText = "暱稱";
          IsAdmin_area.Style["display"] = "none";
        }
        else pinews_name.InnerText = "網紀名稱";
      }
      //else
      //{
      //  icon_init();
      //}
    }

    private void icon_init()
    {
      string query = "Select Certification, IsComplete from Member m left join Member_Payment AS MP on M.Id = MP.User_Id Where M.Id = @uid order by Pay_Time desc";
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
              //uc.FrontEndDebug(this, "debug", string.Format("console.log('{0}', '{1}');", reader["Certification"], reader["IsComplete"]));
              SendCertifyMail.Visible = reader["Certification"].Equals(false);
              Pay_ment.Visible = false;

              if (reader["Certification"].Equals(true))
              {
                uc.FrontEndDebug(this, "is certify", "$('#Certify').children('i').removeClass('exclamation triangle').addClass('user check'); $('#Certify').html($('#Certify').html().replace('未', '已')); $('#Certify').css('background','#e6a732');");
              }
              if (reader["IsComplete"].Equals(true))
              {
                uc.FrontEndDebug(this, "is pay", "$('#pay_Certify').children('i').removeClass('exclamation triangle').addClass('user check'); $('#pay_Certify').html($('#pay_Certify').html().replace('未', '已')); $('#pay_Certify').css('background','#e6a732'); $('#paydate_Certify').css('display','none');");
              }
              if (reader["IsComplete"].Equals(false))
              {
                Pay_ment.Visible = true;
              }
              if (reader["IsComplete"].ToString() == "")
              {
                Pay_ment.Visible = true;
              }
            }
            con.Close();
          }
        }
      }
    }

    private void member_info_init()
    {
      string query = "Select * from Member AS M left join Staff_Id AS S on M.Id = S.User_Id left join Member_Payment AS MP on M.id = MP.User_Id Where M.Id = @uid order by Pay_Time DESC";
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

              pfr_id.Value = reader["Staff_Id"].ToString();
              pfr.Value = reader["Pinews_pfr"].ToString();
              card_class.Value = (reader["Id_card"].ToString() == "1") ? "身份證" : "護照";
              id_number.Value = reader["Id_number"].ToString();
              job.Value = reader["Job"].ToString();
              gender.Value = (reader["Gender"].ToString() == "1") ? "男" : "女";
              birthday.Value = (reader["Birthday"].ToString() == "") ? reader["Birthday"].ToString() : Convert.ToDateTime(reader["Birthday"].ToString()).ToString("yyyy-MM-dd");
              Bank_username.Value = reader["Bank_username"].ToString();
              Bank_name.Value = reader["Bank_name"].ToString();
              Bank_branch.Value = reader["Bank_branch"].ToString();
              Bank_usernum.Value = reader["Bank_usernum"].ToString();

              username.Value = reader["Name"].ToString();
              nickname.Value = reader["Pinews_name"].ToString();
              phone.Value = reader["Phone"].ToString();
              address.Value = reader["Address"].ToString();
              zipcode.Attributes.Add("data-value", reader["AddressCode"].ToString());
              county_HF.Value = uc.CodeCity(reader["Addr_County"].ToString());
              district_HF.Value = reader["Addr_district"].ToString();
              zipcode_HF.Value = reader["AddressCode"].ToString();
              Intro_DTB.Text = reader["Intro"].ToString();
              Intro_TB.Text = reader["Intro"].ToString();
              SendCertifyMail.Visible = reader["Certification"].Equals(false);
              Pay_ment.Visible = false;
              pfr_id_hidden.Value = pfr_id.Value;
              if (reader["Certification"].Equals(true))
              {
                uc.FrontEndDebug(this, "is certify", "$('#Certify').children('i').removeClass('exclamation triangle').addClass('user check'); $('#Certify').html($('#Certify').html().replace('未', '已')); $('#Certify').css('background','#e6a732');");
              }
              if (reader["IsComplete"].Equals(true))
              {
                uc.FrontEndDebug(this, "is pay", "$('#pay_Certify').children('i').removeClass('exclamation triangle').addClass('user check'); $('#pay_Certify').html($('#pay_Certify').html().replace('未', '已')); $('#pay_Certify').css('background','#e6a732'); $('#paydate_Certify').css('display','none');");
              }
              if (reader["IsComplete"].Equals(false))
              {
                Pay_ment.Visible = true;
              }
              if (reader["IsComplete"].ToString() == "")
              {
                Pay_ment.Visible = true;
              }

              if (reader["Pay_Time"].ToString() != "" && reader["Due_Time"].ToString() != "")
              {
                pinews_date.Value = string.Format("{0}~{1}", Convert.ToDateTime(reader["Pay_Time"].ToString()).ToString("yyyy-MM-dd"), Convert.ToDateTime(reader["Due_Time"].ToString()).ToString("yyyy-MM-dd"));
              }
              if (reader["Member_Img_Id"].ToString() != "")
              {
                Cover_Img.ImageUrl = "Image.aspx?ID=" + reader["Member_Img_Id"].ToString();
                Member_Img.ImageUrl = "Image.aspx?ID=" + reader["Member_Img_Id"].ToString();
              }
              if (reader["Idcard_photo_fid"].ToString() != "")
              {
                idcard_fImage.ImageUrl = "Image.aspx?ID=" + reader["Idcard_photo_fid"].ToString();
              }
              if (reader["Idcard_photo_nid"].ToString() != "")
              {
                idcard_nImage.ImageUrl = "Image.aspx?ID=" + reader["Idcard_photo_nid"].ToString();
              }
              if (reader["Pinews_class"].ToString().Equals(""))
              {
                pinews_class.Value = "拍粉";
              }
              if (reader["Pinews_class"].ToString().Equals("1"))
              {
                pinews_class.Value = "專業網記";
              }
              if (reader["Pinews_class"].ToString().Equals("2"))
              {
                pinews_class.Value = "網記主任";
              }
              if (reader["Pinews_class"].ToString().Equals("3"))
              {
                pinews_class.Value = "網記顧問";
              }
              if (reader["Pinews_class"].ToString().Equals("4"))
              {
                pinews_class.Value = "網記講師";
              }
              if (reader["Pinews_class"].ToString().Equals("5"))
              {
                pinews_class.Value = "網站管理員";
                pinews_date.Value = "無效期";
                uc.FrontEndDebug(this, "is admin", "$('#Pay_ment').css('display','none'); $('#pay_Certify').css('display','none'); $('#paydate_Certify').css('display','none');");
              }
            }
          }
          con.Close();
        }
      }
    }

    protected void memberpay_Click(object sender, EventArgs e)
    {
      Session["Order_No"] = string.Format("{0}{1}", DateTime.Now.ToString("yyyyMMddHHmmss"), GetUniqueKey());
      Session["price"] = pinews_class.Value == "專業網記" ? 10000 : 16000;
      Session["Buyer_Name"] = username.Value;
      Session["Buyer_Telm"] = phone.Value;
      Session["Buyer_Mail"] = Session["Email"];
      Session["Buyer_Memo"] = "年費" + Session["price"].ToString() + "元";
      Session["Register_id"] = Session["User_Id"];

      string prquery = @"Insert Into Member_Payment(User_Id, Order_Id, Buyer_Name, Buyer_Telm, Buyer_Mail, Amount, IsComplete) Output Inserted.Id Values(@Uid, @Oid, @BN, @BT, @BM, @price, 0)";
      string[] prparamN = { "@Uid", "@Oid", "@BN", "@BT", "@BM", "@price" };
      string[] prparamV = { Session["Register_id"].ToString(), Session["Order_No"].ToString(), Session["Buyer_Name"].ToString(), Session["Buyer_Telm"].ToString(), Session["Buyer_Mail"].ToString(), Session["price"].ToString() };
      string id = uc.PiNewsSql(prquery, prparamN, prparamV);
      uc.UserLog("Member_Payment", id, "Insert", "新增會員年費資料", "", uc.UserIP());

      Response.Redirect("~/choosepaymode.aspx");
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
      member_info_init();
    }

    protected void change_data_Click(object sender, EventArgs e)
    {

      string query = @"Update Member set Addr_County = @addr_c, Addr_District = @addr_d,
AddressCode = @acode, Address = @a, Intro = @p output inserted.Id Where Id = @uid";
      string[] paramN = { "@addr_c", "@addr_d", "@acode", "@a", "@p", "@uid" };
      string[] paramVal = { uc.CityCode(county_HF.Value),
        district_HF.Value, zipcode_HF.Value, address.Value,
        Intro_TB.Text, Session["User_Id"].ToString() };
      string id = uc.PiNewsSql(query, paramN, paramVal);
      uc.UserLog("Member", id, "Update", "修改會員資料", Session["User_Id"].ToString(), Session["IP"].ToString());

      member_info_init();
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

      member_info_init();
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

    private static string GetUniqueKey()
    {
      int maxSize = 8;
      int minSize = 5;
      char[] chars = new char[62];
      string a;
      a = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
      chars = a.ToCharArray();
      int size = maxSize;
      byte[] data = new byte[1];
      RNGCryptoServiceProvider crypto = new RNGCryptoServiceProvider();
      crypto.GetNonZeroBytes(data);
      size = maxSize;
      data = new byte[size];
      crypto.GetNonZeroBytes(data);
      StringBuilder result = new StringBuilder(size);
      foreach (byte b in data)
      {
        result.Append(chars[b % (chars.Length - 1)]);
      }
      return result.ToString();
    }
  }
}