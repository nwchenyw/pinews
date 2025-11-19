using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace piNews
{
  public partial class Advertisement : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      if (Session["Authority"] != null)
      {
        if (!Array.Exists(Session["Authority"].ToString().Split(','), m => m == "個人廣告"))
          Response.Redirect("Admin.aspx");
      }
      else Response.Redirect("Admin.aspx");
    }
    protected void Page_init(object sender, EventArgs e)
    {
      PostBackTrigger Trigger2 = new PostBackTrigger();
      Trigger2.ControlID = LinkButton1.UniqueID;
      ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger2);
      ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterPostBackControl(LinkButton1);
    }

    protected void LinkButton1_Click(object sender, EventArgs e)
    {
      string sql = "Insert Into Advertisement (Type, Img_Id, Link, Title, Upd_Time, User_Id, Remark, video_type, video_url) Values('personal', @imgid, @link, @title, getDate(), @uid, @remark, @vid_type, @vid_url)";
      string[] para = { "@imgid", "@link", "@title", "@uid", "@remark", "@vid_type", "@vid_url" };

      string fimgid = "";

      string vid_type = video_type_HF.Value.Equals("https://youtu.be/") ? "youtube": video_type_HF.Value.Equals("https://vimeo.com/") ? "vimeo":"";
      string vid_url = Video_id_TB.Text;
      if (ads_FU.HasFiles)
      {
        string fileExtension = Path.GetExtension(ads_FU.PostedFile.FileName);

        string fileName = Guid.NewGuid() + fileExtension;
        string contentType = ads_FU.PostedFile.ContentType;
        byte[] bytes;

        using (Stream fs = ads_FU.PostedFile.InputStream)
        {
          using (BinaryReader br = new BinaryReader(fs))
          {
            bytes = br.ReadBytes((Int32)fs.Length);
          }
        }

        Bitmap bmp = new Bitmap(new System.IO.MemoryStream(bytes));
        System.Drawing.Image img = bmp;
        //if (img.Width > 320)
        //{
        //  Bitmap new_bmp = uc.viewMaker(bmp, 320, 180);
        //  using (MemoryStream ms = new MemoryStream())
        //  {
        //    new_bmp.Save(ms, bmp.RawFormat);
        //    bytes = ms.ToArray();
        //  }
        //}
        if (img.Width > 360)
        {
          Bitmap new_bmp = uc.viewMaker(bmp, 360, 300);
          using (MemoryStream ms = new MemoryStream())
          {
            new_bmp.Save(ms, bmp.RawFormat);
            bytes = ms.ToArray();
          }
        }

        fimgid = uc.PiNewsInsertImg(contentType, fileName, Convert.ToDecimal(bytes.Length / 1024), Session["User_Id"].ToString(), bytes);
        uc.UserLog("Image", fimgid, "Insert", "新增廣告圖片", Session["User_Id"].ToString(), Session["IP"].ToString());

        string[] val = { fimgid, link_TB.Text, title_TB.Text //, CheckBox1.Checked ? "0" : "1"
            , Session["User_Id"].ToString(), Remark_TB.Text, vid_type, vid_url };
        string adid = uc.PiNewsSql(sql, para, val);
        uc.UserLog("Advertisement", adid, "Insert", "新增個人廣告", Session["User_Id"].ToString(), Session["IP"].ToString());
        modal_header.Text = "新增個人廣告";
        modal_content.Text = "新增成功";
        uc.FrontEndDebug(this, "new ad success alert", "$('.ui.notify.modal').modal({inverted: true}).modal('show');");
        ListView1.DataBind();
      } else if (vid_type != null && vid_url != null)
      {
        string sql1 = "Insert Into Advertisement (Type, Link, Title, Upd_Time, User_Id, Remark, video_type, video_url) Values('personal', @link, @title, getDate(), @uid, @remark, @vid_type, @vid_url)";
        string[] para1 = { "@link", "@title", "@uid", "@remark", "@vid_type", "@vid_url" };

        string[] val1 = { link_TB.Text, title_TB.Text //, CheckBox1.Checked ? "0" : "1"
            , Session["User_Id"].ToString(), Remark_TB.Text, vid_type, vid_url };
        string adid = uc.PiNewsSql(sql1, para1, val1);
        uc.UserLog("Advertisement", adid, "Insert", "新增個人廣告", Session["User_Id"].ToString(), Session["IP"].ToString());
        modal_header.Text = "新增個人廣告";
        modal_content.Text = "新增成功";
        uc.FrontEndDebug(this, "ad txt", string.Format("console.log('{0}');", string.Join(",", val1)));
        uc.FrontEndDebug(this, "new ad success alert", "$('.ui.notify.modal').modal({inverted: true}).modal('show');");
        ListView1.DataBind();
      }
    }

    protected void ListView2_DataBound(object sender, EventArgs e)
    {
    }

    protected void ListView2_Load(object sender, EventArgs e)
    {
      uc.FrontEndDebug(this, "ad detail", "$('.ui.advertise.modal').modal({inverted: true, context: '#" + Master.FindControl("UpdatePanel1").ClientID + " .placeholder', onShow: function () {$('.advertise.modal .ui.link').popup();}}).modal('show');");

    }

    protected void LinkButton2_Click(object sender, EventArgs e)
    {
      ListView2.SelectedIndex = -1;
      ListView1.SelectedIndex = -1;
    }

    protected void ListView2_ItemUpdating(object sender, ListViewUpdateEventArgs e)
    {
      TextBox title = (TextBox)ListView2.Items[e.ItemIndex].FindControl("TextBox1");
      //CheckBox title_cb = (CheckBox)ListView2.Items[e.ItemIndex].FindControl("CheckBox2");
      TextBox link = (TextBox)ListView2.Items[e.ItemIndex].FindControl("TextBox2");
      FileUpload fu = (FileUpload)ListView2.Items[e.ItemIndex].FindControl("FileUpload1");
      TextBox remark = (TextBox)ListView2.Items[e.ItemIndex].FindControl("TextBox3");
      TextBox url = (TextBox)ListView2.Items[e.ItemIndex].FindControl("Video_id_TB");
      HiddenField type_HF = (HiddenField)ListView2.Items[e.ItemIndex].FindControl("video_type_HF");


      string vid_type = type_HF.Value.Equals("https://youtu.be/") ? "youtube" : type_HF.Value.Equals("https://vimeo.com/") ? "vimeo" : "";
      string vid_url = url.Text;

      uc.FrontEndDebug(this, "dbg", string.Format("console.log('{0}');", title.Text));

      SqlDataSource2.UpdateParameters["Title"].DefaultValue = title.Text;
      //SqlDataSource2.UpdateParameters["Show_T"].DefaultValue = title_cb.Checked ? "True" : "False";
      SqlDataSource2.UpdateParameters["Link"].DefaultValue = link.Text;
      SqlDataSource2.UpdateParameters["Remark"].DefaultValue = remark.Text;

      string fimgid = "";
      if (fu.HasFiles)
      {
        SqlDataSource2.UpdateCommand = "UPDATE [Advertisement] SET [Img_Id] = @Img_Id, [Link] = @Link, [Title] = @Title, [Show_T] = @Show_T, [Remark] = @Remark WHERE [Id] = @Id";
        string fileExtension = Path.GetExtension(fu.PostedFile.FileName);

        string fileName = Guid.NewGuid() + fileExtension;
        string contentType = fu.PostedFile.ContentType;
        byte[] bytes;

        using (Stream fs = fu.PostedFile.InputStream)
        {
          using (BinaryReader br = new BinaryReader(fs))
          {
            bytes = br.ReadBytes((Int32)fs.Length);
          }
        }

        Bitmap bmp = new Bitmap(new System.IO.MemoryStream(bytes));
        System.Drawing.Image img = bmp;
        //if (img.Width > 320)
        //{
        //  Bitmap new_bmp = uc.viewMaker(bmp, 320, 180);
        //  using (MemoryStream ms = new MemoryStream())
        //  {
        //    new_bmp.Save(ms, bmp.RawFormat);
        //    bytes = ms.ToArray();
        //  }
        //}
        if (img.Width > 360)
        {
          Bitmap new_bmp = uc.viewMaker(bmp, 360, 300);
          using (MemoryStream ms = new MemoryStream())
          {
            new_bmp.Save(ms, bmp.RawFormat);
            bytes = ms.ToArray();
          }
        }

        fimgid = uc.PiNewsInsertImg(contentType, fileName, Convert.ToDecimal(bytes.Length / 1024), Session["User_Id"].ToString(), bytes);
        uc.UserLog("Image", fimgid, "Insert", "新增廣告圖片", Session["User_Id"].ToString(), Session["IP"].ToString());
        SqlDataSource2.UpdateParameters["Img_Id"].DefaultValue = fimgid;
      }
      else if (vid_type != null && vid_url != null)
      {
        SqlDataSource2.UpdateCommand = "UPDATE [Advertisement] SET [Img_Id] = @Img_Id, [Link] = @Link, [Title] = @Title, [Remark] = @Remark WHERE [Id] = @Id";
      }
      else
      {
        SqlDataSource2.UpdateCommand = "UPDATE [Advertisement] SET [Link] = @Link, [Title] = @Title, [Show_T] = @Show_T, [Remark] = @Remark WHERE [Id] = @Id";
      }
      SqlDataSource2.Update();
      ListView1.DataBind();
      uc.UserLog("Advertisement", ListView2.DataKeys[e.ItemIndex].Value.ToString(), "Update", "更新個人廣告", Session["User_Id"].ToString(), Session["IP"].ToString());
    }

    protected void ListView2_PreRender(object sender, EventArgs e)
    {
      if (ListView2.EditIndex != -1)
      {

        PostBackTrigger Trigger2 = new PostBackTrigger();
        Trigger2.ControlID = ListView2.Items[ListView2.EditIndex].FindControl("LinkButton3").UniqueID;
        ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger2);
        ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterPostBackControl(ListView2.Items[ListView2.EditIndex].FindControl("LinkButton3"));
      }
    }

    protected void ListView2_ItemCreated(object sender, ListViewItemEventArgs e)
    {
      //AsyncPostBackTrigger Trigger1 = new AsyncPostBackTrigger();
      //Trigger1.ControlID = e.Item.FindControl("LinkButton2").UniqueID;
      //((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger1);
      ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterAsyncPostBackControl(e.Item.FindControl("LinkButton2"));

      //PostBackTrigger Trigger2 = new PostBackTrigger();
      //Trigger2.ControlID = e.Item.FindControl("LinkButton3").UniqueID;
      //((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger2);
      ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterPostBackControl(e.Item.FindControl("LinkButton3"));
    }
  }
}