using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace piNews
{
  public partial class Admin_Authority : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      if (Session["Authority"] == null) Response.Redirect("Admin.aspx");
      else if (!Array.Exists(Session["Authority"].ToString().Split(','), m => m == "設定權限")) Response.Redirect("Admin.aspx");

      //this.Master.Page.Title = "權限設定 | 拍新聞";
      this.Master.Page.Title = "權限設定 | " + Application["Site_Name"];
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
      if (Array.Exists(Session["Authority"].ToString().Split(','), m => m == "設定權限"))
      {
        string insert_sql = "if not exists(select * from User_Authority where Authority_Id = @aid and User_Id = @uid) Insert Into User_Authority(User_Id, Authority_Id) Values(@uid, @aid)";
        string delete_sql = "Delete from User_Authority where User_Id = @uid and Authority_Id = @aid";
        string[] para = { "@aid", "@uid" };
        List<string> chked = new List<string>();
        List<string> nochked = new List<string>();
        for (int i = 0; i < ListView1.Items.Count; i++)
        {
          CheckBox cb = (CheckBox)ListView1.Items[i].FindControl("CheckBox1");
          string[] val = { ListView1.DataKeys[i].Values["Id"].ToString(), GridView1.DataKeys[GridView1.SelectedIndex].Values["Id"].ToString() };
          if (cb.Checked)
          {
            uc.PiNewsSql(insert_sql, para, val);
            if (!ListView1.DataKeys[i].Values["chk"].Equals("true"))
              chked.Add(ListView1.DataKeys[i].Values["Name"].ToString());
          }
          else
          {
            uc.PiNewsSql(delete_sql, para, val);
            if (!ListView1.DataKeys[i].Values["chk"].Equals("false"))
              nochked.Add(ListView1.DataKeys[i].Values["Name"].ToString());
          }
        }
        string uname = GridView1.DataKeys[GridView1.SelectedIndex].Values["Name"].ToString();
        uc.UserLog("User_Authority", "", "Insert,Delete", string.Format("更動{2}權限[新增]{0}[刪除]{1}", string.Join(",", chked), string.Join(",", nochked), uname), Session["User_Id"].ToString(), Session["IP"].ToString());
        GridView1.DataBind();
      }
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
      uc.FrontEndDebug(this, "edit", "$('.ui.auth_edit.modal').modal({inverted: true, context: '#" + Master.FindControl("UpdatePanel1").ClientID + " .placeholder'}).modal('show');");
    }

    protected void GridView1_PreRender(object sender, EventArgs e)
    {
      if (GridView1.Rows.Count > 0)
      {
        GridView1.HeaderRow.TableSection = TableRowSection.TableHeader;
      }
    }

    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
      if (Array.Exists(Session["Authority"].ToString().Split(','), m => m == "設定權限"))
      {
        HiddenField auth_class = (HiddenField)GridView1.Rows[e.RowIndex].FindControl("HiddenField1");
        Repeater all_auth = (Repeater)GridView1.Rows[e.RowIndex].FindControl("Repeater1");
        int user_class;
        bool isAuth = int.TryParse(auth_class.Value, out user_class);
        bool hasAuth = false;
        if (isAuth)
        {
          string sql = "Select Id, Class_Name from Authority_Class where Id = @id";
          string[] para = { "@id" };
          string[] val = { auth_class.Value };
          hasAuth = uc.PiNewsHasRow(sql, para, val);
          if (user_class == 0) hasAuth = true;
        }

        if (isAuth && hasAuth)
        {
          if (user_class == 0)
          {
            string uid = GridView1.DataKeys[e.RowIndex].Values["Id"].ToString();
            string query = "Select isAdmin from Member where Id = @uid and isAdmin = @admin";
            string[] p = { "@uid", "@admin" };
            string[] v = { uid, "false" };

            if (!uc.PiNewsHasRow(query, p, v))
            {
              query = "Update Member set isAdmin = @admin output Inserted.Id where Id = @uid";
              uc.PiNewsSql(query, p, v);
              query = "Delete from User_Authority output Deleted.Id where User_Id = @uid";
              string[] p1 = { "@uid" };
              string[] v1 = { uid };
              uc.PiNewsSql(query, p1, v1);
            }
            uc.UserLog("Member", uid, "Update", "設為拍粉", Session["User_Id"].ToString(), Session["IP"].ToString());
          }
          else
          {
            string uid = GridView1.DataKeys[e.RowIndex].Values["Id"].ToString();
            string query = "Select isAdmin from Member where Id = @uid and isAdmin = @admin";
            string[] p = { "@uid", "@admin" };
            string[] v = { uid, "true" };
            SqlDataSource1.UpdateParameters["pc"].DefaultValue = auth_class.Value;

            if (!uc.PiNewsHasRow(query, p, v))
            {
              //query = "Update Member set isAdmin = @admin output Inserted.Id where Id = @uid";
              //uc.PiNewsSql(query, p, v);
              if (!GridView1.DataKeys[GridView1.EditIndex].Values["pinews_class"].Equals(DBNull.Value))
              {
              }
              uc.FrontEndDebug(this, "ori  auth", string.Format("console.log('{0}', '{1}');", GridView1.DataKeys[GridView1.EditIndex].Values["pinews_class"].Equals(DBNull.Value), GridView1.DataKeys[GridView1.EditIndex].Values["pinews_class"]));
              //uc.UserLog("Member", uid, "Update", "升為網記", Session["User_Id"].ToString(), Session["IP"].ToString());
            }
              uc.UserLog("Member", uid, "Update", "更改使用者職稱", Session["User_Id"].ToString(), Session["IP"].ToString());
            if (int.Parse(GridView1.DataKeys[GridView1.EditIndex].Values["pinews_class"].ToString()) > user_class)
            {
              string q = "Delete from User_Authority output Deleted.Id where USER_ID = @uid and Authority_Id not in (select Auth_Id from Class_Authority where Auth_Class_Id = @aid)";
              string[] p2 = { "@uid", "@aid" };
              string[] v2 = { uid, user_class.ToString() };
              uc.PiNewsSql(q, p2, v2);

              uc.UserLog("User_Authority", "", "Delete", "刪除不符職稱之權限", Session["User_Id"].ToString(), Session["IP"].ToString());
            }
            uc.FrontEndDebug(this, "auth", string.Format("console.log('ori:', '{0}', 'new:', '{1}');", GridView1.DataKeys[GridView1.EditIndex].Values["pinews_class"].ToString(), user_class.ToString()));
          }
        }
        else e.Cancel = true;
      }
    }
  }
}