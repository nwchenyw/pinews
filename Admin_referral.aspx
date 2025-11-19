<%@ Page Title="" Language="C#" MasterPageFile="AdminPage.Master" AutoEventWireup="true" CodeFile="Admin_referral.aspx.cs" Inherits="piNews.Admin_referral" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  
  <style>
    @media only screen and (max-width: 767.98px){
        .ui.column.grid>[class*="four wide"].column, .ui.grid>.column.row>[class*="four wide"].column, .ui.grid>.row>[class*="four wide"].column, .ui.grid>[class*="four wide"].column {
            width: 100%!important;
            margin-bottom: 10px !important;
        }
        .ui.column.grid>[class*="twelve wide"].column, .ui.grid>.column.row>[class*="twelve wide"].column, .ui.grid>.row>[class*="twelve wide"].column, .ui.grid>[class*="twelve wide"].column {
            width: 100%!important;
        }
    }
    .ui.scrolling.segment #main {
    height: calc(100vh - 2rem) !important;
    }
  </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <div class="ui inverted segment">
    <div class="ui inverted breadcrumb">
      <a class="section">Home</a>
      <div class="divider">/ </div>
      <div class="active section">引薦管理</div>
    </div>
  </div>
  <div class="ui segment">
    <div class="ui stackable grid">
      <div class="row">
        <div class="ui three wide column">
          <div id="referral_list" class="ui fluid vertical menu">
            <a class="teal item" id="all_payment" runat="server" visible="false" data-tab="all_payment">付費總覽</a>
            <a class="teal item" id="referral_all" runat="server" visible="false" data-tab="referral_all">引薦總覽</a>
            <a class="active teal item" id="referral" runat="server" data-tab="referral">引薦獎金
              <%--<span class="ui mini teal left pointing label">1</span>--%>
            </a>
            <a class="teal item" id="referee" runat="server" data-tab="Referee">會員管理
              <%--<span class="ui mini label">51</span>--%>
            </a>
            <a class="teal item" id="dividends" runat="server" visible="false" data-tab="Dividends">差%獎金
              <%--<span class="ui mini label">1</span>--%>
            </a>
            <%--<div class="item">
              <div class="ui transparent icon input">
                <input type="text" placeholder="Search mail...">
                <i class="search icon"></i>
              </div>
            </div>--%>
          </div>
        </div>
        <div class="ui thirteen wide column">

          <%--<h3>引薦管理</h3>
          <div class="ui divider"></div>--%>
          <asp:HiddenField ID="rd_HF" runat="server" />
          <div class="ui action input">
            <div class="ui calendar" id="date_calendar">
              <div class="ui input left icon">
                <i class="calendar icon"></i>
                <asp:TextBox ID="referral_date_TB" runat="server" placeholder="Date" OnTextChanged="referral_date_TB_TextChanged"></asp:TextBox>
                <%--<input type="text">--%>
              </div>
            </div>
            <asp:LinkButton ID="referral_date_LB" runat="server" CssClass="ui button" OnClick="referral_date_LB_Click">搜尋</asp:LinkButton>
          </div>
          <div class="ui tab" data-tab="referral">
            <h2>引薦獎金</h2>
            <div class="ui divider"></div>

            <asp:GridView ID="GridView1" runat="server" CssClass="ui celled unstackable definition table" DataKeyNames="bonus" GridLines="None" ShowFooter="true" CellSpacing="5" DataSourceID="SqlDataSource1" AutoGenerateColumns="False" OnPreRender="GridView1_PreRender" OnDataBound="GridView1_DataBound">
              <Columns>
                <asp:BoundField DataField="sn" FooterText="總計" SortExpression="sn" HeaderStyle-CssClass="collapsing" FooterStyle-CssClass="collapsing" ItemStyle-CssClass="center aligned collapsing" />
                <asp:BoundField DataField="Class_Name" HeaderText="職稱" SortExpression="Class_Name"></asp:BoundField>
                <asp:BoundField DataField="Name" HeaderText="姓名" SortExpression="Name"></asp:BoundField>
                <asp:BoundField DataField="Pay_Time" HeaderText="加入時間" HeaderStyle-CssClass="collapsing" DataFormatString="{0:yyyy/MM/dd tthh:mm}" SortExpression="Referral_Time"></asp:BoundField>
                <asp:BoundField DataField="bonus" HeaderText="引薦獎金" ItemStyle-CssClass="right aligned" FooterStyle-CssClass="right aligned" ReadOnly="True" SortExpression="bonus"></asp:BoundField>
                <asp:TemplateField HeaderText="執行業務所得10%<br />(20000以上)" HeaderStyle-CssClass="collapsing" FooterStyle-CssClass="right aligned"></asp:TemplateField>
                <asp:TemplateField HeaderText="核發獎金" FooterStyle-CssClass="right aligned"></asp:TemplateField>
              </Columns>
            </asp:GridView>
            <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="select row_number() over (order by User_Id) as sn, Class_Name, Name, Pay_Time, bonus from
