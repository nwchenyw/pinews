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
  public partial class Admin_Banners : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      if (Session["Authority"] != null)
        if (!Array.Exists(Session["Authority"].ToString().Split(','), m => m == "首頁橫幅")) Response.Redirect("Default.aspx");

      this.Master.Page.Title = "首頁橫幅設定 | " + Application["Site_Name"];
    }

    protected void LinkButton1_Click(object sender, EventArgs e)
    {
      HttpPostedFile file = FileUpload1.PostedFile;
      var title = TextBox1.Text;
      var link = TextBox2.Text;
      bool isVid = b_type_CB.Checked;
      var v_type = video_type_HF.Value.Equals("https://youtu.be/") ? "youtube" : video_type_HF.Value.Equals("https://vimeo.com/") ? "vimeo" : "";
      var v_url = Video_id_TB.Text;

      //uc.FrontEndDebug(this, "isVideo", string.Format("alert('{0}');", isVid ? "勾":"沒勾"));

      if (!isVid)
      {

        string sql = "Insert into Banner(Image_Id, Title, Link, font_name, font_size, color, isVideo) Values(@img_id, @title, @link, @font_name, @font_size, @color, 0)";
        string[] para = { "@img_id", "@title", "@link", "@font_name", "@font_size", "@color" };

        if (FileUpload1.HasFiles)
        {
          string fileExtension = Path.GetExtension(file.FileName);

          string fileName = Guid.NewGuid() + fileExtension;
          string contentType = file.ContentType;
          byte[] bytes;

          using (Stream fs = file.InputStream)
          {
            //System.Drawing.Image img = System.Drawing.Image.FromStream(file.InputStream);
            //uc.FrontEndDebug(this, "debug", string.Format("console.log('{0}')", img.Width));

            //if (img.Width > 1200)
            //{
            //  System.Drawing.Bitmap bmp = uc.viewMaker(new System.Drawing.Bitmap(file.InputStream), 1200, 375);
            //  using (MemoryStream ms = new MemoryStream())
            //  {
            //    bmp.Save(ms, bmp.RawFormat);
            //    bytes = ms.ToArray();
            //  }
            //}
            //else
            //{
            using (BinaryReader br = new BinaryReader(fs))
            {
              bytes = br.ReadBytes((Int32)fs.Length);
            }
            //}
          }

          Bitmap bmp = new Bitmap(new System.IO.MemoryStream(bytes));
          System.Drawing.Image img = bmp;
          if (img.Width > 1200)
          {
            Bitmap new_bmp = uc.viewMaker(bmp, 1200, 375);
            using (MemoryStream ms = new MemoryStream())
            {
              new_bmp.Save(ms, bmp.RawFormat);
              bytes = ms.ToArray();
            }
          }

          string fimgid = uc.PiNewsInsertImg(contentType, fileName, Convert.ToDecimal(bytes.Length / 1024), Session["User_Id"].ToString(), bytes);
          uc.UserLog("Image", fimgid, "Insert", "新增橫幅圖片", Session["User_Id"].ToString(), Session["IP"].ToString());

          string[] val = { fimgid, title, link, fontName_HF.Value, fontSize_HF.Value, colorPicker_TB.Text };
          var bid = uc.PiNewsSql(sql, para, val);
          uc.UserLog("Image", bid, "Insert", "新增橫幅", Session["User_Id"].ToString(), Session["IP"].ToString());

          modal_header.Text = "新增橫幅";
          modal_content.Text = "新增成功!";
        }
        else
        {
          modal_header.Text = "新增橫幅";
          modal_content.Text = "尚未選擇橫幅圖片!";
        }
      }
      else
      {
        if (v_type != null && v_url != null)
        {
          string sql = "Insert into Banner(Title, Link, font_name, font_size, color, isVideo, Video_type, Video_url) Values(@title, @link, @font_name, @font_size, @color, 1, @v_type, @v_url)";
          string[] para = { "@title", "@link", "@font_name", "@font_size", "@color", "@v_type", "@v_url" };

          string[] val = { title, link, fontName_HF.Value, fontSize_HF.Value, colorPicker_TB.Text, v_type, v_url };
          var bid = uc.PiNewsSql(sql, para, val);
          uc.UserLog("Image", bid, "Insert", "新增橫幅", Session["User_Id"].ToString(), Session["IP"].ToString());

          modal_header.Text = "新增橫幅";
          modal_content.Text = "新增成功!";
        }
        else
        {
          modal_header.Text = "新增橫幅";
          modal_content.Text = "影片連結或格式未填妥!";
        }
      }
      uc.FrontEndDebug(this, "final content", "$('.ui.notify.tiny.modal').modal({inverted: true, autofocus: false}).modal('show');");
      GridView1.DataBind();
    }

    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
      FileUpload fu = (FileUpload)GridView1.Rows[e.RowIndex].FindControl("img_FU");
      TextBox title = (TextBox)GridView1.Rows[e.RowIndex].FindControl("TextBox4");
      TextBox link = (TextBox)GridView1.Rows[e.RowIndex].FindControl("TextBox3");
      TextBox color = (TextBox)GridView1.Rows[e.RowIndex].FindControl("colorPicker_TB");
      HiddenField name = (HiddenField)GridView1.Rows[e.RowIndex].FindControl("fontName_HF");
      HiddenField size = (HiddenField)GridView1.Rows[e.RowIndex].FindControl("fontSize_HF");
      CheckBox active = (CheckBox)GridView1.Rows[e.RowIndex].FindControl("active_CB");
      CheckBox isVid = (CheckBox)GridView1.Rows[e.RowIndex].FindControl("b_type_CB");
      HiddenField v_type_hf = (HiddenField)GridView1.Rows[e.RowIndex].FindControl("video_type_HF");
      TextBox v_url_tb = (TextBox)GridView1.Rows[e.RowIndex].FindControl("Video_id_TB");

      HttpPostedFile file = fu.PostedFile;
      var id = GridView1.DataKeys[e.RowIndex].Value;


      var v_type = v_type_hf.Value.Equals("https://youtu.be/") ? "youtube" : video_type_HF.Value.Equals("https://vimeo.com/") ? "vimeo" : "";
      var v_url = v_url_tb.Text;

      if (!isVid.Checked)
      {
        if (fu.HasFiles)
        {
          string fileExtension = Path.GetExtension(file.FileName);

          string fileName = Guid.NewGuid() + fileExtension;
          string contentType = file.ContentType;
          byte[] bytes;

          using (Stream fs = file.InputStream)
          {
            //System.Drawing.Image img = System.Drawing.Image.FromStream(fs);
            //uc.FrontEndDebug(this, "debug", string.Format("console.log('{0}')", img.Width));

            //if (img.Width > 1200)
            //{
            //  System.Drawing.Bitmap bmp = uc.viewMaker(new System.Drawing.Bitmap(fs), 1200, 375);
            //  using (MemoryStream ms = new MemoryStream())
            //  {
            //    bmp.Save(ms, bmp.RawFormat);
            //    bytes = ms.ToArray();
            //  }
            //}
            //else
            //{
            using (BinaryReader br = new BinaryReader(fs))
            {
              bytes = br.ReadBytes((Int32)fs.Length);
            }
            //}
          }

          Bitmap bmp = new Bitmap(new System.IO.MemoryStream(bytes));
          System.Drawing.Image img = bmp;
          if (img.Width > 1200)
          {
            Bitmap new_bmp = uc.viewMaker(bmp, 1200, 375);
            using (MemoryStream ms = new MemoryStream())
            {
              new_bmp.Save(ms, bmp.RawFormat);
              bytes = ms.ToArray();
            }
          }

          string fimgid = uc.PiNewsInsertImg(contentType, fileName, Convert.ToDecimal(bytes.Length / 1024), Session["User_Id"].ToString(), bytes);
          uc.UserLog("Image", fimgid, "Insert", "新增橫幅圖片", Session["User_Id"].ToString(), Session["IP"].ToString());

          SqlDataSource1.UpdateParameters["Image_Id"].DefaultValue = fimgid;
          SqlDataSource1.UpdateParameters["Title"].DefaultValue = title.Text;
          SqlDataSource1.UpdateParameters["Link"].DefaultValue = link.Text;
          SqlDataSource1.UpdateParameters["font_size"].DefaultValue = size.Value;
          SqlDataSource1.UpdateParameters["font_name"].DefaultValue = name.Value;
          SqlDataSource1.UpdateParameters["color"].DefaultValue = color.Text;
          SqlDataSource1.UpdateParameters["Id"].DefaultValue = id.ToString();
          SqlDataSource1.UpdateParameters["active"].DefaultValue = active.Checked ? "True" : "False";

          SqlDataSource1.Update();

          modal_header.Text = "編輯橫幅";
          modal_content.Text = "新增成功!";
        }
        else
        {
          SqlDataSource1.UpdateCommand = "Update Banner set Title = @Title, Link = @Link, font_size = @font_size, font_name = @font_name, color = @color, active = @active where Id = @Id";
          SqlDataSource1.UpdateParameters["Title"].DefaultValue = title.Text;
          SqlDataSource1.UpdateParameters["Link"].DefaultValue = link.Text;
          SqlDataSource1.UpdateParameters["font_size"].DefaultValue = size.Value;
          SqlDataSource1.UpdateParameters["font_name"].DefaultValue = name.Value;
          SqlDataSource1.UpdateParameters["color"].DefaultValue = color.Text;
          SqlDataSource1.UpdateParameters["Id"].DefaultValue = id.ToString();
          SqlDataSource1.UpdateParameters["active"].DefaultValue = active.Checked ? "True" : "False";

          SqlDataSource1.Update();

          modal_header.Text = "編輯橫幅";
          modal_content.Text = "新增成功!";
        }
      }else
      {
        if (v_type != null && v_url != null)
        {
          string sql = @"Update Banner setTitle = @title, Link = @link, font_name = @font_name, font_size = @font_size, color = @color, isVideo = 1, Video_type = @v_type, Video_url = @v_url)";
          string[] para = { "@title", "@link", "@font_name", "@font_size", "@color", "@v_type", "@v_url" };

          string[] val = { title.Text, link.Text, name.Value, size.Value, color.Text, v_type, v_url };
          var bid = uc.PiNewsSql(sql, para, val);
          uc.UserLog("Image", bid, "Insert", "編輯橫幅", Session["User_Id"].ToString(), Session["IP"].ToString());

          modal_header.Text = "編輯橫幅";
          modal_content.Text = "編輯成功!";
        }
        else
        {
          modal_header.Text = "編輯橫幅";
          modal_content.Text = "影片連結或格式未填妥!";
        }
      }
    }

    protected void Edit_Odr_LB_Click(object sender, EventArgs e)
    {
      Reorder_LB.Visible = true;
      Cancel_Odr_LB.Visible = true;
      uc.FrontEndDebug(this, "reodr", "organize();");
    }

    protected void Reorder_LB_Click(object sender, EventArgs e)
    {
      int[] locationIds = (from p in Request.Form["Banner_Id"].Split(',')
                           select int.Parse(p)).ToArray();
      int[] Marquee_Ids = (from p in Request.Form["Banner_Id"].Split(',')
                           select int.Parse(p)).ToArray();

      int[] grid = new int[GridView1.Rows.Count];
      for (var i = 0; i < GridView1.Rows.Count; i++)
      {
        grid[i] = int.Parse(GridView1.DataKeys[i].Value.ToString());
      }
      Array.Sort(grid);
      Array.Sort(locationIds);

      if (grid.SequenceEqual(locationIds))
      {
        int preference = 1;
        foreach (int Marquee_Id in Marquee_Ids)
        {
          Upd_Marquee_odr(Marquee_Id, preference);
          preference += 1;
        }
      }

      uc.FrontEndDebug(this, "id", string.Format("console.log('{0}', '{1}');", Request.Form["Banner_Id"], string.Join(",", grid)));
      uc.UserLog("Marquee", "", "Update", "更新首頁橫幅排序", Session["User_Id"].ToString(), Session["IP"].ToString());
      GridView1.DataBind();
    }
    private void Upd_Marquee_odr(int Id, int odr)
    {
      string sql = "UPDATE Banner SET Odr = @co output Inserted.Id WHERE Id = @MId";
      string[] para = { "@co", "@MId" };
      string[] val = { odr.ToString(), Id.ToString() };
      uc.PiNewsSql(sql, para, val);
    }


    protected void Cancel_Odr_LB_Click(object sender, EventArgs e)
    {
      Reorder_LB.Visible = false;
      Cancel_Odr_LB.Visible = false;
    }

    protected void GridView1_PreRender(object sender, EventArgs e)
    {
      if (GridView1.Rows.Count > 0)
        GridView1.HeaderRow.TableSection = TableRowSection.TableHeader;
    }
  }
}