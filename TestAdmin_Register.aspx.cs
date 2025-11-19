using System;
using System.IO;
using System.Web.UI;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;
using System.Text;
using System.Linq;

namespace piNews
{
	public partial class TestAdmin_Register : System.Web.UI.Page
	{

        UserClass uc = new UserClass();

        protected void Page_Load(object sender, EventArgs e)
        {

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

        public string Check(string id)
        {
            // 使用「正規表達式」檢驗格式 [A~Z] {1}個數字 [0~9] {9}個數字
            var regex = new Regex("^[A-Z]{1}[0-9]{9}$");
            if (!regex.IsMatch(id))
            {
                //Regular Expression 驗證失敗，回傳 ID 錯誤
                return "0";
            }
            //除了檢查碼外每個數字的存放空間 
            int[] seed = new int[10];
            //建立字母陣列(A~Z)
            //A=10 B=11 C=12 D=13 E=14 F=15 G=16 H=17 J=18 K=19 L=20 M=21 N=22
            //P=23 Q=24 R=25 S=26 T=27 U=28 V=29 X=30 Y=31 W=32  Z=33 I=34 O=35            
            string[] charMapping = new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "U", "V", "X", "Y", "W", "Z", "I", "O" };
            string target = id.Substring(0, 1); //取第一個英文數字
            for (int index = 0; index < charMapping.Length; index++)
            {
                if (charMapping[index] == target)
                {
                    index += 10;
                    //10進制的高位元放入存放空間   (權重*1)
                    seed[0] = index / 10;
                    //10進制的低位元*9後放入存放空間 (權重*9)
                    seed[1] = (index % 10) * 9;
                    break;
                }
            }
            for (int index = 2; index < 10; index++) //(權重*8~1)
            {   //將剩餘數字乘上權數後放入存放空間                
                seed[index] = Convert.ToInt32(id.Substring(index - 1, 1)) * (10 - index);
            }
            //檢查是否符合檢查規則，10減存放空間所有數字和除以10的餘數的個位數字是否等於檢查碼            
            //(10 - ((seed[0] + .... + seed[9]) % 10)) % 10 == 身分證字號的最後一碼   
            if ((10 - (seed.Sum() % 10)) % 10 != Convert.ToInt32(id.Substring(9, 1)))
            {
                return "0";
            }
            return "1";
        }

