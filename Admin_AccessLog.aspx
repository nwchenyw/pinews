<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeFile="Admin_AccessLog.aspx.cs" Inherits="piNews.Admin_AccessLog" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <div class="ui inverted segment">
    <div class="ui inverted breadcrumb">
      <a class="section">Home</a>
      <div class="divider">/ </div>
      <div class="active section">網站管理記錄</div>
    </div>
  </div>
  <div class="ui segment">
    <div class="ui blue text container segment">
      <%--<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>--%>
      <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
          <asp:CheckBox ID="CheckBox1" CssClass="ui checkbox" Text="登入、登出" Checked="true" AutoPostBack="true" OnCheckedChanged="CheckBox1_CheckedChanged" runat="server" />
          <asp:ListView ID="ListView1" runat="server" DataSourceID="SqlDataSource1" OnPagePropertiesChanging="ListView1_PagePropertiesChanging">
            <LayoutTemplate>
              <div class="ui divided list">
                <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
              </div>
            </LayoutTemplate>
            <ItemTemplate>
              <div class="item">
                <div class="right floated content">
                  <%# Eval("o_time") %>
                </div>
                <i class='ui <%# Eval("action") %> icon'></i>
                <div class="content">
                  <div class="header"><%# Eval("Modify_Detail") %></div>
                </div>
              </div>
            </ItemTemplate>
          </asp:ListView>
          <asp:DataPager ID="DataPager1" runat="server" PageSize="8" PagedControlID="ListView1">
            <Fields>
              <asp:NextPreviousPagerField ButtonType="Link" ButtonCssClass="icon item" ShowFirstPageButton="True" ShowNextPageButton="False" FirstPageText="<i class='angle double left icon'></i>" ShowPreviousPageButton="True" PreviousPageText="<i class='angle left icon'></i>"></asp:NextPreviousPagerField>
              <asp:NumericPagerField ButtonType="Link" NumericButtonCssClass="item" CurrentPageLabelCssClass="active item"></asp:NumericPagerField>
              <asp:NextPreviousPagerField ButtonType="Link" ButtonCssClass="icon item" ShowLastPageButton="True" ShowNextPageButton="True" NextPageText="<i class='angle right icon'></i>" LastPageText="<i class='angle double right icon'></i>" ShowPreviousPageButton="False"></asp:NextPreviousPagerField>
            </Fields>
          </asp:DataPager>
        </ContentTemplate>
      </asp:UpdatePanel>
    </div>
    <%--<asp:GridView ID="GridView1" CssClass="ui unstackable table" runat="server" GridLines="None" BorderWidth="1" CellSpacing="-1" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="SqlDataSource1">
      <Columns>
        <asp:TemplateField>
          <ItemTemplate>
            <%# Eval("o_time") %>
          </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField>
          <ItemTemplate>
            <i class='ui <%# Eval("action") %> icon'></i><%# Eval("Modify_Detail") %>
          </ItemTemplate>
        </asp:TemplateField>
      </Columns>
    </asp:GridView>--%>
    <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT *, case Modify_Action when 'Login' then 'sign in alternate' when 'Logout' then 'sign out alternate' when 'Approval' then 'stamp' when 'Insert' then 'plus' when 'Update' then 'edit' when 'Delete' then 'trash alternate' when 'View' then 'book reader' end as action, case when DATEDIFF(DAY, Operate_Time, GETDATE()) < 1 then format(Operate_Time, 'tt hh:mm') when DATEDIFF(DAY, Operate_Time, GETDATE()) = 1 then '昨天 ' + format(Operate_Time, 'tt hh:mm') when year(GETDATE()) - year(Operate_Time) < 1 then format(Operate_Time, 'M月d日') when year(GETDATE()) - year(Operate_Time) >= 1 then format(Operate_Time, 'yyyy年M月d日') end as o_time FROM [UserLog] WHERE (([Operate_User_Id] = @Operate_User_Id) AND ([Modify_Action] <> @Modify_Action)) ORDER BY [Operate_Time] DESC">
      <SelectParameters>
        <asp:SessionParameter SessionField="User_Id" Name="Operate_User_Id" Type="String"></asp:SessionParameter>
        <asp:Parameter DefaultValue="Certify" Name="Modify_Action" Type="String"></asp:Parameter>
      </SelectParameters>
    </asp:SqlDataSource>
  </div>
</asp:Content>
