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

namespace piNews
{
  public partial class Testchoosepaymode : System.Web.UI.Page
  {
    UserClass uc = new UserClass();	
    protected void Page_Load(object sender, EventArgs e)
    {
		
    }
		
	protected void pay_Btn1_Click(object sender, EventArgs e)
	{
	   string Order_No = Session["Order_No"].ToString();
	   string price = Session["price"].ToString();
   	   string Buyer_Name = Session["Buyer_Name"].ToString();
	   string Buyer_Telm = Session["Buyer_Telm"].ToString();
       string Buyer_Mail = Session["Buyer_Mail"].ToString();
       string Buyer_Memo = Session["Buyer_Memo"].ToString();
	  if ( invoice1.Checked == true && string.IsNullOrWhiteSpace(Invoice_carrier.Text) == false )
	  {
		Session["CarrierType"] = "1K0001";
		Session["CarrierId2"] = Invoice_carrier.Text;
	    Session["BuyerIdentifier"] = "";
		Session["NPOBAN"] = "";
		string prquery = @"Update Member_Payment set CarrierType = @CT, CarrierId2 = @Cid2, BuyerIdentifier = @Bif, NPOBAN = @NP output Inserted.Id Where Order_Id = @Oid";
		string[] prparamN = { "@CT", "@Cid2", "@Bif", "@NP", "@Oid" };
		string[] prparamV = { Session["CarrierType"].ToString(), Session["CarrierId2"].ToString(), Session["BuyerIdentifier"].ToString(), Session["NPOBAN"].ToString(), Order_No };
		uc.PiNewsSql(prquery, prparamN, prparamV);

	    string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=0&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&TransCode=00&Buyer_Name={2}&Buyer_Telm={3}&Buyer_Mail={4}&Buyer_Memo={5}&Return_url=https://pinews.asia/Testpaycheck.aspx", Order_No, price, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo );		  
        Response.Redirect(url);
	  }
	  else if ( invoice2.Checked == true && string.IsNullOrWhiteSpace(Invoice_carrier.Text) == false )
	  {
		Session["CarrierType"] = "3J0002";
		Session["CarrierId2"] = Invoice_carrier.Text;
	    Session["BuyerIdentifier"] = "";
		Session["NPOBAN"] = "";
		string prquery = @"Update Member_Payment set CarrierType = @CT, CarrierId2 = @Cid2, BuyerIdentifier = @Bif, NPOBAN = @NP output Inserted.Id Where Order_Id = @Oid";
		string[] prparamN = { "@CT", "@Cid2", "@Bif", "@NP", "@Oid" };
		string[] prparamV = { Session["CarrierType"].ToString(), Session["CarrierId2"].ToString(), Session["BuyerIdentifier"].ToString(), Session["NPOBAN"].ToString(), Order_No };
		uc.PiNewsSql(prquery, prparamN, prparamV);

	    string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=0&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&TransCode=00&Buyer_Name={2}&Buyer_Telm={3}&Buyer_Mail={4}&Buyer_Memo={5}&Return_url=https://pinews.asia/Testpaycheck.aspx", Order_No, price, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo );		  
        Response.Redirect(url);
      }
	  else if ( invoice3.Checked == true && string.IsNullOrWhiteSpace(Invoice_carrier.Text) == false )
	  {
		Session["NPOBAN"] = Invoice_carrier.Text;
	    Session["BuyerIdentifier"] = "";
        Session["CarrierType"] = "";
		Session["CarrierId2"] = "";	
		string prquery = @"Update Member_Payment set CarrierType = @CT, CarrierId2 = @Cid2, BuyerIdentifier = @Bif, NPOBAN = @NP output Inserted.Id Where Order_Id = @Oid";
		string[] prparamN = { "@CT", "@Cid2", "@Bif", "@NP", "@Oid" };
		string[] prparamV = { Session["CarrierType"].ToString(), Session["CarrierId2"].ToString(), Session["BuyerIdentifier"].ToString(), Session["NPOBAN"].ToString(), Order_No };
		uc.PiNewsSql(prquery, prparamN, prparamV);

	    string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=0&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&TransCode=00&Buyer_Name={2}&Buyer_Telm={3}&Buyer_Mail={4}&Buyer_Memo={5}&Return_url=https://pinews.asia/Testpaycheck.aspx", Order_No, price, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo );		  
        Response.Redirect(url);		
      }
	  else if (invoice1.Checked == true || invoice2.Checked == true || invoice3.Checked == true)
      {
		 if( string.IsNullOrWhiteSpace(Invoice_carrier.Text) )
		 {
			invoiceRemark.Text = "請輸入條碼或號碼";
			invoiceRemark.Style["color"] = "red";
			invoiceRemark.Style["font-weight"] = "bolder";
		 }
      }
	  else
	  {
		Session["NPOBAN"] = "";
        Session["CarrierType"] = "";
		Session["CarrierId2"] = "";	
	    Session["BuyerIdentifier"] = BuyerIdentifier.Text;
		string prquery = @"Update Member_Payment set CarrierType = @CT, CarrierId2 = @Cid2, BuyerIdentifier = @Bif, NPOBAN = @NP output Inserted.Id Where Order_Id = @Oid";
		string[] prparamN = { "@CT", "@Cid2", "@Bif", "@NP", "@Oid" };
		string[] prparamV = { Session["CarrierType"].ToString(), Session["CarrierId2"].ToString(), Session["BuyerIdentifier"].ToString(), Session["NPOBAN"].ToString(), Order_No };
		uc.PiNewsSql(prquery, prparamN, prparamV);

	    string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=0&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&TransCode=00&Buyer_Name={2}&Buyer_Telm={3}&Buyer_Mail={4}&Buyer_Memo={5}&Return_url=https://pinews.asia/Testpaycheck.aspx", Order_No, price, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo );		  
        Response.Redirect(url);	
	  }
	}
	
