<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeFile="Admin_Category.aspx.cs" Inherits="piNews.Admin_Category" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <script
    src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"
    integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU="
    crossorigin="anonymous"></script>
  <div class="ui inverted segment">
    <div class="ui inverted breadcrumb">
      <a class="section">Home</a>
      <div class="divider">/ </div>
      <div class="active section">投稿分類管理</div>
    </div>
  </div>
  <div class="ui segment">
    <asp:GridView ID="GridView1" runat="server" ShowFooter="true" CssClass="ui unstackable celled table" AutoGenerateColumns="False" CellSpacing="5" GridLines="None" DataKeyNames="Id" DataSourceID="SqlDataSource1" OnRowDeleting="GridView1_RowDeleting" OnRowUpdating="GridView1_RowUpdating" OnPreRender="GridView1_PreRender">
      <Columns>
        <asp:TemplateField HeaderText="分類名稱" FooterStyle-CssClass="ui fluid input">
          <ItemTemplate>
            <%# Eval("Name") %>
            <input type="hidden" name="Menu_Id" value='<%# Eval("Id") %>' />
          </ItemTemplate>
          <ItemStyle Width="100%" />
          <EditItemTemplate>
            <div class="ui fluid input">
            <asp:TextBox ID="name_TB" runat="server" Text='<%# Eval("Name") %>'></asp:TextBox></div>
          </EditItemTemplate>
          <FooterTemplate>
            <asp:TextBox ID="TextBox1" runat="server" placeholder="分類名稱"></asp:TextBox>
          </FooterTemplate>
        </asp:TemplateField>
        <asp:TemplateField ControlStyle-CssClass="ui tiny button" ItemStyle-CssClass="collapsing" FooterStyle-CssClass="center aligned">
          <ItemTemplate>
            <asp:LinkButton ID="Edit_LB" runat="server" CommandName="Edit">編輯</asp:LinkButton>
            <asp:LinkButton ID="Delete_LB" runat="server" CommandName="Delete">刪除</asp:LinkButton>
          </ItemTemplate>
          <EditItemTemplate>
            <asp:LinkButton ID="Update_LB" runat="server" CommandName="Update">更新</asp:LinkButton>
            <asp:LinkButton ID="Cancel_LB" runat="server" CommandName="Cancel">取消</asp:LinkButton>
          </EditItemTemplate>
          <FooterTemplate>
            <asp:LinkButton ID="Insert_LB" runat="server" CssClass="ui tiny button" OnClick="Insert_LB_Click">新增</asp:LinkButton>
          </FooterTemplate>
        </asp:TemplateField>
        <%--<asp:BoundField DataField="Link" HeaderText="Link" SortExpression="Link"></asp:BoundField>--%>
        <%--<asp:BoundField DataField="Id" HeaderText="Id" ReadOnly="True" InsertVisible="False" SortExpression="Id"></asp:BoundField>--%>
        <%--<asp:CommandField ShowDeleteButton="True" ShowEditButton="True" ControlStyle-CssClass="ui tiny button"></asp:CommandField>--%>
      </Columns>
    </asp:GridView>
    <asp:LinkButton ID="Edit_Order_LB" CssClass="ui button" OnClick="Edit_Order_LB_Click" runat="server">編輯排序</asp:LinkButton>
    <asp:LinkButton ID="Reorder_LB" CssClass="ui button" OnClick="Reorder_LB_Click" runat="server" Visible="false">更新排序</asp:LinkButton>
    <asp:LinkButton ID="Cancel_Order_LB" CssClass="ui button" OnClick="Cancel_Order_LB_Click" runat="server" Visible="false">取消</asp:LinkButton>
    <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' DeleteCommand="DELETE FROM [Menu] WHERE [Id] = @Id" SelectCommand="SELECT [Name], [Link], [Id] FROM [Menu] ORDER BY [odr]" UpdateCommand="UPDATE [Menu] SET [Name] = @Name, [Link] = @Link WHERE [Id] = @Id" InsertCommand="INSERT INTO [Menu] ([Name], [Link]) VALUES (@Name, @Link)">
      <DeleteParameters>
        <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
      </DeleteParameters>
      <InsertParameters>
        <asp:Parameter Name="Name" Type="String"></asp:Parameter>
        <asp:Parameter Name="Link" Type="String"></asp:Parameter>
      </InsertParameters>
      <UpdateParameters>
        <asp:Parameter Name="Name" Type="String"></asp:Parameter>
        <asp:Parameter Name="Link" Type="String"></asp:Parameter>
        <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
      </UpdateParameters>
    </asp:SqlDataSource>
  </div>
  <script>
    function organize() {
      $('#<%= GridView1.EditIndex == -1 ? GridView1.ClientID:"" %>').addClass('selectable')
      $('#<%= GridView1.EditIndex == -1 ? GridView1.ClientID:"" %> tbody tr').on('mouseenter', function () {
        $(this).removeClass('shadow-unpop-br').addClass('shadow-pop-br')
      })
      $('#<%= GridView1.EditIndex == -1 ? GridView1.ClientID:"" %> tbody tr').on('mouseleave', function () {
        $(this).removeClass('shadow-pop-br').addClass('shadow-unpop-br')
      })
      $('#<%= GridView1.EditIndex == -1 ? GridView1.ClientID:"" %>').sortable({
        items: 'tbody tr',
        cursor: 'pointer',
        axis: 'y',
        dropOnEmpty: false,
        start: function (e, ui) {
          ui.item.css('display', 'block')
        },
        stop: function (e, ui) {
          ui.item.css('display', '');
        },
        receive: function (e, ui) {
          $(this).find("tbody").append(ui.item);
        }
      });
    }
  </script>
</asp:Content>
