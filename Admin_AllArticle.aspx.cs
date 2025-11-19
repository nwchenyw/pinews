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
  public partial class Admin_AllArticle : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      string s = Search_TB.Text;
      if (s != "")
      {
        SqlDataSource2.SelectCommand = @"Select [Title], [Front_Img_Id], [Keyword], [Category], [DateTime], [Status], [Author], [Recommand_Category], [Description], a.[Id], [User_Id] from Article a left join Member m on m.Id = a.User_id 
where a.title like '%' + @input + N'%' or m.name like N'%' + @input + '%' or m.Pinews_name like N'%'+ @input + '%'";

        SqlDataSource2.SelectParameters.Clear();
        SqlDataSource2.SelectParameters.Add("input", TypeCode.String, s);
        SqlDataSource2.SelectParameters["input"].DefaultValue = s;
      }
      else
      {
        SqlDataSource2.SelectCommand = @"SELECT [Title], [Front_Img_Id], [Keyword], [Category], [DateTime], [Status], [Author], [Recommand_Category], [Description], [Id], [User_Id] FROM [Article] ORDER BY [DateTime] DESC";
        SqlDataSource2.SelectParameters.Clear();
      }
      //SqlDataSource2.DataBind();
      //GridView2.DataBind();
    }

    //protected void GridView1_PreRender(object sender, EventArgs e)
    //{
    //  if (GridView1.Rows.Count > 0)
    //    GridView1.HeaderRow.TableSection = TableRowSection.TableHeader;
    //}

    protected void GridView2_PreRender(object sender, EventArgs e)
    {
      if (GridView2.Rows.Count > 0)
      {
        GridView2.HeaderRow.TableSection = TableRowSection.TableHeader;
        if (GridView2.PageCount > 0)
          GridView2.BottomPagerRow.TableSection = TableRowSection.TableFooter;
        //GridView2.FooterRow.TableSection = TableRowSection.TableFooter;
      }
    }

    protected void LinkButton2_Click(object sender, EventArgs e)
    {
      //GridView1.SelectedIndex = -1;
      GridView2.SelectedIndex = -1;
      FormView1.DataBind();
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
        uc.FrontEndDebug(this, "show article", "$('#article_detail').modal('hide');$('#article_detail').modal({inverted: true,allowMultiple: true, closable: false, context: '#" + Master.FindControl("UpdatePanel1").ClientID + " .placeholder', debug: true}).modal('show');" + string.Format("console.log({0});", FormView1.DataItemCount));
      if (FormView1.CurrentMode == FormViewMode.Edit)
      {
        //Session["new_Img"] = FormView1.DataKey["r_img"].ToString();
        //Repeater repeater = (Repeater)FormView1.FindControl("Repeater1");
        //if (Session["new_Img"] != null)
        //{
        //  if (Session["new_Img"].ToString().Trim().Length > 0)
        //  {
        //    string arrStr = Session["new_Img"].ToString();
        //    repeater.DataSource = arrStr.TrimEnd(',').Split(',');
        //    repeater.DataBind();
        //  }
        //}if (FormView1.CurrentMode == FormViewMode.Edit)

        SqlDataSource sql5 = (SqlDataSource)FormView1.FindControl("SqlDataSource5");
        ListView lv1 = (ListView)FormView1.FindControl("ListView1");
        sql5.SelectParameters["User_Id"].DefaultValue = GridView2.DataKeys[GridView2.SelectedIndex].Values["User_Id"].ToString();
        sql5.DataBind();
        lv1.DataBind();
        uc.FrontEndDebug(this, "ad debug", string.Format("console.log('{0}');", sql5.SelectParameters["User_Id"].DefaultValue));
      }
    }

    protected void GridView2_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
      uc.FrontEndDebug(this, "gv2 seling", string.Format("console.log('{0}');", e.NewSelectedIndex));
    }

    protected void GridView2_SelectedIndexChanged(object sender, EventArgs e)
    {
      if (FormView1.CurrentMode == FormViewMode.Edit)
      {
        SqlDataSource sql5 = (SqlDataSource)FormView1.FindControl("SqlDataSource5");
        ListView lv1 = (ListView)FormView1.FindControl("ListView1");
        sql5.SelectParameters["User_Id"].DefaultValue = GridView2.DataKeys[GridView2.SelectedIndex].Values["User_Id"].ToString();
        sql5.DataBind();
        lv1.DataBind();
        uc.FrontEndDebug(this, "ad debug", string.Format("console.log('{0}');", sql5.SelectParameters["User_Id"].DefaultValue));
      }
      SqlDataSource5.SelectParameters["Id"].DefaultValue = GridView2.DataKeys[GridView2.SelectedIndex].Values["Id"].ToString();
      uc.FrontEndDebug(this, "gv2 sel", string.Format("console.log('{0}');", GridView2.DataKeys[GridView2.SelectedIndex].Values["Id"].ToString()));
      FormView1.DataBind();
    }

    //protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
    //{
    //  GridView1.SelectedIndex = -1;
    //  GridView2.SelectedIndex = -1;
    //  GridView1.DataBind();
    //  GridView2.DataBind();
    //  SqlDataSource5.SelectParameters["Id"].DefaultValue = "";
    //  FormView1.DataBind();
    //}

    protected void GridView2_RowEditing(object sender, GridViewEditEventArgs e)
    {
      //GridView1.SelectedIndex = -1;
      GridView2.SelectedIndex = -1;
      //GridView1.DataBind();
      GridView2.DataBind();
      SqlDataSource5.SelectParameters["Id"].DefaultValue = "";
      FormView1.DataBind();
    }

    protected void GridView2_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
      HiddenField c_hf = (HiddenField)GridView2.Rows[GridView2.EditIndex].FindControl("Category_HF");
      HiddenField r_hf = (HiddenField)GridView2.Rows[GridView2.EditIndex].FindControl("Recommend_HF");
      CheckBox cb = (CheckBox)GridView2.Rows[GridView2.EditIndex].FindControl("Status_CB");

      string aid = GridView2.DataKeys[e.RowIndex].Values["Id"].ToString();

      SqlDataSource2.UpdateParameters["Category"].DefaultValue = c_hf.Value;
      SqlDataSource2.UpdateParameters["Status"].DefaultValue = cb.Checked ? "1" : "0";
      SqlDataSource2.UpdateParameters["Recommand_Category"].DefaultValue = r_hf.Value;
      SqlDataSource2.UpdateParameters["Id"].DefaultValue = aid;

      SqlDataSource2.Update();

      uc.FrontEndDebug(this, "debug", "console.log('fetch:"+ c_hf.Value + "');");
      uc.FrontEndDebug(this, "de-bug", "console.log('sql:"+ SqlDataSource2.UpdateParameters["Id"].DefaultValue + "');");

      if (r_hf.Value != "")
      {
        string[] rcs = r_hf.Value.Split(',');
        string q = string.Format("Delete Article_Rec_Cat output deleted.Id where Article_id = @id and Rec_cat_id not in ({0})", r_hf.Value);

        uc.FrontEndDebug(this, "debug", string.Format("console.log('{0}');", q));

        uc.PiNewsSql(q, new string[] { "@id" }, new string[] { aid });
        uc.UserLog("Article_Rec_Cat", aid, "Delete", "移除未選首頁投放類別", Session["User_Id"].ToString(), Session["IP"].ToString());

        for (var i = 0; i < rcs.Length; i++)
        {
          string q1 = string.Format("if not exists (Select Article_id, Rec_cat_id from Article_Rec_Cat where Article_id = @Id and Rec_cat_id = @rid) Insert into Article_Rec_Cat Values(@id, @rid)");
          string[] p = { "@id", "@rid" };
          string[] pn = { aid, rcs[i] };

          uc.PiNewsSql(q1, p, pn);
          uc.UserLog("Article_Rec_Cat", aid, "Insert", "新增首頁投放類別", Session["User_Id"].ToString(), Session["IP"].ToString());
        }
      }
      else
      {
        string q = "Delete Article_Rec_Cat output deleted.Id where Article_id = @id";

        uc.FrontEndDebug(this, "debug", string.Format("console.log('{0}');", q));

        uc.PiNewsSql(q, new string[] { "@id" }, new string[] { aid });
        uc.UserLog("Article_Rec_Cat", "", "Delete", "移除未選首頁投放類別", Session["User_Id"].ToString(), Session["IP"].ToString());
      }

      uc.UserLog("Article", GridView2.DataKeys[GridView2.EditIndex].Values["Id"].ToString(), "Update", "修改文章標籤", Session["User_Id"].ToString(), Session["IP"].ToString());
      GridView2.DataBind();
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
          if (arrStr.Length > 0)
          {
            repeater.DataSource = arrStr.Substring(0, arrStr.Length - 1).Split(',');
            repeater.DataBind();
          }
        }
      }
    }
    protected void Repeater1_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
      uc.FrontEndDebug(this, "list upload image", string.Format("console.log('change fired', '{0}');", Session["new_Img"]));
    }

    protected void FormView1_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
      FileUpload fu = (FileUpload)FormView1.FindControl("front_IU");
      //TextBox title_TB = (TextBox)FormView1.FindControl("TitleTextBox");
      HiddenField chf = (HiddenField)FormView1.FindControl("Category_HF");
      HiddenField kwhf = (HiddenField)FormView1.FindControl("Keywords_HF");
      CheckBox cb = (CheckBox)FormView1.FindControl("StatusCheckBox");
      TextBox tb = (TextBox)FormView1.FindControl("Active_TimeTextBox");
      TextBox tb2 = (TextBox)FormView1.FindControl("Title_TB");
      TextBox tb1 = (TextBox)FormView1.FindControl("inActive_TimeTextBox");
      TextBox content = (TextBox)FormView1.FindControl("ContentTextBox");
      TextBox description = (TextBox)FormView1.FindControl("Description");
      HiddenField relate_img = (HiddenField)FormView1.FindControl("HiddenField1");

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

      string finalContent = content.Text;

      string script = string.Format("console.log('{0}','{1}','{2}','{3}','{4}','{5}');", chf.Value, kwhf.Value, finalContent, description.Text, cb.Checked ? "1" : "0", relate_img.Value);
      uc.FrontEndDebug(this, "update data", script);

      HttpPostedFile file = fu.PostedFile;
      if (fu.HasFiles)
      {

        SqlDataSource5.UpdateCommand = "Update Article set Title = @title, Description = @desc, Content = @Content, Front_Img_Id = @fiid, keyword = @kw, Category = @cat, Relate_Img = @rImg, status = @s, Active_Time = @atime, inActive_Time = @inatime where Id = @Id";
        string fileExtension = Path.GetExtension(file.FileName);

        string fileName = Guid.NewGuid() + fileExtension;
        string contentType = file.ContentType;
        byte[] bytes;

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
        SqlDataSource5.UpdateParameters["fiid"].DefaultValue = fimgid;
        uc.UserLog("Image", fimgid, "Insert", "新增文章首圖", Session["User_Id"].ToString(), Session["IP"].ToString());
      }
      //else
      //{
      //  SqlDataSource5.UpdateCommand = "Update Article set Description = @desc, Content = @Content, keyword = @kw, Category = @cat, Relate_Img = @rImg, status = @s, Active_Time = @atime, inActive_Time = @inatime where Id = @Id";
      //}

      SqlDataSource5.UpdateParameters["title"].DefaultValue = HttpUtility.HtmlEncode(tb2.Text);
      //SqlDataSource5.UpdateParameters["Category"].DefaultValue = Cate_HF.Value;
      SqlDataSource5.UpdateParameters["desc"].DefaultValue = description.Text;
      SqlDataSource5.UpdateParameters["kw"].DefaultValue = kwhf.Value;
      SqlDataSource5.UpdateParameters["cat"].DefaultValue = chf.Value;
      SqlDataSource5.UpdateParameters["s"].DefaultValue = cb.Checked ? "1" : "0";
      if (!string.IsNullOrEmpty(tb.Text)) SqlDataSource5.UpdateParameters["atime"].DefaultValue = Convert.ToDateTime(tb.Text).ToString("yyyy/MM/dd HH:mm:ss");
      if (!string.IsNullOrEmpty(tb1.Text)) SqlDataSource5.UpdateParameters["inatime"].DefaultValue = Convert.ToDateTime(tb1.Text).ToString("yyyy/MM/dd HH:mm:ss");
      SqlDataSource5.UpdateParameters["Content"].DefaultValue = HttpUtility.HtmlEncode(finalContent);
      SqlDataSource5.UpdateParameters["rImg"].DefaultValue = relate_img.Value;

      string author = FormView1.DataKey.Values["Author"].ToString();
      string author_email = FormView1.DataKey.Values["Author_Email"].ToString();
      uc.UserLog("Article", FormView1.DataKey.Values["Id"].ToString(), "Update", string.Format("修改{0}({1})文章", author, author_email), Session["User_Id"].ToString(), Session["IP"].ToString());
      if (cb.Checked) uc.UserLog("Article", FormView1.DataKey["Id"].ToString(), "Approval", string.Format("核准{0}({1})文章", author, author_email), Session["User_Id"].ToString(), Session["IP"].ToString());
      FormView1.DataBind();
      GridView2.DataBind();
    }

    protected void GridView2_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
      GridView2.SelectedIndex = -1;
      GridView2.DataBind();
      SqlDataSource5.SelectParameters["Id"].DefaultValue = "";
      FormView1.DataBind();
    }

    protected void Search_LB_Click(object sender, EventArgs e)
    {
      string s = Search_TB.Text;
      if (s != "")
      {
        SqlDataSource2.SelectCommand = @"Select [Title], [Front_Img_Id], [Keyword], [Category], [DateTime], [Status], [Author], [Recommand_Category], [Description], a.[Id], [User_Id] from Article a left join Member m on m.Id = a.User_id 
where a.title like '%' + @input + N'%' or m.name like N'%' + @input + '%' or m.Pinews_name like N'%'+ @input + '%'";

        SqlDataSource2.SelectParameters.Clear();
        SqlDataSource2.SelectParameters.Add("input", TypeCode.String, s);
        SqlDataSource2.SelectParameters["input"].DefaultValue = s;
      }
      else
      {
        SqlDataSource2.SelectCommand = @"SELECT [Title], [Front_Img_Id], [Keyword], [Category], [DateTime], [Status], [Author], [Recommand_Category], [Description], [Id], [User_Id] FROM [Article] ORDER BY [DateTime] DESC";
        SqlDataSource2.SelectParameters.Clear();
      }
      SqlDataSource2.DataBind();
      GridView2.DataBind();
    }

    protected void Search_TB_TextChanged(object sender, EventArgs e)
    {
      string s = Search_TB.Text;
      if (s != "")
      {
        SqlDataSource2.SelectCommand = @"Select [Title], [Front_Img_Id], [Keyword], [Category], [DateTime], [Status], [Author], [Recommand_Category], [Description], a.[Id], [User_Id] from Article a left join Member m on m.Id = a.User_id 
where a.title like '%' + @input + N'%' or m.name like N'%' + @input + '%' or m.Pinews_name like N'%'+ @input + '%'";

        SqlDataSource2.SelectParameters.Clear();
        SqlDataSource2.SelectParameters.Add("input", TypeCode.String, s);
        SqlDataSource2.SelectParameters["input"].DefaultValue = s;
      }
      else
      {
        SqlDataSource2.SelectCommand = @"SELECT [Title], [Front_Img_Id], [Keyword], [Category], [DateTime], [Status], [Author], [Recommand_Category], [Description], [Id], [User_Id] FROM [Article] ORDER BY [DateTime] DESC";
        SqlDataSource2.SelectParameters.Clear();
      }
      SqlDataSource2.DataBind();
      GridView2.SelectedIndex = -1;
      GridView2.DataBind();
      SqlDataSource5.SelectParameters["Id"].DefaultValue = "";
      FormView1.DataBind();
      //GridView2.DataBind();
      //uc.FrontEndDebug(this, "debug", string.Format("console.log(`{0}`, `{1}`);", SqlDataSource2.SelectCommand, SqlDataSource2.SelectParameters["input"].DefaultValue));
    }

    protected void LinkButton3_Click(object sender, EventArgs e)
    {
      SqlDataSource2.SelectCommand = @"SELECT [Title], [Front_Img_Id], [Keyword], [Category], [DateTime], [Status], [Author], [Recommand_Category], [Description], [Id], [User_Id] FROM [Article] ORDER BY [DateTime] DESC";

      SqlDataSource2.SelectParameters.Clear();
      SqlDataSource2.DataBind();
      GridView2.DataBind();
    }

    protected void GridView2_RowCreated(object sender, GridViewRowEventArgs e)
    {
      if (e.Row.RowType == DataControlRowType.Pager)
      {
        int pageCount = GridView2.PageCount;
        int pageIndex = GridView2.PageIndex;

        ((Table)e.Row.Cells[0].Controls[0]).CssClass = "ui collapsing table";
        ((Table)e.Row.Cells[0].Controls[0]).Attributes.Add("style", "display: inline-block; margin: 0;");

        PlaceHolder phdPagenl = new PlaceHolder();

        // 動態加入控制項
        phdPagenl.Controls.Add(
            new LiteralControl(string.Format("<span class='ui right floated menu'><span class='item'>  {0} / {1}", pageIndex + 1, pageCount)));
        phdPagenl.Controls.Add(
            new LiteralControl("  </span></span>"));

        e.Row.Cells[0].Controls.Add(phdPagenl);
      }
    }
  }
}