        protected void only_register_Btn_Click(object sender, EventArgs e)
        {
            string acc = acc_TB.Text;
            string pwd = pwd_TB.Text;

            string pn = pinews_name.Text;
            string pc = pinews_class.Value;
            string pr = platform_referrer.Value;
            string n = name_TB.Text;
            string g = gender.Value;

            string idnum = id_number.Text;
            string idclass = id_card.Value;

            string bd = Convert.ToDateTime(birthday.Text).ToString("yyyyMMdd HH:mm:ss");
            string phone = tel_TB.Text;
            string j = job.Text;

            string bn = Bank_name.Text;
            string bb = Bank_branch.Text;
            string ban = Bank_username.Text;
            string ba = Bank_usernum.Text;

            string county = county_HF.Value;
            string district = district_HF.Value;
            string code = zipcode_HF.Value;
            string addr = addr_TB.Text;

            DateTime t = DateTime.Now;

            if (Check(idnum) == "1")
            {
                string chk_stf_Uid = "";
                string chk_stf_Name = "";
                string chk_stf_piclass = "";
                string sql = "Select * From Member Where UserId = @email";
                string[] pName = { "@email" };
                string[] pVal = { acc };
                bool isRegistered = uc.PiNewsHasRow(sql, pName, pVal);
                if (!isRegistered)
                {
                    if (pr != "" && pr != "無")
                    {
                        string query = "Select * From Staff_Id as S left join Member as M on M.Id = S.User_Id Where Staff_Id = @platform_referrer";
                        string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
                        using (SqlConnection con = new SqlConnection(constr))
                        {
                            using (SqlCommand cmd = new SqlCommand(query, con))
                            {
                                con.Open();
                                cmd.Parameters.Clear();
                                cmd.Parameters.AddWithValue("@platform_referrer", pr);

                                using (SqlDataReader reader = cmd.ExecuteReader())
                                {
                                    if (reader.HasRows)
                                    {
                                        reader.Read();
                                        chk_stf_Uid = reader["User_Id"].ToString();
                                        chk_stf_Name = reader["Name"].ToString();
                                        chk_stf_piclass = reader["Pinews_class"].ToString();

                                        string query1 = @"Insert Into Member(UserId, Password, Pinews_name, Pinews_class, Pinews_pfr, Name, Gender, id_number, id_card, Birthday, Phone, Job, Bank_name, Bank_branch, Bank_username, Bank_usernum, Addr_county, Addr_district, AddressCode, Address, IsAdmin, Certification, Register_time) Output Inserted.Id Values(@email, @pwd, @Piname, @Piclass, @Pipfr, @name, @gender, @idnum, @idcard, @Bday, @phone, @job, @Bkn, @Bkb, @Bkuname, @Bkunum, @acounty, @adistrict, @acode, @addr, 0, 0, @time)";
                                        string[] paramN = { "@email", "@pwd", "@Piname", "@Piclass", "@Pipfr", "@name", "@gender", "@idnum", "@idcard", "@Bday", "@phone", "@job", "@Bkn", "@Bkb", "@Bkuname", "@Bkunum", "@acounty", "@adistrict", "@acode", "@addr", "@time" };
                                        string[] paramV = { acc, pwd, pn, pc, chk_stf_Name, n, g, idnum, idclass, bd, phone, j, bn, bb, ban, ba, uc.CityCode(county), district, code, addr, t.ToString("yyyyMMdd HH:mm:ss") };
                                        string id = uc.PiNewsSql(query1, paramN, paramV);
                                        uc.UserLog("Member", id, "Insert", "新增會員資料", "", uc.UserIP());

                                        string query3 = @"Insert Into Referral(User_Id, User_Class, Introducer_Id, Introducer_Class) Output Inserted.Id Values(@User_Id, @User_Class, @Introducer_Id, @Introducer_Class)";
                                        string[] paramN3 = { "@User_Id", "@User_Class", "@Introducer_Id", "@Introducer_Class" };
                                        string[] paramVa3 = { id, pc, chk_stf_Uid, chk_stf_piclass };
                                        uc.PiNewsSql(query3, paramN3, paramVa3);
                                        uc.UserLog("Referral", id, "Insert", "新增引薦人資料", "", uc.UserIP());

                                        if (id_number_img_front.HasFile || id_number_img_Negative.HasFile)
                                        {
                                            string query2 = @"Update Member set Idcard_photo_fid = @fid, Idcard_photo_nid = @nid output inserted.Id Where Id = @uid";
                                            string[] paramN2 = { "@fid", "@nid", "@uid" };

                                            string fimgid = "";
                                            string fileExtension = Path.GetExtension(id_number_img_front.PostedFile.FileName);
                                            string fileName = Guid.NewGuid() + fileExtension;
                                            string contentType = id_number_img_front.PostedFile.ContentType;
                                            byte[] bytes;
                                            using (Stream fs = id_number_img_front.PostedFile.InputStream)
                                            {
                                                using (BinaryReader br = new BinaryReader(fs))
                                                {
                                                    bytes = br.ReadBytes((Int32)fs.Length);
                                                }
                                            }
                                            fimgid = uc.PiNewsInsertIdImg(contentType, fileName, Convert.ToDecimal(bytes.Length / 1024), id, bytes);
                                            uc.UserLog("Image", fimgid, "Insert", "新增會員身份證正面圖片", "", uc.UserIP());


                                            string fimgid2 = "";
                                            string fileExtension2 = Path.GetExtension(id_number_img_Negative.PostedFile.FileName);
                                            string fileName2 = Guid.NewGuid() + fileExtension2;
                                            string contentType2 = id_number_img_Negative.PostedFile.ContentType;
                                            byte[] bytes2;
                                            using (Stream fs2 = id_number_img_Negative.PostedFile.InputStream)
                                            {
                                                using (BinaryReader br = new BinaryReader(fs2))
                                                {
                                                    bytes2 = br.ReadBytes((Int32)fs2.Length);
                                                }
                                            }
                                            fimgid2 = uc.PiNewsInsertIdImg(contentType2, fileName2, Convert.ToDecimal(bytes2.Length / 1024), id, bytes2);
                                            uc.UserLog("Image", fimgid2, "Insert", "新增會員身份證反面圖片", "", uc.UserIP());
                                            string[] paramVa2 = { fimgid, fimgid2, id };
                                            uc.PiNewsSql(query2, paramN2, paramVa2);
                                        }

                                        string guid = Guid.NewGuid().ToString();
                                        string staffid = uc.StaffID(uc.CityCode(county), t, int.Parse(id));
                                        string hash = uc.HmacSHA256(staffid, guid);
                                        uc.SendCertifyEmail(hash, id, n, acc);
                                        uc.UserLog("Member", id, "Certify", guid, "", uc.UserIP());

                                        modal_header.Text = "會員註冊";
                                        modal_content.Text = "註冊成功！已送出認證信。";
                                        ScriptManager.RegisterStartupScript(this, this.GetType(), "chk staffid", "$('.ui.tiny.modal').modal( { inverted: true, autofocus: false, closable : false, onHidden : function(){ window.location.assign('Login.aspx')} } ).modal('show');", true);

                                    }
                                    else
                                    {
                                        ScriptManager.RegisterStartupScript(this, this.GetType(), "show error", "$('.ui.form').form('add errors', {account: '無此引薦人ID，請再次確認!'});", true);
                                    }
                                }
                                con.Close();
                            }
                        }
                    }
                    if (pr == "無")
                    {
                        string query1 = @"Insert Into Member(UserId, Password, Pinews_name, Pinews_class, Pinews_pfr, Name, Gender, id_number, id_card, Birthday, Phone, Job, Bank_name, Bank_branch, Bank_username, Bank_usernum, Addr_county, Addr_district, AddressCode, Address, IsAdmin, Certification, Register_time) Output Inserted.Id Values(@email, @pwd, @Piname, @Piclass, @Pipfr, @name, @gender, @idnum, @idcard, @Bday, @phone, @job, @Bkn, @Bkb, @Bkuname, @Bkunum, @acounty, @adistrict, @acode, @addr, 0, 0, @time)";
                        string[] paramN = { "@email", "@pwd", "@Piname", "@Piclass", "@Pipfr", "@name", "@gender", "@idnum", "@idcard", "@Bday", "@phone", "@job", "@Bkn", "@Bkb", "@Bkuname", "@Bkunum", "@acounty", "@adistrict", "@acode", "@addr", "@time" };
                        string[] paramV = { acc, pwd, pn, pc, pr, n, g, idnum, idclass, bd, phone, j, bn, bb, ban, ba, uc.CityCode(county), district, code, addr, t.ToString("yyyyMMdd HH:mm:ss") };
                        string id = uc.PiNewsSql(query1, paramN, paramV);
                        uc.UserLog("Member", id, "Insert", "新增會員資料", "", uc.UserIP());


                        if (id_number_img_front.HasFile || id_number_img_Negative.HasFile)
                        {
                            string query2 = @"Update Member set Idcard_photo_fid = @fid, Idcard_photo_nid = @nid output inserted.Id Where Id = @uid";
                            string[] paramN2 = { "@fid", "@nid", "@uid" };

                            string fimgid = "";
                            string fileExtension = Path.GetExtension(id_number_img_front.PostedFile.FileName);
                            string fileName = Guid.NewGuid() + fileExtension;
                            string contentType = id_number_img_front.PostedFile.ContentType;
                            byte[] bytes;
                            using (Stream fs = id_number_img_front.PostedFile.InputStream)
                            {
                                using (BinaryReader br = new BinaryReader(fs))
                                {
                                    bytes = br.ReadBytes((Int32)fs.Length);
                                }
                            }
                            fimgid = uc.PiNewsInsertIdImg(contentType, fileName, Convert.ToDecimal(bytes.Length / 1024), id, bytes);
                            uc.UserLog("Image", fimgid, "Insert", "新增會員身份證正面圖片", "", uc.UserIP());


                            string fimgid2 = "";
                            string fileExtension2 = Path.GetExtension(id_number_img_Negative.PostedFile.FileName);
                            string fileName2 = Guid.NewGuid() + fileExtension2;
                            string contentType2 = id_number_img_Negative.PostedFile.ContentType;
                            byte[] bytes2;
                            using (Stream fs2 = id_number_img_Negative.PostedFile.InputStream)
                            {
                                using (BinaryReader br = new BinaryReader(fs2))
                                {
                                    bytes2 = br.ReadBytes((Int32)fs2.Length);
                                }
                            }
                            fimgid2 = uc.PiNewsInsertIdImg(contentType2, fileName2, Convert.ToDecimal(bytes2.Length / 1024), id, bytes2);
                            uc.UserLog("Image", fimgid2, "Insert", "新增會員身份證反面圖片", "", uc.UserIP());
                            string[] paramVa2 = { fimgid, fimgid2, id };
                            uc.PiNewsSql(query2, paramN2, paramVa2);
                        }

                        string guid = Guid.NewGuid().ToString();
                        string staffid = uc.StaffID(uc.CityCode(county), t, int.Parse(id));
                        string hash = uc.HmacSHA256(staffid, guid);
                        uc.SendCertifyEmail(hash, id, n, acc);
                        uc.UserLog("Member", id, "Certify", guid, "", uc.UserIP());

                        modal_header.Text = "會員註冊";
                        modal_content.Text = "註冊成功！已送出認證信。";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "chk staffid", "$('.ui.tiny.modal').modal( { inverted: true, autofocus: false, closable : false, onHidden : function(){ window.location.assign('Login.aspx')} } ).modal('show');", true);
                    }

                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "show error", "$('.ui.form').form('add errors', {account: '已有人註冊此Email信箱!'});", true);
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "show error", @"$('.ui.form').form('add errors', {account: '身分證輸入錯誤，請再次確認!'});$('#new-article.ui.form').form('add fields', {
              hf_front_img: {
                identifier: '<%= Front_Img_HF.ClientID %>',
                rules: [{
                  type: 'empty',
                  prompt: '請確認首圖裁切',
                }]
              }
            })", true);
            }


        }

        protected void Admin_register_Btn_Click(object sender, EventArgs e)
        {
            string acc = acc_TB.Text;
            string pwd = pwd_TB.Text;

            string pn = pinews_name.Text;
            string pc = pinews_class.Value;
            string pr = platform_referrer.Value;
            string n = name_TB.Text;
            string g = gender.Value;

            string idnum = id_number.Text;
            string idclass = id_card.Value;

            string bd = Convert.ToDateTime(birthday.Text).ToString("yyyyMMdd HH:mm:ss");
            string phone = tel_TB.Text;
            string j = job.Text;

            string bn = Bank_name.Text;
            string bb = Bank_branch.Text;
            string ban = Bank_username.Text;
            string ba = Bank_usernum.Text;

            string county = county_HF.Value;
            string district = district_HF.Value;
            string code = zipcode_HF.Value;
            string addr = addr_TB.Text;

            DateTime t = DateTime.Now;

            if (pc == "1")
            {
                Session["price"] = "10000";
            }
            if (pc == "2")
            {
                Session["price"] = "16000";
            }

            if (Check(idnum) == "1")
            {
                string chk_stf_Uid = "";
                string chk_stf_Name = "";
                string chk_stf_piclass = "";
                string sql = "Select * From Member Where UserId = @email";
                string[] pName = { "@email" };
                string[] pVal = { acc };
                bool isRegistered = uc.PiNewsHasRow(sql, pName, pVal);
                if (!isRegistered)
                {
                    if (pr != "" && pr != "無")
                    {
                        string query = "Select * From Staff_Id as S left join Member as M on M.Id = S.User_Id Where Staff_Id = @platform_referrer";
                        string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
                        using (SqlConnection con = new SqlConnection(constr))
                        {
                            using (SqlCommand cmd = new SqlCommand(query, con))
                            {
                                con.Open();
                                cmd.Parameters.Clear();
                                cmd.Parameters.AddWithValue("@platform_referrer", pr);

                                using (SqlDataReader reader = cmd.ExecuteReader())
                                {
                                    if (reader.HasRows)
                                    {
                                        reader.Read();
                                        chk_stf_Uid = reader["User_Id"].ToString();
                                        chk_stf_Name = reader["Name"].ToString();
                                        chk_stf_piclass = reader["Pinews_class"].ToString();

                                        string query1 = @"Insert Into Member(UserId, Password, Pinews_name, Pinews_class, Pinews_pfr, Name, Gender, id_number, id_card, Birthday, Phone, Job, Bank_name, Bank_branch, Bank_username, Bank_usernum, Addr_county, Addr_district, AddressCode, Address, IsAdmin, Certification, Register_time) Output Inserted.Id Values(@email, @pwd, @Piname, @Piclass, @Pipfr, @name, @gender, @idnum, @idcard, @Bday, @phone, @job, @Bkn, @Bkb, @Bkuname, @Bkunum, @acounty, @adistrict, @acode, @addr, 0, 0, @time)";
                                        string[] paramN = { "@email", "@pwd", "@Piname", "@Piclass", "@Pipfr", "@name", "@gender", "@idnum", "@idcard", "@Bday", "@phone", "@job", "@Bkn", "@Bkb", "@Bkuname", "@Bkunum", "@acounty", "@adistrict", "@acode", "@addr", "@time" };
                                        string[] paramV = { acc, pwd, pn, pc, chk_stf_Name, n, g, idnum, idclass, bd, phone, j, bn, bb, ban, ba, uc.CityCode(county), district, code, addr, t.ToString("yyyyMMdd HH:mm:ss") };
                                        string id = uc.PiNewsSql(query1, paramN, paramV);
                                        uc.UserLog("Member", id, "Insert", "新增會員資料", "", uc.UserIP());

                                        string query3 = @"Insert Into Referral(User_Id, User_Class, Introducer_Id, Introducer_Class) Output Inserted.Id Values(@User_Id, @User_Class, @Introducer_Id, @Introducer_Class)";
                                        string[] paramN3 = { "@User_Id", "@User_Class", "@Introducer_Id", "@Introducer_Class" };
                                        string[] paramVa3 = { id, pc, chk_stf_Uid, chk_stf_piclass };
                                        uc.PiNewsSql(query3, paramN3, paramVa3);
                                        uc.UserLog("Referral", id, "Insert", "新增引薦人資料", "", uc.UserIP());

                                        if (id_number_img_front.HasFile || id_number_img_Negative.HasFile)
                                        {
                                            string query2 = @"Update Member set Idcard_photo_fid = @fid, Idcard_photo_nid = @nid output inserted.Id Where Id = @uid";
                                            string[] paramN2 = { "@fid", "@nid", "@uid" };

                                            string fimgid = "";
                                            string fileExtension = Path.GetExtension(id_number_img_front.PostedFile.FileName);
                                            string fileName = Guid.NewGuid() + fileExtension;
                                            string contentType = id_number_img_front.PostedFile.ContentType;
                                            byte[] bytes;
                                            using (Stream fs = id_number_img_front.PostedFile.InputStream)
                                            {
                                                using (BinaryReader br = new BinaryReader(fs))
                                                {
                                                    bytes = br.ReadBytes((Int32)fs.Length);
                                                }
                                            }
                                            fimgid = uc.PiNewsInsertIdImg(contentType, fileName, Convert.ToDecimal(bytes.Length / 1024), id, bytes);
                                            uc.UserLog("Image", fimgid, "Insert", "新增會員身份證正面圖片", "", uc.UserIP());


                                            string fimgid2 = "";
                                            string fileExtension2 = Path.GetExtension(id_number_img_Negative.PostedFile.FileName);
                                            string fileName2 = Guid.NewGuid() + fileExtension2;
                                            string contentType2 = id_number_img_Negative.PostedFile.ContentType;
                                            byte[] bytes2;
                                            using (Stream fs2 = id_number_img_Negative.PostedFile.InputStream)
                                            {
                                                using (BinaryReader br = new BinaryReader(fs2))
                                                {
                                                    bytes2 = br.ReadBytes((Int32)fs2.Length);
                                                }
                                            }
                                            fimgid2 = uc.PiNewsInsertIdImg(contentType2, fileName2, Convert.ToDecimal(bytes2.Length / 1024), id, bytes2);
                                            uc.UserLog("Image", fimgid2, "Insert", "新增會員身份證反面圖片", "", uc.UserIP());
                                            string[] paramVa2 = { fimgid, fimgid2, id };
                                            uc.PiNewsSql(query2, paramN2, paramVa2);
                                        }

                                        Session["Order_No"] = string.Format("{0}{1}", DateTime.Now.ToString("yyyyMMddHHmmss"), GetUniqueKey());
                                        Session["Register_id"] = id;
                                        Session["Buyer_Name"] = n;
                                        Session["Buyer_Telm"] = phone;
                                        Session["Buyer_Mail"] = acc;
                                        Session["Buyer_Memo"] = "年費" + Session["price"].ToString() + "元";

                                        string prquery = @"Insert Into Member_Payment(User_Id, Order_Id, Buyer_Name, Buyer_Telm, Buyer_Mail, Amount, IsComplete) Output Inserted.Id Values(@Uid, @Oid, @BN, @BT, @BM, @price, 0)";
                                        string[] prparamN = { "@Uid", "@Oid", "@BN", "@BT", "@BM", "@price" };
                                        string[] prparamV = { Session["Register_id"].ToString(), Session["Order_No"].ToString(), Session["Buyer_Name"].ToString(), Session["Buyer_Telm"].ToString(), Session["Buyer_Mail"].ToString(), Session["price"].ToString() };
                                        uc.PiNewsSql(prquery, prparamN, prparamV);
                                        uc.UserLog("Member_Payment", id, "Insert", "新增會員年費資料", "", uc.UserIP());

                                        string guid = Guid.NewGuid().ToString();
                                        string staffid = uc.StaffID(uc.CityCode(county), t, int.Parse(id));
                                        string hash = uc.HmacSHA256(staffid, guid);
                                        uc.SendCertifyEmail(hash, id, n, acc);
                                        uc.UserLog("Member", id, "Certify", guid, "", uc.UserIP());

                                        Response.Redirect("~/Testchoosepaymode.aspx");

                                        //modal_header.Text = "會員註冊";
                                        //modal_content.Text = "註冊成功！已送出認證信。";
                                        //ScriptManager.RegisterStartupScript(this, this.GetType(), "chk staffid", "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');", true);

                                    }
                                    else
                                    {
                                        ScriptManager.RegisterStartupScript(this, this.GetType(), "show error", "$('.ui.form').form('add errors', {account: '無此引薦人ID，請再次確認!'});", true);
                                    }
                                }
                                con.Close();
                            }
                        }
                    }
                    if (pr == "無")
                    {
                        string query1 = @"Insert Into Member(UserId, Password, Pinews_name, Pinews_class, Pinews_pfr, Name, Gender, id_number, id_card, Birthday, Phone, Job, Bank_name, Bank_branch, Bank_username, Bank_usernum, Addr_county, Addr_district, AddressCode, Address, IsAdmin, Certification, Register_time) Output Inserted.Id Values(@email, @pwd, @Piname, @Piclass, @Pipfr, @name, @gender, @idnum, @idcard, @Bday, @phone, @job, @Bkn, @Bkb, @Bkuname, @Bkunum, @acounty, @adistrict, @acode, @addr, 0, 0, @time)";
                        string[] paramN = { "@email", "@pwd", "@Piname", "@Piclass", "@Pipfr", "@name", "@gender", "@idnum", "@idcard", "@Bday", "@phone", "@job", "@Bkn", "@Bkb", "@Bkuname", "@Bkunum", "@acounty", "@adistrict", "@acode", "@addr", "@time" };
                        string[] paramV = { acc, pwd, pn, pc, pr, n, g, idnum, idclass, bd, phone, j, bn, bb, ban, ba, uc.CityCode(county), district, code, addr, t.ToString("yyyyMMdd HH:mm:ss") };
                        string id = uc.PiNewsSql(query1, paramN, paramV);
                        uc.UserLog("Member", id, "Insert", "新增會員資料", "", uc.UserIP());


                        if (id_number_img_front.HasFile || id_number_img_Negative.HasFile)
                        {
                            string query2 = @"Update Member set Idcard_photo_fid = @fid, Idcard_photo_nid = @nid output inserted.Id Where Id = @uid";
                            string[] paramN2 = { "@fid", "@nid", "@uid" };

                            string fimgid = "";
                            string fileExtension = Path.GetExtension(id_number_img_front.PostedFile.FileName);
                            string fileName = Guid.NewGuid() + fileExtension;
                            string contentType = id_number_img_front.PostedFile.ContentType;
                            byte[] bytes;
                            using (Stream fs = id_number_img_front.PostedFile.InputStream)
                            {
                                using (BinaryReader br = new BinaryReader(fs))
                                {
                                    bytes = br.ReadBytes((Int32)fs.Length);
                                }
                            }
                            fimgid = uc.PiNewsInsertIdImg(contentType, fileName, Convert.ToDecimal(bytes.Length / 1024), id, bytes);
                            uc.UserLog("Image", fimgid, "Insert", "新增會員身份證正面圖片", "", uc.UserIP());


                            string fimgid2 = "";
                            string fileExtension2 = Path.GetExtension(id_number_img_Negative.PostedFile.FileName);
                            string fileName2 = Guid.NewGuid() + fileExtension2;
                            string contentType2 = id_number_img_Negative.PostedFile.ContentType;
                            byte[] bytes2;
                            using (Stream fs2 = id_number_img_Negative.PostedFile.InputStream)
                            {
                                using (BinaryReader br = new BinaryReader(fs2))
                                {
                                    bytes2 = br.ReadBytes((Int32)fs2.Length);
                                }
                            }
                            fimgid2 = uc.PiNewsInsertIdImg(contentType2, fileName2, Convert.ToDecimal(bytes2.Length / 1024), id, bytes2);
                            uc.UserLog("Image", fimgid2, "Insert", "新增會員身份證反面圖片", "", uc.UserIP());
                            string[] paramVa2 = { fimgid, fimgid2, id };
                            uc.PiNewsSql(query2, paramN2, paramVa2);
                        }                      
                                                
                        Session["Order_No"] = string.Format("{0}{1}", DateTime.Now.ToString("yyyyMMddHHmmss"), GetUniqueKey());
                        Session["Register_id"] = id;
                        Session["Buyer_Name"] = n;
                        Session["Buyer_Telm"] = phone;
                        Session["Buyer_Mail"] = acc;
                        Session["Buyer_Memo"] = "年費" + Session["price"].ToString() + "元";

                        string query = @"Insert Into Member_Payment(User_Id, Order_Id, Buyer_Name, Buyer_Telm, Buyer_Mail, Amount, IsComplete) Output Inserted.Id Values(@Uid, @Oid, @BN, @BT, @BM, @price, 0)";
                        string[] nprparamN = { "@Uid", "@Oid", "@BN", "@BT", "@BM", "@price" };
                        string[] nprparamV = { Session["Register_id"].ToString(), Session["Order_No"].ToString(), Session["Buyer_Name"].ToString(), Session["Buyer_Telm"].ToString(), Session["Buyer_Mail"].ToString(), Session["price"].ToString() };
                        uc.PiNewsSql(query, nprparamN, nprparamV);
                        uc.UserLog("Member_Payment", id, "Insert", "新增會員年費資料", "", uc.UserIP());

                        string guid = Guid.NewGuid().ToString();
                        string staffid = uc.StaffID(uc.CityCode(county), t, int.Parse(id));
                        string hash = uc.HmacSHA256(staffid, guid);
                        uc.SendCertifyEmail(hash, id, n, acc);
                        uc.UserLog("Member", id, "Certify", guid, "", uc.UserIP());

                        Response.Redirect("~/Testchoosepaymode.aspx");

                        //modal_header.Text = "會員註冊";
                        //modal_content.Text = "註冊成功！已送出認證信。";
                        //ScriptManager.RegisterStartupScript(this, this.GetType(), "chk staffid", "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');", true);
                    }

                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "show error", "$('.ui.form').form('add errors', {account: '已有人註冊此Email信箱!'});", true);
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "show error", "$('.ui.form').form('add errors', {account: '身分證輸入錯誤，請再次確認!'});", true);
            }


        }
    }
}