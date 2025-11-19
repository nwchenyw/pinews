using System;
using System.Data;
using System.Web.UI.WebControls;

namespace piNews
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //this.Master.Page.Title = "首頁 | "+ this.Master.Page.Title;
            ((HiddenField)Master.FindControl("ContentPageTitle_HF")).Value = "首頁 | ";
        }

        protected void Repeater1_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            // 使用原始的邏輯，但加入一些優化
            SqlDataSource sql = (SqlDataSource)e.Item.FindControl("SqlDataSource2");
            Repeater childr = (Repeater)e.Item.FindControl("ChildRepeater");
            Label lblMsg = (Label)e.Item.FindControl("lblMsg");

            if (sql == null || childr == null || lblMsg == null)
            {
                return; // 安全檢查
            }

            if (((DataRowView)e.Item.DataItem)["Art_Grouping"].Equals("all"))
            {
                if (((DataRowView)e.Item.DataItem)["Art_Odr_Type"].Equals("click"))
                {
                    // 檢查 Art_Odr_Duration 是否為 NULL
                    object duration = ((DataRowView)e.Item.DataItem)["Art_Odr_Duration"];
                    string dateFilter = "";
                    string orderCondition = "";

                    if (duration != null && !duration.Equals(DBNull.Value))
                    {
                        string durationStr = duration.ToString();
                        if (durationStr.Equals("week"))
                        {
                            dateFilter = "between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())";
                            orderCondition = "a.DateTime between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())";
                        }
                        else if (durationStr.Equals("month"))
                        {
                            dateFilter = "between convert(date, dateadd(MONTH,-1,GETDATE())) and convert(date, GETDATE())";
                            orderCondition = "format(a.DateTime, 'MM') = format(GETDATE(), 'MM')";
                        }
                        else if (durationStr.Equals("year"))
                        {
                            dateFilter = "between convert(date, dateadd(YEAR,-1,GETDATE())) and convert(date, GETDATE())";
                            orderCondition = "format(a.DateTime, 'yyyy') = format(GETDATE(), 'yyyy')";
                        }
                    }
                    else
                    {
                        // 如果沒有期間限制，則不過濾日期
                        dateFilter = ">= '1900-01-01'";
                        orderCondition = "1=0"; // 預設為 false
                    }

                    sql.SelectCommand = string.Format(@"select distinct top 4 Id, Title, Front_Img_Id, Author, Member_Img_Id, t, v_cnt, odr from (
select a.Id, Title, Front_Img_Id, case m.isAdmin when 1 then a.Author else '拍新聞聯合採訪中心' end as Author, m.Member_Img_Id, arc.Rec_cat_id
, format(a.DateTime, 'yyyy/MM/dd tthh:mm') AS t, count (distinct ul.Id) as v_cnt,case when {1} then 0 else 1 end odr
 from Article a left join Member m on a.User_Id = m.Id left join Article_Rec_Cat arc on a.Id = arc.Article_id
 left join UserLog ul on a.Id = ul.Modify_Id where ul.Modify_Action = 'View'
and convert(date, ul.Operate_Time) {0} AND (a.Status = 1)
group by Title, a.Id, Front_Img_Id, Author, isAdmin, Member_Img_Id, format(a.DateTime, 'yyyy/MM/dd tthh:mm'), a.DateTime, arc.Rec_cat_id
) k order by odr, v_cnt desc", dateFilter, orderCondition);
                }
                else if (((DataRowView)e.Item.DataItem)["Art_Odr_Type"].Equals("like"))
                {
                    // 檢查 Art_Odr_Duration 是否為 NULL
                    object duration = ((DataRowView)e.Item.DataItem)["Art_Odr_Duration"];
                    string dateFilter = "";
                    string orderCondition = "";

                    if (duration != null && !duration.Equals(DBNull.Value))
                    {
                        string durationStr = duration.ToString();
                        if (durationStr.Equals("week"))
                        {
                            dateFilter = "between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())";
                            orderCondition = "a.DateTime between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())";
                        }
                        else if (durationStr.Equals("month"))
                        {
                            dateFilter = "between convert(date, dateadd(MONTH,-1,GETDATE())) and convert(date, GETDATE())";
                            orderCondition = "format(a.DateTime, 'MM') = format(GETDATE(), 'MM')";
                        }
                        else if (durationStr.Equals("year"))
                        {
                            dateFilter = "between convert(date, dateadd(YEAR,-1,GETDATE())) and convert(date, GETDATE())";
                            orderCondition = "format(a.DateTime, 'yyyy') = format(GETDATE(), 'yyyy')";
                        }
                    }
                    else
                    {
                        dateFilter = ">= '1900-01-01'";
                        orderCondition = "1=0";
                    }

                    sql.SelectCommand = string.Format(@"select distinct top 4 Id, Title , Front_Img_Id, Author, Member_Img_Id, t, Description, l_cnt, odr from (
select arc.Rec_cat_id, a.Id, Title, Front_Img_Id, case m.isAdmin when 1 then a.Author else '拍新聞聯合採訪中心' end as Author, m.Member_Img_Id
, format(a.DateTime, 'yyyy/MM/dd tthh:mm') AS t, Description, count (distinct ul.Operate_User_IP) as l_cnt, case when {1} then 0 else 1 end as odr
 from Article a left join Member m on a.User_Id = m.Id left join Article_Rec_Cat arc on a.Id = arc.Article_id
left join UserLog ul on a.Id = ul.Modify_Id and ul.Modify_Action = 'like' and convert(date, ul.Operate_Time) {0} AND (a.Status = 1)
group by a.Id, Title, Front_Img_Id, Author, isAdmin, Member_Img_Id, format(a.DateTime, 'yyyy/MM/dd tthh:mm'), Description, a.DateTime, arc.Rec_cat_id
) a order by odr, l_cnt desc", dateFilter, orderCondition);
                }
                else if (((DataRowView)e.Item.DataItem)["Art_Odr_Type"].Equals("like_click"))
                {
                    sql.SelectCommand = string.Format(@"select distinct top 4 Id, Title, Front_Img_Id, Author, Member_Img_Id, t, v_cnt, l_cnt, odr from (
select a.Id, Title, Front_Img_Id, case m.isAdmin when 1 then a.Author else '拍新聞聯合採訪中心' end as Author, Member_Img_Id, Description, arc.Rec_cat_id
, sum(case when ul.modify_action = 'View' then 1 else 0 end) v_cnt, sum(case when ul.modify_action = 'like' then 1 else 0 end) l_cnt
, case when {1} then 0 else 1 end odr, format(a.DateTime, 'yyyy/MM/dd tthh:mm') AS t from Article a 
left join Article_Rec_Cat arc on arc.Article_id = a.Id left join UserLog ul on ul.Modify_Id = a.Id  left join Member m on m.Id = a.User_Id
where (ul.Modify_Action = 'View' or ul.Modify_Action = 'like') and convert(date, ul.Operate_Time) {0} 
AND a.Status = 1 group by a.Id, Title, Front_Img_Id, Author, Member_Img_Id, Description, arc.Rec_cat_id , a.DateTime, m.IsAdmin
) k order by odr, l_cnt desc, v_cnt desc",
((DataRowView)e.Item.DataItem)["Art_Odr_Duration"].Equals("week") ? "between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())" :
((DataRowView)e.Item.DataItem)["Art_Odr_Duration"].Equals("month") ? "between convert(date, dateadd(MONTH,-1,GETDATE())) and convert(date, GETDATE())" :
((DataRowView)e.Item.DataItem)["Art_Odr_Duration"].Equals("year") ? "between convert(date, dateadd(YEAR,-1,GETDATE())) and convert(date, GETDATE())" : "",
((DataRowView)e.Item.DataItem)["Art_Odr_Duration"].Equals("week") ? "a.DateTime between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())" :
((DataRowView)e.Item.DataItem)["Art_Odr_Duration"].Equals("month") ? "format(a.DateTime, 'MM') = format(GETDATE(), 'MM')" :
((DataRowView)e.Item.DataItem)["Art_Odr_Duration"].Equals("year") ? "format(a.DateTime, 'yyyy') = format(GETDATE(), 'yyyy')" : "");
                }
                else if (((DataRowView)e.Item.DataItem)["Art_Odr_Type"].Equals("like_click_total"))
                {
                    sql.SelectCommand = string.Format(@"select distinct top 4 Id, Title, Front_Img_Id, Author, Member_Img_Id, t, vl_cnt, odr from (
select a.Id, Title, Front_Img_Id, case m.isAdmin when 1 then a.Author else '拍新聞聯合採訪中心' end as Author, Member_Img_Id, Description, arc.Rec_cat_id
, sum(case when ul.modify_action = 'View' then 1 else 0 end) + sum(case when ul.modify_action = 'like' then 1 else 0 end) *10 vl_cnt
, case when {1} then 0 else 1 end odr, format(a.DateTime, 'yyyy/MM/dd tthh:mm') AS t from Article a 
left join Article_Rec_Cat arc on arc.Article_id = a.Id left join UserLog ul on ul.Modify_Id = a.Id  left join Member m on m.Id = a.User_Id
where (ul.Modify_Action = 'View' or ul.Modify_Action = 'like') and convert(date, ul.Operate_Time) {0} 
and a.Status = 1 group by a.Id, Title, Front_Img_Id, Author, Member_Img_Id, Description, arc.Rec_cat_id , a.DateTime, m.IsAdmin
) k order by odr, vl_cnt desc",
((DataRowView)e.Item.DataItem)["Art_Odr_Duration"].Equals("week") ? "between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())" :
((DataRowView)e.Item.DataItem)["Art_Odr_Duration"].Equals("month") ? "between convert(date, dateadd(MONTH,-1,GETDATE())) and convert(date, GETDATE())" :
((DataRowView)e.Item.DataItem)["Art_Odr_Duration"].Equals("year") ? "between convert(date, dateadd(YEAR,-1,GETDATE())) and convert(date, GETDATE())" : "",
((DataRowView)e.Item.DataItem)["Art_Odr_Duration"].Equals("week") ? "a.DateTime between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())" :
((DataRowView)e.Item.DataItem)["Art_Odr_Duration"].Equals("month") ? "format(a.DateTime, 'MM') = format(GETDATE(), 'MM')" :
((DataRowView)e.Item.DataItem)["Art_Odr_Duration"].Equals("year") ? "format(a.DateTime, 'yyyy') = format(GETDATE(), 'yyyy')" : "");
                }
            }
            else if (((DataRowView)e.Item.DataItem)["Art_Grouping"].Equals("all_article"))
            {
                sql.SelectCommand = @"SELECT top 4 a.Id, a.Title, format(a.DateTime, 'yyyy/MM/dd tthh:mm') AS t, case m.isAdmin when 1 then a.Author else '拍新聞聯合採訪中心' end as Author, a.Author_Email, a.Front_Img_Id, m.Member_Img_Id, a.description 
FROM Article AS a LEFT OUTER JOIN Member AS m ON m.UserId = a.Author_Email WHERE (a.Status = 1) ORDER BY DateTime DESC";
            }
            else
            {
                // 其他分類的處理邏輯（簡化版）
                sql.SelectCommand = @"select top 4 a.Id, a.Title, format(a.DateTime, 'yyyy/MM/dd tthh:mm') AS t, case m.isAdmin when 1 then a.Author else '拍新聞聯合採訪中心' end as Author, a.Author_Email, a.Front_Img_Id, m.Member_Img_Id 
From Article As a Left Join Member As m On m.UserId = a.Author_Email left join Article_Rec_Cat arc on arc.Article_id = a.Id Where arc.Rec_cat_id = @Recommand_Category And a.Status = 1 ORDER BY a.DateTime DESC";
            }

            try
            {
                sql.SelectParameters["Recommand_Category"].DefaultValue = ((DataRowView)e.Item.DataItem)["Id"].ToString();
                childr.DataBind();

                if (childr.Items.Count == 0)
                    lblMsg.Visible = true;
                else
                    lblMsg.Visible = false;
            }
            catch (Exception ex)
            {
                // 錯誤處理
                lblMsg.Text = "載入文章時發生錯誤";
                lblMsg.Visible = true;
                System.Diagnostics.Debug.WriteLine("Error in Repeater1_ItemDataBound: " + ex.Message);
            }
        }
    }
}