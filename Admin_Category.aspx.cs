using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace piNews
{
  public partial class Admin_Category : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      this.Master.Page.Title = "投稿分類管理 | " + Application["Site_Name"];
      if (Session["Authority"] == null) Response.Redirect("Admin.aspx");
      else if (!Array.Exists(Session["Authority"].ToString().Split(','), m => m == "投稿分類")) Response.Redirect("Admin.aspx");
    }

    protected void GridView1_PreRender(object sender, EventArgs e)
    {
      if (GridView1.Rows.Count > 0)
        GridView1.HeaderRow.TableSection = TableRowSection.TableHeader;
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

    protected void Insert_LB_Click(object sender, EventArgs e)
    {
      TextBox tb = (TextBox)GridView1.FooterRow.FindControl("TextBox1");
      if (!string.IsNullOrEmpty(tb.Text))
      {
        string query = "Insert Into Menu(Name) output Inserted.Id Values(@name)";
        string[] p = { "@name" };
        string[] v = { tb.Text };

        string mid = uc.PiNewsSql(query, p, v);
        uc.UserLog("Menu", mid, "Insert", "新增投稿分類", Session["User_Id"].ToString(), Session["IP"].ToString());
        GridView1.DataBind();
      }
      else
      {
        uc.FrontEndDebug(this, "empty insert tb", "alert('新增投稿分類名稱不可爲空');");
      }
    }

    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
      TextBox tb = (TextBox)GridView1.Rows[e.RowIndex].FindControl("name_TB");

      uc.FrontEndDebug(this, "txt", string.Format("console.log('{0}');", tb.Text));
      SqlDataSource1.UpdateParameters["Name"].DefaultValue = tb.Text;
      uc.UserLog("Menu", GridView1.DataKeys[e.RowIndex].Value.ToString(), "Update", "更新投稿分類", Session["User_Id"].ToString(), Session["IP"].ToString());
    }

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
      uc.UserLog("Menu", GridView1.DataKeys[e.RowIndex].Value.ToString(), "Delete", "刪除投稿分類", Session["User_Id"].ToString(), Session["IP"].ToString());
    }

    protected void Edit_Order_LB_Click(object sender, EventArgs e)
    {
      Reorder_LB.Visible = true;
      Cancel_Order_LB.Visible = true;
      uc.FrontEndDebug(this, "reodr", "organize();");
    }

    protected void Reorder_LB_Click(object sender, EventArgs e)
    {
      int[] locationIds = (from p in Request.Form["Menu_Id"].Split(',')
                           select int.Parse(p)).ToArray();
      int[] Menu_Ids = (from p in Request.Form["Menu_Id"].Split(',')
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
        foreach (int Menu_Id in Menu_Ids)
        {
          Upd_Menu_odr(Menu_Id, preference);
          preference += 1;
        }
      }

      uc.FrontEndDebug(this, "id", string.Format("console.log('{0}', '{1}');", Request.Form["Menu_Id"], string.Join(",", grid)));
      uc.UserLog("Menu", "", "Update", "更新投稿分類排序", Session["User_Id"].ToString(), Session["IP"].ToString());
      GridView1.DataBind();
    }
    private void Upd_Menu_odr(int Id, int odr)
    {
      string sql = "UPDATE Menu SET Odr = @co output Inserted.Id WHERE Id = @MId";
      string[] para = { "@co", "@MId" };
      string[] val = { odr.ToString(), Id.ToString() };
      uc.PiNewsSql(sql, para, val);
    }

    protected void Cancel_Order_LB_Click(object sender, EventArgs e)
    {
      Reorder_LB.Visible = false;
      Cancel_Order_LB.Visible = false;
    }
  }
}