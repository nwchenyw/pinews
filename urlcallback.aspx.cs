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
	public partial class urlcallback : System.Web.UI.Page
	{

		UserClass uc = new UserClass();

		protected void Page_Load(object sender, EventArgs e)
		{

			if (Request.Form["Send_Type"] == "4" && Request.Form["result"] == "1")
			{
				string res = Request.Form["result"].ToString();
				string eoid = Request.Form["e_orderno"].ToString();
				string CustomerId = "53229980";
				string PayAmount = Request.Form["PayAmount"].ToString();
				string oid = Request.Form["OrderID"].ToString();
				string trade_pwd = "u8hl5arkf0qkp9u52be9r6ywtiudvlcg";
				string needMD5 = res + eoid + CustomerId + PayAmount + oid + trade_pwd;
				string msg = RetrievePassedUrl();

				string e_money = Request.Form["e_money"].ToString();
				string e_date = Request.Form["e_date"].ToString();
				string e_time = Request.Form["e_time"].ToString();
				string PayInfo = Request.Form["e_PayInfo"].ToString();

				string checkUser_id = "";
				string checkprice = "";
				string pinews_class = "";

				string query3 = "Select * From Member_Payment left join Member m on m.id = Member_Payment.User_Id Where Order_Id = @Eid";
				string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
				using (SqlConnection con = new SqlConnection(constr))
				{
					using (SqlCommand cmd = new SqlCommand(query3, con))
					{
						con.Open();
						cmd.Parameters.Clear();
						cmd.Parameters.AddWithValue("@Eid", eoid);
						using (SqlDataReader reader = cmd.ExecuteReader())
						{
							if (reader.HasRows)
							{
								reader.Read();
								checkUser_id = reader["User_Id"].ToString();
								checkprice = reader["Amount"].ToString();
								pinews_class = reader["Pinews_class"].ToString();
							}
						}
						con.Close();
					}
				}

				if (MD5_32code(needMD5) == Request.Form["str_check"].ToString() && checkprice == PayAmount)
				{
					DateTime t = DateTime.Now;

					string sql = "Select * From Member_Payment Where Order_Id = @Eid";
					string[] pName = { "@Eid" };
					string[] pVal = { eoid };
					bool isPaymented = uc.PiNewsHasRow(sql, pName, pVal);
					if (!isPaymented)
					{
						string query = @"Insert Into Member_Payment(User_Id, Order_Id, Amount, IsComplete, Pay_Time, Due_time, Remark, User_Class) Output Inserted.Id Values(@Uid, @Oid, @price, 1, @time, @duetime, @Remark, @pinewsclass)";
						string[] paramN = { "@Uid", "@Oid", "@price", "@time", "@duetime", "Remark", "pinewsclass" };
						string[] paramV = { checkUser_id, eoid, PayAmount, t.ToString("yyyyMMdd HH:mm:ss"), t.AddYears(1).ToString("yyyyMMdd HH:mm:ss"), msg, pinews_class };
						string id = uc.PiNewsSql(query, paramN, paramV);
						uc.UserLog("Member_Payment", id, "Insert", "新增會員年費資料", "", uc.UserIP());

						string sql1 = @"Update Member_Virtual_account_payment set e_money = @e_money, PayAmount = @PayAmount, e_date = @e_date, e_time = @e_time, e_PayInfo = @e_PayInfo, Remark = @Remark output inserted.Id Where e_orderno = @Eid";
						string[] pName1 = { "@e_money", "@PayAmount", "@e_date", "@e_time", "@e_PayInfo", "@Remark", "@Eid" };
						string[] pVal1 = { e_money, PayAmount, e_date, e_time, PayInfo, msg, eoid };
						string id2 = uc.PiNewsSql(sql1, pName1, pVal1);
						uc.UserLog("Member_Virtual_account_payment", id2, "Update", "會員年費虛擬帳號匯款繳費時間", "", uc.UserIP());

						string Referralsql = "Select * From Referral Where User_Id = @uid";
						string[] ReferralpName = { "@uid" };
						string[] ReferralpVal = { checkUser_id };
						bool isReferral = uc.PiNewsHasRow(Referralsql, ReferralpName, ReferralpVal);
						if (isReferral)
						{
							string Referralsql2 = @"Update Referral set Referral_Time = @Referral_Time output inserted.Id Where User_Id = @uid";
							string[] ReferralpName2 = { "@Referral_Time", "@uid" };
							string[] ReferralpVal2 = { t.ToString("yyyyMMdd HH:mm:ss"), checkUser_id };
							string id3 = uc.PiNewsSql(Referralsql2, ReferralpName2, ReferralpVal2);
							uc.UserLog("Referral", id3, "Update", "引薦人付費時間", "", uc.UserIP());
						}

						string membersql = "Select * From Member Where Id = @uid";
						string[] memberpName = { "@uid" };
						string[] memberpVal = { checkUser_id };
						bool ismember = uc.PiNewsHasRow(membersql, memberpName, memberpVal);
						if (ismember)
						{
							string membersql2 = @"Update Member set IsAdmin = @IsAdmin output inserted.Id Where Id = @uid";
							string[] memberpName2 = { "@IsAdmin", "@uid" };
							string[] memberpVal2 = { "1", checkUser_id };
							string id4 = uc.PiNewsSql(membersql2, memberpName2, memberpVal2);
							uc.UserLog("Member", id4, "Update", "確認付費更改IsAdmin權限", "", uc.UserIP());
						}

						string checkBuyerIdentifier = "";
						string checkBuyer_Name = "";
						string checkBuyer_Telm = "";
						string checkBuyer_Mail = "";
						string checkCarrierType = "";
						string checkCarrierId2 = "";
						string checkNPOBAN = "";

						string invoicequery = "Select * From Member_Virtual_account_payment AS MP left join Member AS M on MP.User_Id = M.Id Where e_orderno = @Eid";
						string invoiceconstr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
						using (SqlConnection con = new SqlConnection(invoiceconstr))
						{
							using (SqlCommand cmd = new SqlCommand(invoicequery, con))
							{
								con.Open();
								cmd.Parameters.Clear();
								cmd.Parameters.AddWithValue("@Eid", eoid);
								using (SqlDataReader reader = cmd.ExecuteReader())
								{
									if (reader.HasRows)
									{
										reader.Read();
										checkBuyerIdentifier = reader["Uni_num"].ToString();
										checkBuyer_Name = reader["Name"].ToString();
										checkBuyer_Telm = reader["Phone"].ToString();
										checkBuyer_Mail = reader["UserId"].ToString();
										checkCarrierType = reader["CarrierType"].ToString();
										checkCarrierId2 = reader["CarrierId2"].ToString();
										checkNPOBAN = reader["NPOBAN"].ToString();

										string url = "https://invoice.gomypay.asia/invoice/GUI/API/Invoice_addup_new.asp";
										var request = (HttpWebRequest)WebRequest.Create(url);
										var postData = "BuyerIdentifier=" + Uri.EscapeDataString(checkBuyerIdentifier ?? "");
										postData += "&BuyerName=" + Uri.EscapeDataString(checkBuyer_Name);
										postData += "&BuyerTelephoneNumber=" + Uri.EscapeDataString(checkBuyer_Telm);
										postData += "&BuyerEmailAddress=" + Uri.EscapeDataString(checkBuyer_Mail);
										postData += "&TotalAmount=" + Uri.EscapeDataString(PayAmount);
										postData += "&Description=" + Uri.EscapeDataString(PayAmount == "10000" ? "A類平台使用費" : "B類平台使用費");
										postData += "&UnitPrice=" + Uri.EscapeDataString(PayAmount);
										postData += "&Quantity=" + Uri.EscapeDataString("1");
										postData += "&Amount=" + Uri.EscapeDataString(PayAmount);
										postData += "&user_id=" + Uri.EscapeDataString(CustomerId);
										postData += "&check_pwd=" + Uri.EscapeDataString(trade_pwd);
										postData += "&Remark=" + Uri.EscapeDataString(PayAmount == "10000" ? "網記會員年費一年" : "網記主任年費一年");
										postData += "&CarrierType=" + Uri.EscapeDataString(checkCarrierType ?? "");
										postData += "&CarrierId2=" + Uri.EscapeDataString(checkCarrierId2 ?? "");
										postData += "&NPOBAN=" + Uri.EscapeDataString(checkNPOBAN ?? "");
										var data = Encoding.ASCII.GetBytes(postData);
										request.Method = "POST";
										request.ContentType = "application/x-www-form-urlencoded";
										request.ContentLength = data.Length;
										using (var stream = request.GetRequestStream())
										{
											stream.Write(data, 0, data.Length);
										}
										var response = (HttpWebResponse)request.GetResponse();
									}
								}
								con.Close();
							}
						}



					}
					else
					{
						string query = @"Update Member_Payment set IsComplete = @IsComplete, Pay_Time = @Pay_Time, Due_time = @Due_time, Remark = @Remark, User_Class = @pinewsclass output inserted.Id Where Order_Id = @Eid";
						string[] paramN = { "@IsComplete", "@Pay_Time", "@Due_time", "@Remark", "@pinewsclass", "@Eid" };
						string[] paramVal = { "1", t.ToString("yyyyMMdd HH:mm:ss"), t.AddYears(1).ToString("yyyyMMdd HH:mm:ss"), msg, pinews_class, eoid };
						string id = uc.PiNewsSql(query, paramN, paramVal);
						uc.UserLog("Member_Payment", id, "Update", "新增會員年費資料", "", uc.UserIP());

						string sql1 = @"Update Member_Virtual_account_payment set e_money = @e_money, PayAmount = @PayAmount, e_date = @e_date, e_time = @e_time, e_PayInfo = @e_PayInfo, Remark = @Remark output inserted.Id Where e_orderno = @Eid";
						string[] pName1 = { "@e_money", "@PayAmount", "@e_date", "@e_time", "@e_PayInfo", "@Remark", "@Eid" };
						string[] pVal1 = { e_money, PayAmount, e_date, e_time, PayInfo, msg, eoid };
						string id2 = uc.PiNewsSql(sql1, pName1, pVal1);
						uc.UserLog("Member_Virtual_account_payment", id2, "Update", "會員年費虛擬帳號匯款繳費時間", "", uc.UserIP());

						string Referralsql = "Select * From Referral Where User_Id = @uid";
						string[] ReferralpName = { "@uid" };
						string[] ReferralpVal = { checkUser_id };
						bool isReferral = uc.PiNewsHasRow(Referralsql, ReferralpName, ReferralpVal);
						if (isReferral)
						{
							string Referralsql2 = @"Update Referral set Referral_Time = @Referral_Time output inserted.Id Where User_Id = @uid";
							string[] ReferralpName2 = { "@Referral_Time", "@uid" };
							string[] ReferralpVal2 = { t.ToString("yyyyMMdd HH:mm:ss"), checkUser_id };
							string id3 = uc.PiNewsSql(Referralsql2, ReferralpName2, ReferralpVal2);
							uc.UserLog("Referral", id3, "Update", "引薦人付費時間", "", uc.UserIP());
						}

						string membersql = "Select * From Member Where Id = @uid";
						string[] memberpName = { "@uid" };
						string[] memberpVal = { checkUser_id };
						bool ismember = uc.PiNewsHasRow(membersql, memberpName, memberpVal);
						if (ismember)
						{
							string membersql2 = @"Update Member set IsAdmin = @IsAdmin output inserted.Id Where Id = @uid";
							string[] memberpName2 = { "@IsAdmin", "@uid" };
							string[] memberpVal2 = { "1", checkUser_id };
							string id4 = uc.PiNewsSql(membersql2, memberpName2, memberpVal2);
							uc.UserLog("Member", id4, "Update", "確認付費更改IsAdmin權限", "", uc.UserIP());
						}

						string checkBuyerIdentifier = "";
						string checkBuyer_Name = "";
						string checkBuyer_Telm = "";
						string checkBuyer_Mail = "";
						string checkCarrierType = "";
						string checkCarrierId2 = "";
						string checkNPOBAN = "";

						string invoicequery = "Select * From Member_Virtual_account_payment AS MP left join Member AS M on MP.User_Id = M.Id Where e_orderno = @Eid";
						string invoiceconstr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
						using (SqlConnection con = new SqlConnection(invoiceconstr))
						{
							using (SqlCommand cmd = new SqlCommand(invoicequery, con))
							{
								con.Open();
								cmd.Parameters.Clear();
								cmd.Parameters.AddWithValue("@Eid", eoid);
								using (SqlDataReader reader = cmd.ExecuteReader())
								{
									if (reader.HasRows)
									{
										reader.Read();
										checkBuyerIdentifier = reader["Uni_num"].ToString();
										checkBuyer_Name = reader["Name"].ToString();
										checkBuyer_Telm = reader["Phone"].ToString();
										checkBuyer_Mail = reader["UserId"].ToString();
										checkCarrierType = reader["CarrierType"].ToString();
										checkCarrierId2 = reader["CarrierId2"].ToString();
										checkNPOBAN = reader["NPOBAN"].ToString();

										string url = "https://invoice.gomypay.asia/invoice/GUI/API/Invoice_addup_new.asp";
										var request = (HttpWebRequest)WebRequest.Create(url);
										var postData = "BuyerIdentifier=" + Uri.EscapeDataString(checkBuyerIdentifier ?? "");
										postData += "&BuyerName=" + Uri.EscapeDataString(checkBuyer_Name);
										postData += "&BuyerTelephoneNumber=" + Uri.EscapeDataString(checkBuyer_Telm);
										postData += "&BuyerEmailAddress=" + Uri.EscapeDataString(checkBuyer_Mail);
										postData += "&TotalAmount=" + Uri.EscapeDataString(PayAmount);
										postData += "&Description=" + Uri.EscapeDataString(PayAmount == "10000" ? "A類平台使用費" : "B類平台使用費");
										postData += "&UnitPrice=" + Uri.EscapeDataString(PayAmount);
										postData += "&Quantity=" + Uri.EscapeDataString("1");
										postData += "&Amount=" + Uri.EscapeDataString(PayAmount);
										postData += "&user_id=" + Uri.EscapeDataString(CustomerId);
										postData += "&check_pwd=" + Uri.EscapeDataString(trade_pwd);
										postData += "&Remark=" + Uri.EscapeDataString(PayAmount == "10000" ? "網記會員年費一年" : "網記主任年費一年");
										postData += "&CarrierType=" + Uri.EscapeDataString(checkCarrierType ?? "");
										postData += "&CarrierId2=" + Uri.EscapeDataString(checkCarrierId2 ?? "");
										postData += "&NPOBAN=" + Uri.EscapeDataString(checkNPOBAN ?? "");
										var data = Encoding.ASCII.GetBytes(postData);
										request.Method = "POST";
										request.ContentType = "application/x-www-form-urlencoded";
										request.ContentLength = data.Length;
										using (var stream = request.GetRequestStream())
										{
											stream.Write(data, 0, data.Length);
										}
										var response = (HttpWebResponse)request.GetResponse();
									}
								}
								con.Close();
							}
						}
					}
				}
				//else
				//{
				//	string ST = Request.Form["Send_Type"].ToString();
				//	string em = Request.Form["e_money"].ToString();
				//	string ed = Request.Form["e_date"].ToString();
				//	string et = Request.Form["e_time"].ToString();
				//	string epayac = Request.Form["e_payaccount"].ToString();
				//	string epayif = Request.Form["e_PayInfo"].ToString();
				//	string strch = Request.Form["str_check"].ToString();

				//	string SUM = ST + res + msg + oid + em + PayAmount + ed + et + eoid + epayac + epayif + strch;

				//	string sql1 = @"Update Member_Virtual_account_payment set Remark = @Remark output inserted.Id Where e_orderno = @Eid";
				//	string[] pName1 = { "@Remark", "@Eid" };
				//	string[] pVal1 = { SUM, eoid };
				//	uc.PiNewsSql(sql1, pName1, pVal1);
				//}
			}

			else if (Request.Form["Send_Type"] == "6" && Request.Form["result"] == "1")
			{
				string res = Request.Form["result"].ToString();
				string eoid = Request.Form["e_orderno"].ToString();
				string CustomerId = "53229980";
				string PayAmount = Request.Form["PayAmount"].ToString();
				string oid = Request.Form["OrderID"].ToString();
				string trade_pwd = "u8hl5arkf0qkp9u52be9r6ywtiudvlcg";
				string needMD5 = res + eoid + CustomerId + PayAmount + oid + trade_pwd;
				string msg = RetrievePassedUrl();

				string StoreType = Request.Form["StoreType"].ToString();
				string PinCode = Request.Form["PinCode"].ToString();
				string e_money = Request.Form["e_money"].ToString();
				string e_date = Request.Form["e_date"].ToString();
				string e_time = Request.Form["e_time"].ToString();
				string Barcode2 = Request.Form["Barcode2"].ToString();
				string Market_ID = Request.Form["Market_ID"].ToString();
				string Shop_Store_Name = Request.Form["Shop_Store_Name"].ToString();

				string checkUser_id = "";
				string checkprice = "";
				string pinews_class = "";

				string query3 = "Select * From Member_Payment left join Member m on m.id = Member_Payment.User_Id Where Order_Id = @Eid";
				string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
				using (SqlConnection con = new SqlConnection(constr))
				{
					using (SqlCommand cmd = new SqlCommand(query3, con))
					{
						con.Open();
						cmd.Parameters.Clear();
						cmd.Parameters.AddWithValue("@Eid", eoid);
						using (SqlDataReader reader = cmd.ExecuteReader())
						{
							if (reader.HasRows)
							{
								reader.Read();
								checkUser_id = reader["User_Id"].ToString();
								checkprice = reader["Amount"].ToString();
								pinews_class = reader["Pinews_class"].ToString();
							}
						}
						con.Close();
					}
				}

				if (MD5_32code(needMD5) == Request.Form["str_check"].ToString() && checkprice == PayAmount)
				{
					DateTime t = DateTime.Now;

					string sql = "Select * From Member_Payment Where Order_Id = @Eid";
					string[] pName = { "@Eid" };
					string[] pVal = { eoid };
					bool isPaymented = uc.PiNewsHasRow(sql, pName, pVal);
					if (!isPaymented)
					{
						string query = @"Insert Into Member_Payment(User_Id, Order_Id, Amount, IsComplete, Pay_Time, Due_time, Remark, User_Class) Output Inserted.Id Values(@Uid, @Oid, @price, 1, @time, @duetime, @Remark, @pinewsclass)";
						string[] paramN = { "@Uid", "@Oid", "@price", "@time", "@duetime", "Remark", "pinewsclass" };
						string[] paramV = { checkUser_id, eoid, PayAmount, t.ToString("yyyyMMdd HH:mm:ss"), t.AddYears(1).ToString("yyyyMMdd HH:mm:ss"), msg, pinews_class };
						string id = uc.PiNewsSql(query, paramN, paramV);
						uc.UserLog("Member_Payment", id, "Insert", "新增會員年費資料", "", uc.UserIP());

						string sql1 = @"Update Member_Convenience_store_code_payment set e_money = @e_money, PayAmount = @PayAmount, e_date = @e_date, e_time = @e_time, Barcode2 = @Barcode2, Market_ID = @Market_ID, Shop_Store_Name = @Shop_Store_Name, Remark = @Remark output inserted.Id Where e_orderno = @Eid";
						string[] pName1 = { "@e_money", "@PayAmount", "@e_date", "@e_time", "@Barcode2", "@Market_ID", "@Shop_Store_Name", "@Remark", "@Eid" };
						string[] pVal1 = { e_money, PayAmount, e_date, e_time, Barcode2, Market_ID, Shop_Store_Name, msg, eoid };
						string id2 = uc.PiNewsSql(sql1, pName1, pVal1);
						uc.UserLog("Member_Virtual_account_payment", id2, "Update", "會員年費超商代碼繳費時間", "", uc.UserIP());

						string Referralsql = "Select * From Referral Where User_Id = @uid";
						string[] ReferralpName = { "@uid" };
						string[] ReferralpVal = { checkUser_id };
						bool isReferral = uc.PiNewsHasRow(Referralsql, ReferralpName, ReferralpVal);
						if (isReferral)
						{
							string Referralsql2 = @"Update Referral set Referral_Time = @Referral_Time output inserted.Id Where User_Id = @uid";
							string[] ReferralpName2 = { "@Referral_Time", "@uid" };
							string[] ReferralpVal2 = { t.ToString("yyyyMMdd HH:mm:ss"), checkUser_id };
							string id3 = uc.PiNewsSql(Referralsql2, ReferralpName2, ReferralpVal2);
							uc.UserLog("Referral", id3, "Update", "引薦人付費時間", "", uc.UserIP());
						}

						string membersql = "Select * From Member Where Id = @uid";
						string[] memberpName = { "@uid" };
						string[] memberpVal = { checkUser_id };
						bool ismember = uc.PiNewsHasRow(membersql, memberpName, memberpVal);
						if (ismember)
						{
							string membersql2 = @"Update Member set IsAdmin = @IsAdmin output inserted.Id Where Id = @uid";
							string[] memberpName2 = { "@IsAdmin", "@uid" };
							string[] memberpVal2 = { "1", checkUser_id };
							string id4 = uc.PiNewsSql(membersql2, memberpName2, memberpVal2);
							uc.UserLog("Member", id4, "Update", "確認付費更改IsAdmin權限", "", uc.UserIP());
						}

						string checkBuyerIdentifier = "";
						string checkBuyer_Name = "";
						string checkBuyer_Telm = "";
						string checkBuyer_Mail = "";
						string checkCarrierType = "";
						string checkCarrierId2 = "";
						string checkNPOBAN = "";

						string invoicequery = "Select * From Member_Convenience_store_code_payment AS MP left join Member AS M on MP.User_Id = M.Id Where e_orderno = @Eid";
						string invoiceconstr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
						using (SqlConnection con = new SqlConnection(invoiceconstr))
						{
							using (SqlCommand cmd = new SqlCommand(invoicequery, con))
							{
								con.Open();
								cmd.Parameters.Clear();
								cmd.Parameters.AddWithValue("@Eid", eoid);
								using (SqlDataReader reader = cmd.ExecuteReader())
								{
									if (reader.HasRows)
									{
										reader.Read();
										checkBuyerIdentifier = reader["Uni_num"].ToString();
										checkBuyer_Name = reader["Name"].ToString();
										checkBuyer_Telm = reader["Phone"].ToString();
										checkBuyer_Mail = reader["UserId"].ToString();
										checkCarrierType = reader["CarrierType"].ToString();
										checkCarrierId2 = reader["CarrierId2"].ToString();
										checkNPOBAN = reader["NPOBAN"].ToString();

										string url = "https://invoice.gomypay.asia/invoice/GUI/API/Invoice_addup_new.asp";
										var request = (HttpWebRequest)WebRequest.Create(url);
										var postData = "BuyerIdentifier=" + Uri.EscapeDataString(checkBuyerIdentifier ?? "");
										postData += "&BuyerName=" + Uri.EscapeDataString(checkBuyer_Name);
										postData += "&BuyerTelephoneNumber=" + Uri.EscapeDataString(checkBuyer_Telm);
										postData += "&BuyerEmailAddress=" + Uri.EscapeDataString(checkBuyer_Mail);
										postData += "&TotalAmount=" + Uri.EscapeDataString(PayAmount);
										postData += "&Description=" + Uri.EscapeDataString(PayAmount == "10000" ? "A類平台使用費" : "B類平台使用費");
										postData += "&UnitPrice=" + Uri.EscapeDataString(PayAmount);
										postData += "&Quantity=" + Uri.EscapeDataString("1");
										postData += "&Amount=" + Uri.EscapeDataString(PayAmount);
										postData += "&user_id=" + Uri.EscapeDataString(CustomerId);
										postData += "&check_pwd=" + Uri.EscapeDataString(trade_pwd);
										postData += "&Remark=" + Uri.EscapeDataString(PayAmount == "10000" ? "網記會員年費一年" : "網記主任年費一年");
										postData += "&CarrierType=" + Uri.EscapeDataString(checkCarrierType ?? "");
										postData += "&CarrierId2=" + Uri.EscapeDataString(checkCarrierId2 ?? "");
										postData += "&NPOBAN=" + Uri.EscapeDataString(checkNPOBAN ?? "");
										var data = Encoding.ASCII.GetBytes(postData);
										request.Method = "POST";
										request.ContentType = "application/x-www-form-urlencoded";
										request.ContentLength = data.Length;
										using (var stream = request.GetRequestStream())
										{
											stream.Write(data, 0, data.Length);
										}
										var response = (HttpWebResponse)request.GetResponse();
									}
								}
								con.Close();
							}
						}

					}
					else
					{
						string query = @"Update Member_Payment set IsComplete = @IsComplete, Pay_Time = @Pay_Time, Due_time = @Due_time, Remark = @Remark, User_Class = @pinewsclass output inserted.Id Where Order_Id = @Eid";
						string[] paramN = { "@IsComplete", "@Pay_Time", "@Due_time", "@Remark", "@pinewsclass", "@Eid" };
						string[] paramVal = { "1", t.ToString("yyyyMMdd HH:mm:ss"), t.AddYears(1).ToString("yyyyMMdd HH:mm:ss"), msg, pinews_class, eoid };
						string id = uc.PiNewsSql(query, paramN, paramVal);
						uc.UserLog("Member_Payment", id, "Update", "新增會員年費資料", "", uc.UserIP());

						string sql1 = @"Update Member_Convenience_store_code_payment set e_money = @e_money, PayAmount = @PayAmount, e_date = @e_date, e_time = @e_time, Barcode2 = @Barcode2, Market_ID = @Market_ID, Shop_Store_Name = @Shop_Store_Name, Remark = @Remark output inserted.Id Where e_orderno = @Eid";
						string[] pName1 = { "@e_money", "@PayAmount", "@e_date", "@e_time", "@Barcode2", "@Market_ID", "@Shop_Store_Name", "@Remark", "@Eid" };
						string[] pVal1 = { e_money, PayAmount, e_date, e_time, Barcode2, Market_ID, Shop_Store_Name, msg, eoid };
						string id2 = uc.PiNewsSql(sql1, pName1, pVal1);
						uc.UserLog("Member_Virtual_account_payment", id2, "Update", "會員年費超商代碼繳費時間", "", uc.UserIP());

						string Referralsql = "Select * From Referral Where User_Id = @uid";
						string[] ReferralpName = { "@uid" };
						string[] ReferralpVal = { checkUser_id };
						bool isReferral = uc.PiNewsHasRow(Referralsql, ReferralpName, ReferralpVal);
						if (isReferral)
						{
							string Referralsql2 = @"Update Referral set Referral_Time = @Referral_Time output inserted.Id Where User_Id = @uid";
							string[] ReferralpName2 = { "@Referral_Time", "@uid" };
							string[] ReferralpVal2 = { t.ToString("yyyyMMdd HH:mm:ss"), checkUser_id };
							string id3 = uc.PiNewsSql(Referralsql2, ReferralpName2, ReferralpVal2);
							uc.UserLog("Referral", id3, "Update", "引薦人付費時間", "", uc.UserIP());
						}

						string membersql = "Select * From Member Where Id = @uid";
						string[] memberpName = { "@uid" };
						string[] memberpVal = { checkUser_id };
						bool ismember = uc.PiNewsHasRow(membersql, memberpName, memberpVal);
						if (ismember)
						{
							string membersql2 = @"Update Member set IsAdmin = @IsAdmin output inserted.Id Where Id = @uid";
							string[] memberpName2 = { "@IsAdmin", "@uid" };
							string[] memberpVal2 = { "1", checkUser_id };
							string id4 = uc.PiNewsSql(membersql2, memberpName2, memberpVal2);
							uc.UserLog("Member", id4, "Update", "確認付費更改IsAdmin權限", "", uc.UserIP());
						}

						string checkBuyerIdentifier = "";
						string checkBuyer_Name = "";
						string checkBuyer_Telm = "";
						string checkBuyer_Mail = "";
						string checkCarrierType = "";
						string checkCarrierId2 = "";
						string checkNPOBAN = "";

						string invoicequery = "Select * From Member_Convenience_store_code_payment AS MP left join Member AS M on MP.User_Id = M.Id Where e_orderno = @Eid";
						string invoiceconstr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
						using (SqlConnection con = new SqlConnection(invoiceconstr))
						{
							using (SqlCommand cmd = new SqlCommand(invoicequery, con))
							{
								con.Open();
								cmd.Parameters.Clear();
								cmd.Parameters.AddWithValue("@Eid", eoid);
								using (SqlDataReader reader = cmd.ExecuteReader())
								{
									if (reader.HasRows)
									{
										reader.Read();
										checkBuyerIdentifier = reader["Uni_num"].ToString();
										checkBuyer_Name = reader["Name"].ToString();
										checkBuyer_Telm = reader["Phone"].ToString();
										checkBuyer_Mail = reader["UserId"].ToString();
										checkCarrierType = reader["CarrierType"].ToString();
										checkCarrierId2 = reader["CarrierId2"].ToString();
										checkNPOBAN = reader["NPOBAN"].ToString();

										string url = "https://invoice.gomypay.asia/invoice/GUI/API/Invoice_addup_new.asp";
										var request = (HttpWebRequest)WebRequest.Create(url);
										var postData = "BuyerIdentifier=" + Uri.EscapeDataString(checkBuyerIdentifier ?? "");
										postData += "&BuyerName=" + Uri.EscapeDataString(checkBuyer_Name);
										postData += "&BuyerTelephoneNumber=" + Uri.EscapeDataString(checkBuyer_Telm);
										postData += "&BuyerEmailAddress=" + Uri.EscapeDataString(checkBuyer_Mail);
										postData += "&TotalAmount=" + Uri.EscapeDataString(PayAmount);
										postData += "&Description=" + Uri.EscapeDataString(PayAmount == "10000" ? "A類平台使用費" : "B類平台使用費");
										postData += "&UnitPrice=" + Uri.EscapeDataString(PayAmount);
										postData += "&Quantity=" + Uri.EscapeDataString("1");
										postData += "&Amount=" + Uri.EscapeDataString(PayAmount);
										postData += "&user_id=" + Uri.EscapeDataString(CustomerId);
										postData += "&check_pwd=" + Uri.EscapeDataString(trade_pwd);
										postData += "&Remark=" + Uri.EscapeDataString(PayAmount == "10000" ? "網記會員年費一年" : "網記主任年費一年");
										postData += "&CarrierType=" + Uri.EscapeDataString(checkCarrierType ?? "");
										postData += "&CarrierId2=" + Uri.EscapeDataString(checkCarrierId2 ?? "");
										postData += "&NPOBAN=" + Uri.EscapeDataString(checkNPOBAN ?? "");
										var data = Encoding.ASCII.GetBytes(postData);
										request.Method = "POST";
										request.ContentType = "application/x-www-form-urlencoded";
										request.ContentLength = data.Length;
										using (var stream = request.GetRequestStream())
										{
											stream.Write(data, 0, data.Length);
										}
										var response = (HttpWebResponse)request.GetResponse();
									}
								}
								con.Close();
							}
						}
					}
				}
				//else
				//{
				//	string ST = Request.Form["Send_Type"].ToString();
				//	string em = Request.Form["e_money"].ToString();
				//	string ed = Request.Form["e_date"].ToString();
				//	string et = Request.Form["e_time"].ToString();
				//	string epayac = Request.Form["e_payaccount"].ToString();
				//	string epayif = Request.Form["e_PayInfo"].ToString();
				//	string strch = Request.Form["str_check"].ToString();

				//	string SUM = ST + res + msg + oid + em + PayAmount + ed + et + eoid + epayac + epayif + strch;
				//	string sql1 = @"Update Member_Convenience_store_code_payment set Remark = @Remark output inserted.Id Where e_orderno = @Eid";
				//	string[] pName1 = { "@Remark", "@Eid" };
				//	string[] pVal1 = { SUM, eoid };
				//	uc.PiNewsSql(sql1, pName1, pVal1);
				//}
			}

			else
			{
				string res = Request.Form["result"].ToString();
				string eoid = Request.Form["e_orderno"].ToString();
				string CustomerId = "53229980";
				string PayAmount = Request.Form["PayAmount"].ToString();
				string oid = Request.Form["OrderID"].ToString();
				string trade_pwd = "u8hl5arkf0qkp9u52be9r6ywtiudvlcg";
				string needMD5 = res + eoid + CustomerId + PayAmount + oid + trade_pwd;
				string msg = RetrievePassedUrl();

				string StoreType = Request.Form["StoreType"].ToString();
				string PinCode = Request.Form["PinCode"].ToString();
				string e_money = Request.Form["e_money"].ToString();
				string e_date = Request.Form["e_date"].ToString();
				string e_time = Request.Form["e_time"].ToString();
				string Barcode2 = Request.Form["Barcode2"].ToString();
				string Market_ID = Request.Form["Market_ID"].ToString();
				string Shop_Store_Name = Request.Form["Shop_Store_Name"].ToString();

				string ST = Request.Form["Send_Type"].ToString();
				string em = Request.Form["e_money"].ToString();
				string ed = Request.Form["e_date"].ToString();
				string et = Request.Form["e_time"].ToString();
				string epayac = Request.Form["e_payaccount"].ToString();
				string epayif = Request.Form["e_PayInfo"].ToString();
				string strch = Request.Form["str_check"].ToString();

				string SUM = ST + res + msg + oid + em + PayAmount + ed + et + eoid + epayac + epayif + strch;
				string sql1 = @"Update Member_Payment set Remark = @Remark output inserted.Id Where Order_Id = @Eid";
				string[] pName1 = { "@Remark", "@Eid" };
				string[] pVal1 = { SUM, eoid };
				uc.PiNewsSql(sql1, pName1, pVal1);
			}

		}

		public string RetrievePassedUrl()
		{
			return HttpContext.Current.Server.UrlDecode(HttpContext.Current.Request.Form["ret_msg"]);
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