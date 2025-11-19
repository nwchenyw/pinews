<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeFile="Admin_OpenMemberList.aspx.cs" Inherits="piNews.Admin_MemberList" %>

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
        <asp:GridView ID="GridView1" runat="server" CssClass="ui unstackable celled table" PagerSettings-FirstPageText="<i class='angle double left icon'></i>" AllowPaging="true" PageSize="50" GridLines="None" CellSpacing="5" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="SqlDataSource1" OnPreRender="GridView1_PreRender" OnRowCommand="GridView1_RowCommand">
            <Columns>
                <asp:BoundField DataField="id" HeaderText="編號" />
                <asp:BoundField DataField="Staff_Id" HeaderText="推薦編號" />
                <asp:BoundField DataField="Name" HeaderText="姓名" SortExpression="Name"></asp:BoundField>
                <asp:BoundField DataField="Phone" HeaderText="電話" SortExpression="Phone"></asp:BoundField>
                <asp:BoundField DataField="Pinews_pfr" HeaderText="引薦人" SortExpression="Pinews_pfr"></asp:BoundField>
                <asp:TemplateField HeaderText="是否開通">
                    <ItemTemplate>
                        <asp:Label ID="lblIsAdmin" runat="server" Text='<%# ConvertToChinese((bool)Eval("IsAdmin")) %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="UserId" HeaderText="會員帳號" SortExpression="UserId"></asp:BoundField>
                <asp:BoundField DataField="Password" HeaderText="會員密碼" SortExpression="Password"></asp:BoundField>
                <asp:BoundField DataField="Register_Time" HeaderText="註冊時間" SortExpression="Register_Time"></asp:BoundField>
                <asp:BoundField DataField="subscription_count" HeaderText="開通次數" SortExpression="subscription_count"></asp:BoundField>
                <asp:BoundField DataField="lsat_subscription_time" HeaderText="最後一次註冊時間" SortExpression="lsat_subscription_time"></asp:BoundField>


                <asp:TemplateField HeaderText="開通">
                    <ItemTemplate>
                        <asp:Button ID="btnActivate" runat="server" Text="開通" OnClientClick="return confirm('確定要開通嗎？');" CommandName="Activate" CommandArgument='<%# Eval("id") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="關閉">
                    <ItemTemplate>
                        <asp:Button ID="btnDeactivate" runat="server" Text="關閉" OnClientClick="return confirm('確定要關閉嗎？');" CommandName="Deactivate" CommandArgument='<%# Eval("id") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
            <PagerSettings Position="Bottom" Mode="NumericFirstLast" PageButtonCount="5" FirstPageText="<i class='angle double left icon'></i>" LastPageText="<i class='angle double right icon'></i>" />
        </asp:GridView>
        <%--<asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="select id,Name,Phone,Pinews_pfr,IsAdmin,UserId,Password,Register_Time  from Member order by id desc"></asp:SqlDataSource>--%>
        <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>'
            SelectCommand="SELECT Member.id, Member.Name, Member.Phone, Member.Pinews_pfr, Member.IsAdmin, Member.UserId, Member.Password, Member.Register_Time
                   ,Member.subscription_count
                   ,Member.lsat_subscription_time
                   ,Staff_Id.[User_Id], Staff_Id.[Staff_Id]
                   FROM Member
                   INNER JOIN Staff_Id ON Member.id = Staff_Id.User_Id
                   ORDER BY Member.id DESC"></asp:SqlDataSource>

    </div>
</asp:Content>
