using Microsoft.AspNet.SignalR;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;

namespace piNews
{
  public partial class Admin_newArticle : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    public class msg_list
    {
      public string name { get; set; }
      public string msg { get; set; }
    }
    public class link_msg_list
    {
      public string name { get; set; }
      public string msg { get; set; }
      public string link { get; set; }
    }

    protected void Page_init(object sender, EventArgs e)
    {
      //Button btn = (Button)this.Form.Parent.FindControl("lbtn");
      PostBackTrigger Trigger1 = new PostBackTrigger();
      Trigger1.ControlID = Submit_Btn.UniqueID;
      ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger1);
    }

    bool hasntSubmit = true;
    protected void Page_Load(object sender, EventArgs e)
    {

      if (IsPostBack)
      {

        if (!string.IsNullOrEmpty(Request.Form[Submit_Btn.UniqueID]))
        {
          uc.FrontEndDebug(this, "hasnt submit", string.Format("console.log('hasnt submit:{0}');", hasntSubmit));
        }
        string eTarget = Request.Params["__EVENTTARGET"].ToString();
        string buttonevent = Submit_Btn.UniqueID;

        //uc.FrontEndDebug(this, "ispostback", string.Format("alert('ispostback:{0}:{1}');", eTarget, buttonevent));
        if (eTarget == buttonevent && Session["User_Id"] == null)
        {
          // temp store
          //uc.FrontEndDebug(this, "check submit click", "alert('submit click && session timeout');");
          bool isAdmin = false;
          bool hasUser = false;

          string qry = "select isAdmin from Member where Id = @id and UserId = @email";

          string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
          using (SqlConnection con = new SqlConnection(constr))
          {
            using (SqlCommand cmd = new SqlCommand(qry, con))
            {
              con.Open();
              cmd.Parameters.Clear();

              cmd.Parameters.AddWithValue("@id", UID_HF.Value);
              cmd.Parameters.AddWithValue("@email", Email_HF.Value);

              using (SqlDataReader reader = cmd.ExecuteReader())
              {
                if (reader.HasRows)
                {
                  reader.Read();
                  isAdmin = (bool)reader["isAdmin"];
                  hasUser = true;
                }
                reader.Close();
              }
              con.Close();
            }
          }

          if (hasUser)
          {
            string title = title_TB.Text;
            string category = Category_HF.Value;
            string content = article_TB.Text;
            string stime = s_time.Text != "" ? Convert.ToDateTime(s_time.Text).ToString("yyyyMMdd HH:mm:ss") : "";
            string etime = e_time.Text != "" ? Convert.ToDateTime(e_time.Text).ToString("yyyyMMdd HH:mm:ss") : "";
            string keywords = Keywords_HF.Value;
            //string[] replace_from = imgUrl_HF.Value.Split(',');
            string ifcanview = isAdmin ? (status_CB.Checked ? "1" : "0") : "0";
            string ifrealname = "0";
            string description = HttpUtility.HtmlEncode(Regex.Replace(Description.Text, @"<script>[\s\S]+<\/script>", ""));
            string ip = uc.UserIP();

            //debug
            //uc.FrontEndDebug(this, "img replacement", string.Format("console.log('{0}');", string.Join(",", replace_from)));

            string[] replace_to = HiddenField1.Value.Split(','); //Session["new_Img"] != null ? Session["new_Img"].ToString().Substring(0, Session["new_Img"].ToString().Length - 1).Split(','): new string[] { };

            //string query = "Insert into Image output Inserted.Id Values('Image', @name, @path, @id, GETDATE());";
            //string[] paramN = { "@name", "@path", "@id" };
            string sql = "Insert into Article output Inserted.Id Values(@title, @content, @imgid, @cat, @keyword, GETDATE(), @status, @nstatus, @stime, @etime, @name, @email, @allimgid, null, @de, @uid)";
            string[] param = { "@title", "@content", "@imgid", "@cat", "@keyword", "@status", "@nstatus", "@stime", "@etime", "@name", "@email", "@allimgid", "@de", "@uid" };
            //int cnt = 0;
            string fimgid = "";

            if (Front_img_FU.HasFile)
            {
              string fileExtension = Path.GetExtension(Front_img_FU.PostedFile.FileName);

              string fileName = Guid.NewGuid() + fileExtension;
              string contentType = Front_img_FU.PostedFile.ContentType;
              byte[] bytes;

              using (Stream fs = Front_img_FU.PostedFile.InputStream)
              {
                using (BinaryReader br = new BinaryReader(fs))
                {
                  bytes = br.ReadBytes((Int32)fs.Length);
                }
              }

              Bitmap bmp = new Bitmap(new System.IO.MemoryStream(bytes));
              System.Drawing.Image img = bmp;
              if (img.Width > 800)
              {
                Bitmap new_bmp = uc.viewMaker(bmp, 800, 450);
                using (MemoryStream ms = new MemoryStream())
                {
                  new_bmp.Save(ms, bmp.RawFormat);
                  bytes = ms.ToArray();
                }
              }

              fimgid = uc.PiNewsInsertImg(contentType, fileName, Convert.ToDecimal(bytes.Length / 1024), "", bytes);

              uc.UserLog("Image", fimgid, "Insert", "新增首圖", UID_HF.Value, ip);
            }

            // cuz validate = false so u need to do encode when store in db and decode when get data from db :D


            string[] value = { HttpUtility.HtmlEncode(title), HttpUtility.HtmlEncode(Regex.Replace(content, @"<script>[\s\S]+<\/script>", "")), fimgid, category, keywords, ifcanview, ifrealname, stime, etime, Pname_HF.Value, Email_HF.Value, string.Join(",", replace_to), description, UID_HF.Value };
            string article_id = uc.PiNewsSql(sql, param, value);
            uc.UserLog("Article", article_id, "Insert", "新增文章", UID_HF.Value, ip);

            string query = @"if not exists (Select * from Article_Image where article_id = @aid and image_id = @imgid) 
Insert into Article_Image values(@aid, @imgid)";
            string[] para = { "@aid", "@imgid" };

            if (HiddenField1.Value.Trim().Length > 0)
            {
              for (var i = 0; i < replace_to.Length; i++)
              {
                string[] val = { article_id, replace_to[i] };
                uc.PiNewsSql(query, para, val);
              }
            }

            //debug
            modal_header.Text = "新增文章";
            modal_content.Text = "新增文章成功";
            uc.FrontEndDebug(this, "final content", //string.Format("console.log(`{0}`);", content) + 
              "$('.ui.notify.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');");


            hasntSubmit = false;
          }
        }
      }
      if (!IsPostBack)
      {
        if (Session["new_Img"] != null)
          Session["new_Img"] = null;
        Description.Attributes.Add("maxlength", "400");

        if (Session["User_Id"] != null)
        {
          Name_HF.Value = Session["Name"].ToString();
          Email_HF.Value = Session["Email"].ToString();
          UID_HF.Value = Session["User_Id"].ToString();
          Pname_HF.Value = Session["pname"].ToString();
        }
      };
      if (Session["User_Id"] == null) Response.Redirect("Default.aspx");
      else if (!Session["IsAdmin"].Equals("True")) status_CB.Enabled = false;

      this.Master.Page.Title = "新增投稿文章 | " + Application["Site_Name"];
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void UploadImage()
    {
      string jsonData = "-1";
      string state = "no file";
      if (img_UL.PostedFiles.Count > 0)
      {
        UserClass uc = new UserClass();
        HttpPostedFile file = img_UL.PostedFiles[0];
        string query = "Insert into Image output Inserted.Id Values('Image', @name, @path, @id, GETDATE());";
        string[] paramN = { "@name", "@path", "@id" };

        string fileExtension = Path.GetExtension(file.FileName);

        string ftppath = "ftp://192.168.1.150/web/pinews/img/news/";
        string fileName = Guid.NewGuid() + fileExtension;

        string savePath = ftppath + fileName;
        //uc.FTPUpload(savePath, files[0], (Page)(HttpContext.Current.Handler));
        uc.FTPUpload(savePath, file, this);

        string[] paramVal = { fileName, "img/news/" + fileName, Session["User_Id"].ToString() };
        string fimgid = uc.PiNewsSql(query, paramN, paramVal);
        state = "OK";
        uc.UserLog("Image", fimgid, "Insert", "新增內文圖片", Session["User_Id"].ToString(), Session["IP"].ToString());

      }
      //Send File details in a JSON Response.
      string json = new JavaScriptSerializer().Serialize(
          new
          {
            id = jsonData,
            stat = state,
          });
      Response.StatusCode = (int)HttpStatusCode.OK;
      Response.ContentType = "application/json";
      Response.Write(json);
      Response.End();
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UploadFile(HttpContext context)
    {
      string jsonData = "-1";
      string state = "no file";
      if (context.Request.Files.Count > 0)
      {
        UserClass uc = new UserClass();
        HttpFileCollection files = context.Request.Files;
        string query = "Insert into Image output Inserted.Id Values('Image', @name, @path, @id, GETDATE());";
        string[] paramN = { "@name", "@path", "@id" };

        string fileExtension = Path.GetExtension(files[0].FileName);

        string ftppath = "ftp://192.168.1.150/web/pinews/img/news/";
        string fileName = Guid.NewGuid() + fileExtension;

        string savePath = ftppath + fileName;
        uc.FTPUpload(savePath, files[0], (Page)(HttpContext.Current.Handler));
        //uc.FTPUpload(savePath, files[0], this);

        string[] paramVal = { fileName, "img/news/" + fileName, HttpContext.Current.Session["User_Id"].ToString() };
        string fimgid = uc.PiNewsSql(query, paramN, paramVal);
        state = "OK";
        uc.UserLog("Image", fimgid, "Insert", "新增內文圖片", HttpContext.Current.Session["User_Id"].ToString(), HttpContext.Current.Session["IP"].ToString());

      }
      //Send File details in a JSON Response.
      string json = new JavaScriptSerializer().Serialize(
          new
          {
            id = jsonData,
            stat = state,
          });
      //Response.StatusCode = (int)HttpStatusCode.OK;
      //Response.ContentType = "text/json";
      //Response.Write(json);
      //Response.End();

      return new JavaScriptSerializer().Serialize(new { id = jsonData, stat = state });
    }

    protected void Submit_Btn_Click(object sender, EventArgs e)
    {
      if (hasntSubmit)
      {
        string title = title_TB.Text;
        string category = Category_HF.Value;
        string content = article_TB.Text;
        string stime = s_time.Text != "" ? Convert.ToDateTime(s_time.Text).ToString("yyyyMMdd HH:mm:ss") : "";
        string etime = e_time.Text != "" ? Convert.ToDateTime(e_time.Text).ToString("yyyyMMdd HH:mm:ss") : "";
        string keywords = Keywords_HF.Value;
        //string[] replace_from = imgUrl_HF.Value.Split(',');
        string ifcanview = Session["IsAdmin"].Equals("True") ? (status_CB.Checked ? "1" : "0") : "0";
        string ifrealname = "0";
        string description = HttpUtility.HtmlEncode(Regex.Replace(Description.Text, @"<script>[\s\S]+<\/script>", ""));

        string base64 = Front_Img_HF.Value;
        byte[] bytes;
        //if (!string.IsNullOrEmpty(base64))
        //  bytes = Convert.FromBase64String(base64);


        //debug
        //uc.FrontEndDebug(this, "img replacement", string.Format("console.log('{0}');", string.Join(",", replace_from)));

        string[] replace_to = HiddenField1.Value.Split(','); //Session["new_Img"] != null ? Session["new_Img"].ToString().Substring(0, Session["new_Img"].ToString().Length - 1).Split(','): new string[] { };

        //string query = "Insert into Image output Inserted.Id Values('Image', @name, @path, @id, GETDATE());";
        //string[] paramN = { "@name", "@path", "@id" };
        string sql = "Insert into Article output Inserted.Id Values(@title, @content, @imgid, @cat, @keyword, GETDATE(), @status, @nstatus, @stime, @etime, @name, @email, @allimgid, null, @de, @uid)";
        string[] param = { "@title", "@content", "@imgid", "@cat", "@keyword", "@status", "@nstatus", "@stime", "@etime", "@name", "@email", "@allimgid", "@de", "@uid" };
        //int cnt = 0;
        string fimgid = "";

        if (Front_img_FU.HasFile)
        {
          string fileExtension = Path.GetExtension(Front_img_FU.PostedFile.FileName);

          string fileName = Guid.NewGuid() + fileExtension;
          string contentType = Front_img_FU.PostedFile.ContentType;
          //byte[] bytes;

          using (Stream fs = Front_img_FU.PostedFile.InputStream)
          {
            using (BinaryReader br = new BinaryReader(fs))
            {
              bytes = br.ReadBytes((Int32)fs.Length);
            }
          }

          Bitmap bmp = new Bitmap(new System.IO.MemoryStream(bytes));
          System.Drawing.Image img = bmp;
          if (img.Width > 800)
          {
            Bitmap new_bmp = uc.viewMaker(bmp, 800, 450);
            using (MemoryStream ms = new MemoryStream())
            {
              new_bmp.Save(ms, bmp.RawFormat);
              bytes = ms.ToArray();
            }
          }

          fimgid = uc.PiNewsInsertImg(contentType, fileName, Convert.ToDecimal(bytes.Length / 1024), Session["User_Id"].ToString(), bytes);

          uc.UserLog("Image", fimgid, "Insert", "新增首圖", Session["User_Id"].ToString(), Session["IP"].ToString());
        }
        else if (!Front_img_FU.HasFile && !string.IsNullOrEmpty(base64) && !string.IsNullOrEmpty(f_extension_HF.Value) && !string.IsNullOrEmpty(contenttype_HF.Value))
        {
          bytes = Convert.FromBase64String(base64);
          string fileName = Guid.NewGuid() + f_extension_HF.Value;

          fimgid = uc.PiNewsInsertImg(contenttype_HF.Value, fileName, Convert.ToDecimal(bytes.Length / 1024), Session["User_Id"].ToString(), bytes);

          uc.UserLog("Image", fimgid, "Insert", "新增首圖", Session["User_Id"].ToString(), Session["IP"].ToString());
        }

        // cuz validate = false so u need to do encode when store in db and decode when get data from db :D

        string[] value = { HttpUtility.HtmlEncode(title), HttpUtility.HtmlEncode(Regex.Replace(content, @"<script>[\s\S]+<\/script>", "")), fimgid, category, keywords, ifcanview, ifrealname, stime, etime, Session["pname"].ToString(), Session["Email"].ToString(), string.Join(",", replace_to), description, Session["User_Id"].ToString() };
        string article_id = uc.PiNewsSql(sql, param, value);
        uc.UserLog("Article", article_id, "Insert", "新增文章", Session["User_Id"].ToString(), Session["IP"].ToString());

        string query = @"if not exists (Select * from Article_Image where article_id = @aid and image_id = @imgid) 
Insert into Article_Image values(@aid, @imgid)";
        string[] para = { "@aid", "@imgid" };

        if (HiddenField1.Value.Trim().Length > 0)
        {
          for (var i = 0; i < replace_to.Length; i++)
          {
            string[] val = { article_id, replace_to[i] };
            uc.PiNewsSql(query, para, val);
          }
        }


        string sql1 = @"select a.UserId from UserLog ul left join (select Operate_User_Id, m.UserId, MAX(Operate_Time) dt from UserLog ul left join 
Member m on m.Id = ul.Operate_User_Id where (Modify_Action = 'follow' or Modify_Action = 'unfollow') and Modify_Id = @id 
group by Operate_User_Id, m.UserId) a on a.Operate_User_Id = ul.Operate_User_Id where a.dt = ul.Operate_Time and Modify_Action = 'follow'";
        string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
        using (SqlConnection con = new SqlConnection(constr))
        {
          using (SqlCommand cmd = new SqlCommand(query, con))
          {
            con.Open();
            cmd.CommandText = sql1;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@id", Session["User_Id"].ToString());

            var list = new List<string>();
            using (SqlDataReader reader = cmd.ExecuteReader())
            {
              while (reader.Read())
              {
                //string hash = uc.EncryptString(reader["UserId"].ToString(), "kb53229980");
                list.Add(reader["UserId"].ToString());

              };

              var context = GlobalHost.ConnectionManager.GetHubContext<PushHub>();
              var msgs = new link_msg_list
              {
                name = HttpUtility.HtmlEncode(string.Format("您追蹤的{0}上架新文章囉~", Session["Name"].ToString())),
                msg = HttpUtility.HtmlEncode("趕快去看看吧ヽ(。・∀・)ノ"),
                link = GetRouteUrl("NewsInfoRoute", new { ArticleId = article_id })
              };
              var hash = uc.HmacSHA256(JsonConvert.SerializeObject(msgs), "kb53229980");

              context.Clients.Users(list).broadcastVerifiedLinkMessage("SendLinkMsg", hash, HttpUtility.UrlEncode(msgs.name), HttpUtility.UrlEncode(msgs.msg), HttpUtility.UrlEncode(msgs.link));
              context.Clients.Users(list).error(JsonConvert.SerializeObject(msgs));
              reader.Close();
            };

            con.Close();
          }
        }

        //debug
        modal_header.Text = "新增文章";
        modal_content.Text = "新增文章成功";
        uc.FrontEndDebug(this, "final content", string.Format("console.log(`{0}`);", content) + "$('.ui.notify.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');");

      }
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
    protected void UpdatePanel1_Load(object sender, EventArgs e)
    {
      //uc.FrontEndDebug(ScriptManager1, "refresh lazyload", "$('.lazy').Lazy();");
    }
  }
}