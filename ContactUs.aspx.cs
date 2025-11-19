using System;
using System.Net.Mail;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace piNews
{
    public partial class ContactUs : System.Web.UI.Page
    {

    protected void Page_Load(object sender, EventArgs e)
    {
      //this.Master.Page.Title = "聯絡我們 | 拍新聞";
      ((HiddenField)Master.FindControl("ContentPageTitle_HF")).Value = "聯絡我們 | ";
    }

    protected void ContactUs_Btn_Click(object sender, EventArgs e)
    {
        string content = messsage.Value;
        string n = name.Text;
        string m = mail.Text;
        string p = phone.Text;

        SendmessageEmail(n,m,p,content);
        modal_header.Text = "發送成功";
        modal_content.Text = "感謝你的來信，我們將盡快回復您!!";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "send mail success", "$('.ui.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');", true);
    }

    public void SendEmail(string From, string To, string Subject, string Body)
        {
            MailMessage msg = new MailMessage();
            //收件者，以逗號分隔不同收件者 ex "test@gmail.com,test2@gmail.com"
            msg.To.Add(To);
            msg.From = new MailAddress(From, Subject, System.Text.Encoding.UTF8);
            //郵件標題 
            msg.Subject = Subject;
            //郵件標題編碼  
            msg.SubjectEncoding = System.Text.Encoding.UTF8;
            //郵件內容
            msg.Body = Body;
            msg.IsBodyHtml = true;
            msg.BodyEncoding = System.Text.Encoding.UTF8;//郵件內容編碼 
            msg.Priority = MailPriority.Normal;//郵件優先級 
                                               //建立 SmtpClient 物件 並設定 Gmail的smtp主機及Port 
            #region 其它 Host
            /*
             *  outlook.com smtp.live.com port:25
             *  yahoo smtp.mail.yahoo.com.tw port:465
            */
            #endregion
            SmtpClient MySmtp = new SmtpClient("smtp.gmail.com", 587);
            //設定你的帳號密碼
            MySmtp.Credentials = new System.Net.NetworkCredential("pinews.tw@gmail.com", "bazsbklppmgvjndb");
            //Gmial 的 smtp 使用 SSL
            MySmtp.EnableSsl = true;
            MySmtp.Send(msg);
        }

    public void SendmessageEmail( string name, string email, string phone, string content)
        {
            string body = String.Format(@"發問者姓名: {0} <br>
                                          發問者郵件地址: {1} <br>
                                          發問者手機號碼: {2} <br>
                                          發問內容: {3}", name ,email,phone ,content);
            SendEmail("pinews.tw@gmail.com", "pinews.tw@gmail.com", "拍新聞'聯絡我們'信件", body);
        }

    }
}