(select distinct r.User_Id, ac.Class_Name, m.Name, r.Referral_Time as Pay_Time, caf.fee*cb.Bonus_Rate/100 as bonus 
from Referral r 
left join Member m on r.User_Id = m.Id
left join Authority_Class ac on ac.Id = r.User_Class
left join Authority_Class ac1 on ac.Id = r.Introducer_Class
left join class_Bonus cb on cb.class_id = r.Introducer_Class 
left join class_annual_fee caf on caf.class_id = r.User_Class
where r.Introducer_Id = @id and Format(r.Referral_Time, 'yyyy/MM') = Format(@dt, 'yyyy/MM')) l">
              <SelectParameters>
                <asp:SessionParameter SessionField="User_Id" Name="id"></asp:SessionParameter>
                <asp:ControlParameter ControlID="rd_HF" PropertyName="Value" DbType="DateTime" Name="dt"></asp:ControlParameter>
              </SelectParameters>
            </asp:SqlDataSource>
            <%--<table class="ui celled unstackable definition table">
              <thead class="full-width">
                <tr>
                  <th class="collapsing"></th>
                  <th>職稱</th>
                  <th>姓名</th>
                  <th>加入時間</th>
                  <th>引薦獎金40%</th>
                  <th>執行業務所得10%<br />
                    (20000以上)</th>
                  <th>核發獎金</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td class="collapsing">1</td>
                  <td>網記主任</td>
                  <td>阿百川</td>
                  <td>1位</td>
                  <td>1400</td>
                  <td></td>
                  <td></td>
                </tr>
              </tbody>
              <tfoot class="full-width">
                <tr>
                  <th class="collapsing">
                    <h5>總計</h5>
                  </th>
                  <th></th>
                  <th></th>
                  <th></th>
                  <th>1400</th>
                  <th>2800</th>
                  <th>4200</th>
                </tr>
              </tfoot>
            </table>--%>
          </div>

          <div class="ui tab" data-tab="Referee">
            <h2>會員管理</h2>
            <div class="ui divider"></div>

            <asp:GridView ID="GridView2" runat="server" CssClass="ui celled unstackable definition table" ShowFooter="true" GridLines="None" CellSpacing="5" DataSourceID="SqlDataSource2" AutoGenerateColumns="False" OnPreRender="GridView2_PreRender" OnDataBound="GridView2_DataBound">
              <Columns>
                <asp:BoundField DataField="sn" FooterText="總計" HeaderStyle-CssClass="collapsing" FooterStyle-CssClass="collapsing" ItemStyle-CssClass="center aligned collapsing" />
                <asp:BoundField DataField="Pinews_name" HeaderText="暱稱" SortExpression="Pinews_name"></asp:BoundField>
                <asp:BoundField DataField="Name" HeaderText="姓名" SortExpression="Name"></asp:BoundField>
                <asp:BoundField DataField="Pay_Time" HeaderText="加入時間" SortExpression="Pay_Time" HeaderStyle-CssClass="collapsing" FooterStyle-CssClass="right aligned collapsing" ItemStyle-CssClass="center aligned collapsing" DataFormatString="{0:yyyy/MM/dd tthh:mm}"></asp:BoundField>
              </Columns>
            </asp:GridView>

            <asp:SqlDataSource runat="server" ID="SqlDataSource2" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="select row_number() over (order by r.User_Id) as sn, m.Pinews_name, m.Name, r.Referral_Time as Pay_Time from Referral r
