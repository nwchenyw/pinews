using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace piNews
{
  public partial class Admin_Marquee : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      if (Session["Authority"] != null)
      {
        if (!Array.Exists(Session["Authority"].ToString().Split(','), m => m == "首頁跑馬燈")) Response.Redirect("Default.aspx");
      }
      else Response.Redirect("Default.aspx");
      this.Master.Page.Title = "跑馬燈設定 | " + Application["Site_Name"];
    }

    protected void Insert_item_Click(object sender, EventArgs e)
    {
      string sql = "Insert Into Marquee(Text, Link, Add_Time, font_name, font_size, color) Values(@txt, @link, GETDATE(), @font_name, @font_size, @color)";
      string[] para = { "@txt", "@link", "@font_name", "@font_size", "@color" };
      string[] val = { Marquee_Text.Text, Link_TB.Text, fontName_HF.Value, fontSize_HF.Value, colorPicker_TB.Text };

      string id = uc.PiNewsSql(sql, para, val);

      string sql1 = "update Marquee set font_size = @fs, font_weight = @fw output Inserted.Id";
      string[] paran = { "@fs", "@fw" };
      string[] val1 = { fontSize_HF.Value, Bold_CB.Checked ? "bold" : "normal" };

      uc.PiNewsSql(sql1, paran, val1);
      uc.UserLog("Marquee", id, "Insert", "新增跑馬燈", Session["User_Id"].ToString(), Session["IP"].ToString());
      GridView1.DataBind();
    }

    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
      TextBox mtb = (TextBox)GridView1.Rows[e.RowIndex].FindControl("Marquee_TB");
      TextBox ltb = (TextBox)GridView1.Rows[e.RowIndex].FindControl("link_TB");
      TextBox color = (TextBox)GridView1.Rows[e.RowIndex].FindControl("colorPicker_TB");
      HiddenField size = (HiddenField)GridView1.Rows[e.RowIndex].FindControl("fontSize_HF");
      HiddenField name = (HiddenField)GridView1.Rows[e.RowIndex].FindControl("fontName_HF");
      CheckBox weight = (CheckBox)GridView1.Rows[e.RowIndex].FindControl("Bold_CB");
      CheckBox active = (CheckBox)GridView1.Rows[e.RowIndex].FindControl("active_CB");
      SqlDataSource1.UpdateParameters["Text"].DefaultValue = mtb.Text;
      SqlDataSource1.UpdateParameters["Link"].DefaultValue = ltb.Text;
      SqlDataSource1.UpdateParameters["font_size"].DefaultValue = size.Value;
      SqlDataSource1.UpdateParameters["font_name"].DefaultValue = name.Value;
      SqlDataSource1.UpdateParameters["font_weight"].DefaultValue = weight.Checked ? "bold" : "normal";
      SqlDataSource1.UpdateParameters["color"].DefaultValue = color.Text;
      SqlDataSource1.UpdateParameters["active"].DefaultValue = active.Checked ? "True":"False";

      string sql = "update Marquee set font_size = @fs, font_weight = @fw output Inserted.Id";
      string[] para = { "@fs", "@fw" };
      string[] val = { size.Value, weight.Checked ? "bold" : "normal" };

      uc.PiNewsSql(sql, para, val);
      uc.UserLog("Marquee", GridView1.DataKeys[e.RowIndex].Value.ToString(), "Update", "更新跑馬燈", Session["User_Id"].ToString(), Session["IP"].ToString());
    }

    protected void GridView1_PreRender(object sender, EventArgs e)
    {
      GridView1.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void Cancel_Odr_LB_Click(object sender, EventArgs e)
    {
      Reorder_LB.Visible = false;
      Cancel_Odr_LB.Visible = false;
    }

    protected void Reorder_LB_Click(object sender, EventArgs e)
    {
      Reorder_LB.Visible = false;
      Cancel_Odr_LB.Visible = false;

      int[] locationIds = (from p in Request.Form["Marquee_Id"].Split(',')
                           select int.Parse(p)).ToArray();
      int[] Marquee_Ids = (from p in Request.Form["Marquee_Id"].Split(',')
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

      uc.FrontEndDebug(this, "id", string.Format("console.log('{0}', '{1}');", Request.Form["Marquee_Id"], string.Join(",", grid)));
      uc.UserLog("Marquee", "", "Update", "更新跑馬燈排序", Session["User_Id"].ToString(), Session["IP"].ToString());
      GridView1.DataBind();
    }

    private void Upd_Marquee_odr(int Id, int odr)
    {
      string sql = "UPDATE Marquee SET Odr = @co output Inserted.Id WHERE Id = @MId";
      string[] para = { "@co", "@MId" };
      string[] val = { odr.ToString(), Id.ToString() };
      uc.PiNewsSql(sql, para, val);
    }

    protected void Edit_Odr_LB_Click(object sender, EventArgs e)
    {
      Reorder_LB.Visible = true;
      Cancel_Odr_LB.Visible = true;
      uc.FrontEndDebug(this, "reodr", "organize();");
    }
  }
}