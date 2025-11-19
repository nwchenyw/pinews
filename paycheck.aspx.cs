using System;
using System.IO;
using System.Web.UI;
using System.Web;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text.RegularExpressions;
using System.Text;
using System.Net;
using System.Collections.Specialized;

namespace piNews
{
  public partial class paycheck : System.Web.UI.Page
  {

    UserClass uc = new UserClass();
	
    protected void Page_Load(object sender, EventArgs e)
    {
			//modal_header.Text = "price";
			//modal_content.Text = Session["price"].ToString();
			//uc.FrontEndDebug(this, "popup modal", "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');");

			if (Request.QueryString["Send_Type"] == "0" && Request.QueryString["result"] == "1")
			{
				string eoid = Request.QueryString["e_orderno"].ToString();
				string price = "";
				string Buyer_Name = "";
				string Buyer_Telm = "";
				string Buyer_Mail = "";
				string CarrierType = "";
				string CarrierId2 = "";
				string BuyerIdentifier = "";
				string NPOBAN = "";
				string Register_id = "";
				string pinews_class = "";


				string prquery = "Select * from Member_Payment left join Member m on m.id = Member_Payment.User_Id Where Order_Id = @oid";
				string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
				using (SqlConnection con = new SqlConnection(constr))
				{
					using (SqlCommand cmd = new SqlCommand(prquery, con))
					{
						con.Open();
						cmd.Parameters.Clear();
						cmd.Parameters.AddWithValue("@oid", eoid);
						using (SqlDataReader reader = cmd.ExecuteReader())
						{
							if (reader.HasRows)
							{
								reader.Read();
								price = reader["Amount"].ToString();
								Buyer_Name = reader["Buyer_Name"].ToString();
								Buyer_Telm = reader["Buyer_Telm"].ToString();
								Buyer_Mail = reader["Buyer_Mail"].ToString();
								CarrierType = reader["CarrierType"].ToString();
								CarrierId2 = reader["CarrierId2"].ToString();
								BuyerIdentifier = reader["BuyerIdentifier"].ToString();
								NPOBAN = reader["NPOBAN"].ToString();
								Register_id = reader["User_Id"].ToString();
								pinews_class = reader["Pinews_class"].ToString();
							}
						}
						con.Close();
					}
				}

				string res = Request.QueryString["result"].ToString();
				string oid = Request.QueryString["OrderID"].ToString();
				string CustomerId = "57EA81C3A419CC9A0E57D303065C7C5D";
				string trade_pwd = "txrvazbocksy0q1x3jfgew7gjiorliwb";
				string needMD5 = res + eoid + CustomerId + price + oid + trade_pwd;
				string msg = RetrievePassedUrl();

				if (MD5_32code(needMD5) == Request.QueryString["str_check"].ToString())
				{
					DateTime t = DateTime.Now;

					string sql = "Select * From Member_Payment Where Order_Id = @oid";
					string[] pName = { "@oid" };
					string[] pVal = { eoid };
					bool isPaymented = uc.PiNewsHasRow(sql, pName, pVal);
					if (!isPaymented)
					{
						string query = @"Insert Into Member_Payment(User_Id, Order_Id, Buyer_Name, Buyer_Telm, Buyer_Mail, Amount, CarrierType, CarrierId2, BuyerIdentifier, NPOBAN, IsComplete, Pay_Time, Due_time, Remark, User_Class) Output Inserted.Id Values(@Uid, @Oid, @BN, @BT, @BM, @price, @CT, @Cid2, @Bif, @NP, 1, @time, @duetime, @Remark, @pinewsclass)";
						string[] paramN = { "@Uid", "@Oid", "@BN", "@BT", "@BM", "@price", "@CT", "@Cid2", "@Bif", "@NP", "@time", "@duetime", "Remark", "pinewsclass" };
						string[] paramV = { Register_id, eoid, Buyer_Name, Buyer_Telm, Buyer_Mail, price, CarrierType, CarrierId2, BuyerIdentifier, NPOBAN, t.ToString("yyyyMMdd HH:mm:ss"), t.AddYears(1).ToString("yyyyMMdd HH:mm:ss"), msg, pinews_class };
						string id = uc.PiNewsSql(query, paramN, paramV);
						uc.UserLog("Member_Payment", id, "Insert", "新增會員年費資料", "", uc.UserIP());

						string Referralsql = "Select * From Referral Where User_Id = @uid";
						string[] ReferralpName = { "@uid" };
						string[] ReferralpVal = { Register_id };
						bool isReferral = uc.PiNewsHasRow(Referralsql, ReferralpName, ReferralpVal);
						if (isReferral)
						{
							string Referralsql2 = @"Update Referral set Referral_Time = @Referral_Time output inserted.Id Where User_Id = @uid";
							string[] ReferralpName2 = { "@Referral_Time", "@uid" };
							string[] ReferralpVal2 = { t.ToString("yyyyMMdd HH:mm:ss"), Register_id };
							uc.PiNewsSql(Referralsql2, ReferralpName2, ReferralpVal2);
							uc.UserLog("Referral", id, "Update", "引薦人付費時間", "", uc.UserIP());
						}

						string membersql = "Select * From Member Where Id = @uid";
						string[] memberpName = { "@uid" };
						string[] memberpVal = { Register_id };
						bool ismember = uc.PiNewsHasRow(membersql, memberpName, memberpVal);
						if (ismember)
						{
							string membersql2 = @"Update Member set IsAdmin = @IsAdmin output inserted.Id Where Id = @uid";
							string[] memberpName2 = { "@IsAdmin", "@uid" };
							string[] memberpVal2 = { "1", Register_id };
							uc.PiNewsSql(membersql2, memberpName2, memberpVal2);
							uc.UserLog("Member", id, "Update", "確認付費更改IsAdmin權限", "", uc.UserIP());
						}

                        string url = "https://n.gomypay.asia/ShuntClass.aspx";
						var request = (HttpWebRequest)WebRequest.Create(url);
						var postData = "BuyerIdentifier=" + Uri.EscapeDataString(BuyerIdentifier ?? "");
						postData += "&BuyerName=" + Uri.EscapeDataString(Buyer_Name);
						postData += "&BuyerTelephoneNumber=" + Uri.EscapeDataString(Buyer_Telm);
						postData += "&BuyerEmailAddress=" + Uri.EscapeDataString(Buyer_Mail);
						postData += "&TotalAmount=" + Uri.EscapeDataString(price);
						postData += "&Description=" + Uri.EscapeDataString(price == "10000" ? "A類平台使用費" : "B類平台使用費");
						postData += "&UnitPrice=" + Uri.EscapeDataString(price);
						postData += "&Quantity=" + Uri.EscapeDataString("1");
						postData += "&Amount=" + Uri.EscapeDataString(price);
						postData += "&user_id=" + Uri.EscapeDataString(CustomerId);
						postData += "&check_pwd=" + Uri.EscapeDataString(trade_pwd);
						postData += "&Remark=" + Uri.EscapeDataString(price == "10000" ? "網記會員年費一年" : "網記主任年費一年");
						postData += "&CarrierType=" + Uri.EscapeDataString(CarrierType ?? "");
						postData += "&CarrierId2=" + Uri.EscapeDataString(CarrierId2 ?? "");
						postData += "&NPOBAN=" + Uri.EscapeDataString(NPOBAN ?? "");
                        postData += "&TransMode=1";
						var data = Encoding.ASCII.GetBytes(postData);
						request.Method = "POST";
						request.ContentType = "application/x-www-form-urlencoded";
						request.ContentLength = data.Length;
						using (var stream = request.GetRequestStream())
						{
							stream.Write(data, 0, data.Length);
						}
						var response = (HttpWebResponse)request.GetResponse();

						if (Register_id == null)
						{
							modal_header.Text = "付費成功";
							modal_content.Text = "註冊、付費成功，請至信箱收取驗證信，驗證信箱";
							uc.FrontEndDebug(this, "popup modal", "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');");
						}
						if (Register_id != null)
						{
							payifo.InnerText = "付費成功";
							payifm.InnerText = "付費成功，恭喜您成為正式會員!";
							modal_header.Text = "付費成功";
							modal_content.Text = "付費成功，恭喜您成為正式會員!";
							uc.FrontEndDebug(this, "popup modal", "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');");
						}


					}
					else
					{
						string query = @"Update Member_Payment set IsComplete = @IsComplete, Pay_Time = @Pay_Time, Due_time = @Due_time, Remark = @Remark, User_Class = @pinewsclass output inserted.Id Where Order_Id = @oid";
						string[] paramN = { "@IsComplete", "@Pay_Time", "@Due_time", "@Remark", "@pinewsclass", "@oid" };
						string[] paramVal = { "1", t.ToString("yyyyMMdd HH:mm:ss"), t.AddYears(1).ToString("yyyyMMdd HH:mm:ss"), msg, pinews_class, eoid };
						string id = uc.PiNewsSql(query, paramN, paramVal);
						uc.UserLog("Member_Payment", id, "Update", "新增會員年費資料", "", uc.UserIP());

						string Referralsql = "Select * From Referral Where User_Id = @uid";
						string[] ReferralpName = { "@uid" };
						string[] ReferralpVal = { Register_id };
						bool isReferral = uc.PiNewsHasRow(Referralsql, ReferralpName, ReferralpVal);
						if (isReferral)
						{
							string Referralsql2 = @"Update Referral set Referral_Time = @Referral_Time output inserted.Id Where User_Id = @uid";
							string[] ReferralpName2 = { "@Referral_Time", "@uid" };
							string[] ReferralpVal2 = { t.ToString("yyyyMMdd HH:mm:ss"), Register_id };
							uc.PiNewsSql(Referralsql2, ReferralpName2, ReferralpVal2);
							uc.UserLog("Referral", id, "Update", "引薦人付費時間", "", uc.UserIP());
						}

						string membersql = "Select * From Member Where Id = @uid";
						string[] memberpName = { "@uid" };
						string[] memberpVal = { Register_id };
						bool ismember = uc.PiNewsHasRow(membersql, memberpName, memberpVal);
						if (ismember)
						{
							string membersql2 = @"Update Member set IsAdmin = @IsAdmin output inserted.Id Where Id = @uid";
							string[] memberpName2 = { "@IsAdmin", "@uid" };
							string[] memberpVal2 = { "1", Register_id };
							uc.PiNewsSql(membersql2, memberpName2, memberpVal2);
							uc.UserLog("Member", id, "Update", "確認付費更改IsAdmin權限", "", uc.UserIP());
						}

                        string url = "https://n.gomypay.asia/ShuntClass.aspx";
						var request = (HttpWebRequest)WebRequest.Create(url);
						var postData = "BuyerIdentifier=" + Uri.EscapeDataString(BuyerIdentifier ?? "");
						postData += "&BuyerName=" + Uri.EscapeDataString(Buyer_Name);
						postData += "&BuyerTelephoneNumber=" + Uri.EscapeDataString(Buyer_Telm);
						postData += "&BuyerEmailAddress=" + Uri.EscapeDataString(Buyer_Mail);
						postData += "&TotalAmount=" + Uri.EscapeDataString(price);
						postData += "&Description=" + Uri.EscapeDataString(price == "10000" ? "A類平台使用費" : "B類平台使用費");
						postData += "&UnitPrice=" + Uri.EscapeDataString(price);
						postData += "&Quantity=" + Uri.EscapeDataString("1");
						postData += "&Amount=" + Uri.EscapeDataString(price);
						postData += "&user_id=" + Uri.EscapeDataString(CustomerId);
						postData += "&check_pwd=" + Uri.EscapeDataString(trade_pwd);
						postData += "&Remark=" + Uri.EscapeDataString(price == "10000" ? "網記會員年費一年" : "網記主任年費一年");
						postData += "&CarrierType=" + Uri.EscapeDataString(CarrierType ?? "");
						postData += "&CarrierId2=" + Uri.EscapeDataString(CarrierId2 ?? "");
						postData += "&NPOBAN=" + Uri.EscapeDataString(NPOBAN ?? "");
                        postData += "&TransMode=1";
						var data = Encoding.ASCII.GetBytes(postData);
						request.Method = "POST";
						request.ContentType = "application/x-www-form-urlencoded";
						request.ContentLength = data.Length;
						using (var stream = request.GetRequestStream())
						{
							stream.Write(data, 0, data.Length);
						}
						var response = (HttpWebResponse)request.GetResponse();

						if (Register_id == null)
						{
							modal_header.Text = "付費成功";
							modal_content.Text = "註冊、付費成功，請至信箱收取驗證信，驗證信箱";
							uc.FrontEndDebug(this, "popup modal", "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');");
						}
						if (Register_id != null)
						{
							payifo.InnerText = "付費成功";
							payifm.InnerText = "付費成功，恭喜您成為正式會員!";
							modal_header.Text = "付費成功";
							modal_content.Text = "付費成功，恭喜您成為正式會員!";
							uc.FrontEndDebug(this, "popup modal", "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');");
						}
					}

				}
				if (MD5_32code(needMD5) != Request.QueryString["str_check"].ToString())
				{
					string query = @"Update Member_Payment set Remark = @Remark output inserted.Id Where Order_Id = @oid";
					string[] paramN = { "@Remark", "@oid" };
					string[] paramVal = { msg, Session["Order_No"].ToString() };
					string id = uc.PiNewsSql(query, paramN, paramVal);

					payifo.InnerText = "付費失敗";
					payifm.InnerText = "付費失敗，請洽客服人員";
					modal_header.Text = "付費失敗";
					modal_content.Text = msg;
					uc.FrontEndDebug(this, "popup modal", "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');");
				}
			}
			if (Request.QueryString["Send_Type"] == "0" && Request.QueryString["result"] == "0")
			{
				string eoid = Request.QueryString["e_orderno"].ToString();
				string price = "";
				string Buyer_Name = "";
				string Buyer_Telm = "";
				string Buyer_Mail = "";
				string CarrierType = "";
				string CarrierId2 = "";
				string BuyerIdentifier = "";
				string NPOBAN = "";
				string Register_id = "";
				string pinews_class = "";

				string prquery = "Select * from Member_Payment left join Member m on m.id = Member_Payment.User_Id Where Order_Id = @oid";
				string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
				using (SqlConnection con = new SqlConnection(constr))
				{
					using (SqlCommand cmd = new SqlCommand(prquery, con))
					{
						con.Open();
						cmd.Parameters.Clear();
						cmd.Parameters.AddWithValue("@oid", eoid);
						using (SqlDataReader reader = cmd.ExecuteReader())
						{
							if (reader.HasRows)
							{
								reader.Read();
								price = reader["Amount"].ToString();
								Buyer_Name = reader["Buyer_Name"].ToString();
								Buyer_Telm = reader["Buyer_Telm"].ToString();
								Buyer_Mail = reader["Buyer_Mail"].ToString();
								CarrierType = reader["CarrierType"].ToString();
								CarrierId2 = reader["CarrierId2"].ToString();
								BuyerIdentifier = reader["BuyerIdentifier"].ToString();
								NPOBAN = reader["NPOBAN"].ToString();
								Register_id = reader["User_Id"].ToString();
								pinews_class = reader["Pinews_class"].ToString();
							}
						}
						con.Close();
					}
				}

				string query = @"Update Member_Payment set Remark = @Remark output inserted.Id Where Order_Id = @oid";
				string[] paramN = { "@Remark", "@oid" };
				string[] paramVal = { RetrievePassedUrl(), eoid };
				string id = uc.PiNewsSql(query, paramN, paramVal);

				string Order_No = string.Format("{0}{1}", DateTime.Now.ToString("yyyyMMddHHmmss"), GetUniqueKey());
				string Buyer_Memo = "年費" + price + "元";
                string url = string.Format(@"https://n.gomypay.asia/ShuntClass.aspx?Send_Type=0&Pay_Mode_No=2&CustomerId=69696686&Order_No={0}&Amount={1}&TransCode=00&Buyer_Name={2}&Buyer_Telm={3}&Buyer_Mail={4}&Buyer_Memo={5}&TransMode=1&Return_url=http://pinews.asia/Testpaycheck.aspx", Order_No, price, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo);

				string pr2query = @"Insert Into Member_Payment(User_Id, Order_Id, Buyer_Name, Buyer_Telm, Buyer_Mail, Amount, CarrierType, CarrierId2, BuyerIdentifier, NPOBAN) Output Inserted.Id Values(@Uid, @Oid, @BN, @BT, @BM, @price, @CT, @Cid2, @Bif, @NP)";
				string[] pr2paramN = { "@Uid", "@Oid", "@BN", "@BT", "@BM", "@price", "@CT", "@Cid2", "@Bif", "@NP" };
				string[] paramV = { Register_id, Order_No, Buyer_Name, Buyer_Telm, Buyer_Mail, price, CarrierType, CarrierId2, BuyerIdentifier, NPOBAN };
				uc.PiNewsSql(pr2query, pr2paramN, paramV);
				uc.UserLog("Member_Payment", Register_id, "Insert", "新增會員年費資料", "", uc.UserIP());

				payifo.InnerText = "付費失敗";
				payifm.InnerText = "付費失敗，請洽客服人員";
				modal_header.Text = "付費失敗";
				modal_content.Text = RetrievePassedUrl();
				uc.FrontEndDebug(this, "popup modal", string.Format("$('.ui.tiny.modal').modal({{inverted: true, autofocus: false, closable : false, onHidden : function(){{ window.location.assign('{0}')}}}}).modal('show');", url));
			}

			if (Request.QueryString["Send_Type"] == "4" && Request.QueryString["result"] == "1")
			{

				string eoid = Request.QueryString["e_orderno"].ToString();
				string price = "";
				string Buyer_Name = "";
				string Buyer_Telm = "";
				string Buyer_Mail = "";
				string CarrierType = "";
				string CarrierId2 = "";
				string BuyerIdentifier = "";
				string NPOBAN = "";
				string Register_id = "";

				string prquery = "Select * from Member_Payment Where Order_Id = @oid";
				string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
				using (SqlConnection con = new SqlConnection(constr))
				{
					using (SqlCommand cmd = new SqlCommand(prquery, con))
					{
						con.Open();
						cmd.Parameters.Clear();
						cmd.Parameters.AddWithValue("@oid", eoid);
						using (SqlDataReader reader = cmd.ExecuteReader())
						{
							if (reader.HasRows)
							{
								reader.Read();
								price = reader["Amount"].ToString();
								Buyer_Name = reader["Buyer_Name"].ToString();
								Buyer_Telm = reader["Buyer_Telm"].ToString();
								Buyer_Mail = reader["Buyer_Mail"].ToString();
								CarrierType = reader["CarrierType"].ToString();
								CarrierId2 = reader["CarrierId2"].ToString();
								BuyerIdentifier = reader["BuyerIdentifier"].ToString();
								NPOBAN = reader["NPOBAN"].ToString();
								Register_id = reader["User_Id"].ToString();
							}
						}
						con.Close();
					}
				}

				string res = Request.QueryString["result"].ToString();
				string oid = Request.QueryString["OrderID"].ToString();
                string CustomerId = "57EA81C3A419CC9A0E57D303065C7C5D";
                string trade_pwd = "txrvazbocksy0q1x3jfgew7gjiorliwb";
				string needMD5 = res + eoid + CustomerId + price + oid + trade_pwd;
				string msg = RetrievePassedUrl();


				string first_strcheck = MD5_32code(needMD5);
				string epac = HttpContext.Current.Server.UrlDecode(HttpContext.Current.Request.QueryString["e_payaccount"]);
				string Ltime = Request.QueryString["LimitDate"].ToString();

				string query = @"Insert Into Member_Virtual_account_payment(User_Id, Order_ID, e_orderno, e_payaccount, LimitDate, first_strcheck, Uni_num, CarrierType, CarrierId2, NPOBAN) Output Inserted.Id Values(@Uid, @Oid, @Eid, @Epact, @Ltime, @fsc, @Uni_num, @CarrierType, @CarrierId2, @NPOBAN)";
				string[] paramN = { "@Uid", "@Oid", "@Eid", "@Epact", "@Ltime", "@fsc", "@Uni_num", "@CarrierType", "@CarrierId2", "@NPOBAN" };
				string[] paramV = { Register_id, oid, eoid, epac, Ltime, first_strcheck, BuyerIdentifier, CarrierType, CarrierId2, NPOBAN };
				string id = uc.PiNewsSql(query, paramN, paramV);
				uc.UserLog("Member_Virtual_account_payment", id, "Insert", "新增會員年費虛擬帳號繳費資料", "", uc.UserIP());

				string payifma = string.Format(@"您的年費為{0}元，匯款繳費虛擬帳號為{1}", price, epac);
				string payifmb = string.Format(@"繳費期限為{0}，匯款後將於1~2工作天完成系統自動查帳。", Ltime);

				payifo.InnerText = "取號成功";
				payifm.InnerText = payifma;
				payifm2.InnerText = payifmb;
			}
			if (Request.QueryString["Send_Type"] == "4" && Request.QueryString["result"] == "0")
			{
				payifo.InnerText = "取號失敗，請洽客服人員。";
				payifm.InnerText = "錯誤訊息 : " + RetrievePassedUrl();
			}

			if (Request.QueryString["Send_Type"] == "6" && Request.QueryString["result"] == "1")
			{

				string eoid = Request.QueryString["e_orderno"].ToString();
				string price = "";
				string Buyer_Name = "";
				string Buyer_Telm = "";
				string Buyer_Mail = "";
				string CarrierType = "";
				string CarrierId2 = "";
				string BuyerIdentifier = "";
				string NPOBAN = "";
				string Register_id = "";

				string prquery = "Select * from Member_Payment Where Order_Id = @oid";
				string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
				using (SqlConnection con = new SqlConnection(constr))
				{
					using (SqlCommand cmd = new SqlCommand(prquery, con))
					{
						con.Open();
						cmd.Parameters.Clear();
						cmd.Parameters.AddWithValue("@oid", eoid);
						using (SqlDataReader reader = cmd.ExecuteReader())
						{
							if (reader.HasRows)
							{
								reader.Read();
								price = reader["Amount"].ToString();
								Buyer_Name = reader["Buyer_Name"].ToString();
								Buyer_Telm = reader["Buyer_Telm"].ToString();
								Buyer_Mail = reader["Buyer_Mail"].ToString();
								CarrierType = reader["CarrierType"].ToString();
								CarrierId2 = reader["CarrierId2"].ToString();
								BuyerIdentifier = reader["BuyerIdentifier"].ToString();
								NPOBAN = reader["NPOBAN"].ToString();
								Register_id = reader["User_Id"].ToString();
							}
						}
						con.Close();
					}
				}

				string res = Request.QueryString["result"].ToString();
				string oid = Request.QueryString["OrderID"].ToString();
				string CustomerId = "57EA81C3A419CC9A0E57D303065C7C5D";
				string trade_pwd = "txrvazbocksy0q1x3jfgew7gjiorliwb";
				string needMD5 = res + eoid + CustomerId + price + oid + trade_pwd;
				string msg = RetrievePassedUrl();

				string first_strcheck = MD5_32code(needMD5);
				string StoreType = Request.QueryString["StoreType"].ToString();
				string PinCode = Request.QueryString["PinCode"].ToString();


				string query = @"Insert Into Member_Convenience_store_code_payment(User_Id, StoreType, OrderID, e_orderno, PinCode, first_strcheck, Uni_num, CarrierType, CarrierId2, NPOBAN) Output Inserted.Id Values(@Uid, @StoreType, @Oid, @Eid, @PinCode, @fsc, @Uni_num, @CarrierType, @CarrierId2, @NPOBAN)";
				string[] paramN = { "@Uid", "@StoreType", "@Oid", "@Eid", "@PinCode", "@fsc", "@Uni_num", "@CarrierType", "@CarrierId2", "@NPOBAN" };
				string[] paramV = { Register_id, StoreType, oid, eoid, PinCode, first_strcheck, BuyerIdentifier, CarrierType, CarrierId2, NPOBAN };
				string id = uc.PiNewsSql(query, paramN, paramV);
				uc.UserLog("Member_Virtual_account_payment", id, "Insert", "新增會員年費虛擬帳號繳費資料", "", uc.UserIP());

				string payifma = string.Format(@"您的年費為{0}元，超商繳費代碼為{1}", price, PinCode);
				string payifmb = "繳費期限：印單時間四家超商皆為30分鐘，印單後(全家、OK、萊爾富為30分鐘；統一超商為3小時內)繳費";
				string payifmc = "繳費後將於1~2工作天完成系統自動查帳。";

				payifo.InnerText = "取號成功";
				payifm.InnerText = payifma;
				payifm2.InnerText = payifmb;
				payifm3.InnerText = payifmc;
			}
			if (Request.QueryString["Send_Type"] == "6" && Request.QueryString["result"] == "0")
			{
				payifo.InnerText = "取號失敗，請洽客服人員。";
				payifm.InnerText = "錯誤訊息 : " + RetrievePassedUrl();
			}

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

		public string RetrievePassedUrl()
		{
			return HttpContext.Current.Server.UrlDecode(HttpContext.Current.Request.QueryString["ret_msg"]);
		}

		public static string MD5_32code(string str)
		{
			string cl = str;
			string pwd = "";
			MD5 md5 = MD5.Create();//實例化一個md5對像
			// 加密後是一個字節類型的數組，這裏要註意編碼UTF8/Unicode等的選擇　
			byte[] s = md5.ComputeHash(Encoding.UTF8.GetBytes(cl));
			// 通過使用循環，將字節類型的數組轉換為字符串，此字符串是常規字符格式化所得
			for (int i = 0; i < s.Length; i++)
			{
				// 將得到的字符串使用十六進制類型格式。格式後的字符是小寫的字母，如果使用大寫（X）則格式後的字符是大寫字符 
				pwd = pwd + s[i].ToString("x2");
			}
			return pwd;
		}
	
	
  }
}