	protected void pay_Btn2_Click(object sender, EventArgs e)
	{
	   string Order_No = Session["Order_No"].ToString();
	   string price = Session["price"].ToString();
	   string Buyer_Name = Session["Buyer_Name"].ToString();
	   string Buyer_Telm = Session["Buyer_Telm"].ToString();
       string Buyer_Mail = Session["Buyer_Mail"].ToString();
       string Buyer_Memo = Session["Buyer_Memo"].ToString();	
	  if ( invoice1.Checked == true && string.IsNullOrWhiteSpace(Invoice_carrier.Text) == false )
	  {
		Session["CarrierType"] = "1K0001";
		Session["CarrierId2"] = Invoice_carrier.Text;
	    Session["BuyerIdentifier"] = "";
		Session["NPOBAN"] = "";
		string prquery = @"Update Member_Payment set CarrierType = @CT, CarrierId2 = @Cid2, BuyerIdentifier = @Bif, NPOBAN = @NP output Inserted.Id Where Order_Id = @Oid";
		string[] prparamN = { "@CT", "@Cid2", "@Bif", "@NP", "@Oid" };
		string[] prparamV = { Session["CarrierType"].ToString(), Session["CarrierId2"].ToString(), Session["BuyerIdentifier"].ToString(), Session["NPOBAN"].ToString(), Order_No };
		uc.PiNewsSql(prquery, prparamN, prparamV);

	    string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=4&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&Buyer_Name={2}&Buyer_Telm={3}&Buyer_Mail={4}&Buyer_Memo={5}&Return_url=https://pinews.asia/Testpaycheck.aspx&Callback_Url=https://pinews.asia/Testurlcallback.aspx", Order_No, price, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo );		  
        Response.Redirect(url);	
	  }
	  else if ( invoice2.Checked == true && string.IsNullOrWhiteSpace(Invoice_carrier.Text) == false )
	  {
		Session["CarrierType"] = "3J0002";
		Session["CarrierId2"] = Invoice_carrier.Text;
	    Session["BuyerIdentifier"] = "";
		Session["NPOBAN"] = "";
		string prquery = @"Update Member_Payment set CarrierType = @CT, CarrierId2 = @Cid2, BuyerIdentifier = @Bif, NPOBAN = @NP output Inserted.Id Where Order_Id = @Oid";
		string[] prparamN = { "@CT", "@Cid2", "@Bif", "@NP", "@Oid" };
		string[] prparamV = { Session["CarrierType"].ToString(), Session["CarrierId2"].ToString(), Session["BuyerIdentifier"].ToString(), Session["NPOBAN"].ToString(), Order_No };
		uc.PiNewsSql(prquery, prparamN, prparamV);

	    string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=4&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&Buyer_Name={2}&Buyer_Telm={3}&Buyer_Mail={4}&Buyer_Memo={5}&Return_url=https://pinews.asia/Testpaycheck.aspx&Callback_Url=https://pinews.asia/Testurlcallback.aspx", Order_No, price, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo );		  
        Response.Redirect(url);
      }
	  else if ( invoice3.Checked == true && string.IsNullOrWhiteSpace(Invoice_carrier.Text) == false )
	  {
		Session["NPOBAN"] = Invoice_carrier.Text;
	    Session["BuyerIdentifier"] = "";
        Session["CarrierType"] = "";
		Session["CarrierId2"] = "";	  
		string prquery = @"Update Member_Payment set CarrierType = @CT, CarrierId2 = @Cid2, BuyerIdentifier = @Bif, NPOBAN = @NP output Inserted.Id Where Order_Id = @Oid";
		string[] prparamN = { "@CT", "@Cid2", "@Bif", "@NP", "@Oid" };
		string[] prparamV = { Session["CarrierType"].ToString(), Session["CarrierId2"].ToString(), Session["BuyerIdentifier"].ToString(), Session["NPOBAN"].ToString(), Order_No };
		uc.PiNewsSql(prquery, prparamN, prparamV);

	    string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=4&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&Buyer_Name={2}&Buyer_Telm={3}&Buyer_Mail={4}&Buyer_Memo={5}&Return_url=https://pinews.asia/Testpaycheck.aspx&Callback_Url=https://pinews.asia/Testurlcallback.aspx", Order_No, price, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo );		  
        Response.Redirect(url);	
      }
	  else if (invoice1.Checked == true || invoice2.Checked == true || invoice3.Checked == true)
      {
		 if( string.IsNullOrWhiteSpace(Invoice_carrier.Text) )
		 {
			invoiceRemark.Text = "請輸入條碼或號碼";
			invoiceRemark.Style["color"] = "red";
			invoiceRemark.Style["font-weight"] = "bolder";
		 }
      }
	  else
	  {
		Session["NPOBAN"] = "";
        Session["CarrierType"] = "";
		Session["CarrierId2"] = "";	
	    Session["BuyerIdentifier"] = BuyerIdentifier.Text;
		string prquery = @"Update Member_Payment set CarrierType = @CT, CarrierId2 = @Cid2, BuyerIdentifier = @Bif, NPOBAN = @NP output Inserted.Id Where Order_Id = @Oid";
		string[] prparamN = { "@CT", "@Cid2", "@Bif", "@NP", "@Oid" };
		string[] prparamV = { Session["CarrierType"].ToString(), Session["CarrierId2"].ToString(), Session["BuyerIdentifier"].ToString(), Session["NPOBAN"].ToString(), Order_No };
		uc.PiNewsSql(prquery, prparamN, prparamV);	  

	    string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=4&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&Buyer_Name={2}&Buyer_Telm={3}&Buyer_Mail={4}&Buyer_Memo={5}&Return_url=https://pinews.asia/Testpaycheck.aspx&Callback_Url=https://pinews.asia/Testurlcallback.aspx", Order_No, price, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo );		  
        Response.Redirect(url);		
	  }	  	
	}
	
