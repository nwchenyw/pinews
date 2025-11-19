<%@ Page Title="" Language="C#" MasterPageFile="ClientPage.Master" AutoEventWireup="true" CodeFile="User_Profile.aspx.cs" Inherits="piNews.User_Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <style>
      .ui.card .grid .column {
        padding-left: 0;
        padding-right: 0;
      }
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <div class="ui feed container">
    <div class="event">
      <div class="label">
        <i class="history icon"></i>
      </div>
      <div class="content">
        <div class="ui breadcrumb">
          <a class="section" href="Default.aspx">首頁</a>
          <div class="divider">/ </div>
          <%--<span class="section">關於</span>
          <div class="divider">/ </div>--%>
          <asp:Repeater ID="Repeater2" runat="server" DataSourceID="SqlDataSource2" OnItemDataBound="Repeater2_ItemDataBound">
            <ItemTemplate>
              <div class="active section"><%# Eval("Name") %></div>
            </ItemTemplate>
          </asp:Repeater>
          <asp:SqlDataSource runat="server" ID="SqlDataSource2" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT TOP 1 Name FROM [Menu] WHERE ([Id] = @Id)">
            <SelectParameters>
              <asp:QueryStringParameter QueryStringField="id" Name="Id" Type="Int32"></asp:QueryStringParameter>
            </SelectParameters>
          </asp:SqlDataSource>
        </div>
      </div>
    </div>
  </div>
  <div id="main" class="ui container">
    <div id="article" class="ui grid container">
      <div class="two column doubling row">
      <div class="five wide column">
        <div class="ui unstackable items">
          <div class="item">
            <div class="ui small image">
              <div class="square">
                <asp:Image ID="P_Img" CssClass="image" runat="server" />
                <span class="no-img">No Image</span>
              </div>
            </div>
            <div class="content">
              <asp:Label ID="Name_L" CssClass="header" runat="server" Text="暱稱"></asp:Label>
              <div class="meta">
              </div>
              <div class="description">
                <p>
                  <asp:Label ID="Intro" runat="server" Text="Label"></asp:Label>
                </p>
              </div>
              <div class="extra">
              </div>
            </div>
          </div>
          <div class="ui divider"></div>
          <div class="item">
            於<span id="Article_joindate" runat="server"></span>加入
          </div>
          <div class="item">
            <div class="ui horizontal mini statistic">
              <div class="content">
                <a id="Number_of_reports" runat="server"></a>
              </div>
              <div class="label">
                篇報導
              </div>
            </div>
          </div>
          <div class="item">
            <asp:ListView ID="ListView2" runat="server" DataSourceID="SqlDataSource1">
              <LayoutTemplate>
                <table class="ui definition compact table">
                  <tbody>
                    <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
                  </tbody>
                </table>
              </LayoutTemplate>
              <ItemTemplate>
                <tr>
                  <td><%# Eval("t") %></td>
                  <td>
                    <%# Eval("c") %>
                  </td>
                </tr>
              </ItemTemplate>
            </asp:ListView>
            <%--<table class="ui definition compact table">
              <tbody>
                <tr>
                  <td>累計瀏覽</td>
                  <td>
                    <asp:Label ID="Total_View" runat="server" Text=""></asp:Label>1200
                  </td>
                </tr>
                <tr>
                  <td>累計喜歡</td>
                  <td>1200</td>
                </tr>
              </tbody>
            </table>--%>
            <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT '累計瀏覽' AS t, COUNT(ul.Id) AS c FROM UserLog AS ul LEFT OUTER JOIN Article AS a ON a.Id = ul.Modify_Id WHERE (ul.Modify_Table = 'Article') AND (ul.Modify_Action = 'View') AND (a.User_Id = @uid)">
              <SelectParameters>
                <asp:QueryStringParameter QueryStringField="confirm" Name="uid"></asp:QueryStringParameter>

              </SelectParameters>
            </asp:SqlDataSource>
          </div>

          <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
          <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
              <div class="item">
                <div class="content">
                  <div class="ui fluid icon input">
                    <i class="search icon"></i>
                    <asp:TextBox ID="Article_Search" runat="server" placeholder="搜尋..." AutoPostBack="true" OnTextChanged="Article_Search_TextChanged"></asp:TextBox>
                  </div>
                </div>
              </div>
              <div class="hidden item">
                <div class="content">
                  <span class="header">文章分類</span>
                  <div class="ui list">
                    <div class="item">
                      <i class="tag icon" style="vertical-align: middle;"></i>
                      <div class="content">
                        測試
                        <div class="ui mini right floated label">1</div>
                      </div>
                    </div>
                    <div class="item">
                      <i class="tag icon" style="vertical-align: middle;"></i>
                      <div class="content">
                        兔兔
                        <div class="ui mini right floated label">2</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </ContentTemplate>
          </asp:UpdatePanel>
        </div>
      </div>
      <div class="eleven wide column">
        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
          <ContentTemplate>
            <asp:ListView ID="ListView1" runat="server" DataKeyNames="Id" DataSourceID="SqlDataSource3" Visible="true">
              <EmptyDataTemplate>
                尚無發布任何文章
              </EmptyDataTemplate>
              <LayoutTemplate>
                <div class="ui three doubling centered cards">
                  <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
                </div>
              </LayoutTemplate>
              <ItemTemplate>
                <a class="ui link card" title="在前端瀏覽報導" href='News_Info.aspx?article_Id=<%# Eval("Id") %>'>
                  <div class="image" style="/*width: 120px; */">
                    <div class="long square">
                      <img class="lazy" data-src='Image.aspx?ID=<%# Eval("Front_Img_Id") %>'>
                    </div>
                  </div>
                  <div class="squeeze content" style="position: relative;">
                    <div class="header"><%# Eval("Title") %></div>
                    <div class="meta">
                      <span class="right floated time"><%# Eval("DateTime") %></span>
                      <div class="category">
                        <%--<div class="ui multiple disabled tagged dropdown">
                      <asp:HiddenField ID="Category_HF" runat="server" Value='<%# Eval("Category") %>' />
                      <div class="default text">Category</div>
                      <div class="menu">
                        <asp:Repeater ID="Category_R" runat="server" DataSourceID="SqlDataSource3">
                          <ItemTemplate>
                            <div class="item" data-value='<%# Eval("Id") %>'><%# Eval("Name") %></div>
                          </ItemTemplate>
                        </asp:Repeater>
                        <asp:SqlDataSource runat="server" ID="SqlDataSource3" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT * FROM [Menu]"></asp:SqlDataSource>
                      </div>
                    </div>--%>
                      </div>
                    </div>
                    <div class="description">
                      <p></p>
                    </div>
                    <div class="extra content ui three column grid" style="margin: 0;">
                      <div class="ui sixteen wide fitted column pv-0 divider" style="padding: 0;"></div>
                      <div class="column center aligned author">
                        <i class="share square icon"></i>
                        0
                      </div>
                      <div class="column center aligned author">
                        <i class="user friends icon"></i>
                        <%# Eval("cnt") %>
                      </div>
                      <div class="column center aligned author">
                        <i class="comment alternate icon"></i>
                        0
                      </div>
                    </div>
                  </div>
                </a>
              </ItemTemplate>
            </asp:ListView>
            <div class="ui basic center aligned segment">
            <asp:DataPager ID="DataPager1" runat="server" PageSize="9" PagedControlID="ListView1">
              <Fields>
                <asp:NextPreviousPagerField ButtonType="Link" ButtonCssClass="icon item" ShowFirstPageButton="True" ShowNextPageButton="False" FirstPageText="<i class='angle double left icon'></i>" ShowPreviousPageButton="False"></asp:NextPreviousPagerField>
                <asp:NextPreviousPagerField ButtonType="Link" ButtonCssClass="icon item" ShowFirstPageButton="False" ShowNextPageButton="False" PreviousPageText="<i class='angle left icon'></i>" ShowPreviousPageButton="True"></asp:NextPreviousPagerField>
                <asp:NumericPagerField ButtonType="Link" NumericButtonCssClass="item" CurrentPageLabelCssClass="active item"></asp:NumericPagerField>
                <asp:NextPreviousPagerField ButtonType="Link" ButtonCssClass="icon item" ShowLastPageButton="False" ShowNextPageButton="True" NextPageText="<i class='angle right icon'></i>" ShowPreviousPageButton="False"></asp:NextPreviousPagerField>
                <asp:NextPreviousPagerField ButtonType="Link" ButtonCssClass="icon item" ShowLastPageButton="True" ShowNextPageButton="False" LastPageText="<i class='angle double right icon'></i>" ShowPreviousPageButton="False"></asp:NextPreviousPagerField>
              </Fields>
            </asp:DataPager></div>
            <asp:SqlDataSource runat="server" ID="SqlDataSource3" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>'
              SelectCommand="SELECT Title, Category, Format(DateTime, 'yyyy/MM/dd tthh:mm') AS DateTime, Status, Recommand_Category, a.Id, Front_Img_Id, count(ul.Id) as cnt FROM Article a LEFT JOIN UserLog ul on ul.Modify_Id = a.Id and ul.Modify_Table = 'Article' and ul.Modify_Action = 'View' LEFT JOIN User_Url uu ON uu.User_Id = a.User_Id WHERE (uu.Url = @uurl) and a.User_Id = @uid and a.Status = '1' GROUP BY TItle,Category,DateTime,Status,Recommand_Category,a.Id,Front_Img_Id order by DateTime Desc">
              <SelectParameters>
                <asp:Parameter Name="uurl"></asp:Parameter>
                <asp:Parameter Name="uid"></asp:Parameter>
              </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource runat="server" ID="Sql3" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT Title, Category, Format(DateTime, 'yyyy/MM/dd tthh:mm') AS DateTime, Status, Recommand_Category, a.Id, Front_Img_Id, count(ul.Id) as cnt FROM Article a LEFT JOIN UserLog ul on ul.Modify_Id = a.Id and ul.Modify_Table = 'Article' and ul.Modify_Action = 'View' LEFT JOIN User_Url uu ON uu.User_Id = a.User_Id WHERE (uu.Url = @uurl) and a.User_Id = @uid and a.Status = '1' and (Title like '%' + @search + '%' OR Keyword like '%' + @search + '%') GROUP BY TItle,Category,DateTime,Status,Recommand_Category,a.Id,Front_Img_Id">
              <SelectParameters>
                <asp:Parameter Name="uurl"></asp:Parameter>
                <asp:Parameter Name="uid"></asp:Parameter>
                <asp:Parameter Name="search"></asp:Parameter>
              </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="select Title, Category, Format(DateTime, 'yyyy/MM/dd tthh:mm') AS DateTime, Status, Recommand_Category
