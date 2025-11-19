<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeFile="Admin_Authority.aspx.cs" Inherits="piNews.Admin_Authority" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <div class="ui inverted segment">
    <div class="ui inverted breadcrumb">
      <a class="section">Home</a>
      <div class="divider">/ </div>
      <div class="active section">權限設定</div>
    </div>
  </div>
  <div class="ui segment">
    <asp:GridView ID="GridView1" CssClass="ui unstackable celled table" runat="server" DataKeyNames="Id,Name,pinews_class" AutoGenerateColumns="false" OnPreRender="GridView1_PreRender" OnRowUpdating="GridView1_RowUpdating" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" GridLines="None" CellSpacing="5" DataSourceID="SqlDataSource1">
      <Columns>
        <%--<asp:BoundField DataField="Name" HeaderText="使用者" SortExpression="Name"></asp:BoundField>--%>
        <asp:TemplateField HeaderText="使用者">
          <ItemTemplate>
            <%# Eval("Name") %><br />
            <%# Eval("Staff_Id") %>
          </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="層級">
          <ItemTemplate>
            <%# Eval("Class_Name") + (Eval("isAdmin").Equals(true) ? "":(Eval("Class_Name").Equals(DBNull.Value) ? "拍粉":"(未付費)")) %>
          </ItemTemplate>
          <EditItemTemplate>
            <div class="ui floating dropdown labeled icon button">
              <i class="world icon"></i>
              <asp:HiddenField ID="HiddenField1" Value='<%# Eval("pinews_class") %>' runat="server" />
              <span class="text">Level Of Authority</span>
              <div class="menu">
                <div class="item" data-value="0">拍粉</div>
                <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSource3">
                  <ItemTemplate>
                    <div class="item" data-value='<%# Eval("Id") %>'><%# Eval("Class_Name") %></div>
                  </ItemTemplate>
                </asp:Repeater>
              </div>
            </div>
            <asp:SqlDataSource runat="server" ID="SqlDataSource3" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT [Id], [Class_Name] FROM [Authority_Class]"></asp:SqlDataSource>
          </EditItemTemplate>
        </asp:TemplateField>
        <%--<asp:BoundField DataField="Authority" HeaderText="權限" ReadOnly="True" SortExpression="Authority"></asp:BoundField>--%>
        <asp:TemplateField HeaderText="權限">
          <ItemTemplate>
            編輯文章,新增文章,<%# (Eval("isAdmin").Equals(true) ? "上架文章,":"")+Eval("Authority") %>
          </ItemTemplate>
        </asp:TemplateField>
        <asp:CommandField ShowSelectButton="True" ShowEditButton="true" ControlStyle-CssClass="ui tiny button" EditText="更改層級" SelectText="編輯"></asp:CommandField>
      </Columns>
    </asp:GridView>

    <div class="ui auth_edit modal">
      <div class="header">
        <%= GridView1.SelectedIndex != -1 ? GridView1.DataKeys[GridView1.SelectedIndex].Values["Name"].ToString():"" %>權限編輯
      </div>
      <div class="content">
        <asp:ListView ID="ListView1" runat="server" DataKeyNames="Id,Name,chk" DataSourceID="SqlDataSource2">
          <LayoutTemplate>
            <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
          </LayoutTemplate>
          <ItemTemplate>
            <asp:CheckBox ID="CheckBox1" runat="server" Text='<%# Eval("Name") + (Eval("isAdmin").Equals(true) ? "":"(試用)") %>' Checked='<%# Eval("chk").Equals("true") %>' />
          </ItemTemplate>
        </asp:ListView>
      </div>
      <div class="actions">
        <asp:LinkButton ID="LinkButton1" runat="server" CssClass="ui primary button" OnClick="LinkButton1_Click">更新</asp:LinkButton>
        <div class="ui deny button">取消</div>
      </div>
    </div>

    <%--<asp:CheckBoxList ID="CheckBoxList1" runat="server" DataSourceID="SqlDataSource2" RepeatDirection="Horizontal" DataValueField="Id" DataTextField="Name"></asp:CheckBoxList>--%>
    <asp:SqlDataSource runat="server" ID="SqlDataSource2" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="select distinct ac.Class_Name, m.isAdmin, a.Id, a.Name, case when ua.User_Id = @uid then 'true' else 'false' end as chk from Authority_Class ac left join Member m on m.Pinews_class = ac.Id left join Class_Authority ca on ca.Auth_Class_Id = ac.Id left join Authority a on a.Id = ca.Auth_Id
left join User_Authority ua on ua.Authority_Id = a.Id and ua.User_Id = @uid where m.id = @uid">
      <SelectParameters>
        <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="uid"></asp:ControlParameter>
      </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT u_auth.Id, sid.Staff_Id, Name, isAdmin, pinews_class, ac.Class_Name, LEFT (NULLIF (auth, ''), LEN(NULLIF (auth, '')) - 1) AS Authority FROM (SELECT Name + ' <br>(' + UserId + ')' as Name, Id, isAdmin, Pinews_class, (SELECT TOP (100) PERCENT a.Name + ',' AS [text()] FROM User_Authority AS ua LEFT OUTER JOIN Authority AS a ON ua.User_Id = m.Id AND a.Id = ua.Authority_Id ORDER BY a.Id FOR XML PATH('')) AS auth FROM Member AS m) AS u_auth left join Authority_Class ac on ac.Id = u_auth.Pinews_class left join Staff_Id sid on sid.User_Id = u_auth.Id" UpdateCommand="UPDATE Member SET Pinews_class = @pc WHERE (Id = @id)">
      <UpdateParameters>
        <asp:Parameter Name="pc"></asp:Parameter>
        <asp:Parameter Name="id"></asp:Parameter>
      </UpdateParameters>
    </asp:SqlDataSource>
  </div>
  <script>
    $('.ui.dropdown.button').dropdown();
  </script>
</asp:Content>
