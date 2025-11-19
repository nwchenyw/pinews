<%@ Page Title="" Language="C#" MasterPageFile="ClientPage.Master" AutoEventWireup="true" CodeFile="News.aspx.cs" Inherits="piNews.News" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <meta property="og:url" content='<%= Request.Url.AbsoluteUri %>' />
  <meta property="og:type" content="website" />
  <meta id="org_title" runat="server" property="og:title" />
  <meta property="og:description" content="How much does culture influence creative thinking?" />
  <meta id="org_img" runat="server" property="og:image" />
  <meta id="keyword" runat="server" name="keywords" />
  <%--<script data-ad-client="ca-pub-7266289617887477" async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>--%>
  <style>
    .ui.ad {
      max-width: 100% !important;
    }

    /*.item .meta {
      display: table;
      width: 100%;
    }*/
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <span></span>
  <div class="ui feed container">
    <div class="event">
      <div class="label">
        <i class="history icon"></i>
      </div>
      <div class="content">
        <div class="ui breadcrumb">
          <a class="section" href="/Home">首頁</a>
          <div class="divider">/ </div>
          <asp:Repeater ID="Repeater2" runat="server" DataSourceID="SqlDataSource2" OnItemDataBound="Repeater2_ItemDataBound">
            <ItemTemplate>
              <div class="active section"><%# Eval("Name") %></div>
            </ItemTemplate>
          </asp:Repeater>
          <asp:SqlDataSource ID="SqlDataSource7" runat="server" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT [Category_Name] as Name FROM [Recommendation] WHERE ([Id] = @Id)">
            <SelectParameters>
              <asp:RouteParameter RouteKey="cat" Name="Id"></asp:RouteParameter>
            </SelectParameters>
          </asp:SqlDataSource>
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
    <div id="article" class="ui stackable grid container">
      <div id="article-list" class="eleven wide column">
        <div class="ui unstackable divided link items">
          <asp:ListView ID="ListView1" runat="server" DataSourceID="SqlDataSource1">
            <LayoutTemplate>
              <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
              <%--<div class="ui pagination menu">--%>
              <%--</div>--%>
            </LayoutTemplate>
            <ItemTemplate>
              <a class="top-show item" href='<%# GetRouteUrl("NewsInfoRoute", new { ArticleId = Eval("Id") }) %>'>
                <div class="ui medium image">
                  <div class="long border square">
                    <img class="lazy" data-src='/Image.aspx?ID=<%# Eval("Front_Img_Id") %>'>
                  </div>
                </div>
                <div class="content">
                  <h4 class="ui header"><%# Eval("Title") %></h4>
                  <div class="meta">
                    <%# Eval("Author") %>
                    <span class="ui right floated label"><i class="calendar icon"></i>
                      <span class="category"><%# Eval("time") %></span></span>
                  </div>
                  <div class="description">
                    <p><%# Eval("Description") %></p>
                  </div>
                </div>
              </a>
            </ItemTemplate>
            <EditItemTemplate>
              目前尚無任何資訊><
            </EditItemTemplate>
            <EmptyDataTemplate>
              目前尚無任何資訊><
            </EmptyDataTemplate>
          </asp:ListView>
          <asp:SqlDataSource ID="SqlDataSource6" runat="server" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT a.Id, a.Title, format(a.DateTime, 'yyyy/MM/dd tthh:mm') AS time, a.Author, a.Author_Email, a.Front_Img_Id, m.Member_Img_Id, a.description FROM Article AS a LEFT OUTER JOIN Member AS m ON m.UserId = a.Author_Email WHERE (a.Recommand_Category LIKE '%' + @Recommand_Category + '%') AND (a.Status = 1) ORDER BY DateTime DESC">
            <SelectParameters>
              <asp:RouteParameter RouteKey="cat" Name="Recommand_Category" Type="String"></asp:RouteParameter>
            </SelectParameters>
          </asp:SqlDataSource>
          <asp:SqlDataSource runat="server" ID="SqlDataSource5" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT Id, Front_Img_Id, Title, Description, Author, Format(DateTime, 'yyyy-MM-dd') AS time FROM Article WHERE (Title LIKE '%' + @search + '%' OR Keyword LIKE '%' + @search + '%' OR Author LIKE '%'+ @search +'%') AND (Status = 1) ORDER BY DateTime DESC">
            <SelectParameters>
              <asp:Parameter Name="search"></asp:Parameter>

            </SelectParameters>
          </asp:SqlDataSource>
          <div class="ui basic center aligned segment">
            <asp:DataPager ID="DataPager1" runat="server" PageSize="6" PagedControlID="ListView1">
              <Fields>
                <asp:NextPreviousPagerField ButtonType="Link" ButtonCssClass="icon item" ShowFirstPageButton="True" ShowNextPageButton="False" FirstPageText="<i class='angle double left icon'></i>" PreviousPageText="<i class='angle left icon'></i>" ShowPreviousPageButton="True"></asp:NextPreviousPagerField>
                <asp:NumericPagerField ButtonType="Link" NumericButtonCssClass="item" NextPreviousButtonCssClass="item" CurrentPageLabelCssClass="active item"></asp:NumericPagerField>
                <asp:NextPreviousPagerField ButtonType="Link" ButtonCssClass="icon item" ShowLastPageButton="True" ShowNextPageButton="True" NextPageText="<i class='angle right icon'></i>" LastPageText="<i class='angle double right icon'></i>" ShowPreviousPageButton="False"></asp:NextPreviousPagerField>
              </Fields>
            </asp:DataPager>
          </div>
          <%--<asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSource1">
            <ItemTemplate>
              <a class="top-show item" href='News_Info.aspx?article_id=<%# Eval("Id") %>&id=<%= Request.QueryString["id"] %>'>
                <div class="ui medium image">
                  <div class="long border square">
                    <img src='<%# Eval("File_Path") %>'>
                  </div>
                </div>
                <div class="content">
                  <h4 class="ui header"><%# Eval("Title") %></h4>
                  <div class="meta">
                    <i class="calendar icon"></i>
                    <span class="category"><%# Eval("time") %></span>
                  </div>
                </div>
              </a>
            </ItemTemplate>
          </asp:Repeater>--%>
          <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT a.Id, a.Front_Img_Id, Title, Description, case m.isAdmin when 1 then a.Author else '拍新聞聯合採訪中心' end as Author, Format(DateTime, 'yyyy-MM-dd') as time FROM [Article] a OUTER APPLY dbo.SplitString (a.Category, ',') cate left join Member m on a.User_Id = m.Id where cate.Item = @menu_id and Status = 1 ORDER BY [DateTime] DESC">
            <SelectParameters>
              <asp:QueryStringParameter QueryStringField="id" Name="menu_id"></asp:QueryStringParameter>
            </SelectParameters>
          </asp:SqlDataSource>
          <%--<div class="top-show item">
            <div class="ui medium image">
              <div class="long border square">
                <img src="http://www.pinews.com.tw/upload/post/images/120210511160025.JPG">
              </div>
            </div>
            <div class="content">
              <h4 class="ui header">歡喜來相逢俱樂部社團嚴振祥團長 助全盲林佩貞妹妹圓音樂夢</h4>
              <div class="meta">
                <i class="calendar icon"></i>
                <span class="category">2021-01-10</span>
              </div>
            </div>
          </div>
          <div class="top-show item">
            <div class="ui medium image">
              <div class="long border square">
                <img src="http://www.pinews.com.tw/upload/post/images/120210512194156.JPG">
              </div>
            </div>
            <div class="content">
              <h4 class="ui header">(直播)國內疫情進入社區感染鏈  陳時中：可能升至3級警戒</h4>
              <div class="meta">
                <i class="calendar icon"></i>
                <span class="category">2021-05-13</span>
              </div>
            </div>
          </div>
          <div class="top-show item">
            <div class="ui medium image">
              <div class="long border square">
                <img src="http://www.pinews.com.tw/upload/post/images/120210512194026.JPG">
              </div>
            </div>
            <div class="content">
              <h4 class="ui header">五股獅子會前會長例會群聚一傳十確診　LINE群組道歉貼文曝光</h4>
              <div class="meta">
                <i class="calendar icon"></i>
                <span class="category">2021-01-10</span>
              </div>
            </div>
          </div>
          <div class="top-show item">
            <div class="ui medium image">
              <div class="long border square">
                <img src="http://www.pinews.com.tw/upload/post/images/120210512194156.JPG">
              </div>
            </div>
            <div class="content">
              <h4 class="ui header">(直播)國內疫情進入社區感染鏈  陳時中：可能升至3級警戒</h4>
              <div class="meta">
                <i class="calendar icon"></i>
                <span class="category">2021-05-13</span>
              </div>
            </div>
          </div>
          <div class="top-show item">
            <div class="ui medium image">
              <div class="long border square">
                <img src="http://www.pinews.com.tw/upload/post/images/120210512194026.JPG">
              </div>
            </div>
            <div class="content">
              <h4 class="ui header">五股獅子會前會長例會群聚一傳十確診　LINE群組道歉貼文曝光</h4>
              <div class="meta">
                <i class="calendar icon"></i>
                <span class="category">2021-01-10</span>
              </div>
            </div>
          </div>--%>
        </div>
        <%--<div class="ui pagination menu">
          <a class="icon item">
            <i class='angle left icon'></i>
          </a>
          <a class="active item">1
          </a>
          <div class="disabled item">
            ...
          </div>
          <a class="item">10
          </a>
          <a class="item">11
          </a>
          <a class="item">12
          </a>
          <a class="icon item">
            <i class='angle right icon'></i>
          </a>
        </div>--%>
      </div>
      <div id="recommanded" class="ui five wide pl-0 column">
        <div class="ui bottom-show sticky">
          <a class="ui med-small centered image" href="/News/all/week/time">
            <img src="/img/weeknews.png">
          </a>
          <div class="ui unstackable link items">
            <asp:Repeater ID="Article_Repeater" runat="server" DataSourceID="SqlDataSource3">
              <ItemTemplate>
                <a class="item" href='<%# GetRouteUrl("NewsInfoRoute", new { ArticleId = Eval("Id") }) %>'>
                  <div class="ui tiny image">
                    <div class="long border square">
                      <img class="lazy" data-src='/Image.aspx?ID=<%# Eval("Front_Img_Id") %>'>
                    </div>
                  </div>
                  <div class="content">
                    <h4 class="ui header"><%# Eval("Title") %></h4>
                  </div>
                </a>
              </ItemTemplate>
            </asp:Repeater>
            <asp:SqlDataSource runat="server" ID="SqlDataSource3" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT Top 6 Id, Title, Front_Img_Id FROM [Article]  where status = 1 order by DateTime Desc"></asp:SqlDataSource>

          </div>
          <div class="fb-page" data-href="https://www.facebook.com/pinews.tw/" data-tabs="" data-width=""
            data-height="" data-small-header="false" data-adapt-container-width="true" data-hide-cover="true"
            data-show-facepile="false">
            <blockquote cite="https://www.facebook.com/pinews.tw/" class="fb-xfbml-parse-ignore">
              <a href="https://www.facebook.com/pinews.tw/">拍新聞</a>
            </blockquote>
          </div>
          <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSource4">
            <ItemTemplate>
              <div id="right-banner" class="ui card centered test ad" data-show-title='<%# Eval("Show_T").Equals(true) ? "true":"false" %>' style="padding: 0;">
                <i class="right floated inverted close icon" style="margin: .2rem; z-index: 1;position: absolute; top: 0;left:0;"></i>
                <a class='<%# Eval("Show_T").Equals(true)?"blurring dimmable ":"" %>image' href='<%# Eval("link") %>' target="_blank">
                  <div class="ui inverted center dimmer">
                    <div class="content">
                      <div class="center">
                        <div class="ui header"><%# Eval("Title") %></div>
                      </div>
                    </div>
                  </div>
                  <img class="ui medium image" src='/Image.aspx?Id=<%# Eval("Img_Id") %>'>
                </a>
              </div>
            </ItemTemplate>
          </asp:Repeater>
          <%--<div class="ui medium rectangle centered ad" data-text="Banner">
            <!-- square-ad -->
            <ins class="adsbygoogle"
              style="display: block"
              data-ad-client="ca-pub-7266289617887477"
              data-ad-slot="7273057307"
              data-ad-format="auto"
              data-full-width-responsive="true"></ins>
            <script>
              (adsbygoogle = window.adsbygoogle || []).push({});
            </script>
          </div>--%>
          <asp:SqlDataSource runat="server" ID="SqlDataSource4" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT [Img_Id], [Link], [Title], [Show_T] FROM [Advertisement] WHERE ([Type] = @Type)">
            <SelectParameters>
              <asp:Parameter DefaultValue="sidebar square" Name="Type" Type="String"></asp:Parameter>
            </SelectParameters>
          </asp:SqlDataSource>
        </div>
      </div>
    </div>
  </div>
  <div id="fb-root"></div>
  <script async defer crossorigin="anonymous" src="https://connect.facebook.net/zh_TW/sdk.js#xfbml=1&version=v10.0"
    nonce="48f42QHf"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-animateNumber/0.0.14/jquery.animateNumber.min.js"
    integrity="sha512-WY7Piz2TwYjkLlgxw9DONwf5ixUOBnL3Go+FSdqRxhKlOqx9F+ee/JsablX84YBPLQzUPJsZvV88s8YOJ4S/UA=="
    crossorigin="anonymous"></script>
  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.9/jquery.lazy.min.js"></script>
  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.9/jquery.lazy.plugins.min.js"></script>
  <script>
    $('.lazy').Lazy({
      effect: "fadeIn",
      effectTime: 1000,
      threshold: 0
    });
    $('#<%= DataPager1.ClientID %>').addClass('ui pagination menu');
    $('#<%= DataPager1.ClientID %>').html(function (i, html) {
      return html.replace(/&nbsp;/g, '');
    });
    $('#<%= DataPager1.ClientID %> .item').each(function (i) {
      console.log($(this))
      if ($(this).hasClass('aspNetDisabled') || $(this).attr('disabled') != null) $(this).removeClass('aspNetDisabled').addClass('disabled');
    })
  </script>
</asp:Content>