, a.Id, Front_Img_Id, COUNT(ul.Id) as cnt from article a left join Member m on m.Id = a.User_Id
left join UserLog ul on ul.Modify_Id = a.Id and ul.Modify_Table = 'Article' and ul.Modify_Action = 'View' where m.IsAdmin = 0 and a.Status = 1
group by Title, Category, DateTime, Status, Recommand_Category, a.Id, Front_Img_Id order by DateTime Desc"></asp:SqlDataSource>
          </ContentTemplate>
        </asp:UpdatePanel>
      </div></div>
    </div>
  </div>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-animateNumber/0.0.14/jquery.animateNumber.min.js"
    integrity="sha512-WY7Piz2TwYjkLlgxw9DONwf5ixUOBnL3Go+FSdqRxhKlOqx9F+ee/JsablX84YBPLQzUPJsZvV88s8YOJ4S/UA=="
    crossorigin="anonymous"></script>
  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.9/jquery.lazy.min.js"></script>
  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.9/jquery.lazy.plugins.min.js"></script>
  <script>
    $('.image:has(.image[src=""])').css('background', 'lightblue');
    $('.lazy').Lazy({
      effect: "fadeIn",
      effectTime: 1000,
      threshold: 0
    });

    var prm = Sys.WebForms.PageRequestManager.getInstance();
    prm.add_endRequest(function () {
      $('#<%= DataPager1.ClientID %>').addClass('ui pagination menu');
      $('#<%= DataPager1.ClientID %>').html(function (i, html) {
        return html.replace(/&nbsp;/g, '');
      });
      $('#<%= DataPager1.ClientID %> .item').each(function (i) {
        console.log($(this))
        if ($(this).hasClass('aspNetDisabled') || $(this).attr('disabled') != null) $(this).removeClass('aspNetDisabled').addClass('disabled');
      })
    })

    $('#<%= DataPager1.ClientID %>').addClass('ui pagination menu');
    $('#<%= DataPager1.ClientID %>').html(function (i, html) {
      return html.replace(/&nbsp;/g, '');
    });
    $('#<%= DataPager1.ClientID %> .item').each(function (i) {
      console.log($(this))
      if ($(this).hasClass('aspNetDisabled') || $(this).attr('disabled') != null) $(this).removeClass('aspNetDisabled').addClass('disabled');
    })

    if ($(window).width() < 1200) {
      $('#<%= P_Img.ClientID %>').parent('.square').parent('.ui.image').removeClass('small mini').addClass('tiny')
    }
    <%--if ($(window).width() < 991) {
      $('#<%= P_Img.ClientID %>').parent('.square').parent('.ui.image').removeClass('small tiny').addClass('mini')
    }--%>
    $(window).on('resize', function () {
      if ($(window).width() >= 1200) {

        $('#<%= P_Img.ClientID %>').parent('.square').parent('.ui.image').removeClass('tiny mini').addClass('small')
      }
      if ($(window).width() < 1200) {
        $('#<%= P_Img.ClientID %>').parent('.square').parent('.ui.image').removeClass('small mini').addClass('tiny')
      }
      <%--if ($(window).width() < 991) {
        $('#<%= P_Img.ClientID %>').parent('.square').parent('.ui.image').removeClass('small tiny').addClass('mini')
      }--%>
    })
  </script>
</asp:Content>
