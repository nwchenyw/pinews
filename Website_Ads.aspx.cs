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
  public partial class Website_Ads : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      this.Master.Page.Title = "管理網站廣告 | " + Application["Site_Name"];
      if (Session["Authority"] != null)
      {
        if (!Array.Exists(Session["Authority"].ToString().Split(','), m => m == "網站廣告"))
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
      string sql = "Insert Into Advertisement (Type, Img_Id, Link, Title, Show_T, Upd_Time, User_Id, Remark) output Inserted.Id Values(@type, @imgid, @link, @title, @ift, getDate(), @uid, @remark)";
      string[] para = { "@type", "@imgid", "@link", "@title", "@ift", "@uid", "@remark" };

      string fimgid = "";
      if (ads_FU.HasFiles)
      {
        string fileExtension = Path.GetExtension(ads_FU.PostedFile.FileName);

        string fileName = Guid.NewGuid() + fileExtension;
        string contentType = ads_FU.PostedFile.ContentType;
        byte[] bytes;

        int width = 0, height = 0;
        if (Type_HF.Value == "friend") height = 35;
        else if (Type_HF.Value == "long square") { 
          width = 320;
          height = 180;
        }
        else if (Type_HF.Value == "left square" || Type_HF.Value == "right square" || Type_HF.Value == "sidebar square")
        {
          width = 360;
          height = 300;
        }
        using (Stream fs = ads_FU.PostedFile.InputStream)
        {
          using (BinaryReader br = new BinaryReader(fs))
          {
            bytes = br.ReadBytes((Int32)fs.Length);
          }
        }

        Bitmap bmp = new Bitmap(new System.IO.MemoryStream(bytes));
        System.Drawing.Image img = bmp;
        if (Type_HF.Value == "long square")
        {
          if (img.Width > width)
          {
            Bitmap new_bmp = uc.viewMaker(bmp, width, height);
            using (MemoryStream ms = new MemoryStream())
            {
              new_bmp.Save(ms, bmp.RawFormat);
              bytes = ms.ToArray();
            }
          }
        }
        else if (Type_HF.Value == "friend")
        {
          if (img.Height > height)
          {
            Bitmap new_bmp = uc.viewMaker(bmp, (img.Width / img.Height) * height, height);
            using (MemoryStream ms = new MemoryStream())
            {
              new_bmp.Save(ms, bmp.RawFormat);
              bytes = ms.ToArray();
            }
          }
        }
        else
        {
          if (img.Width > width)
          {
            Bitmap new_bmp = uc.viewMaker(bmp, width, height);
            using (MemoryStream ms = new MemoryStream())
            {
              new_bmp.Save(ms, bmp.RawFormat);
              bytes = ms.ToArray();
            }
          }
        }

        fimgid = uc.PiNewsInsertImg(contentType, fileName, Convert.ToDecimal(bytes.Length / 1024), Session["User_Id"].ToString(), bytes);
        uc.UserLog("Image", fimgid, "Insert", "新增廣告圖片", Session["User_Id"].ToString(), Session["IP"].ToString());

        string[] val = { Type_HF.Value, fimgid, link_TB.Text, title_TB.Text, (Type_HF.Value == "right square") ? "1" : "0", Session["User_Id"].ToString(), Remark_TB.Text };
        string adid = uc.PiNewsSql(sql, para, val);
        uc.UserLog("Advertisement", adid, "Insert", "新增網站廣告", Session["User_Id"].ToString(), Session["IP"].ToString());
        modal_header.Text = "新增網站廣告";
        modal_content.Text = "新增成功";
        uc.FrontEndDebug(this, "new ad success alert", "$('.ui.notify.modal').modal({inverted: true}).modal('show');");
        ListView1.DataBind();
        ListView2.DataBind();
        ListView3.DataBind();
        ListView4.DataBind();
      }
    }

    protected void New_LB_Click(object sender, EventArgs e)
    {
      Type_HF.Value = "friend";
      show_title.Visible = false;

      uc.FrontEndDebug(this, "new modal", "$('#friend-msg').removeClass('hidden');$('#new-ad').modal({inverted: true, context: '#" + Master.FindControl("UpdatePanel1").ClientID + " .placeholder', onShow: function () {$('.advertise.modal .ui.link').popup();}}).modal('show');");
    }

    protected void New_long_LB_Click(object sender, EventArgs e)
    {
      Type_HF.Value = "long square";
      show_title.Visible = false;

      uc.FrontEndDebug(this, "new modal", "$('#lsquare-msg').removeClass('hidden');$('#new-ad').modal({inverted: true, context: '#" + Master.FindControl("UpdatePanel1").ClientID + " .placeholder', debug: true, onShow: function () {$('.advertise.modal .ui.link').popup();}}).modal('show');");
    }

    protected void LinkButton2_Click(object sender, EventArgs e)
    {
      Type_HF.Value = "right square";
      show_title.Visible = true;

      uc.FrontEndDebug(this, "new modal", "$('#othersquare-msg').removeClass('hidden');$('#new-ad').modal({inverted: true, context: '#" + Master.FindControl("UpdatePanel1").ClientID + " .placeholder', debug: true, onShow: function () {$('.advertise.modal .ui.link').popup();}}).modal('show');");
    }

    protected void Select_Cancel_Click(object sender, EventArgs e)
    {
      ListView1.SelectedIndex = -1;
      ListView1.EditIndex = -1;
      ListView2.SelectedIndex = -1;
      ListView2.EditIndex = -1;
      ListView3.SelectedIndex = -1;
      ListView3.EditIndex = -1;
      ListView4.SelectedIndex = -1;
      ListView4.EditIndex = -1;
    }

    //protected void ListView3_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //  ListView1.SelectedIndex = -1;
    //  ListView2.SelectedIndex = -1;
    //  uc.FrontEndDebug(this, "new modal", "$('.advertise.modal').modal({inverted: true, context: '#" + Master.FindControl("UpdatePanel1").ClientID + " .placeholder', debug: true, onShow: function () {$('.advertise.modal .ui.link').popup();}}).modal('show');");
    //}

    protected void ListView1_DataBound(object sender, EventArgs e)
    {
      if (ListView1.EditIndex != -1 || ListView1.SelectedIndex != -1)
      {
        ListView2.SelectedIndex = -1;
        ListView2.EditIndex = -1;
        ListView3.SelectedIndex = -1;
        ListView3.EditIndex = -1;
        ListView4.SelectedIndex = -1;
        ListView4.EditIndex = -1;
        uc.FrontEndDebug(this, "new modal", "$('.advertise.modal').modal({inverted: true, context: '#" + Master.FindControl("UpdatePanel1").ClientID + " .placeholder', debug: true, onShow: function () {$('.advertise.modal .ui.link').popup();}}).modal('show');");
      }
    }

    protected void ListView1_ItemUpdating(object sender, ListViewUpdateEventArgs e)
    {
      TextBox title = (TextBox)ListView1.Items[e.ItemIndex].FindControl("TextBox1");
      TextBox link = (TextBox)ListView1.Items[e.ItemIndex].FindControl("TextBox2");
      FileUpload fu = (FileUpload)ListView1.Items[e.ItemIndex].FindControl("FileUpload1");
      TextBox remark = (TextBox)ListView1.Items[e.ItemIndex].FindControl("TextBox3");
      HiddenField hf = (HiddenField)ListView1.Items[e.ItemIndex].FindControl("HiddenField1");

      SqlDataSource1.UpdateParameters["title"].DefaultValue = title.Text;
      SqlDataSource1.UpdateParameters["link"].DefaultValue = link.Text;
      SqlDataSource1.UpdateParameters["rmrk"].DefaultValue = remark.Text;

      string fimgid = "";
      if (fu.HasFiles)
      {
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
        if (img.Height > 35)
        {
          Bitmap new_bmp = uc.viewMaker(bmp, (img.Width / img.Height) * 35, 35);
          using (MemoryStream ms = new MemoryStream())
          {
            new_bmp.Save(ms, bmp.RawFormat);
            bytes = ms.ToArray();
          }
        }

        fimgid = uc.PiNewsInsertImg(contentType, fileName, Convert.ToDecimal(bytes.Length / 1024), Session["User_Id"].ToString(), bytes);
        uc.UserLog("Image", fimgid, "Insert", "新增拍新聞好友圖片", Session["User_Id"].ToString(), Session["IP"].ToString());
        SqlDataSource1.UpdateParameters["iid"].DefaultValue = fimgid;
      }
      else
        SqlDataSource1.UpdateParameters["iid"].DefaultValue = hf.Value;
      uc.UserLog("Advertisement", ListView1.DataKeys[ListView1.EditIndex].Value.ToString(), "Update", "更新拍新聞好友", Session["User_Id"].ToString(), Session["IP"].ToString());
    }

    protected void ListView2_DataBound(object sender, EventArgs e)
    {
      if (ListView2.EditIndex != -1 || ListView2.SelectedIndex != -1)
      {
        ListView1.SelectedIndex = -1;
        ListView1.EditIndex = -1;
        ListView3.SelectedIndex = -1;
        ListView3.EditIndex = -1;
        ListView4.SelectedIndex = -1;
        ListView4.EditIndex = -1;
        uc.FrontEndDebug(this, "new modal", "$('.advertise.modal').modal({inverted: true, context: '#"+ Master.FindControl("UpdatePanel1").ClientID + " .placeholder', debug: true, onShow: function () {$('.advertise.modal .ui.link').popup();}}).modal('show');");
      }
    }

    protected void ListView2_ItemUpdating(object sender, ListViewUpdateEventArgs e)
    {
      TextBox title = (TextBox)ListView2.Items[e.ItemIndex].FindControl("TextBox1");
      TextBox link = (TextBox)ListView2.Items[e.ItemIndex].FindControl("TextBox2");
      FileUpload fu = (FileUpload)ListView2.Items[e.ItemIndex].FindControl("FileUpload1");
      TextBox remark = (TextBox)ListView2.Items[e.ItemIndex].FindControl("TextBox3");
      HiddenField hf = (HiddenField)ListView2.Items[e.ItemIndex].FindControl("HiddenField1");

      SqlDataSource2.UpdateParameters["Title"].DefaultValue = title.Text;
      SqlDataSource2.UpdateParameters["Link"].DefaultValue = link.Text;
      SqlDataSource2.UpdateParameters["Remark"].DefaultValue = remark.Text;
      SqlDataSource2.UpdateParameters["Img_Id"].DefaultValue = hf.Value;

      string fimgid = "";
      if (fu.HasFiles)
      {
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
        if (img.Width > 320)
        {
          Bitmap new_bmp = uc.viewMaker(bmp, 320, 180);
          using (MemoryStream ms = new MemoryStream())
          {
            new_bmp.Save(ms, bmp.RawFormat);
            bytes = ms.ToArray();
          }
        }

        if (img.Width/img.Height != 16/9)
        {
          uc.FrontEndDebug(this, "error", "alert('請修正長寬比');");
          e.Cancel = true;
        }

        fimgid = uc.PiNewsInsertImg(contentType, fileName, Convert.ToDecimal(bytes.Length / 1024), Session["User_Id"].ToString(), bytes);
        uc.UserLog("Image", fimgid, "Insert", "新增拍新聞橫幅廣告圖片", Session["User_Id"].ToString(), Session["IP"].ToString());
        SqlDataSource2.UpdateParameters["Img_Id"].DefaultValue = fimgid;
      }

      uc.UserLog("Advertisement", ListView2.DataKeys[ListView2.EditIndex].Value.ToString(), "Update", "更新拍新聞橫幅廣告", Session["User_Id"].ToString(), Session["IP"].ToString());
    }

    protected void ListView3_DataBound(object sender, EventArgs e)
    {
      ListView1.SelectedIndex = -1;
      ListView1.EditIndex = -1;
      ListView2.SelectedIndex = -1;
      ListView2.EditIndex = -1;
      ListView4.SelectedIndex = -1;
      ListView4.EditIndex = -1;
      uc.FrontEndDebug(this, "new modal", "$('.advertise.modal').modal({inverted: true, context: '#" + Master.FindControl("UpdatePanel1").ClientID + " .placeholder', debug: true, onShow: function () {$('.advertise.modal .ui.link').popup();}}).modal('show');");
    }

    protected void ListView1_PreRender(object sender, EventArgs e)
    {
      if (ListView1.EditIndex != -1)
      {

        PostBackTrigger Trigger2 = new PostBackTrigger();
        Trigger2.ControlID = ListView1.Items[ListView1.EditIndex].FindControl("LinkButton3").UniqueID;
        ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger2);
        ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterPostBackControl(ListView1.Items[ListView1.EditIndex].FindControl("LinkButton3"));
      }
      else if (ListView1.SelectedIndex != -1)
      {
        AsyncPostBackTrigger Trigger1 = new AsyncPostBackTrigger();
        Trigger1.ControlID = ListView1.Items[ListView1.SelectedIndex].FindControl("Select_Cancel").UniqueID;
        ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger1);
        ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterAsyncPostBackControl(ListView1.Items[ListView1.SelectedIndex].FindControl("Select_Cancel"));

        PostBackTrigger Trigger2 = new PostBackTrigger();
        Trigger2.ControlID = ListView1.Items[ListView1.SelectedIndex].FindControl("LinkButton3").UniqueID;
        ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger2);
        ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterPostBackControl(ListView1.Items[ListView1.SelectedIndex].FindControl("LinkButton3"));

        PostBackTrigger Trigger3 = new PostBackTrigger();
        Trigger3.ControlID = ListView1.Items[ListView1.SelectedIndex].FindControl("LinkButton4").UniqueID;
        ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger3);
        ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterPostBackControl(ListView1.Items[ListView1.SelectedIndex].FindControl("LinkButton4"));
      }

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
      else if (ListView2.SelectedIndex != -1)
      {
        AsyncPostBackTrigger Trigger1 = new AsyncPostBackTrigger();
        Trigger1.ControlID = ListView2.Items[ListView2.SelectedIndex].FindControl("Select_Cancel").UniqueID;
        ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger1);
        ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterAsyncPostBackControl(ListView2.Items[ListView2.SelectedIndex].FindControl("Select_Cancel"));

        PostBackTrigger Trigger2 = new PostBackTrigger();
        Trigger2.ControlID = ListView2.Items[ListView2.SelectedIndex].FindControl("LinkButton3").UniqueID;
        ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger2);
        ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterPostBackControl(ListView2.Items[ListView2.SelectedIndex].FindControl("LinkButton3"));

        PostBackTrigger Trigger3 = new PostBackTrigger();
        Trigger3.ControlID = ListView2.Items[ListView2.SelectedIndex].FindControl("LinkButton5").UniqueID;
        ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger3);
        ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterPostBackControl(ListView2.Items[ListView2.SelectedIndex].FindControl("LinkButton5"));
      }
    }

    protected void ListView3_PreRender(object sender, EventArgs e)
    {
      if (ListView3.EditIndex != -1)
      {

        PostBackTrigger Trigger2 = new PostBackTrigger();
        Trigger2.ControlID = ListView3.Items[ListView3.EditIndex].FindControl("LinkButton3").UniqueID;
        ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger2);
        ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterPostBackControl(ListView3.Items[ListView3.EditIndex].FindControl("LinkButton3"));
      }
      else if (ListView3.SelectedIndex != -1)
      {
        AsyncPostBackTrigger Trigger1 = new AsyncPostBackTrigger();
        Trigger1.ControlID = ListView3.Items[ListView3.SelectedIndex].FindControl("Select_Cancel").UniqueID;
        ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger1);
        ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterAsyncPostBackControl(ListView3.Items[ListView3.SelectedIndex].FindControl("Select_Cancel"));

        PostBackTrigger Trigger2 = new PostBackTrigger();
        Trigger2.ControlID = ListView3.Items[ListView3.SelectedIndex].FindControl("LinkButton3").UniqueID;
        ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger2);
        ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterPostBackControl(ListView3.Items[ListView3.SelectedIndex].FindControl("LinkButton3"));

        PostBackTrigger Trigger3 = new PostBackTrigger();
        Trigger3.ControlID = ListView3.Items[ListView3.SelectedIndex].FindControl("Delete").UniqueID;
        ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger3);
        ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterPostBackControl(ListView3.Items[ListView3.SelectedIndex].FindControl("Delete"));
      }
    }

    protected void ListView3_ItemUpdating(object sender, ListViewUpdateEventArgs e)
    {
      TextBox title = (TextBox)ListView3.Items[e.ItemIndex].FindControl("TextBox1");
      TextBox link = (TextBox)ListView3.Items[e.ItemIndex].FindControl("TextBox2");
      FileUpload fu = (FileUpload)ListView3.Items[e.ItemIndex].FindControl("FileUpload1");
      TextBox remark = (TextBox)ListView3.Items[e.ItemIndex].FindControl("TextBox3");
      HiddenField hf = (HiddenField)ListView3.Items[e.ItemIndex].FindControl("HiddenField1");
      CheckBox cb = (CheckBox)ListView3.Items[e.ItemIndex].FindControl("CheckBox2");

      SqlDataSource3.UpdateParameters["Title"].DefaultValue = title.Text;
      SqlDataSource3.UpdateParameters["Link"].DefaultValue = link.Text;
      SqlDataSource3.UpdateParameters["Remark"].DefaultValue = remark.Text;
      SqlDataSource3.UpdateParameters["Img_Id"].DefaultValue = hf.Value;
      SqlDataSource3.UpdateParameters["Show_T"].DefaultValue = cb.Checked ? "true" : "false";

      string fimgid = "";
      if (fu.HasFiles)
      {
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
        if (img.Width > 360)
        {
          Bitmap new_bmp = uc.viewMaker(bmp, 360, (img.Height / img.Width) * 360);
          using (MemoryStream ms = new MemoryStream())
          {
            new_bmp.Save(ms, bmp.RawFormat);
            bytes = ms.ToArray();
          }
        }

        fimgid = uc.PiNewsInsertImg(contentType, fileName, Convert.ToDecimal(bytes.Length / 1024), Session["User_Id"].ToString(), bytes);
        uc.UserLog("Image", fimgid, "Insert", "新增拍新聞橫幅廣告圖片", Session["User_Id"].ToString(), Session["IP"].ToString());
        SqlDataSource3.UpdateParameters["Img_Id"].DefaultValue = fimgid;
      }

      uc.UserLog("Advertisement", ListView3.DataKeys[ListView3.EditIndex].Value.ToString(), "Update", "更新拍新聞橫幅廣告", Session["User_Id"].ToString(), Session["IP"].ToString());
    }

    protected void ListView4_PreRender(object sender, EventArgs e)
    {
      if (ListView4.EditIndex != -1)
      {

        PostBackTrigger Trigger2 = new PostBackTrigger();
        Trigger2.ControlID = ListView4.Items[ListView4.EditIndex].FindControl("LinkButton3").UniqueID;
        ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger2);
        ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterPostBackControl(ListView4.Items[ListView4.EditIndex].FindControl("LinkButton3"));
      }
      else if (ListView4.SelectedIndex != -1)
      {
        AsyncPostBackTrigger Trigger1 = new AsyncPostBackTrigger();
        Trigger1.ControlID = ListView4.Items[ListView4.SelectedIndex].FindControl("Select_Cancel").UniqueID;
        ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger1);
        ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterAsyncPostBackControl(ListView4.Items[ListView4.SelectedIndex].FindControl("Select_Cancel"));

        PostBackTrigger Trigger2 = new PostBackTrigger();
        Trigger2.ControlID = ListView4.Items[ListView4.SelectedIndex].FindControl("LinkButton3").UniqueID;
        ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger2);
        ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterPostBackControl(ListView4.Items[ListView4.SelectedIndex].FindControl("LinkButton3"));

        PostBackTrigger Trigger3 = new PostBackTrigger();
        Trigger3.ControlID = ListView4.Items[ListView4.SelectedIndex].FindControl("Delete").UniqueID;
        ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger3);
        ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterPostBackControl(ListView4.Items[ListView4.SelectedIndex].FindControl("Delete"));
      }
    }

    protected void New_sidebar_LB_Click(object sender, EventArgs e)
    {
      Type_HF.Value = "sidebar square";
      show_title.Visible = true;

      uc.FrontEndDebug(this, "new modal", "$('#new-ad').modal({inverted: true, context: '#" + Master.FindControl("UpdatePanel1").ClientID + " .placeholder', debug: true, onShow: function () {$('.advertise.modal .ui.link').popup();}}).modal('show');");
    }

    protected void ListView4_ItemUpdating(object sender, ListViewUpdateEventArgs e)
    {
      TextBox title = (TextBox)ListView4.Items[e.ItemIndex].FindControl("TextBox1");
      TextBox link = (TextBox)ListView4.Items[e.ItemIndex].FindControl("TextBox2");
      FileUpload fu = (FileUpload)ListView4.Items[e.ItemIndex].FindControl("FileUpload1");
      TextBox remark = (TextBox)ListView4.Items[e.ItemIndex].FindControl("TextBox3");
      HiddenField hf = (HiddenField)ListView4.Items[e.ItemIndex].FindControl("HiddenField1");
      CheckBox cb = (CheckBox)ListView4.Items[e.ItemIndex].FindControl("CheckBox2");

      SqlDataSource4.UpdateParameters["Title"].DefaultValue = title.Text;
      SqlDataSource4.UpdateParameters["Link"].DefaultValue = link.Text;
      SqlDataSource4.UpdateParameters["Remark"].DefaultValue = remark.Text;
      SqlDataSource4.UpdateParameters["Img_Id"].DefaultValue = hf.Value;
      SqlDataSource4.UpdateParameters["Show_T"].DefaultValue = cb.Checked ? "true" : "false";

      string fimgid = "";
      if (fu.HasFiles)
      {
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
        if (img.Width > 360)
        {
          Bitmap new_bmp = uc.viewMaker(bmp, 360, (img.Height / img.Width) * 360);
          using (MemoryStream ms = new MemoryStream())
          {
            new_bmp.Save(ms, bmp.RawFormat);
            bytes = ms.ToArray();
          }
        }

        fimgid = uc.PiNewsInsertImg(contentType, fileName, Convert.ToDecimal(bytes.Length / 1024), Session["User_Id"].ToString(), bytes);
        uc.UserLog("Image", fimgid, "Insert", "新增拍新聞橫幅廣告圖片", Session["User_Id"].ToString(), Session["IP"].ToString());
        SqlDataSource4.UpdateParameters["Img_Id"].DefaultValue = fimgid;
      }

      uc.UserLog("Advertisement", ListView4.DataKeys[ListView4.EditIndex].Value.ToString(), "Update", "更新拍新聞橫幅廣告", Session["User_Id"].ToString(), Session["IP"].ToString());
      ListView4.DataBind();
    }

    protected void ListView4_DataBound(object sender, EventArgs e)
    {

      ListView1.SelectedIndex = -1;
      ListView1.EditIndex = -1;
      ListView2.SelectedIndex = -1;
      ListView2.EditIndex = -1;
      ListView3.SelectedIndex = -1;
      ListView3.EditIndex = -1;
      uc.FrontEndDebug(this, "new modal", "$('.advertise.modal').modal({inverted: true, context: '#" + Master.FindControl("UpdatePanel1").ClientID + " .placeholder', debug: true, onShow: function () {$('.advertise.modal .ui.link').popup();}}).modal('show');");
    }

    protected void ListView3_ItemDeleting(object sender, ListViewDeleteEventArgs e)
    {

      var adid = ListView3.DataKeys[e.ItemIndex].Value.ToString();
      uc.UserLog("Advertisement", adid, "Delete", "刪除網站方格廣告(右)", Session["User_Id"].ToString(), Session["IP"].ToString());
      ListView4.SelectedIndex = -1;
      ListView3.SelectedIndex = -1;
      ListView2.SelectedIndex = -1;
      ListView1.SelectedIndex = -1;
    }

    protected void ListView2_ItemDeleting(object sender, ListViewDeleteEventArgs e)
    {
      var adid = ListView2.DataKeys[e.ItemIndex].Value.ToString();
      uc.UserLog("Advertisement", adid, "Delete", "刪除網站方格廣告(右)", Session["User_Id"].ToString(), Session["IP"].ToString());
      ListView4.SelectedIndex = -1;
      ListView3.SelectedIndex = -1;
      ListView2.SelectedIndex = -1;
      ListView1.SelectedIndex = -1;
    }

    protected void ListView1_ItemDeleting(object sender, ListViewDeleteEventArgs e)
    {
      var adid = ListView1.DataKeys[e.ItemIndex].Value.ToString();
      uc.UserLog("Advertisement", adid, "Delete", "刪除網站方格廣告(右)", Session["User_Id"].ToString(), Session["IP"].ToString());
      ListView4.SelectedIndex = -1;
      ListView3.SelectedIndex = -1;
      ListView2.SelectedIndex = -1;
      ListView1.SelectedIndex = -1;
    }

    protected void ListView4_ItemDeleting(object sender, ListViewDeleteEventArgs e)
    {

      var adid = ListView4.DataKeys[e.ItemIndex].Value.ToString();
      uc.UserLog("Advertisement", adid, "Delete", "刪除網站方格廣告(右)", Session["User_Id"].ToString(), Session["IP"].ToString());
      ListView4.SelectedIndex = -1;
      ListView3.SelectedIndex = -1;
      ListView2.SelectedIndex = -1;
      ListView1.SelectedIndex = -1;
    }
  }
}