left join Member m on m.Id = r.User_Id 
where r.Introducer_Id = @id">
              <SelectParameters>
                <asp:SessionParameter SessionField="User_Id" Name="id"></asp:SessionParameter>
              </SelectParameters>
            </asp:SqlDataSource>
            <%--<table class="ui celled unstackable definition table">
              <thead class="full-width">
                <tr>
                  <th></th>
                  <th>暱稱</th>
                  <th>姓名</th>
                  <th>加入時間</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>1</td>
                  <td>abc</td>
                  <td>阿百川</td>
                  <td>2021年8月19日 18:00</td>
                </tr>
              </tbody>
            </table>--%>
          </div>

          <div class="ui tab" data-tab="Dividends">
            <h2>差%獎金</h2>
            <div class="ui divider"></div>

            <asp:GridView ID="GridView3" runat="server" CssClass="ui celled unstackable definition table" Visible="false" DataKeyNames="m,b,m1,b1" ShowFooter="true" GridLines="None" CellSpacing="5" DataSourceID="SqlDataSource3" AutoGenerateColumns="False" OnPreRender="GridView3_PreRender" OnDataBound="GridView3_DataBound">
              <Columns>
                <asp:BoundField DataField="sn" ReadOnly="True" FooterText="總計" HeaderStyle-CssClass="collapsing" FooterStyle-CssClass="collapsing" ItemStyle-CssClass="center aligned collapsing" SortExpression="sn"></asp:BoundField>
                <asp:BoundField DataField="Class_Name" HeaderText="職稱" SortExpression="Class_Name"></asp:BoundField>
                <asp:BoundField DataField="Name" HeaderText="姓名" SortExpression="Name"></asp:BoundField>
                <asp:BoundField DataField="m" HeaderText="網記會員" ReadOnly="True" ItemStyle-CssClass="right aligned" SortExpression="m"></asp:BoundField>
                <asp:BoundField DataField="b" HeaderText="差%獎金" ReadOnly="True" ItemStyle-CssClass="right aligned" FooterStyle-CssClass="right aligned" SortExpression="b"></asp:BoundField>
                <asp:BoundField DataField="m1" HeaderText="網記主任" ReadOnly="True" ItemStyle-CssClass="right aligned" SortExpression="m1"></asp:BoundField>
                <asp:BoundField DataField="b1" HeaderText="差%獎金" ReadOnly="True" ItemStyle-CssClass="right aligned" FooterStyle-CssClass="right aligned" SortExpression="b1"></asp:BoundField>
                <asp:BoundField HeaderText="核發獎金" FooterStyle-CssClass="right aligned" />
              </Columns>
            </asp:GridView>

            <asp:SqlDataSource runat="server" ID="SqlDataSource3" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="select row_number() over (order by User_Id) as sn, Class_Name, Name, m, b, m1, b1 from(
