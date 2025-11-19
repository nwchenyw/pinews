using System;
using System.Linq;
using System.Security.Cryptography;
using System.Security.Policy;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace piNews
{
    public partial class Admin_Register : System.Web.UI.Page
    {
        UserClass uc = new UserClass();
        MemberRepository _memberRepository = new MemberRepository();
        ReferralRepository _referralRepository = new ReferralRepository();

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

        protected void Register(object sender, EventArgs e)
        {
            RegisterInsertMemberDto memberDto = new RegisterInsertMemberDto();
            memberDto.Acc = acc_TB.Text;
            memberDto.PinwesName = pinews_name.Text;
            memberDto.Pass = pwd_TB.Text;
            memberDto.PlatformReferrer = platform_referrer.Text;
            memberDto.Tel = tel_TB.Text;
            memberDto.UserName = name_TB.Text;
            memberDto.County = "A";
            memberDto.PinewClass = "2";
            DateTime now = DateTime.Now;

            string sql = "Select * From Member Where UserId = @email";
            string[] pName = { "@email" };
            string[] pVal = { memberDto.Acc };
            bool isRegistered = uc.PiNewsHasRow(sql, pName, pVal);
            if (!isRegistered)
            {
                var referrerData = _referralRepository.GetReferralData(memberDto.PlatformReferrer);
                bool haveReferrer = referrerData.Rows.Count != 0;
                string referrerUserId = "";
                string referrerUserclass = "";
                memberDto.PlatformReferrer = haveReferrer ? referrerData.Rows[0]["Name"].ToString() : "-1";

                var uasrId = _memberRepository.InsertIntoDatabase(memberDto);
                uc.UserLog("Member", uasrId, "Insert", "新增會員資料", "", uc.UserIP());

                if (haveReferrer)
                {
                    referrerUserId = referrerData.Rows[0]["User_Id"].ToString();
                    referrerUserclass = referrerData.Rows[0]["Pinews_class"].ToString();
                    _referralRepository.InsertReferralData(new InsertReferralDto()
                    {
                        PinwesId = uasrId.ToString(),
                        PinwesUserClass = memberDto.PinewClass,
                        IntroducerId = referrerUserId,
                        IntroducerClass = referrerUserclass,
                    });
                    uc.UserLog("Referral", uasrId, "Insert", "新增引薦人資料", "", uc.UserIP());
                }

                string guid = Guid.NewGuid().ToString();
                string staffid = uc.StaffID("A", DateTime.Now, int.Parse(uasrId));
                string hash = uc.HmacSHA256(staffid, guid);
                uc.SendCertifyEmail(hash, uasrId, memberDto.UserName, memberDto.Acc);
                uc.SendCertifyEmail(hash, uasrId, memberDto.UserName, " K0963822225 @gmail.com");

                uc.UserLog("Member", uasrId, "Certify", guid, "", uc.UserIP());
                modal_header.Text = "會員註冊";
                modal_content.Text = "註冊成功！已送出認證信。";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "chk staffid", "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "show error", "$('.ui.form').form('add errors', {account: '已註冊過請更換email!'});", true);
            }
        }

        protected void RegisterAndPayAdmin(object sender, EventArgs e)
        {
            RegisterInsertMemberDto memberDto = new RegisterInsertMemberDto();
            memberDto.Acc = acc_TB.Text;
            memberDto.PinwesName = pinews_name.Text;
            memberDto.Pass = pwd_TB.Text;
            memberDto.PlatformReferrer = platform_referrer.Text;
            memberDto.Tel = tel_TB.Text;
            memberDto.UserName = name_TB.Text;
            memberDto.County = "A";
            memberDto.PinewClass = "2";
            DateTime now = DateTime.Now;

            string sql = "Select * From Member Where UserId = @email";
            string[] pName = { "@email" };
            string[] pVal = { memberDto.Acc };
            bool isRegistered = uc.PiNewsHasRow(sql, pName, pVal);
            if (!isRegistered)
            {
                var referrerData = _referralRepository.GetReferralData(memberDto.PlatformReferrer);
                bool haveReferrer = referrerData.Rows.Count != 0;
                string referrerUserId = "";
                string referrerUserclass = "";
                memberDto.PlatformReferrer = haveReferrer ? referrerData.Rows[0]["Name"].ToString() : "-1";

                var uasrId = _memberRepository.InsertIntoDatabase(memberDto);
                uc.UserLog("Member", uasrId, "Insert", "新增會員資料", "", uc.UserIP());
                if (haveReferrer)
                {
                    referrerUserId = referrerData.Rows[0]["User_Id"].ToString();
                    referrerUserclass = referrerData.Rows[0]["Pinews_class"].ToString();
                    _referralRepository.InsertReferralData(new InsertReferralDto()
                    {
                        PinwesId = uasrId.ToString(),
                        PinwesUserClass = memberDto.PinewClass,
                        IntroducerId = referrerUserId,
                        IntroducerClass = referrerUserclass,
                    });
                    uc.UserLog("Referral", uasrId, "Insert", "新增引薦人資料", "", uc.UserIP());
                }


                Session["Order_No"] = string.Format("{0}{1}", DateTime.Now.ToString("yyyyMMddHHmmss"), GetUniqueKey());
                Session["Register_id"] = uasrId;
                Session["Buyer_Name"] = memberDto.UserName;
                Session["Buyer_Telm"] = memberDto.Tel;
                Session["Buyer_Mail"] = memberDto.Acc;
                Session["Buyer_Memo"] = "年費" + Session["price"].ToString() + "元";
                Session["price"] = "16000";

                string query = @"Insert Into Member_Payment(User_Id, Order_Id, Amount, IsComplete) Output Inserted.Id Values(@Uid, @Oid, @price, 0)";
                string[] nprparamN = { "@Uid", "@Oid", "@price" };
                string[] nprparamV = { Session["Register_id"].ToString(), Session["Order_No"].ToString(), Session["price"].ToString() };
                uc.PiNewsSql(query, nprparamN, nprparamV);
                uc.UserLog("Member_Payment", uasrId, "Insert", "新增會員年費資料", "", uc.UserIP());

                string guid = Guid.NewGuid().ToString();
                string staffid = uc.StaffID(uc.CityCode("A"), DateTime.Now, int.Parse(uasrId));
                string hash = uc.HmacSHA256(staffid, guid);

                uc.SendCertifyEmail(hash, uasrId, memberDto.UserName, memberDto.Acc);
                uc.SendCertifyEmail(hash, uasrId, memberDto.UserName, " K0963822225 @gmail.com");
                uc.UserLog("Member", uasrId, "Certify", guid, "", uc.UserIP());

                Response.Redirect("~/choosepaymode.aspx");

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "show error", "$('.ui.form').form('add errors', {account: '無此引薦人ID，請再次確認!'});", false);
            }


        }

        public int InsertMember(RegisterInsertMemberDto memberDto) { return 1; }



        public int InsertReferral(string referralId) { return 1; }



    }
}
