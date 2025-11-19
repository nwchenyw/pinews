using System;
using System.Web.UI;

namespace piNews
{
  public partial class Register : System.Web.UI.Page
  {

    UserClass uc = new UserClass();

    protected void Page_Load(object sender, EventArgs e)
    {
      //Code[Array.IndexOf(city, "新北市")]
      if (Request.Form["user"]!=null)
      {
        name_TB.Text = Request.Form["user"].ToString();
        Session["FB_Id"] = Request.Form["Id"].ToString();
      }
    }

    protected void register_Btn_Click(object sender, EventArgs e)
    {
      string acc = acc_TB.Text;
      string n = name_TB.Text;
      string pn = pinews_name.Text; 
      string pwd = pwd_TB.Text;
      string county = county_HF.Value;
      string district = district_HF.Value;
      string code = zipcode_HF.Value;
      string addr = addr_TB.Text;
      string phone = tel_TB.Text;
      DateTime t = DateTime.Now;

      string sql = "Select * From Member Where UserId = @email";
      string[] pName = { "@email" };
      string[] pVal = { acc };
      bool isRegistered = uc.PiNewsHasRow(sql, pName, pVal);
      if (!isRegistered)
      {
        string query = @"Insert Into Member(UserId, Name, Pinews_name, Password, Addr_county, Addr_district, AddressCode, Address, Phone, IsAdmin, Certification, Register_time) 
        Output Inserted.Id Values(@email, @name, @piname, @pwd, @acounty, @adistrict, @acode, @addr, @phone, 0, 0, @time)";
        string[] paramN = { "@email", "@name", "@piname", "@pwd", "@acounty", "@adistrict", "@acode", "@addr", "@phone", "@time" };
        string[] paramV = { acc, n, pn, pwd, uc.CityCode(county), district, code, addr, phone, t.ToString("yyyyMMdd HH:mm:ss") };

        string id = uc.PiNewsSql(query, paramN, paramV);
        uc.UserLog("Member", id, "Insert", "新增會員資料", "", uc.UserIP());

        if (Session["FB_Id"] != null)
        {
          string query1 = @"Insert Into FB_User_Id(User_Id, FB_Id) Output Inserted.Id Values(@id, @fbid)";
          string[] paramN1 = { "@id", "@fbid" };
          string[] paramV1 = { id, Session["FB_Id"].ToString() };
          //Session["FB_Id"] = null;

          string fbid = uc.PiNewsSql(query1, paramN1, paramV1);
        }

        string guid = Guid.NewGuid().ToString();
        string staffid = uc.StaffID(uc.CityCode(county), t, int.Parse(id));
        string hash = uc.HmacSHA256(staffid, guid);
        uc.SendCertifyEmail(hash, id, n, acc);
        uc.UserLog("Member", id, "Certify", guid, "", uc.UserIP());
        modal_header.Text = "會員註冊";
        modal_content.Text = "註冊成功！已送出認證信。";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "chk staffid", "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');", true);
      }
      else
      {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "show error", "$('.ui.form').form('add errors', {account: '已有人註冊此Email信箱!'})", true);
      }
    }
  }
}