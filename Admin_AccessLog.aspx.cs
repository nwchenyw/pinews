using System;
using System.Web.UI.WebControls;

namespace piNews
{
  public partial class Admin_AccessLog : System.Web.UI.Page
  {
    protected void Page_Load(object sender, EventArgs e)
    {
      //if (GridView1.Rows.Count > 0)
      //GridView1.HeaderRow.TableSection = TableRowSection.TableHeader;

      this.Master.Page.Title = "網站管理記錄 | " + Application["Site_Name"]; ;
    }

    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
      string sql = @"SELECT *, 
case Modify_Action 
when 'Login' then 'sign in alternate' when 'Logout' then 'sign out alternate' 
when 'Approval' then 'stamp' when 'Insert' then 'plus' 
when 'Update' then 'edit' when 'Delete' then 'trash alternate' 
when 'View' then 'book reader' end as action, 
case when DATEDIFF(DAY, Operate_Time, GETDATE()) < 1 then format(Operate_Time, 'tt hh:mm') 
when DATEDIFF(DAY, Operate_Time, GETDATE()) = 1 then '昨天 ' + format(Operate_Time, 'tt hh:mm') 
when year(GETDATE()) - year(Operate_Time) < 1 then format(Operate_Time, 'M月d日') 
when year(GETDATE()) - year(Operate_Time) >= 1 then format(Operate_Time, 'yyyy年M月d日') end as o_time 
FROM [UserLog] WHERE [Operate_User_Id] = @Operate_User_Id AND [Modify_Action] <> @Modify_Action";
      string sql_end = " ORDER BY [Operate_Time] DESC";
      if (!CheckBox1.Checked) { 
      sql = sql + @" AND [Modify_Action] <> 'Login' AND [Modify_Action] <> 'Logout'";
      }
      SqlDataSource1.SelectCommand = sql + sql_end;
      SqlDataSource1.DataBind();
      DataPager1.SetPageProperties(0 * DataPager1.PageSize,
    DataPager1.MaximumRows,
    false
);
    }
    protected void ListView1_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
    {
      //set current page startindex, max rows and rebind to false
      DataPager1.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);

      //rebind List View
      string sql = @"SELECT *, 
case Modify_Action 
when 'Login' then 'sign in alternate' when 'Logout' then 'sign out alternate' 
when 'Approval' then 'stamp' when 'Insert' then 'plus' 
when 'Update' then 'edit' when 'Delete' then 'trash alternate' 
when 'View' then 'book reader' end as action, 
case when DATEDIFF(DAY, Operate_Time, GETDATE()) < 1 then format(Operate_Time, 'tt hh:mm') 
when DATEDIFF(DAY, Operate_Time, GETDATE()) = 1 then '昨天 ' + format(Operate_Time, 'tt hh:mm') 
when year(GETDATE()) - year(Operate_Time) < 1 then format(Operate_Time, 'M月d日') 
when year(GETDATE()) - year(Operate_Time) >= 1 then format(Operate_Time, 'yyyy年M月d日') end as o_time 
FROM [UserLog] WHERE [Operate_User_Id] = @Operate_User_Id AND [Modify_Action] <> @Modify_Action";
      string sql_end = " ORDER BY [Operate_Time] DESC";
      if (!CheckBox1.Checked)
      {
        sql = sql + @" AND [Modify_Action] <> 'Login' AND [Modify_Action] <> 'Logout'";
      }
      SqlDataSource1.SelectCommand = sql + sql_end;
      SqlDataSource1.DataBind();
    }
  }
}