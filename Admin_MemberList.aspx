<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeFile="Admin_MemberList.aspx.cs" Inherits="piNews.Admin_MemberList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <div class="ui inverted segment">
    <div class="ui inverted breadcrumb">
      <a class="section">Home</a>
      <div class="divider">/ </div>
      <div class="active section">會員資料總覽</div>
    </div>
  </div>
  <div class="ui segment">
    <div class="ui action input">
      <asp:TextBox ID="Search_TB" runat="server" placeholder="搜尋..." OnTextChanged="Search_TB_TextChanged"></asp:TextBox>
      <asp:LinkButton ID="Search_LB" runat="server" CssClass="ui icon button" OnClick="Search_LB_Click"><i class="search icon"></i></asp:LinkButton>
    </div>
    <asp:GridView ID="GridView1" runat="server" CssClass="ui unstackable celled table" PagerSettings-FirstPageText="<i class='angle double left icon'></i>" AllowPaging="true" PageSize="10" GridLines="None" CellSpacing="5" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="SqlDataSource1" OnPreRender="GridView1_PreRender">
      <Columns>
        <asp:BoundField DataField="Staff_Id" HeaderText="編號" />
        <%--<asp:BoundField DataField="Id" HeaderText="Id" ReadOnly="True" InsertVisible="False" SortExpression="Id"></asp:BoundField>--%>
        <%--<asp:BoundField DataField="Class_Name" HeaderText="職稱" SortExpression="Class_Name"></asp:BoundField>--%>
        <asp:TemplateField HeaderText="職稱">
          <ItemTemplate>
            <%# Eval("Class_Name") + (Eval("IsAdmin").Equals(true) ? "":Eval("Class_Name").Equals(DBNull.Value) ? "拍粉":"(未付費)") %>
          </ItemTemplate>
        </asp:TemplateField>
        <asp:BoundField DataField="Pinews_pfr" HeaderText="引薦人" SortExpression="Pinews_pfr"></asp:BoundField>
        <asp:BoundField DataField="Name" HeaderText="姓名" SortExpression="Name"></asp:BoundField>
        <asp:BoundField DataField="Phone" HeaderText="電話" SortExpression="Phone"></asp:BoundField>
      </Columns>
      <PagerSettings Position="Bottom" Mode="NumericFirstLast" PageButtonCount="5" FirstPageText="<i class='angle double left icon'></i>" LastPageText="<i class='angle double right icon'></i>" />
      <%--<PagerSettings Position="Bottom" Mode="NumericFirstLast" PageButtonCount="5" FirstPageText="f" LastPageText="l" />--%>
    </asp:GridView>
    <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT m.Id, ac.Class_Name, m.Pinews_pfr, m.Name, m.Phone, m.IsAdmin, sid.Staff_Id FROM Member AS m LEFT OUTER JOIN Authority_Class AS ac ON ac.Id = m.Pinews_class LEFT OUTER JOIN Staff_Id AS sid ON sid.User_Id = m.Id order by m.Id DESC"></asp:SqlDataSource>
  </div>
</asp:Content>
