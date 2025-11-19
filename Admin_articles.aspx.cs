using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace piNews
{
  public partial class Admin_articles : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    protected void Page_init(object sender, EventArgs e)
    {
    }

    bool hasntSubmit = true;
    protected void Page_Load(object sender, EventArgs e)
    {
      this.Master.Page.Title = "管理投稿文章 | " + Application["Site_Name"];
      if (FormView1.CurrentMode == FormViewMode.Edit && Session["User_Id"] == null)
      {
        string q = "select m.Id from Member m left join Article a on a.User_Id = m.Id where a.id = @Aid and a.User_Id = @Id";
        string[] n = { "@Aid", "@Id" };
        string[] v = { FormView1.DataKey["Id"].ToString(), UID_HF.Value };
        bool isAdmin = false;
        bool hasUser = false;

        string qry = "select m.isAdmin from Member m left join Article a on a.User_Id = m.Id where m.Id = @Id and a.User_Id = @Id and a.id = @Aid and m.UserId = @email";

        string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
        using (SqlConnection con = new SqlConnection(constr))
        {
          using (SqlCommand cmd = new SqlCommand(qry, con))
          {
            con.Open();
            cmd.Parameters.Clear();

            cmd.Parameters.AddWithValue("@Id", UID_HF.Value);
            cmd.Parameters.AddWithValue("@email", Email_HF.Value);
            cmd.Parameters.AddWithValue("@Aid", FormView1.DataKey["Id"].ToString());

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
          FileUpload fu = (FileUpload)FormView1.FindControl("front_IU");
          TextBox title_TB = (TextBox)FormView1.FindControl("TitleTextBox");
          HiddenField Cate_HF = (HiddenField)FormView1.FindControl("Category_HF");
          HiddenField kw_HF = (HiddenField)FormView1.FindControl("Keywords_HF");
          CheckBox status = (CheckBox)FormView1.FindControl("StatusCheckBox");
          TextBox stime = (TextBox)FormView1.FindControl("Active_TimeTextBox");
          TextBox etime = (TextBox)FormView1.FindControl("inActive_TimeTextBox");
          TextBox content = (TextBox)FormView1.FindControl("ContentTextBox");
          TextBox description = (TextBox)FormView1.FindControl("Description");
          HiddenField relate_img = (HiddenField)FormView1.FindControl("HiddenField1");
          string finalContent = content.Text;

          string ip = uc.UserIP();
          string base64 = Front_Img_HF.Value;
          byte[] bytes;


          HttpPostedFile file = fu.PostedFile;
          if (fu.HasFiles)
          {
            SqlDataSource2.UpdateCommand = "UPDATE Article SET Title = @Title, [Content] = @Content, Category = @Category, Keyword = @Keyword, Status = @Status, Active_Time = @Active_Time, inActive_Time = @inActive_Time, Relate_Img = @Relate_Img, Description = @Description, Front_Img_Id = @fiid WHERE (Id = @Id)";
            string fileExtension = Path.GetExtension(file.FileName);

            string fileName = Guid.NewGuid() + fileExtension;
            string contentType = file.ContentType;

            using (Stream fs = file.InputStream)
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

            string fimgid = uc.PiNewsInsertImg(contentType, fileName, Convert.ToDecimal(bytes.Length / 1024), UID_HF.Value, bytes);
            SqlDataSource2.UpdateParameters["fiid"].DefaultValue = fimgid;
            uc.UserLog("Image", fimgid, "Insert", "新增文章首圖", UID_HF.Value, ip);
          }
          else if (!fu.HasFiles && !string.IsNullOrEmpty(base64) && !string.IsNullOrEmpty(f_extension_HF.Value) && !string.IsNullOrEmpty(contenttype_HF.Value))
          {
            bytes = Convert.FromBase64String(base64);
            string fileName = Guid.NewGuid() + f_extension_HF.Value;

            string fimgid = uc.PiNewsInsertImg(contenttype_HF.Value, fileName, Convert.ToDecimal(bytes.Length / 1024), UID_HF.Value, bytes);
            SqlDataSource2.UpdateParameters["fiid"].DefaultValue = fimgid;
            uc.UserLog("Image", fimgid, "Insert", "新增文章首圖", UID_HF.Value, ip);
          }
          else
          {
            SqlDataSource2.UpdateCommand = "UPDATE [Article] SET [Title] = @Title, [Content] = @Content, [Category] = @Category, [Keyword] = @Keyword, [Status] = @Status, [Active_Time] = @Active_Time, [inActive_Time] = @inActive_Time, [Relate_Img] = @Relate_Img, [Description] = @Description WHERE [Id] = @Id";
          }

          SqlDataSource2.UpdateParameters["Title"].DefaultValue = HttpUtility.HtmlEncode(title_TB.Text);
          SqlDataSource2.UpdateParameters["Category"].DefaultValue = Cate_HF.Value;
          SqlDataSource2.UpdateParameters["Keyword"].DefaultValue = kw_HF.Value;
          SqlDataSource2.UpdateParameters["Status"].DefaultValue = isAdmin ? (status.Checked ? "1" : "0") : "0";
          if (!string.IsNullOrEmpty(stime.Text)) SqlDataSource2.UpdateParameters["Active_Time"].DefaultValue = Convert.ToDateTime(stime.Text).ToString("yyyy/MM/dd HH:mm:ss");
          if (!string.IsNullOrEmpty(etime.Text)) SqlDataSource2.UpdateParameters["inActive_Time"].DefaultValue = Convert.ToDateTime(etime.Text).ToString("yyyy/MM/dd HH:mm:ss");
          SqlDataSource2.UpdateParameters["Content"].DefaultValue = HttpUtility.HtmlEncode(Regex.Replace(finalContent, @"<script>[\s\S]+<\/script>", ""));
          SqlDataSource2.UpdateParameters["Relate_Img"].DefaultValue = relate_img.Value;
          SqlDataSource2.UpdateParameters["Description"].DefaultValue = description.Text;
          SqlDataSource2.Update();

          string[] r_img = relate_img.Value.Split(',');
          string article_id = FormView1.DataKey["Id"].ToString();

          if (relate_img.Value.Trim().Length > 0)
          {
            string sql = "Delete from Article_Image where article_id = @aid and image_id ";
            if (r_img.Length == 1)
              sql += "<> " + relate_img.Value;
            else
              sql += string.Format("not in ({0})", relate_img.Value);
            string[] param = { "@aid" };
            string[] value = { article_id };

            uc.PiNewsSql(sql, param, value);

            string query = @"if not exists (Select * from Article_Image where article_id = @aid and image_id = @imgid) 
Insert into Article_Image values(@aid, @imgid)";
            string[] para = { "@aid", "@imgid" };
            for (var i = 0; i < r_img.Length; i++)
            {
              string[] val = { article_id, r_img[i] };
              uc.PiNewsSql(query, para, val);
            }
          }

          //string script = string.Format("console.log('{0}','{1}','{2}','{3}','{4}','{5}');",
          //  title_TB.Text, Cate_HF.Value, kw_HF.Value, finalContent, isAdmin ? (status.Checked ? "1" : "0") : "0", relate_img.Value);
          //uc.FrontEndDebug(this, "update data", script);
          uc.UserLog("Article", article_id, "Update", "更改文章", UID_HF.Value, ip);
          if (status.Checked && isAdmin) uc.UserLog("Article", FormView1.DataKey["Id"].ToString(), "Approval", "核准文章", UID_HF.Value, ip);

          GridView1.DataBind();
          ListView1.DataBind();
        }
      }
      if (Session["User_Id"] == null) Response.Redirect("Default.aspx");
      //else if (!Session["IsAdmin"].Equals("True")) Response.Redirect("Default.aspx");
      if (!IsPostBack)
      {
        Session["new_Img"] = null;
      }
    }

    protected void FormView1_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
      FileUpload fu = (FileUpload)FormView1.FindControl("front_IU");
      TextBox title_TB = (TextBox)FormView1.FindControl("TitleTextBox");
      HiddenField Cate_HF = (HiddenField)FormView1.FindControl("Category_HF");
      HiddenField kw_HF = (HiddenField)FormView1.FindControl("Keywords_HF");
      CheckBox status = (CheckBox)FormView1.FindControl("StatusCheckBox");
      TextBox stime = (TextBox)FormView1.FindControl("Active_TimeTextBox");
      TextBox etime = (TextBox)FormView1.FindControl("inActive_TimeTextBox");
      TextBox content = (TextBox)FormView1.FindControl("ContentTextBox");
      TextBox description = (TextBox)FormView1.FindControl("Description");
      HiddenField relate_img = (HiddenField)FormView1.FindControl("HiddenField1");
      string finalContent = content.Text;

      string base64 = Front_Img_HF.Value;
      byte[] bytes;


      HttpPostedFile file = fu.PostedFile;
      if (fu.HasFiles)
      {
        SqlDataSource2.UpdateCommand = "UPDATE Article SET Title = @Title, [Content] = @Content, Category = @Category, Keyword = @Keyword, Status = @Status, Active_Time = @Active_Time, inActive_Time = @inActive_Time, Relate_Img = @Relate_Img, Description = @Description, Front_Img_Id = @fiid WHERE (Id = @Id)";
        string fileExtension = Path.GetExtension(file.FileName);

        string fileName = Guid.NewGuid() + fileExtension;
        string contentType = file.ContentType;

        using (Stream fs = file.InputStream)
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

        string fimgid = uc.PiNewsInsertImg(contentType, fileName, Convert.ToDecimal(bytes.Length / 1024), Session["User_Id"].ToString(), bytes);
        SqlDataSource2.UpdateParameters["fiid"].DefaultValue = fimgid;
        uc.UserLog("Image", fimgid, "Insert", "新增文章首圖", Session["User_Id"].ToString(), Session["IP"].ToString());
      }
      else if (!fu.HasFiles && !string.IsNullOrEmpty(base64) && !string.IsNullOrEmpty(f_extension_HF.Value) && !string.IsNullOrEmpty(contenttype_HF.Value))
      {
        bytes = Convert.FromBase64String(base64);
        string fileName = Guid.NewGuid() + f_extension_HF.Value;

        string fimgid = uc.PiNewsInsertImg(contenttype_HF.Value, fileName, Convert.ToDecimal(bytes.Length / 1024), Session["User_Id"].ToString(), bytes);
        SqlDataSource2.UpdateParameters["fiid"].DefaultValue = fimgid;
        uc.UserLog("Image", fimgid, "Insert", "新增文章首圖", Session["User_Id"].ToString(), Session["IP"].ToString());
      }
      else
      {
        SqlDataSource2.UpdateCommand = "UPDATE [Article] SET [Title] = @Title, [Content] = @Content, [Category] = @Category, [Keyword] = @Keyword, [Status] = @Status, [Active_Time] = @Active_Time, [inActive_Time] = @inActive_Time, [Relate_Img] = @Relate_Img, [Description] = @Description WHERE [Id] = @Id";
      }

      SqlDataSource2.UpdateParameters["Title"].DefaultValue = HttpUtility.HtmlEncode(title_TB.Text);
      SqlDataSource2.UpdateParameters["Category"].DefaultValue = Cate_HF.Value;
      SqlDataSource2.UpdateParameters["Keyword"].DefaultValue = kw_HF.Value;
      SqlDataSource2.UpdateParameters["Status"].DefaultValue = Session["IsAdmin"].Equals("True") ? (status.Checked ? "1" : "0") : "0";
      if (!string.IsNullOrEmpty(stime.Text)) SqlDataSource2.UpdateParameters["Active_Time"].DefaultValue = Convert.ToDateTime(stime.Text).ToString("yyyy/MM/dd HH:mm:ss");
      if (!string.IsNullOrEmpty(etime.Text)) SqlDataSource2.UpdateParameters["inActive_Time"].DefaultValue = Convert.ToDateTime(etime.Text).ToString("yyyy/MM/dd HH:mm:ss");
      SqlDataSource2.UpdateParameters["Content"].DefaultValue = HttpUtility.HtmlEncode(Regex.Replace(finalContent, @"<script>[\s\S]+<\/script>", ""));
      SqlDataSource2.UpdateParameters["Relate_Img"].DefaultValue = relate_img.Value;
      SqlDataSource2.UpdateParameters["Description"].DefaultValue = description.Text;
      SqlDataSource2.Update();

      string[] r_img = relate_img.Value.Split(',');
      string article_id = FormView1.DataKey["Id"].ToString();

      if (relate_img.Value.Trim().Length > 0)
      {
        string sql = "Delete from Article_Image where article_id = @aid and image_id ";
        if (r_img.Length == 1)
          sql += "<> " + relate_img.Value;
        else
          sql += string.Format("not in ({0})", relate_img.Value);
        string[] param = { "@aid" };
        string[] value = { article_id };

        uc.PiNewsSql(sql, param, value);

        string query = @"if not exists (Select * from Article_Image where article_id = @aid and image_id = @imgid) 
Insert into Article_Image values(@aid, @imgid)";
        string[] para = { "@aid", "@imgid" };
        for (var i = 0; i < r_img.Length; i++)
        {
          string[] val = { article_id, r_img[i] };
          uc.PiNewsSql(query, para, val);
        }
      }

      //string script = string.Format("console.log('{0}','{1}','{2}','{3}','{4}','{5}');",
      //  title_TB.Text, Cate_HF.Value, kw_HF.Value, finalContent, Session["IsAdmin"].Equals("True") ? (status.Checked ? "1" : "0") : "0", relate_img.Value);
      //uc.FrontEndDebug(this, "update data", script);
      uc.UserLog("Article", article_id, "Update", "更改文章", Session["User_Id"].ToString(), Session["IP"].ToString());
      if (status.Checked && Session["IsAdmin"].Equals("True")) uc.UserLog("Article", FormView1.DataKey["Id"].ToString(), "Approval", "核准文章", Session["User_Id"].ToString(), Session["IP"].ToString());

      GridView1.DataBind();
      ListView1.DataBind();
    }

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
      string id = GridView1.DataKeys[e.RowIndex].Value.ToString();
      string query = "Delete from Article_Image where article_id = @id";
      string[] n = { "@id" };
      string[] v = { id };
      uc.PiNewsSql(query, n, v);

      string query1 = "Delete from Article_Rec_Cat where Article_id = @id";
      uc.PiNewsSql(query, n, v);
      uc.PiNewsSql(query1, n, v);
      uc.UserLog("Article", id, "Delete", "刪除文章", Session["User_Id"].ToString(), Session["IP"].ToString());
    }

    protected void FormView1_PreRender(object sender, EventArgs e)
    {
      if (FormView1.CurrentMode == FormViewMode.ReadOnly && FormView1.DataItemCount > 0)
      {
        AsyncPostBackTrigger Trigger1 = new AsyncPostBackTrigger();
        Trigger1.ControlID = FormView1.FindControl("LinkButton2").UniqueID;
        ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger1);
        ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterAsyncPostBackControl(FormView1.FindControl("LinkButton2"));

        PostBackTrigger Trigger2 = new PostBackTrigger();
        Trigger2.ControlID = FormView1.FindControl("LinkButton1").UniqueID;
        ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger2);
        ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterPostBackControl(FormView1.FindControl("LinkButton1"));
      }

      if (FormView1.CurrentMode == FormViewMode.Edit)
      {
        PostBackTrigger Trigger2 = new PostBackTrigger();
        Trigger2.ControlID = FormView1.FindControl("UpdateButton").UniqueID;
        ((UpdatePanel)Master.FindControl("UpdatePanel1")).Triggers.Add(Trigger2);
        ((ScriptManager)Master.FindControl("ScriptManager1")).RegisterPostBackControl(FormView1.FindControl("UpdateButton"));
      }
      if (FormView1.DataItemCount > 0)
        uc.FrontEndDebug(this, "show article", @"$('#article_detail').modal('hide');
$('#article_detail').modal({inverted: true,allowMultiple: true, closable: false, context: '#"
+ Master.FindControl("UpdatePanel1").ClientID + " .placeholder', debug: true"
+ (FormView1.CurrentMode == FormViewMode.Edit ? ", onVisible: function () {var mh = $(window).height() - $('.ui.textarea-option.segment').outerHeight() - 135;if (mh < 150) mh = 150;$('#article-edit').css('max-height', mh)}" : "") + "}).modal('show');"
+ string.Format("console.log({0});", FormView1.DataItemCount));
      if (FormView1.CurrentMode == FormViewMode.Edit)
      {
        Session["new_Img"] = FormView1.DataKey["r_img"].ToString();
        Repeater repeater = (Repeater)FormView1.FindControl("Repeater1");
        if (Session["new_Img"] != null)
        {
          if (Session["new_Img"].ToString().Trim().Length > 0)
          {
            string arrStr = Session["new_Img"].ToString();
            repeater.DataSource = arrStr.TrimEnd(',').Split(',');
            repeater.DataBind();
          }
        }
      }
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
      if (e.Row.RowType == DataControlRowType.DataRow)
      {
        if (GridView1.SelectedIndex == e.Row.RowIndex) e.Row.CssClass = "active";
      }
    }

    protected override void Render(HtmlTextWriter writer)
    {
      bool isEditRecommend = false;
      if (Session["Authority"] != null)
        if (Array.Exists(Session["Authority"].ToString().Split(','), m => m == "選擇首頁投放類別")) isEditRecommend = true;
      GridView1.Columns[2].Visible = isEditRecommend;
      GridView1.Columns[4].Visible = Session["IsAdmin"].Equals("True");

      if (GridView1.Rows.Count > 0)
      {
        GridView1.HeaderRow.TableSection = TableRowSection.TableHeader;
        GridView1.BottomPagerRow.TableSection = TableRowSection.TableFooter;
      }

      foreach (GridViewRow row in this.GridView1.Rows)
      {
        if (row.RowType == DataControlRowType.DataRow)
        {
          if ((row.RowState & DataControlRowState.Edit) == DataControlRowState.Edit)
          {
            GridView1.CssClass = GridView1.CssClass.Replace("selectable", "");
          }
          else
          {
            for (var i = 0; i < this.GridView1.Columns.Count - 1; i++)
            {
              row.Cells[i].Attributes.Add("onclick", Page.ClientScript.GetPostBackEventReference(this.GridView1, "Select$" + row.RowIndex));
              Page.ClientScript.RegisterForEventValidation(this.GridView1.UniqueID, "Select$" + row.RowIndex);
            }
            row.Cells[this.GridView1.Columns.Count - 1].Attributes.Add("style", "cursor: initial;");
          }
        }
      }

      foreach (ListViewDataItem item in ListView1.Items)
      {
        if (item.ItemType == ListViewItemType.DataItem)
        {
          Page.ClientScript.RegisterForEventValidation(this.ListView1.UniqueID, "Select$" + item.DataItemIndex);
        }
      }

      base.Render(writer);
    }

    protected void GridView1_RowCreated(object sender, GridViewRowEventArgs e)
    {
      if (e.Row.RowType == DataControlRowType.Pager)
      {
        // 取得控制項
        GridView gv = sender as GridView;
        PlaceHolder phdPageNumber = e.Row.FindControl("phdPageNumber") as PlaceHolder;
        PlaceHolder phdPagenl = e.Row.FindControl("phdPagenl") as PlaceHolder;
        LinkButton lbtnPrev = e.Row.FindControl("lbtnPrev") as LinkButton;
        LinkButton lbtnNext = e.Row.FindControl("lbtnNext") as LinkButton;
        LinkButton lbtnFirst = e.Row.FindControl("lbtnFirst") as LinkButton;
        LinkButton lbtnLast = e.Row.FindControl("lbtnLast") as LinkButton;
        LinkButton lbtnPage;

        // 設定每頁顯示筆數
        // 產生頁數
        int showRange = 6;
        int pageCount = gv.PageCount;
        int pageIndex = gv.PageIndex;
        int startIndex = (pageIndex + 1 < showRange) ?
            0 : (pageIndex + 1 + showRange / 2 >= pageCount) ? pageCount - showRange : pageIndex - showRange / 2;
        int endIndex = (startIndex >= pageCount - showRange) ? pageCount : startIndex + showRange;

        phdPageNumber.Controls.Add(new LiteralControl("  "));
        for (int i = startIndex; i < endIndex; i++)
        {
          lbtnPage = new LinkButton();
          lbtnPage.Text = (i + 1).ToString();
          lbtnPage.CommandName = "Page";
          lbtnPage.CommandArgument = (i + 1).ToString();
          lbtnPage.Click += new EventHandler(page_Click);
          lbtnPage.Font.Overline = false;
          lbtnPage.CssClass = "item";
          if (i == pageIndex)
            /*lbtnPage.Font.Bold = true;*/
            lbtnPage.CssClass += " active";
          else
            lbtnPage.Font.Bold = false;
          phdPageNumber.Controls.Add(lbtnPage);
          phdPageNumber.Controls.Add(new LiteralControl(" "));
        }
        lbtnPrev.Click += delegate (object obj, EventArgs args)
        {
          if (gv.PageIndex > 0)
          {
            gv.PageIndex = gv.PageIndex - 1;
            GridView1.DataBind();
          }
        };
        lbtnNext.Click += delegate (object obj, EventArgs args)
        {
          if (gv.PageIndex < gv.PageCount)
          {
            gv.PageIndex = gv.PageIndex + 1;
            GridView1.DataBind();
          }
        };
        lbtnFirst.Click += delegate (object obj, EventArgs args)
        {
          gv.PageIndex = 0;
          GridView1.DataBind();
        };
        lbtnLast.Click += delegate (object obj, EventArgs args)
        {
          gv.PageIndex = gv.PageCount;
          GridView1.DataBind();
        };
        if (gv.PageIndex == 0)
        {
          lbtnFirst.CssClass += " disabled";
          lbtnPrev.CssClass += " disabled";
        }
        if (gv.PageIndex == gv.PageCount)
        {
          lbtnLast.CssClass += " disalbed";
          lbtnNext.CssClass += " disalbed";
        }
        // 動態加入控制項
        phdPagenl.Controls.Add(
            new LiteralControl(string.Format("<li class='item'>  {0} / {1}", pageIndex + 1, pageCount)));
        phdPagenl.Controls.Add(
            new LiteralControl("  </li>"));
      }
    }

    protected void page_Click(object sender, EventArgs args) //換頁
    {
      LinkButton button = sender as LinkButton;
      GridView1.PageIndex = int.Parse(button.Text) - 1;
      GridView1.DataBind();
    }

    protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
    {
      GridView1.SelectedIndex = -1;
      ListView1.SelectedIndex = -1;
      FormView1.DataBind();
      ListView1.DataBind();
    }

    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
      HiddenField cate_hf = (HiddenField)GridView1.Rows[e.RowIndex].FindControl("Category_HF");
      HiddenField recommend_hf = (HiddenField)GridView1.Rows[e.RowIndex].FindControl("Recommend_HF");
      CheckBox cb = (CheckBox)GridView1.Rows[e.RowIndex].FindControl("Status_CB");
      string rcat = GridView1.DataKeys[e.RowIndex].Values["Recommand_Category"].ToString();
      string aid = GridView1.DataKeys[e.RowIndex].Values["Id"].ToString();

      SqlDataSource1.UpdateParameters["Category"].DefaultValue = cate_hf.Value;
      SqlDataSource1.UpdateParameters["Status"].DefaultValue = Session["IsAdmin"].Equals("True") ? (cb.Checked ? "1" : "0") : "0";

      if (Session["Authority"] != null)
      {
        if (Array.Find(Session["Authority"].ToString().Split(','), m => m == "選擇首頁投放類別") != "")
        {
          SqlDataSource1.UpdateParameters["rcat"].DefaultValue = recommend_hf.Value;
          if (recommend_hf.Value != "")
          {
            string[] rcs = recommend_hf.Value.Split(',');
            string q = string.Format("Delete Article_Rec_Cat output deleted.Id where Article_id = @id and Rec_cat_id not in ({0})", recommend_hf.Value);

            uc.FrontEndDebug(this, "debug", string.Format("console.log('{0}');", q));

            uc.PiNewsSql(q, new string[] { "@id" }, new string[] { aid });
            uc.UserLog("Article_Rec_Cat", "", "Delete", "移除未選首頁投放類別", Session["User_Id"].ToString(), Session["IP"].ToString());

            for (var i = 0; i < rcs.Length; i++)
            {
              string q1 = string.Format("if not exists (Select Article_id, Rec_cat_id from Article_Rec_Cat where Article_id = @Id and Rec_cat_id = @rid) Insert into Article_Rec_Cat Values(@id, @rid)");
              string[] p = { "@id", "@rid" };
              string[] pn = { aid, rcs[i] };

              uc.PiNewsSql(q1, p, pn);
              uc.UserLog("Article_Rec_Cat", "", "Insert", "新增首頁投放類別", Session["User_Id"].ToString(), Session["IP"].ToString());
            }
          }else
          {
            string q = "Delete Article_Rec_Cat output deleted.Id where Article_id = @id";

            uc.FrontEndDebug(this, "debug", string.Format("console.log('{0}');", q));

            uc.PiNewsSql(q, new string[] { "@id" }, new string[] { aid });
            uc.UserLog("Article_Rec_Cat", "", "Delete", "移除未選首頁投放類別", Session["User_Id"].ToString(), Session["IP"].ToString());
          }
        }
        else
          SqlDataSource1.UpdateParameters["rcat"].DefaultValue = rcat;
      }
      else SqlDataSource1.UpdateParameters["rcat"].DefaultValue = rcat;
      string id = GridView1.DataKeys[e.RowIndex].Values["Id"].ToString();
      uc.FrontEndDebug(this, "rcat", "console.log('" + rcat + "');");
      uc.UserLog("Article", id, "Update", "文章快速編輯", Session["User_Id"].ToString(), Session["IP"].ToString());
    }

    protected void HiddenField1_ValueChanged(object sender, EventArgs e)
    {
      if (FormView1.CurrentMode == FormViewMode.Edit)
      {
        uc.FrontEndDebug(this, "list upload image", string.Format("console.log('change fired', '{0}');", Session["new_Img"]));
        Repeater repeater = (Repeater)FormView1.FindControl("Repeater1");
        if (Session["new_Img"] != null)
        {
          uc.FrontEndDebug(this, "list upload image", string.Format("console.log('change fired', '{0}');", repeater.ClientID));
          string arrStr = Session["new_Img"].ToString();
          repeater.DataSource = arrStr.Substring(0, arrStr.Length - 1).Split(',');
          repeater.DataBind();
        }
      }
    }

    protected void LinkButton2_Click(object sender, EventArgs e)
    {
      GridView1.SelectedIndex = -1;
      ListView1.SelectedIndex = -1;
      FormView1.DataBind();
      ListView1.DataBind();
    }

    protected void Repeater1_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
      uc.FrontEndDebug(this, "list upload image", string.Format("console.log('change fired', '{0}');", Session["new_Img"]));
    }

    protected void RadioButtonList1_SelectedIndexChanged(object sender, EventArgs e)
    {
      if (RadioButtonList1.SelectedValue == "table")
      {
        GridView1.DataSourceID = SqlDataSource1.ID;
        GridView1.Visible = true;
        ListView1.DataSourceID = "";
        ListView1.Visible = false;
      }
      else
      {
        GridView1.DataSourceID = "";
        GridView1.Visible = false;
        ListView1.DataSourceID = SqlDataSource1.ID;
        ListView1.Visible = true;
      }
      GridView1.SelectedIndex = -1;
      ListView1.SelectedIndex = -1;
      FormView1.DataBind();
      ListView1.DataBind();
    }

    protected void SqlDataSource1_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
    {
      //uc.FrontEndDebug(this, "listview select", string.Format("console.log({0});", ListView1.SelectedIndex));
      if (RadioButtonList1.SelectedValue != "table")
      {
        if (ListView1.SelectedIndex >= 0)
        {
          var article_id = ListView1.DataKeys[ListView1.SelectedIndex].Value.ToString();
          SqlDataSource2.SelectParameters["Id"].DefaultValue = article_id;
        }
        else SqlDataSource2.SelectParameters["Id"].DefaultValue = "";
        SqlDataSource2.DataBind();
      }
    }
  }
}