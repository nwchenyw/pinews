using System;
using System.IO;
using System.Web;

namespace piNews
{
  public partial class OnlinePost : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      if (Session["User_Id"] != null)
      {
        Name_TB.Text = Session["Name"].ToString();
        Email_TB.Text = Session["Email"].ToString();
      }
      else
      {
        Response.Redirect("Login.aspx");
      }
    }

    protected void Send_Btn_Click(object sender, EventArgs e)
    {
      string name = Name_TB.Text;
      string email = Email_TB.Text;

      string title = Title_TB.Text;
      string category = Category_HF.Value;
      string content = Content_TB.Text;
      string fimgid = "";
      string[] replace_from = imgUrl_HF.Value.Split(',');
      string[] replace_to = new string[replace_from.Length];

      string query = "Insert into Image output Inserted.Id Values('Image', @name, @path, @id, GETDATE());";
      string[] paramN = { "@name", "@path", "@id" };
      string sql = "Insert into Article output Inserted.Id Values(@title, @content, @imgid, @cat, null, GETDATE(), '0', null, null, @name, @email, null, null)";
      string[] param = { "@title", "@content", "@imgid", "@cat", "@name", "@email" };
      int cnt = 0;

      string fileExtension = Path.GetExtension(Front_Img_FU.PostedFile.FileName);

      string ftppath = "ftp://192.168.1.150/web/pinews/img/news/";
      string fileName = Guid.NewGuid() + fileExtension;

      string savePath = ftppath + fileName;

      if (Front_Img_FU.HasFile)
      {
        uc.FTPUpload(savePath, Front_Img_FU.PostedFile, this);

        string[] paramVal = { fileName, "img/news/" + fileName, Session["User_Id"].ToString() };
        fimgid = uc.PiNewsSql(query, paramN, paramVal);
        uc.UserLog("Image", fimgid, "Insert", "新增首圖", Session["User_Id"].ToString(), Session["IP"].ToString());

      }

      if (img_FU.HasFiles)
      {
        foreach (HttpPostedFile upFile in img_FU.PostedFiles)
        {
          fileExtension = Path.GetExtension(upFile.FileName);

          ftppath = "ftp://192.168.1.150/web/pinews/img/news/";
          fileName = Guid.NewGuid() + fileExtension;

          savePath = ftppath + fileName;
          uc.FTPUpload(savePath, upFile, this);

          string path = "img/news/" + fileName;
          string[] paramVal1 = { fileName, path, Session["User_Id"].ToString() };
          replace_to[cnt] = uc.PiNewsSql(query, paramN, paramVal1);
          content = content.Replace(replace_from[cnt], path);
          uc.UserLog("Image", replace_to[cnt], "Insert", "新增內文圖片", Session["User_Id"].ToString(), Session["IP"].ToString());

          cnt++;
        }
      }

      //cuz validate = false so u need to do encode when store in db and decode when get data from db :D
      string[] value = { HttpUtility.HtmlEncode(title), HttpUtility.HtmlEncode(content), fimgid, category, name, email };
      string article_id = uc.PiNewsSql(sql, param, value);
      uc.UserLog("Article", article_id, "Insert", "新增文章", Session["User_Id"].ToString(), Session["IP"].ToString());

      modal_header.Text = "新增文章";
      modal_content.Text = "新增成功";
      uc.FrontEndDebug(this, "final content", string.Format("console.log(`{0}`);", content) + "$('.ui.notify.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');");
    }

    protected void HiddenField1_ValueChanged(object sender, EventArgs e)
    {
      if (Session["new_Img"] != null)
      {
        string arrStr = Session["new_Img"].ToString();
        Repeater1.DataSource = arrStr.Substring(0, arrStr.Length - 1).Split(',');
        Repeater1.DataBind();
      }
    }
  }
}