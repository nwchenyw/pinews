<%@ Page Title="" Language="C#" MasterPageFile="AdminPage.Master" AutoEventWireup="true" CodeFile="Admin_SiteSetting.aspx.cs" Inherits="piNews.Admin_SiteSetting" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <div class="ui inverted segment">
    <div class="ui inverted breadcrumb">
      <a class="section">Home</a>
      <div class="divider">/ </div>
      <div class="active section">網站資料管理</div>
    </div>
  </div>
  <div class="ui segment">
    <asp:GridView ID="GridView1" runat="server" CssClass="ui unstackable celled definition table" ShowHeader="false" GridLines="None" CellSpacing="5" AutoGenerateColumns="False" DataKeyNames="Id,Option" DataSourceID="SqlDataSource1" OnRowUpdating="GridView1_RowUpdating">
      <Columns>
        <asp:TemplateField ItemStyle-CssClass="center aligned">
          <ItemTemplate>
            <%# Eval("Option").Equals("Name") ? "網站<br>名稱":
                Eval("Option").Equals("Description") ? "網站<br>描述":
                (Eval("Option")+"<br>連結") %>
          </ItemTemplate>
        </asp:TemplateField>
        <%--<asp:BoundField DataField="Option" HeaderText="Option" SortExpression="Option"></asp:BoundField>--%>
        <asp:BoundField DataField="Setting" SortExpression="Setting"></asp:BoundField>
        <asp:CommandField ShowEditButton="True" ControlStyle-CssClass="ui button"></asp:CommandField>
      </Columns>
    </asp:GridView>
    <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT * FROM [WebSite_Data]" DeleteCommand="DELETE FROM [WebSite_Data] WHERE [Id] = @Id" InsertCommand="INSERT INTO [WebSite_Data] ([Option], [Setting]) VALUES (@Option, @Setting)" UpdateCommand="UPDATE [WebSite_Data] SET [Setting] = @Setting WHERE [Id] = @Id">
      <DeleteParameters>
        <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
      </DeleteParameters>
      <InsertParameters>
        <asp:Parameter Name="Option" Type="String"></asp:Parameter>
        <asp:Parameter Name="Setting" Type="String"></asp:Parameter>
      </InsertParameters>
      <UpdateParameters>
        <asp:Parameter Name="Setting" Type="String"></asp:Parameter>
        <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
      </UpdateParameters>
    </asp:SqlDataSource>
  </div>
</asp:Content>