select distinct r.User_Id, ac.Class_Name, m.Name
, count(case when r1.User_Class = 1 then r1.User_Id else null end) as m, (cb.Bonus_Rate-cb1.Bonus_Rate)*caf.fee/100 as b
, count(case when r1.User_Class = 2 then r1.User_Id else null end) as m1, (cb.Bonus_Rate-cb1.Bonus_Rate)*caf1.fee/100 as b1
from Referral r 
left join Referral r1 on r1.Introducer_Id = r.User_Id
left join Member m on r.User_Id = m.Id
left join Authority_Class ac on ac.Id = r.User_Class
left join class_Bonus cb on cb.class_id = r.Introducer_Class
left join class_Bonus cb1 on cb1.class_id = r.User_Class
left join class_annual_fee caf on caf.class_id = 1
left join class_annual_fee caf1 on caf1.class_id = 2
where r.Introducer_Id = @uid and Format(r1.Referral_time, 'yyyy/MM') = Format(@dt, 'yyyy/MM') group by r.User_Id, ac.Class_Name, m.Name, 
(cb.Bonus_Rate-cb1.Bonus_Rate)*caf.fee/100, (cb.Bonus_Rate-cb1.Bonus_Rate)*caf1.fee/100) l">
              <SelectParameters>
                <asp:SessionParameter SessionField="User_Id" Name="uid"></asp:SessionParameter>
                <asp:ControlParameter ControlID="rd_HF" PropertyName="Value" DbType="DateTime" Name="dt"></asp:ControlParameter>
              </SelectParameters>
            </asp:SqlDataSource>
            <%--<table class="ui celled unstackable definition table">
              <thead class="full-width">
                <tr>
                  <th></th>
                  <th>職稱</th>
                  <th>姓名</th>
                  <th>網記會員</th>
                  <th>差%獎金</th>
                  <th>網記主任</th>
                  <th>差%獎金</th>
                  <th>核發獎金</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>1</td>
                  <td>網記主任</td>
                  <td>阿百川</td>
                  <td>1位</td>
                  <td>1400</td>
                  <td>1位</td>
                  <td>2800</td>
                  <td></td>
                </tr>
              </tbody>
              <tfoot class="full-width">
                <tr>
                  <th>
                    <h5>總計</h5>
                  </th>
                  <th></th>
                  <th></th>
                  <th></th>
                  <th>1400</th>
                  <th></th>
                  <th>2800</th>
                  <th>4200</th>
                </tr>
              </tfoot>
            </table>--%>
          </div>

          <div class="ui tab" data-tab="all_payment">
            <h2>繳費會員人數</h2>
            <div class="ui divider"></div>
            <asp:GridView ID="GridView6" runat="server" CssClass="ui unstackable definition selectable celled table" Visible="false" DataKeyNames="date,mc,zc,gc,jc,c,b,tr,dr,final" ShowFooter="true" AutoGenerateColumns="false" GridLines="None" CellSpacing="5" DataSourceID="SqlDataSource6" OnSelectedIndexChanging="GridView6_SelectedIndexChanging" OnPreRender="GridView6_PreRender" OnDataBound="GridView6_DataBound">
              <Columns>
                <asp:BoundField DataField="date" HeaderText="時間" HtmlEncode="false" HeaderStyle-CssClass="center aligned" ItemStyle-CssClass="center aligned" FooterStyle-CssClass="right aligned" />
                <asp:BoundField DataField="mc" HeaderText="會員<br>繳費人數" HtmlEncode="false" HeaderStyle-CssClass="center aligned" ItemStyle-CssClass="right aligned" FooterStyle-CssClass="right aligned" />
                <asp:BoundField DataField="zc" HeaderText="主任<br>繳費人數" HtmlEncode="false" HeaderStyle-CssClass="center aligned" ItemStyle-CssClass="right aligned" FooterStyle-CssClass="right aligned" />
                <asp:BoundField DataField="gc" HeaderText="顧問<br>繳費人數" HtmlEncode="false" HeaderStyle-CssClass="center aligned" ItemStyle-CssClass="right aligned" FooterStyle-CssClass="right aligned" />
                <asp:BoundField DataField="jc" HeaderText="講師<br>繳費人數" HtmlEncode="false" HeaderStyle-CssClass="center aligned" ItemStyle-CssClass="right aligned" FooterStyle-CssClass="right aligned" />
                <asp:BoundField DataField="c" HeaderText="總繳費<br>人數" HtmlEncode="false" HeaderStyle-CssClass="center aligned" ItemStyle-CssClass="right aligned" FooterStyle-CssClass="right aligned" />
                <asp:BoundField DataField="b" HeaderText="月總付費<br>金額" HtmlEncode="false" HeaderStyle-CssClass="center aligned" ItemStyle-CssClass="right aligned" FooterStyle-CssClass="right aligned" />
                <asp:BoundField DataField="tr" HeaderText="月引薦<br>獎金" HtmlEncode="false" HeaderStyle-CssClass="center aligned" ItemStyle-CssClass="right aligned" FooterStyle-CssClass="right aligned" />
                <asp:BoundField DataField="dr" HeaderText="月差%<br>獎金" HtmlEncode="false" HeaderStyle-CssClass="center aligned" ItemStyle-CssClass="right aligned" FooterStyle-CssClass="right aligned" />
                <asp:BoundField DataField="final" HeaderText="月實收<br>金額" HtmlEncode="false" HeaderStyle-CssClass="center aligned" ItemStyle-CssClass="right aligned" FooterStyle-CssClass="right aligned" />
              </Columns>
            </asp:GridView>

            <div class="ui modal" id="all_payment_detail">
              <div class="header">當月付費總覽詳細</div>
              <div class="content">
                <asp:GridView ID="GridView7" CssClass="ui unstackable celled table" runat="server" GridLines="None" CellSpacing="5" AutoGenerateColumns="False" DataSourceID="SqlDataSource7" OnPreRender="GridView7_PreRender">
                  <Columns>
                    <asp:BoundField DataField="Name" HeaderText="姓名" SortExpression="Name"></asp:BoundField>
                    <asp:BoundField DataField="Amount" HeaderText="繳費" SortExpression="Amount"></asp:BoundField>
                    <asp:BoundField DataField="Pay_Time" HeaderText="繳費時間" SortExpression="Pay_Time"></asp:BoundField>
                    <asp:BoundField DataField="Due_Time" HeaderText="到期時間" SortExpression="Due_Time"></asp:BoundField>
                    <asp:BoundField DataField="Class_Name" HeaderText="職稱" SortExpression="User_Class"></asp:BoundField>
                    <asp:BoundField DataField="r" HeaderText="引薦獎金" SortExpression="r"></asp:BoundField>
                    <asp:BoundField DataField="introducer_name" HeaderText="引薦人" SortExpression="introducer_name"></asp:BoundField>
                    <asp:BoundField DataField="master_name" HeaderText="推薦講師" />
                    <asp:BoundField DataField="d" HeaderText="差%獎金" SortExpression="d" />
                  </Columns>
                </asp:GridView>
                <asp:SqlDataSource runat="server" ID="SqlDataSource7" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="select m1.Name, m1.Pinews_name, ac.Class_Name, m1.Register_Time, mp.Amount, cb1.Bonus_Rate, caf.fee * (case when cb1.Bonus_Rate is null then cb2.Bonus_Rate else cb1.Bonus_Rate end) / 100 as r, m2.Name as introducer_name, case when r1.Introducer_Class = 4 then(cb.Bonus_Rate - cb1.Bonus_Rate)*caf.fee/100 else 0 end as d, m.Name as master_name, mp.Pay_Time, mp.Due_Time from Referral r left join Member m1 on m1.Id = r.User_Id left join Member m2 on m2.Id = r.Introducer_Id left join Referral r1 on r1.User_Id = r.Introducer_Id and r1.Introducer_Class = 4 left join Member m on m.Id = r1.Introducer_Id left join class_Bonus cb on cb.class_id = r1.Introducer_Class left join class_Bonus cb1 on cb1.class_id = r1.User_Class left join class_Bonus cb2 on cb2.class_id = r.Introducer_Class left join Class_annual_fee caf on caf.Class_Id = r.User_Class left join Member_Payment mp on mp.User_Id = r.User_Id left join Authority_Class As ac ON ac.Id = mp.User_Class where r.Referral_Time is not null and (format(r.Referral_Time, 'yyyy年MM月') = @date)">
                  <SelectParameters>
                    <asp:ControlParameter ControlID="GridView6" PropertyName="SelectedValue" Name="date"></asp:ControlParameter>
                  </SelectParameters>
                </asp:SqlDataSource>
              </div>
              <div class="actions">
                <asp:LinkButton ID="LinkButton2" CssClass="ui button" runat="server" OnClick="LinkButton2_Click">關閉</asp:LinkButton>
              </div>
            </div>
            <asp:SqlDataSource runat="server" ID="SqlDataSource6" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT format(DATEADD(MONTH, nbr - 1, DATEADD(Month, -11, dateadd(MONTH, DATEDIFF(MONTH, format(GETDATE(), 'yyyy-MM-dd'), format(GETDATE(), 'yyyy-12-dd')), format(GETDATE(), 'yyyy-MM-dd')))), 'yyyy年MM月') as date, mc, zc, gc, jc, mt.c, b, o.d as dr, sum(r) as tr, b - sum(r) - isnull(o.d, 0) as final FROM ( SELECT ROW_NUMBER() OVER ( ORDER BY c.object_id ) AS Nbr FROM sys.columns c ) nbrs left join (select sum(case mp.User_Class when 1 then 1 else 0 end) as mc, sum(case mp.User_Class when 2 then 1 else 0 end) as zc, sum(case mp.User_Class when 3 then 1 else 0 end) as gc, sum(case mp.User_Class when 4 then 1 else 0 end) as jc, count(mp.User_Class) as c, format(mp.Pay_Time, 'yyyy年MM月') as t, sum(caf.fee) as b from Member_Payment mp left join Member m on m.Id = mp.User_Id left join Class_annual_fee caf on mp.User_Class = caf.Class_Id where mp.IsComplete = 1 and mp.User_Class != 5 group by format(mp.Pay_Time, 'yyyy年MM月')) mt on mt.t = format(DATEADD(MONTH, nbr - 1, DATEADD(Month, -11, dateadd(MONTH, DATEDIFF(MONTH, format(GETDATE(), 'yyyy-MM-dd'), format(GETDATE(), 'yyyy-12-dd')), format(GETDATE(), 'yyyy-MM-dd')))), 'yyyy年MM月')left join (select r.Introducer_Id,sum( case when r.Introducer_Class = 4 then(cb.Bonus_Rate - cb1.Bonus_Rate)*caf.fee/100 else 0 end) as d, Format(r1.Referral_Time, 'yyyy年MM月') as rt from Referral r  left join Referral r1 on r.User_Id = r1.Introducer_Id left join class_Bonus cb on cb.class_id = r.Introducer_Class left join class_Bonus cb1 on cb1.class_id = r.User_Class left join Class_annual_fee caf on caf.Class_Id = r1.User_Class where r1.Id is not null and case when r.Introducer_Class = 4 then(cb.Bonus_Rate - cb1.Bonus_Rate)*caf.fee/100 else 0 end != 0 and r.Referral_Time is not null and r1.Referral_Time is not null group by Format(r1.Referral_Time, 'yyyy年MM月'), r.Introducer_Id) o on o.rt = format(DATEADD(MONTH, nbr - 1, DATEADD(Month, -11, dateadd(MONTH, DATEDIFF(MONTH, format(GETDATE(), 'yyyy-MM-dd'), format(GETDATE(), 'yyyy-12-dd')), format(GETDATE(), 'yyyy-MM-dd')))), 'yyyy年MM月') left join (select case when sum(caf.fee * cb.Bonus_Rate / 100) >= 20000 then sum(caf.fee * cb.Bonus_Rate / 100) * 0.9 else sum(caf.fee * cb.Bonus_Rate / 100) end as r, format(r.Referral_Time, 'yyyy年MM月') as d from Referral r left join Class_annual_fee caf on r.User_Class = caf.Class_Id left join Class_Bonus cb on r.Introducer_Class = cb.Class_Id where r.Referral_Time is not null group by r.Introducer_Id, format(r.Referral_Time, 'yyyy年MM月')) r on r.d = format(DATEADD(MONTH, nbr - 1, DATEADD(Month, -11, dateadd(MONTH, DATEDIFF(MONTH, format(GETDATE(), 'yyyy-MM-dd'), format(GETDATE(), 'yyyy-12-dd')), format(GETDATE(), 'yyyy-MM-dd')))), 'yyyy年MM月') WHERE nbr - 1 <= 11group by format(DATEADD(MONTH, nbr - 1, DATEADD(Month, -11, dateadd(MONTH, DATEDIFF(MONTH, format(GETDATE(), 'yyyy-MM-dd'), format(GETDATE(), 'yyyy-12-dd')), format(GETDATE(), 'yyyy-MM-dd')))), 'yyyy年MM月'), mc, zc, gc, jc, c, b, o.d"></asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource8" runat="server" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT format(DATEADD(MONTH, nbr - 1, DATEADD(Month, -11, dateadd(MONTH, DATEDIFF(MONTH, format(@dt, 'yyyy-MM-dd'), format(@dt, 'yyyy-12-dd')), format(@dt, 'yyyy-MM-dd')))), 'yyyy年MM月') as date, mc, zc, gc, jc, mt.c, b, o.d as dr, sum(r) as tr, b - sum(r) - isnull(o.d, 0) as final FROM ( SELECT ROW_NUMBER() OVER ( ORDER BY c.object_id ) AS Nbr FROM sys.columns c ) nbrs left join (select sum(case mp.User_Class when 1 then 1 else 0 end) as mc, sum(case mp.User_Class when 2 then 1 else 0 end) as zc, sum(case mp.User_Class when 3 then 1 else 0 end) as gc, sum(case mp.User_Class when 4 then 1 else 0 end) as jc, count(mp.User_Class) as c, format(mp.Pay_Time, 'yyyy年MM月') as t, sum(caf.fee) as b from Member_Payment mp left join Member m on m.Id = mp.User_Id left join Class_annual_fee caf on mp.User_Class = caf.Class_Id where mp.IsComplete = 1 and mp.User_Class != 5 group by format(mp.Pay_Time, 'yyyy年MM月')) mt on mt.t = format(DATEADD(MONTH, nbr - 1, DATEADD(Month, -11, dateadd(MONTH, DATEDIFF(MONTH, format(@dt, 'yyyy-MM-dd'), format(@dt, 'yyyy-12-dd')), format(@dt, 'yyyy-MM-dd')))), 'yyyy年MM月')left join (select r.Introducer_Id,sum( case when r.Introducer_Class = 4 then(cb.Bonus_Rate - cb1.Bonus_Rate)*caf.fee/100 else 0 end) as d, Format(r1.Referral_Time, 'yyyy年MM月') as rt from Referral r  left join Referral r1 on r.User_Id = r1.Introducer_Id left join class_Bonus cb on cb.class_id = r.Introducer_Class left join class_Bonus cb1 on cb1.class_id = r.User_Class left join Class_annual_fee caf on caf.Class_Id = r1.User_Class where r1.Id is not null and case when r.Introducer_Class = 4 then(cb.Bonus_Rate - cb1.Bonus_Rate)*caf.fee/100 else 0 end != 0 and r.Referral_Time is not null and r1.Referral_Time is not null group by Format(r1.Referral_Time, 'yyyy年MM月'), r.Introducer_Id) o on o.rt = format(DATEADD(MONTH, nbr - 1, DATEADD(Month, -11, dateadd(MONTH, DATEDIFF(MONTH, format(@dt, 'yyyy-MM-dd'), format(@dt, 'yyyy-12-dd')), format(@dt, 'yyyy-MM-dd')))), 'yyyy年MM月') left join (select case when sum(caf.fee * cb.Bonus_Rate / 100) >= 20000 then sum(caf.fee * cb.Bonus_Rate / 100) * 0.9 else sum(caf.fee * cb.Bonus_Rate / 100) end as r, format(r.Referral_Time, 'yyyy年MM月') as d from Referral r left join Class_annual_fee caf on r.User_Class = caf.Class_Id left join Class_Bonus cb on r.Introducer_Class = cb.Class_Id where r.Referral_Time is not null group by r.Introducer_Id, format(r.Referral_Time, 'yyyy年MM月')) r on r.d = format(DATEADD(MONTH, nbr - 1, DATEADD(Month, -11, dateadd(MONTH, DATEDIFF(MONTH, format(@dt, 'yyyy-MM-dd'), format(@dt, 'yyyy-12-dd')), format(@dt, 'yyyy-MM-dd')))), 'yyyy年MM月') WHERE nbr - 1 <= 11group by format(DATEADD(MONTH, nbr - 1, DATEADD(Month, -11, dateadd(MONTH, DATEDIFF(MONTH, format(@dt, 'yyyy-MM-dd'), format(@dt, 'yyyy-12-dd')), format(@dt, 'yyyy-MM-dd')))), 'yyyy年MM月'), mc, zc, gc, jc, c, b, o.d">
              <SelectParameters>
                <asp:ControlParameter ControlID="rd_HF" PropertyName="Value" DbType="DateTime" Name="dt"></asp:ControlParameter>

              </SelectParameters>
            </asp:SqlDataSource>
          </div>

          <div class="ui tab scrolling" style="overflow: auto;" data-tab="referral_all">
            <h2>引薦總覽</h2>
            <div class="ui divider"></div>
            <%--<asp:UpdatePanel ID="UpdatePanel1" runat="server">
              <ContentTemplate>--%>
            <asp:GridView ID="GridView5" runat="server" CssClass="ui unstackable definition selectable celled table" DataKeyNames="Introducer_Id,mon_bonus,all_bonus" ShowFooter="true" GridLines="None" CellSpacing="5" OnRowDataBound="GridView5_RowDataBound" OnSelectedIndexChanging="GridView5_SelectedIndexChanging" OnPreRender="GridView5_PreRender" OnDataBound="GridView5_DataBound" AutoGenerateColumns="False" DataSourceID="SqlDataSource5">
              <Columns>
                <asp:BoundField DataField="sn" ItemStyle-CssClass="center aligned collapsing" FooterStyle-CssClass="collapsing" FooterText="總計" />
                <asp:BoundField DataField="Class_Name" HeaderText="引薦人<br>職稱" HtmlEncode="false" HeaderStyle-CssClass="center aligned collapsing" SortExpression="Class_Name"></asp:BoundField>
                <asp:BoundField DataField="Name" HeaderText="引薦人<br>名稱" HtmlEncode="false" HeaderStyle-CssClass="center aligned collapsing" SortExpression="Name"></asp:BoundField>
                <asp:BoundField DataField="mon1" HeaderText="當月引薦<br/>會員人數" HtmlEncode="false" HeaderStyle-CssClass="center aligned collapsing" ItemStyle-CssClass="right aligned" SortExpression="mon1"></asp:BoundField>
                <asp:BoundField DataField="mon2" HeaderText="當月引薦<br/>主任人數" HtmlEncode="false" HeaderStyle-CssClass="center aligned collapsing" ItemStyle-CssClass="right aligned" SortExpression="mon2"></asp:BoundField>
                <asp:BoundField DataField="mon_bonus" HeaderText="當月<br/>引薦獎金" HtmlEncode="false" HeaderStyle-CssClass="center aligned collapsing" ItemStyle-CssClass="right aligned collapsing" FooterStyle-CssClass="right aligned" ReadOnly="True" SortExpression="p"></asp:BoundField>
                <asp:BoundField DataField="all1" HeaderText="引薦會員<br/>總人數" HtmlEncode="false" HeaderStyle-CssClass="center aligned collapsing" ItemStyle-CssClass="right aligned" SortExpression="all1"></asp:BoundField>
                <asp:BoundField DataField="all2" HeaderText="引薦主任<br/>總人數" HtmlEncode="false" HeaderStyle-CssClass="center aligned collapsing" ItemStyle-CssClass="right aligned" SortExpression="all2"></asp:BoundField>
                <asp:BoundField DataField="all_bonus" HeaderText="引薦<br/>總獎金" HtmlEncode="false" HeaderStyle-CssClass="center aligned" ItemStyle-CssClass="right aligned collapsing" FooterStyle-CssClass="right aligned" ReadOnly="True" SortExpression="p"></asp:BoundField>
              </Columns>
            </asp:GridView>
            <asp:SqlDataSource runat="server" ID="SqlDataSource5" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="select ROW_NUMBER() over (order by sum(mon_bonus)) sn, Introducer_Id, m.Name, Class_Name, sum(case when FORMAT(referral_time, 'yyyy/MM') = Format(@dt, 'yyyy/MM') then member_mon else 0 end) as mon1, sum(case when FORMAT(referral_time, 'yyyy/MM') = Format(@dt, 'yyyy/MM') then senior_mon else 0 end) as mon2, sum(case when FORMAT(referral_time, 'yyyy/MM') = Format(@dt, 'yyyy/MM') then actual_bonus else 0 end) as mon_bonus, sum(member_mon) as all1, sum(senior_mon) as all2, sum(actual_bonus) as all_bonus from (select r.Introducer_Id, ac.Class_Name, sum(case when r.User_Class = 1 then 1 else 0 end) as 'member_mon', sum (case when r.User_Class = 2 then 1 else 0 end) as 'senior_mon', sum(caf.fee*cb.Bonus_Rate/100) as 'mon_bonus', case when sum(caf.fee*cb.Bonus_Rate/100) >= 20000 then sum(caf.fee*cb.Bonus_Rate/100)*0.9 else sum(caf.fee*cb.Bonus_Rate/100) end as 'actual_bonus', r.Referral_Time from Referral r left join Authority_Class ac on r.Introducer_Class = ac.Id left join Class_Bonus cb on r.Introducer_Class = cb.Class_Id left join Class_annual_fee caf on r.User_Class = caf.Class_Id where r.Referral_Time is not null and r.Referral_Time < DATEADD(MONTH, 1, @dt) group by r.Introducer_Id, ac.Class_Name, r.Referral_Time)k left join Member m on m.Id = k.Introducer_Id group by Introducer_Id, Class_Name, m.Name">
              <SelectParameters>
                <asp:ControlParameter ControlID="rd_HF" PropertyName="Value" DbType="DateTime" Name="dt"></asp:ControlParameter>
              </SelectParameters>
            </asp:SqlDataSource>
            <%--</ContentTemplate>
            </asp:UpdatePanel>--%>

            <div class="ui modal" id="referral_all_detail">
              <div class="header">當月引薦總覽詳細</div>
              <div class="content">
                <asp:GridView ID="GridView4" runat="server" CssClass="ui unstackable celled table" EmptyDataText="本月尚無該人員引薦資訊。" GridLines="None" CellSpacing="5" OnPreRender="GridView4_PreRender" OnDataBound="GridView4_DataBound" DataSourceID="SqlDataSource4" AutoGenerateColumns="False">
                  <Columns>
                    <asp:BoundField DataField="sn" ReadOnly="True" SortExpression="sn"></asp:BoundField>
                    <asp:BoundField DataField="icn" HeaderText="引薦人職稱" SortExpression="icn"></asp:BoundField>
                    <asp:BoundField DataField="iname" HeaderText="引薦人名稱" SortExpression="iname"></asp:BoundField>
                    <asp:BoundField DataField="Class_Name" HeaderText="被引薦人職稱" SortExpression="Class_Name"></asp:BoundField>
                    <asp:BoundField DataField="Name" HeaderText="被引薦人名稱" SortExpression="Name"></asp:BoundField>
                    <asp:BoundField DataField="Referral_Time" HeaderText="加入時間" SortExpression="Pay_Time"></asp:BoundField>
                    <asp:BoundField DataField="bonus" HeaderText="引薦獎金" ItemStyle-CssClass="right aligned collapsing" ReadOnly="True" SortExpression="bonus"></asp:BoundField>
                  </Columns>
                </asp:GridView>
              </div>
              <div class="actions">
                <asp:LinkButton ID="LinkButton1" runat="server" CssClass="ui button" OnClick="LinkButton1_Click">關閉</asp:LinkButton>
              </div>
            </div>
            <asp:SqlDataSource runat="server" ID="SqlDataSource4" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="select row_number() over (order by User_Id) as sn, icn, iname, Class_Name, Name, Referral_Time, bonus from
