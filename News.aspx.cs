using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace piNews
{
  public partial class News : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      if (RouteData.Values["Id"] != null)
      {
        SqlDataSource2.SelectParameters["Id"].DefaultValue = RouteData.Values["Id"].ToString();
        SqlDataSource1.SelectParameters["menu_id"].DefaultValue = RouteData.Values["Id"].ToString();
        Repeater2.DataBind();
      }

      if (RouteData.Values["Val"] != null)
      {
        string search = HttpUtility.HtmlEncode(HttpUtility.UrlDecode(RouteData.Values["Val"].ToString()));
        ListView1.DataSourceID = SqlDataSource5.ID;
        SqlDataSource5.SelectParameters["Search"].DefaultValue = search;
        ListView1.DataBind();
      }

      if (RouteData.Values["group"] != null && RouteData.Values["cat"] != null)
      {
        string g = RouteData.Values["group"].ToString();
        string c = RouteData.Values["cat"].ToString();
        if (RouteData.Values["dur"] != null)
        {
          string d = RouteData.Values["dur"].ToString();
          if (RouteData.Values["type"] != null)
          {
            string t = RouteData.Values["type"].ToString();
            uc.FrontEndDebug(this, "data", string.Format("console.log('{0}', '{1}', '{2}', '{3}');", g, c, d, t));
            if (g.Equals("all"))
            {
              if (t.Equals("click"))
              {
                //                SqlDataSource6.SelectCommand = string.Format(@"select distinct Id, Title, Front_Img_Id, Author, Member_Img_Id, time, v_cnt, description from 
                //(select ROW_NUMBER() over (partition by cat.item order by count (ul.Modify_Action) desc) as sn, cat.item, a.Id, Title, Front_Img_Id, Author, m.Member_Img_Id, format(a.DateTime, 'yyyy/MM/dd tthh:mm') AS time, count (ul.Modify_Action) as v_cnt, a.description
                // from Article a cross apply dbo.SplitString(a.Recommand_Category, ',') cat left join Member m on a.User_Id = m.Id
                //left join UserLog ul on a.Id = ul.Modify_Id where ul.Modify_Action = 'View'
                //{0}
                //group by Title, a.Id, Front_Img_Id, Author, Member_Img_Id, format(a.DateTime, 'yyyy/MM/dd tthh:mm'), cat.Item, a.description) k
                //order by v_cnt desc",
                //      d.Equals("week") ? "and convert(date, ul.Operate_Time) between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())" :
                //      d.Equals("month") ? "and convert(date, ul.Operate_Time) between convert(date, dateadd(MONTH,-1,GETDATE())) and convert(date, GETDATE())" :
                //      d.Equals("year") ? "and convert(date, ul.Operate_Time) between convert(date, dateadd(YEAR,-1,GETDATE())) and convert(date, GETDATE())" : "");
                SqlDataSource6.SelectCommand = string.Format(@"select distinct Id, Title, Front_Img_Id, Author, Member_Img_Id, time, v_cnt, odr, Description from (
select a.Id, Title, Front_Img_Id, case m.isAdmin when 1 then a.Author else '拍新聞聯合採訪中心' end as Author, m.Member_Img_Id, arc.Rec_cat_id
, format(a.DateTime, 'yyyy/MM/dd tthh:mm') AS time, count (distinct ul.Id) as v_cnt,case when {1} then 0 else 1 end odr, Description
 from Article a left join Member m on a.User_Id = m.Id left join Article_Rec_Cat arc on a.Id = arc.Article_id
 left join UserLog ul on a.Id = ul.Modify_Id where ul.Modify_Action = 'View'
and convert(date, ul.Operate_Time) {0} AND (a.Status = 1)
group by Title, a.Id, Front_Img_Id, Author, isAdmin, Member_Img_Id, format(a.DateTime, 'yyyy/MM/dd tthh:mm'), a.DateTime, arc.Rec_cat_id, Description
) k order by odr, v_cnt desc",
      d.Equals("week") ? "between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())" :
      d.Equals("month") ? "between convert(date, dateadd(MONTH,-1,GETDATE())) and convert(date, GETDATE())" :
      d.Equals("year") ? "between convert(date, dateadd(YEAR,-1,GETDATE())) and convert(date, GETDATE())" : "",
      d.Equals("week") ? "a.DateTime between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())" :
      d.Equals("month") ? "format(a.DateTime, 'MM') = format(GETDATE(), 'MM')" :
      d.Equals("year") ? "format(a.DateTime, 'yyyy') = format(GETDATE(), 'yyyy')" : "");
              }
              else if (t.Equals("like"))
              {
                SqlDataSource6.SelectCommand = string.Format(@"select distinct Id, Title , Front_Img_Id, Author, Member_Img_Id, time, Description, l_cnt, odr from (
select arc.Rec_cat_id, a.Id, Title, Front_Img_Id, case m.isAdmin when 1 then a.Author else '拍新聞聯合採訪中心' end as Author, m.Member_Img_Id
, format(a.DateTime, 'yyyy/MM/dd tthh:mm') AS time, Description, count (distinct ul.Operate_User_IP) as l_cnt, case when {1} then 0 else 1 end as odr
 from Article a left join Member m on a.User_Id = m.Id left join Article_Rec_Cat arc on a.Id = arc.Article_id
left join UserLog ul on a.Id = ul.Modify_Id and ul.Modify_Action = 'like' and convert(date, ul.Operate_Time) {0} AND (a.Status = 1)
group by a.Id, Title, Front_Img_Id, Author, isAdmin, Member_Img_Id, format(a.DateTime, 'yyyy/MM/dd tthh:mm'), Description, a.DateTime, arc.Rec_cat_id
) a order by odr, l_cnt desc",
      d.Equals("week") ? "between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())" :
      d.Equals("month") ? "between convert(date, dateadd(MONTH,-1,GETDATE())) and convert(date, GETDATE())" :
      d.Equals("year") ? "between convert(date, dateadd(YEAR,-1,GETDATE())) and convert(date, GETDATE())" : "",
      d.Equals("week") ? "a.DateTime between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())" :
      d.Equals("month") ? "format(a.DateTime, 'MM') = format(GETDATE(), 'MM')" :
      d.Equals("year") ? "format(a.DateTime, 'yyyy') = format(GETDATE(), 'yyyy')" : "");
              }
              else if (t.Equals("like_click"))
              {
                SqlDataSource6.SelectCommand = string.Format(@"select distinct Id, Title, Front_Img_Id, Author, Member_Img_Id, time, v_cnt, l_cnt, odr, Description from (
select a.Id, Title, Front_Img_Id, case m.isAdmin when 1 then a.Author else '拍新聞聯合採訪中心' end as Author, Member_Img_Id, Description, arc.Rec_cat_id
, sum(case when ul.modify_action = 'View' then 1 else 0 end) v_cnt, sum(case when ul.modify_action = 'like' then 1 else 0 end) l_cnt
, case when {1} then 0 else 1 end odr, format(a.DateTime, 'yyyy/MM/dd tthh:mm') AS time from Article a 
left join Article_Rec_Cat arc on arc.Article_id = a.Id left join UserLog ul on ul.Modify_Id = a.Id  left join Member m on m.Id = a.User_Id
where (ul.Modify_Action = 'View' or ul.Modify_Action = 'like') and convert(date, ul.Operate_Time) {0} 
AND a.Status = 1 group by a.Id, Title, Front_Img_Id, Author, Member_Img_Id, Description, arc.Rec_cat_id , a.DateTime, m.IsAdmin
) k order by odr, l_cnt desc, v_cnt desc",
      d.Equals("week") ? "between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())" :
      d.Equals("month") ? "between convert(date, dateadd(MONTH,-1,GETDATE())) and convert(date, GETDATE())" :
      d.Equals("year") ? "between convert(date, dateadd(YEAR,-1,GETDATE())) and convert(date, GETDATE())" : "",
      d.Equals("week") ? "a.DateTime between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())" :
      d.Equals("month") ? "format(a.DateTime, 'MM') = format(GETDATE(), 'MM')" :
      d.Equals("year") ? "format(a.DateTime, 'yyyy') = format(GETDATE(), 'yyyy')" : "");
              }
              else if (t.Equals("like_click_total"))
              {
                SqlDataSource6.SelectCommand = string.Format(@"select distinct Id, Title, Front_Img_Id, Author, Member_Img_Id, time, vl_cnt, odr, Description from (
select a.Id, Title, Front_Img_Id, case m.isAdmin when 1 then a.Author else '拍新聞聯合採訪中心' end as Author, Member_Img_Id, Description, arc.Rec_cat_id
, sum(case when ul.modify_action = 'View' then 1 else 0 end) + sum(case when ul.modify_action = 'like' then 1 else 0 end) *10 vl_cnt
, case when {1} then 0 else 1 end odr, format(a.DateTime, 'yyyy/MM/dd tthh:mm') AS time from Article a 
left join Article_Rec_Cat arc on arc.Article_id = a.Id left join UserLog ul on ul.Modify_Id = a.Id  left join Member m on m.Id = a.User_Id
where (ul.Modify_Action = 'View' or ul.Modify_Action = 'like') and convert(date, ul.Operate_Time) {0} 
and a.Status = 1 group by a.Id, Title, Front_Img_Id, Author, Member_Img_Id, Description, arc.Rec_cat_id , a.DateTime, m.IsAdmin
) k order by odr, vl_cnt desc",
      d.Equals("week") ? "between convert(date, dateadd(DAY,-7, GETDATE())) and convert(date, GETDATE())" :
      d.Equals("month") ? "between convert(date, dateadd(MONTH,-1,GETDATE())) and convert(date, GETDATE())" :
      d.Equals("year") ? "between convert(date, dateadd(YEAR,-1,GETDATE())) and convert(date, GETDATE())" : "",
      d.Equals("week") ? "a.DateTime between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())" :
      d.Equals("month") ? "format(a.DateTime, 'MM') = format(GETDATE(), 'MM')" :
      d.Equals("year") ? "format(a.DateTime, 'yyyy') = format(GETDATE(), 'yyyy')" : "");
              }
            }
            else
            {
              if (t.Equals("click"))
              {
                SqlDataSource6.SelectCommand = string.Format(@"select distinct top 4 Id, Title, Front_Img_Id, Author, Member_Img_Id, t, v_cnt, odr from (
select a.Id, Title, Front_Img_Id, case m.isAdmin when 1 then a.Author else '拍新聞聯合採訪中心' end as Author, m.Member_Img_Id, arc.Rec_cat_id
, format(a.DateTime, 'yyyy/MM/dd tthh:mm') AS t, count (distinct ul.Id) as v_cnt,case when {1} then 0 else 1 end odr
 from Article a left join Member m on a.User_Id = m.Id left join Article_Rec_Cat arc on a.Id = arc.Article_id
 left join UserLog ul on a.Id = ul.Modify_Id where ul.Modify_Action = 'View' and arc.Rec_cat_id = @Recommand_Category
and convert(date, ul.Operate_Time) {0} AND (a.Status = 1)
group by Title, a.Id, Front_Img_Id, Author, isAdmin, Member_Img_Id, format(a.DateTime, 'yyyy/MM/dd tthh:mm'), a.DateTime, arc.Rec_cat_id
) k order by odr, v_cnt desc",
        d.Equals("week") ? "and convert(date, ul.Operate_Time) between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())" :
        d.Equals("month") ? "and convert(date, ul.Operate_Time) between convert(date, dateadd(MONTH,-1,GETDATE())) and convert(date, GETDATE())" :
        d.Equals("year") ? "and convert(date, ul.Operate_Time) between convert(date, dateadd(YEAR,-1,GETDATE())) and convert(date, GETDATE())" : "",
        d.Equals("week") ? "a.DateTime between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())" :
        d.Equals("month") ? "format(a.DateTime, 'MM') = format(GETDATE(), 'MM')" :
        d.Equals("year") ? "format(a.DateTime, 'yyyy') = format(GETDATE(), 'yyyy')" : "");
              }
              else if (t.Equals("like"))
              {
                SqlDataSource6.SelectCommand = string.Format(@"select distinct top 4 Id, Title , Front_Img_Id, Author, Member_Img_Id, t, Description, l_cnt, odr from (
select arc.Rec_cat_id, a.Id, Title, Front_Img_Id, case m.isAdmin when 1 then a.Author else '拍新聞聯合採訪中心' end as Author, m.Member_Img_Id
, format(a.DateTime, 'yyyy/MM/dd tthh:mm') AS t, Description, count (distinct ul.Operate_User_IP) as l_cnt, case when {1} then 0 else 1 end as odr
 from Article a left join Member m on a.User_Id = m.Id left join Article_Rec_Cat arc on a.Id = arc.Article_id left join UserLog ul on a.Id = ul.Modify_Id 
and ul.Modify_Action = 'like' and convert(date, ul.Operate_Time) {0} AND (a.Status = 1) and arc.Rec_cat_id = @Recommand_Category
group by a.Id, Title, Front_Img_Id, Author, isAdmin, Member_Img_Id, format(a.DateTime, 'yyyy/MM/dd tthh:mm'), Description, a.DateTime, arc.Rec_cat_id
) a order by odr, l_cnt desc",
      d.Equals("week") ? "between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())" :
      d.Equals("month") ? "between convert(date, dateadd(MONTH,-1,GETDATE())) and convert(date, GETDATE())" :
      d.Equals("year") ? "between convert(date, dateadd(YEAR,-1,GETDATE())) and convert(date, GETDATE())" : "",
      d.Equals("week") ? "a.DateTime between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())" :
      d.Equals("month") ? "format(a.DateTime, 'MM') = format(GETDATE(), 'MM')" :
      d.Equals("year") ? "format(a.DateTime, 'yyyy') = format(GETDATE(), 'yyyy')" : "");
              }
              else if (t.Equals("like_click"))
              {
                SqlDataSource6.SelectCommand = string.Format(@"select distinct top 4 Id, Title, Front_Img_Id, Author, Member_Img_Id, t, v_cnt, l_cnt, odr from (
select a.Id, Title, Front_Img_Id, case m.isAdmin when 1 then a.Author else '拍新聞聯合採訪中心' end as Author, Member_Img_Id, Description, arc.Rec_cat_id
, sum(case when ul.modify_action = 'View' then 1 else 0 end) v_cnt, sum(case when ul.modify_action = 'like' then 1 else 0 end) l_cnt
, case when {1} then 0 else 1 end odr, format(a.DateTime, 'yyyy/MM/dd tthh:mm') AS t from Article a 
left join Article_Rec_Cat arc on arc.Article_id = a.Id left join UserLog ul on ul.Modify_Id = a.Id  left join Member m on m.Id = a.User_Id
where (ul.Modify_Action = 'View' or ul.Modify_Action = 'like') and convert(date, ul.Operate_Time) {0} and arc.Rec_cat_id = @Recommand_Category 
AND a.Status = 1 group by a.Id, Title, Front_Img_Id, Author, Member_Img_Id, Description, arc.Rec_cat_id , a.DateTime, m.IsAdmin
) k order by odr, l_cnt desc, v_cnt desc",
        d.Equals("week") ? "and convert(date, ul.Operate_Time) between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())" :
        d.Equals("month") ? "and convert(date, ul.Operate_Time) between convert(date, dateadd(MONTH,-1,GETDATE())) and convert(date, GETDATE())" :
        d.Equals("year") ? "and convert(date, ul.Operate_Time) between convert(date, dateadd(YEAR,-1,GETDATE())) and convert(date, GETDATE())" : "",
        d.Equals("week") ? "a.DateTime between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())" :
        d.Equals("month") ? "format(a.DateTime, 'MM') = format(GETDATE(), 'MM')" :
        d.Equals("year") ? "format(a.DateTime, 'yyyy') = format(GETDATE(), 'yyyy')" : "");
              }
              else if (t.Equals("like_click_total"))
              {
                SqlDataSource6.SelectCommand = string.Format(@"select distinct top 4 Id, Title, Front_Img_Id, Author, Member_Img_Id, t, vl_cnt, odr from (
select a.Id, Title, Front_Img_Id, case m.isAdmin when 1 then a.Author else '拍新聞聯合採訪中心' end as Author, Member_Img_Id, Description, arc.Rec_cat_id
, sum(case when ul.modify_action = 'View' then 1 else 0 end) + sum(case when ul.modify_action = 'like' then 1 else 0 end) * 10 vl_cnt
, case when {1} then 0 else 1 end odr, format(a.DateTime, 'yyyy/MM/dd tthh:mm') AS t from Article a 
left join Article_Rec_Cat arc on arc.Article_id = a.Id left join UserLog ul on ul.Modify_Id = a.Id  left join Member m on m.Id = a.User_Id
where (ul.Modify_Action = 'View' or ul.Modify_Action = 'like') and convert(date, ul.Operate_Time) {0} and arc.Rec_cat_id = @Recommand_Category 
and a.Status = 1 group by a.Id, Title, Front_Img_Id, Author, Member_Img_Id, Description, arc.Rec_cat_id , a.DateTime, m.IsAdmin
) k order by odr, vl_cnt desc",
      d.Equals("week") ? "and convert(date, ul.Operate_Time) between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())" :
      d.Equals("month") ? "and convert(date, ul.Operate_Time) between convert(date, dateadd(MONTH,-1,GETDATE())) and convert(date, GETDATE())" :
      d.Equals("year") ? "and convert(date, ul.Operate_Time) between convert(date, dateadd(YEAR,-1,GETDATE())) and convert(date, GETDATE())" : "",
      d.Equals("week") ? "a.DateTime between convert(date, dateadd(DAY,-7,GETDATE())) and convert(date, GETDATE())" :
      d.Equals("month") ? "format(a.DateTime, 'MM') = format(GETDATE(), 'MM')" :
      d.Equals("year") ? "format(a.DateTime, 'yyyy') = format(GETDATE(), 'yyyy')" : "");
              }
            }
            ListView1.DataSourceID = SqlDataSource6.ID;
            ListView1.DataBind();
          }
          uc.FrontEndDebug(this, "data", string.Format("console.log('{0}', '{1}', '{2}');", g, c, d));
        }
        else
        {
          if (g.Equals("all"))
          {
            if (c.Equals("week"))
            {
              SqlDataSource6.SelectCommand = @"SELECT a.Id, a.Title, format(a.DateTime, 'yyyy/MM/dd tthh:mm') AS time, case m.isAdmin when 1 then a.Author else '拍新聞聯合採訪中心' end as Author, a.Author_Email, a.Front_Img_Id, m.Member_Img_Id, a.description 
FROM Article AS a LEFT OUTER JOIN Member AS m ON m.UserId = a.Author_Email WHERE 
convert(date, a.DateTime) between convert(date, dateadd(Day,-7,GETDATE())) and convert(date, GETDATE()) AND (a.Status = 1) ORDER BY DateTime DESC";
              SqlDataSource7.SelectCommand = "Select '本周焦點' as Name";
              SqlDataSource7.DataBind();
            }
            else
            {
              SqlDataSource6.SelectCommand = @"SELECT a.Id, a.Title, format(a.DateTime, 'yyyy/MM/dd tthh:mm') AS time, case m.isAdmin when 1 then a.Author else '拍新聞聯合採訪中心' end as Author, a.Author_Email, a.Front_Img_Id, m.Member_Img_Id, a.description 
FROM Article AS a LEFT OUTER JOIN Member AS m ON m.UserId = a.Author_Email WHERE (a.Status = 1) ORDER BY DateTime DESC";
              SqlDataSource7.SelectParameters["Id"].DefaultValue = c;
              SqlDataSource7.DataBind();
            }
          }
          ListView1.DataSourceID = SqlDataSource6.ID;
          ListView1.DataBind();
          uc.FrontEndDebug(this, "data", string.Format("console.log('{0}', '{1}', 'time');", g, c));
        }

        int iscat;

        if ((g.Equals("cat") && int.TryParse(c, out iscat)) || g.Equals("all"))
        {
          Repeater2.DataSourceID = SqlDataSource7.ID;
          Repeater2.DataBind();
        }
      }

      //uc.FrontEndDebug(this, "sql", string.Format("console.log(`sql:{0}`, `sql:{1}`);", SqlDataSource6.SelectCommand, SqlDataSource7.SelectCommand));
      //uc.FrontEndDebug(this, "route", string.Format("console.log('{0}');", RouteData.Values["Id"]));
    }

    protected void Repeater2_ItemDataBound(object sender, System.Web.UI.WebControls.RepeaterItemEventArgs e)
    {
      string a = DataBinder.Eval(e.Item.DataItem, "Name").ToString();
      //this.Master.Page.Title = a + " | 拍新聞";

      ((HiddenField)Master.FindControl("ContentPageTitle_HF")).Value = a + " | ";
    }
  }
}