	protected void pay_Btn3_Click(object sender, EventArgs e)
	{
	  if ( invoice1.Checked == true && string.IsNullOrWhiteSpace(Invoice_carrier.Text) == false )
	  {
			Session["CarrierType"] = "1K0001";
			Session["CarrierId2"] = Invoice_carrier.Text;
			Session["BuyerIdentifier"] = "";
	    	Session["NPOBAN"] = "";
			string Order_No = Session["Order_No"].ToString();
			string price = Session["price"].ToString();
			string Buyer_Name = Session["Buyer_Name"].ToString();
			string Buyer_Telm = Session["Buyer_Telm"].ToString();
			string Buyer_Mail = Session["Buyer_Mail"].ToString();
			string Buyer_Memo = Session["Buyer_Memo"].ToString();
			string prquery = @"Update Member_Payment set CarrierType = @CT, CarrierId2 = @Cid2, BuyerIdentifier = @Bif, NPOBAN = @NP output Inserted.Id Where Order_Id = @Oid";
			string[] prparamN = { "@CT", "@Cid2", "@Bif", "@NP", "@Oid" };
			string[] prparamV = { Session["CarrierType"].ToString(), Session["CarrierId2"].ToString(), Session["BuyerIdentifier"].ToString(), Session["NPOBAN"].ToString(), Order_No };
			uc.PiNewsSql(prquery, prparamN, prparamV);

			if (Family.Checked == true)
			{
				string StoreType = "0";
				string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=6&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&StoreType={2}&Buyer_Name={3}&Buyer_Telm={4}&Buyer_Mail={5}&Buyer_Memo={6}&Return_url=https://pinews.asia/Testpaycheck.aspx&Callback_Url=https://pinews.asia/Testurlcallback.aspx", Order_No, price, StoreType, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo);
				Response.Redirect(url);
			}
			else if (Ok.Checked == true)
			{
				string StoreType = "1";
				string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=6&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&StoreType={2}&Buyer_Name={3}&Buyer_Telm={4}&Buyer_Mail={5}&Buyer_Memo={6}&Return_url=https://pinews.asia/Testpaycheck.aspx&Callback_Url=https://pinews.asia/Testurlcallback.aspx", Order_No, price, StoreType, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo);
				Response.Redirect(url);
			}
			else if (Lairfu.Checked == true)
			{
				string StoreType = "2";
				string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=6&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&StoreType={2}&Buyer_Name={3}&Buyer_Telm={4}&Buyer_Mail={5}&Buyer_Memo={6}&Return_url=https://pinews.asia/Testpaycheck.aspx&Callback_Url=https://pinews.asia/Testurlcallback.aspx", Order_No, price, StoreType, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo);
				Response.Redirect(url);
			}
			else if (Seven.Checked == true)
			{
				string StoreType = "3";
				string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=6&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&StoreType={2}&Buyer_Name={3}&Buyer_Telm={4}&Buyer_Mail={5}&Buyer_Memo={6}&Return_url=https://pinews.asia/Testpaycheck.aspx&Callback_Url=https://pinews.asia/Testurlcallback.aspx", Order_No, price, StoreType, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo);
				Response.Redirect(url);
			}
			else 
			{
				Remark.Text = "請選擇商店";
				Remark.Style["color"] = "red";
				Remark.Style["font-weight"] = "bolder";
			}
	  }
	  else if ( invoice2.Checked == true && string.IsNullOrWhiteSpace(Invoice_carrier.Text) == false )
	  {
			Session["CarrierType"] = "3J0002";
			Session["CarrierId2"] = Invoice_carrier.Text;
			Session["BuyerIdentifier"] = "";
		    Session["NPOBAN"] = "";
			string Order_No = Session["Order_No"].ToString();
			string price = Session["price"].ToString();
			string Buyer_Name = Session["Buyer_Name"].ToString();
			string Buyer_Telm = Session["Buyer_Telm"].ToString();
			string Buyer_Mail = Session["Buyer_Mail"].ToString();
			string Buyer_Memo = Session["Buyer_Memo"].ToString();
			string prquery = @"Update Member_Payment set CarrierType = @CT, CarrierId2 = @Cid2, BuyerIdentifier = @Bif, NPOBAN = @NP output Inserted.Id Where Order_Id = @Oid";
			string[] prparamN = { "@CT", "@Cid2", "@Bif", "@NP", "@Oid" };
			string[] prparamV = { Session["CarrierType"].ToString(), Session["CarrierId2"].ToString(), Session["BuyerIdentifier"].ToString(), Session["NPOBAN"].ToString(), Order_No };
			uc.PiNewsSql(prquery, prparamN, prparamV);

			if (Family.Checked == true)
			{
				string StoreType = "0";
				string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=6&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&StoreType={2}&Buyer_Name={3}&Buyer_Telm={4}&Buyer_Mail={5}&Buyer_Memo={6}&Return_url=https://pinews.asia/Testpaycheck.aspx&Callback_Url=https://pinews.asia/Testurlcallback.aspx", Order_No, price, StoreType, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo);
				Response.Redirect(url);
			}
			else if (Ok.Checked == true)
			{
				string StoreType = "1";
				string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=6&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&StoreType={2}&Buyer_Name={3}&Buyer_Telm={4}&Buyer_Mail={5}&Buyer_Memo={6}&Return_url=https://pinews.asia/Testpaycheck.aspx&Callback_Url=https://pinews.asia/Testurlcallback.aspx", Order_No, price, StoreType, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo);
				Response.Redirect(url);
			}
			else if (Lairfu.Checked == true)
			{
				string StoreType = "2";
				string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=6&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&StoreType={2}&Buyer_Name={3}&Buyer_Telm={4}&Buyer_Mail={5}&Buyer_Memo={6}&Return_url=https://pinews.asia/Testpaycheck.aspx&Callback_Url=https://pinews.asia/Testurlcallback.aspx", Order_No, price, StoreType, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo);
				Response.Redirect(url);
			}
			else if (Seven.Checked == true)
			{
				string StoreType = "3";
				string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=6&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&StoreType={2}&Buyer_Name={3}&Buyer_Telm={4}&Buyer_Mail={5}&Buyer_Memo={6}&Return_url=https://pinews.asia/Testpaycheck.aspx&Callback_Url=https://pinews.asia/Testurlcallback.aspx", Order_No, price, StoreType, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo);
				Response.Redirect(url);
			}
			else 
			{
				Remark.Text = "請選擇商店";
				Remark.Style["color"] = "red";
				Remark.Style["font-weight"] = "bolder";
			}
      }
	  else if ( invoice3.Checked == true && string.IsNullOrWhiteSpace(Invoice_carrier.Text) == false )
	  {
			Session["NPOBAN"] = Invoice_carrier.Text;
			Session["BuyerIdentifier"] = "";
			Session["CarrierType"] = "";
			Session["CarrierId2"] = "";
			string Order_No = Session["Order_No"].ToString();
			string price = Session["price"].ToString();
			string Buyer_Name = Session["Buyer_Name"].ToString();
			string Buyer_Telm = Session["Buyer_Telm"].ToString();
			string Buyer_Mail = Session["Buyer_Mail"].ToString();
			string Buyer_Memo = Session["Buyer_Memo"].ToString();
			string prquery = @"Update Member_Payment set CarrierType = @CT, CarrierId2 = @Cid2, BuyerIdentifier = @Bif, NPOBAN = @NP output Inserted.Id Where Order_Id = @Oid";
			string[] prparamN = { "@CT", "@Cid2", "@Bif", "@NP", "@Oid" };
			string[] prparamV = { Session["CarrierType"].ToString(), Session["CarrierId2"].ToString(), Session["BuyerIdentifier"].ToString(), Session["NPOBAN"].ToString(), Order_No };
			uc.PiNewsSql(prquery, prparamN, prparamV);

			if (Family.Checked == true)
			{
				string StoreType = "0";
				string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=6&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&StoreType={2}&Buyer_Name={3}&Buyer_Telm={4}&Buyer_Mail={5}&Buyer_Memo={6}&Return_url=https://pinews.asia/Testpaycheck.aspx&Callback_Url=https://pinews.asia/Testurlcallback.aspx", Order_No, price, StoreType, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo);
				Response.Redirect(url);
			}
			else if (Ok.Checked == true)
			{
				string StoreType = "1";
				string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=6&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&StoreType={2}&Buyer_Name={3}&Buyer_Telm={4}&Buyer_Mail={5}&Buyer_Memo={6}&Return_url=https://pinews.asia/Testpaycheck.aspx&Callback_Url=https://pinews.asia/Testurlcallback.aspx", Order_No, price, StoreType, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo);
				Response.Redirect(url);
			}
			else if (Lairfu.Checked == true)
			{
				string StoreType = "2";
				string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=6&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&StoreType={2}&Buyer_Name={3}&Buyer_Telm={4}&Buyer_Mail={5}&Buyer_Memo={6}&Return_url=https://pinews.asia/Testpaycheck.aspx&Callback_Url=https://pinews.asia/Testurlcallback.aspx", Order_No, price, StoreType, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo);
				Response.Redirect(url);
			}
			else if (Seven.Checked == true)
			{
				string StoreType = "3";
				string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=6&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&StoreType={2}&Buyer_Name={3}&Buyer_Telm={4}&Buyer_Mail={5}&Buyer_Memo={6}&Return_url=https://pinews.asia/Testpaycheck.aspx&Callback_Url=https://pinews.asia/Testurlcallback.aspx", Order_No, price, StoreType, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo);
				Response.Redirect(url);
			}
			else 
			{
				Remark.Text = "請選擇商店";
				Remark.Style["color"] = "red";
				Remark.Style["font-weight"] = "bolder";
			}
      }
	  else if (invoice1.Checked == true || invoice2.Checked == true || invoice3.Checked == true)
      {
		 if( string.IsNullOrWhiteSpace(Invoice_carrier.Text) )
		 {
			invoiceRemark.Text = "請輸入條碼或號碼";
			invoiceRemark.Style["color"] = "red";
			invoiceRemark.Style["font-weight"] = "bolder";
		 }
      }
	  else
	  {
			Session["NPOBAN"] = "";
			Session["CarrierType"] = "";
			Session["CarrierId2"] = "";	
			Session["BuyerIdentifier"] = BuyerIdentifier.Text;
			string Order_No = Session["Order_No"].ToString();
			string price = Session["price"].ToString();
			string Buyer_Name = Session["Buyer_Name"].ToString();
			string Buyer_Telm = Session["Buyer_Telm"].ToString();
			string Buyer_Mail = Session["Buyer_Mail"].ToString();
			string Buyer_Memo = Session["Buyer_Memo"].ToString();
			string prquery = @"Update Member_Payment set CarrierType = @CT, CarrierId2 = @Cid2, BuyerIdentifier = @Bif, NPOBAN = @NP output Inserted.Id Where Order_Id = @Oid";
			string[] prparamN = { "@CT", "@Cid2", "@Bif", "@NP", "@Oid" };
			string[] prparamV = { Session["CarrierType"].ToString(), Session["CarrierId2"].ToString(), Session["BuyerIdentifier"].ToString(), Session["NPOBAN"].ToString(), Order_No };
			uc.PiNewsSql(prquery, prparamN, prparamV);

			if (Family.Checked == true)
			{
				string StoreType = "0";
				string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=6&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&StoreType={2}&Buyer_Name={3}&Buyer_Telm={4}&Buyer_Mail={5}&Buyer_Memo={6}&Return_url=http://pinews.asia/Testpaycheck.aspx&Callback_Url=http://pinews.asia/Testurlcallback.aspx", Order_No, price, StoreType, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo);
				Response.Redirect(url);
			}
			else if (Ok.Checked == true)
			{
				string StoreType = "1";
				string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=6&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&StoreType={2}&Buyer_Name={3}&Buyer_Telm={4}&Buyer_Mail={5}&Buyer_Memo={6}&Return_url=http://pinews.asia/Testpaycheck.aspx&Callback_Url=http://pinews.asia/Testurlcallback.aspx", Order_No, price, StoreType, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo);
				Response.Redirect(url);
			}
			else if (Lairfu.Checked == true)
			{
				string StoreType = "2";
				string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=6&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&StoreType={2}&Buyer_Name={3}&Buyer_Telm={4}&Buyer_Mail={5}&Buyer_Memo={6}&Return_url=http://pinews.asia/Testpaycheck.aspx&Callback_Url=http://pinews.asia/Testurlcallback.aspx", Order_No, price, StoreType, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo);
				Response.Redirect(url);
			}
			else if (Seven.Checked == true)
			{
				string StoreType = "3";
				string url = string.Format(@"https://n.gomypay.asia/TestShuntClass.aspx?Send_Type=6&Pay_Mode_No=2&CustomerId=53229980&Order_No={0}&Amount={1}&StoreType={2}&Buyer_Name={3}&Buyer_Telm={4}&Buyer_Mail={5}&Buyer_Memo={6}&Return_url=http://pinews.asia/Testpaycheck.aspx&Callback_Url=http://pinews.asia/Testurlcallback.aspx", Order_No, price, StoreType, Buyer_Name, Buyer_Telm, Buyer_Mail, Buyer_Memo);
				Response.Redirect(url);
			}
			else 
			{
				Remark.Text = "請選擇商店";
				Remark.Style["color"] = "red";
				Remark.Style["font-weight"] = "bolder";
			}		
	  }	  	
	}

  }
}