(select distinct r.User_Id, ac1.Class_Name as icn, Referral_Time, m1.Name as iname, ac.Class_Name, m.Name, caf.fee*cb.Bonus_Rate/100 as bonus 
from Referral r 
left join Member m on r.User_Id = m.Id
left join Member m1 on r.Introducer_Id = m1.Id
left join Authority_Class ac on ac.Id = r.User_Class
left join Authority_Class ac1 on ac1.Id = r.Introducer_Class
left join class_Bonus cb on cb.class_id = r.Introducer_Class 
left join class_annual_fee caf on caf.class_id = r.User_Class
where r.Introducer_Id = @id and Format(r.referral_Time, 'yyyy/MM') = Format(@dt, 'yyyy/MM')) l">
              <SelectParameters>
                <asp:Parameter Name="id"></asp:Parameter>
                <asp:ControlParameter ControlID="rd_HF" PropertyName="Value" DbType="DateTime" Name="dt"></asp:ControlParameter>
              </SelectParameters>
            </asp:SqlDataSource>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script>
    $('#date_calendar').calendar({
      type: 'month', minDate: new Date(), maxDate: new Date(), text: {
        days: ['日', '一', '二', '三', '四', '五', '六'],
        months: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
        monthsShort: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
        today: '今天', now: '現在', am: 'AM', pm: 'PM'
      }
    });

    $('#referral_list .item').on('click', function () {
      $('#referral_list .item .ui.label').removeClass('teal left pointing');
      $(this).children('.ui.label').addClass('teal left pointing');
    })
    $('#referral_list .item').tab({
      //onVisible: function () {
      //  console.log($(this));
      //  $('#referral .item .ui.label').removeClass('teal left pointing');
      //  $(this).children('.ui.label').addClass('teal left pointing');
      //}
    });
    $('.tab table.definition thead').addClass("full-width");
    var sum = 0;
    $('.tab[data-tab=referral] table tbody td:nth-child(5)').each(function () {
      sum += parseInt($(this).html());
    })
    console.log(sum);
    //$('.tab[data-tab=referral] table tfoot td:nth-child(5)').html(sum);
  </script>
</asp:Content>
