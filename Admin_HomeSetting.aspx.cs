using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace piNews
{
  public partial class Admin_HomeSetting : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      this.Master.Page.Title = "首頁標題設定 | " + Application["Site_Name"];
      if (Session["Authority"] != null)
      {
        if (!Array.Exists(Session["Authority"].ToString().Split(','), m => m == "首頁標題設定")) Response.Redirect("Default.aspx");
      }
      else Response.Redirect("Default.aspx");
    }
    private void Page_Error(object sender, EventArgs e)
    {
      // Get last error from the server.
      Exception ex = Server.GetLastError();

      StringBuilder sb = new StringBuilder();
      sb.Append("********************" + " Error Log - " + DateTime.Now + "*********************");
      sb.Append("\n");
      sb.Append("\n");
      sb.Append("Exception Type : " + ex.GetType().Name);
      sb.Append("\n");
      sb.Append("Error Message : " + ex.Message);
      sb.Append("\n");
      sb.Append("Error Source : " + ex.Source);
      sb.Append("\n");
      if (ex.StackTrace != null)
      {
        sb.Append("Error Trace : " + ex.StackTrace);
      }
      Exception innerEx = ex.InnerException;
      while (innerEx != null)
      {
        sb.Append("\n");
        sb.Append("\n");
        sb.Append("Exception Type : " + innerEx.GetType().Name);
        sb.Append("\n");
        sb.Append("Error Message : " + innerEx.Message);
        sb.Append("\n");
        sb.Append("Error Source : " + innerEx.Source);
        sb.Append("\n");
        if (ex.StackTrace != null)
        {
          sb.Append("Error Trace : " + innerEx.StackTrace);
        }
        innerEx = innerEx.InnerException;
      }

      uc.FrontEndDebug(this, "err", string.Format("alert('error');console.log(`{0}`);", sb.ToString()));

      // Handle specific exception.
      //if (ex is InvalidOperationException)
      //{
      //  // Pass the error on to the error page.
      //  Server.Transfer("Error.aspx?handler=Page_Error%20-%20Admin_HomeSetting.aspx",
      //      true);
      //}
    }

    protected void GridView1_PreRender(object sender, EventArgs e)
    {
      if (GridView1.Rows.Count > 0)
      {
        GridView1.HeaderRow.TableSection = TableRowSection.TableHeader;
        if (GridView1.ShowFooter)
          GridView1.FooterRow.TableSection = TableRowSection.TableFooter;
      }
      if (GridView1.EditIndex != -1)
      {
        Edit_Order_LB.Visible = false;
        Reorder_LB.Visible = false;
        Cancel_Order_LB.Visible = false;
      }
      else
      {
        Edit_Order_LB.Visible = true;
      }
    }

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
      string id = GridView1.DataKeys[e.RowIndex].Value.ToString();

      uc.UserLog("Recommendation", id, "Delete", "刪除投稿分類", Session["User_Id"].ToString(), Session["IP"].ToString());
      GridView1.DataBind();
    }

    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
      string id = GridView1.DataKeys[e.RowIndex].Value.ToString();
      TextBox tb = (TextBox)GridView1.Rows[e.RowIndex].FindControl("TextBox1");
      HiddenField hf1 = (HiddenField)GridView1.Rows[e.RowIndex].FindControl("HiddenField1");
      HiddenField hf2 = (HiddenField)GridView1.Rows[e.RowIndex].FindControl("HiddenField2");
      HiddenField hf3 = (HiddenField)GridView1.Rows[e.RowIndex].FindControl("HiddenField3");
      HiddenField fn = (HiddenField)GridView1.Rows[e.RowIndex].FindControl("fontName_HF");
      TextBox fc = (TextBox)GridView1.Rows[e.RowIndex].FindControl("colorPicker_TB");
      bool ok = true;

      if (ok)
      {
        SqlDataSource1.UpdateParameters["Category_Name"].DefaultValue = tb.Text;
        SqlDataSource1.UpdateParameters["Art_Odr_Type"].DefaultValue = hf1.Value;
        SqlDataSource1.UpdateParameters["Art_Odr_Duration"].DefaultValue = hf2.Value;
        SqlDataSource1.UpdateParameters["Art_Grouping"].DefaultValue = hf3.Value;
        SqlDataSource1.UpdateParameters["fn"].DefaultValue = fn.Value;
        SqlDataSource1.UpdateParameters["fc"].DefaultValue = fc.Text;

        uc.UserLog("Recommendation", id, "Update", "編輯投稿分類", Session["User_Id"].ToString(), Session["IP"].ToString());
        GridView1.DataBind();
      }
    }

    protected void LinkButton3_Click(object sender, EventArgs e)
    {
      TextBox tb = (TextBox)GridView1.FooterRow.FindControl("TextBox2");
      TextBox ctb = (TextBox)GridView1.FooterRow.FindControl("colorPicker_TB");
      HiddenField hf1 = (HiddenField)GridView1.FooterRow.FindControl("HiddenField1");
      HiddenField hf2 = (HiddenField)GridView1.FooterRow.FindControl("HiddenField2");
      HiddenField hf3 = (HiddenField)GridView1.FooterRow.FindControl("HiddenField3");
      HiddenField fhf = (HiddenField)GridView1.FooterRow.FindControl("fontName_HF");
      if (!string.IsNullOrEmpty(tb.Text))
      {
        string sql = "Insert into Recommendation(Category_Name, Art_Odr_Type, Art_Grouping, Art_Odr_Duration, font_color, font_name) output Inserted.Id Values(@name, @odr, @grp, @dura, @fc, @fn)";
        string[] para = { "@name", "@odr", "@grp", "@dura", "@fc", "@fn" };
        string[] val = { tb.Text, hf1.Value, hf3.Value, hf2.Value, ctb.Text, fhf.Value };

        string id = uc.PiNewsSql(sql, para, val);
        uc.UserLog("Recommendation", id, "Insert", "新增首頁標題分類", Session["User_Id"].ToString(), Session["IP"].ToString());
        GridView1.DataBind();
      }
      else uc.FrontEndDebug(this, "insert err", "alert('新增首頁標題分類不可爲空');");
    }

    protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
    {
      uc.FrontEndDebug(this, "dropdown", string.Format("$('#{0} tbody .ui.dropdown').dropdown();", GridView1.ClientID));
    }

    protected void Reorder_LB_Click(object sender, EventArgs e)
    {
      int[] locationIds = (from p in Request.Form["Reco_Id"].Split(',')
                           select int.Parse(p)).ToArray();
      int[] Reco_Ids = (from p in Request.Form["Reco_Id"].Split(',')
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
        foreach (int Reco_Id in Reco_Ids)
        {
          Upd_Recommendation_odr(Reco_Id, preference);
          preference += 1;
        }
      }

      uc.FrontEndDebug(this, "id", string.Format("console.log('{0}', '{1}');", Request.Form["Reco_Id"], string.Join(",", grid)));
      uc.UserLog("Recommendation", "", "Update", "更新首頁標題排序", Session["User_Id"].ToString(), Session["IP"].ToString());
      GridView1.DataBind();
    }

    private void Upd_Recommendation_odr(int Id, int odr)
    {
      string sql = "UPDATE Recommendation SET Cat_Order = @co output Inserted.Id WHERE Id = @RId";
      string[] para = { "@co", "@RId" };
      string[] val = { odr.ToString(), Id.ToString() };
      uc.PiNewsSql(sql, para, val);
    }

    protected void Edit_Order_LB_Click(object sender, EventArgs e)
    {
      Reorder_LB.Visible = true;
      Cancel_Order_LB.Visible = true;
      uc.FrontEndDebug(this, "reodr", "organize();");
    }

    protected void Cancel_Order_LB_Click(object sender, EventArgs e)
    {
      Reorder_LB.Visible = false;
      Cancel_Order_LB.Visible = false;
    }
  }
}