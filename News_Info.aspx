<%@ Page Title="" Language="C#" MasterPageFile="ClientPage.Master" AutoEventWireup="true" CodeFile="News_Info.aspx.cs" Inherits="piNews.News_Info" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta property="og:url" content='<%= Request.Url.AbsoluteUri %>' />
    <meta property="og:type" content="article" />
    <meta id="og_title" runat="server" property="og:title" />
    <%--<meta id="og_description" property="og:description" />--%>
    <meta id="og_img" runat="server" property="og:image" />
    <meta id="keyword" runat="server" name="keywords" />
    <meta id="news_keyword" runat="server" name="news_keywords" />

    <meta property="fb:app_id" content="780152909217089" />
    <style>
        #preview {
            word-wrap: break-word;
        }

        .ui.ad .content .header span {
            overflow: hidden;
            text-overflow: ellipsis;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            display: -webkit-box;
            width: calc( 100% - 2rem );
        }

        .ui.ad .content .meta {
            overflow: hidden;
            text-overflow: ellipsis;
            -webkit-line-clamp: 1;
            -webkit-box-orient: vertical;
            display: -webkit-box;
        }
    </style>
    <script data-ad-client="ca-pub-7266289617887477" async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
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
                    <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSource3">
                        <ItemTemplate>
                            <div class="active section"><%# Eval("Name") %></div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:SqlDataSource runat="server" ID="SqlDataSource3" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT * FROM [Menu] WHERE ([Id] = @Id)">
                        <SelectParameters>
                            <asp:QueryStringParameter QueryStringField="id" Name="Id" Type="Int32"></asp:QueryStringParameter>
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
            </div>
        </div>
    </div>
    <div id="main" class="ui container">
        <h1 class="ui header">
            <asp:Label ID="Title_Label" runat="server"></asp:Label></h1>
        <div id="article" class="ui grid container">
            <div class="two column doubling row">
                <div class="eleven wide column">
                    <div class="top-show">
                        <div class="ui segment">
                            <div class="ui centered image">
                                <asp:Image ID="Front_Image" CssClass="ui centered image" runat="server" />
                                <%--<img src="http://www.pinews.com.tw/upload/post/images/120210427150639.JPG">--%>
                            </div>
                        </div>
                        <div id="preview">
                            <asp:Literal ID="Content_Literal" runat="server"></asp:Literal>
                            <%--<asp:Panel ID="Content_Panel" runat="server"></asp:Panel>--%>
                            <%--<p>
              <span style="color: #990000;"><span style="font-size: 14px;"><span
                style="font-family: 微軟正黑體;">▲新北板橋觀護協會桃園一日遊合影。(圖一/新北板橋觀護協會提供）</span></span></span><br>
              <br>
              <span style="color: #000000;"><span style="font-size: 20px;"><span style="font-family: 微軟正黑體;">新北市板橋觀護協會
                      支持國旅提振台灣觀光</span></span></span>
            </p>

            <p>
              <span style="font-size: 18px;"><span style="color: #000000;"><span
                style="font-family: 微軟正黑體;">【拍新聞/記者朱育申/桃園報導〕</span></span></span>
            </p>

            <p>
              <span style="font-size: 18px;"><span style="color: #000000;"><span
                style="font-family: 微軟正黑體;">全球疫情衝擊趨緩新北板橋觀護協會，繼去年苗栗秋季旅遊後，再次支持台灣觀光旅遊產業，於4月24日由理事長洪振成率團58人，再度組團發起桃園一日活動，此次行程由執行秘書等人規劃，重點參觀包含郭元益糕餅博物館觀光工廠、埔心牧場園區樂活休閒體驗烤肉活動及餐廳聯誼美食聚會..等。隨著COVID-19疫情衝擊，旅遊、觀光、伴手禮、美食餐廳產業顯然是直接且嚴重的受害者，新北板橋觀護協會為了促進會員友誼及用實際行動支持國民旅遊，安排此次桃園一日遊活動，洪理事長特別用心在埔心牧場園區內，邀請＂那卡西＂樂團表演唱曲舞蹈，把氣氛炒到最高點，隨後參訪桃園楊梅知名郭元益糕餅博物館參訪，體驗學習精緻糕餅製作過程，隨後回到中和鵝肉大王海鮮餐廳餐聚，一路上笑聲不斷讓所有會員度過美麗愉快的一天。</span></span></span><br>
              &nbsp;
            </p>

            <p>
              <span style="color: #000000;"><span style="font-size: 14px;"><span style="font-family: 微軟正黑體;">
                <img alt=""
                  class="ui image" src="http://www.pinews.com.tw/upload/ckeditor/images/141674.jpg"
                  style=""></span></span></span><span style="color: #990000;"><span style="font-size: 14px;"><span
                    style="font-family: 微軟正黑體;">▲新北板橋觀護協會桃園一日遊合影。(圖二/新北板橋觀護協會提供）</span></span></span><br>
              <br>
              <span style="font-size: 18px;"><span style="color: #000000;"><span
                style="font-family: 微軟正黑體;">洪振成理事長表示：規劃此次活動參與人數相當踴躍，原本預計安排一台遊覽車40人，因人數暴增後續又再追加一台中型巴士，其中更要感謝協會裡多位顧問支持贊助，讓這次活動內容更豐富聲勢更加壯大，新北市板橋觀護協會是個充滿歡樂與友善的單位，從平日活動就可看出夥伴的向心力，愛笑、愛喝，愛玩，特愛玩……桌遊，互信、互助各個都是以良善為出發點，在協會裡的會員各個都是臥虎藏龍，歡迎各界好友，加入新北市板橋觀護協會，讓我們一起共創美好的明天。</span></span></span>
            </p>

            <p>
              <span style="font-size: 18px;"><span style="color: #000000;"><span style="font-family: 微軟正黑體;">關鍵字:
                      新北板橋觀護協會、郭元益糕餅、洪振成、埔心牧場、支持國旅</span></span></span>
            </p>

            <p>&nbsp;</p>--%>
                        </div>
                        <div class="ui fitted basic segment center aligned fluid card">
                            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                            <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <asp:ListView ID="ListView2" runat="server" DataKeyNames="ip" DataSourceID="SqlDataSource6" OnItemCommand="ListView2_ItemCommand">
                                        <ItemTemplate>
                                            <div class="ui statistic">
                                                <asp:LinkButton ID="LinkButton2" ClientIDMode="AutoID" CssClass="value" OnClientClick="javascript: setTimeout(function () {return true;}, 500);" CommandName="likely" runat="server"><i class='heart<%# Eval("ip").Equals(0) ? " outline":"" %> blue like icon'></i></asp:LinkButton>
                                                <%--<i class="heart outline like icon"></i>--%>
                                                <span class="label" style="">最愛人氣<br />
                                                    <%# Eval("cnt") %> likes</span>
                                            </div>
                                        </ItemTemplate>
                                    </asp:ListView>
                                    <asp:SqlDataSource runat="server" ID="SqlDataSource6" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="select IsNull(count(act),0) as cnt, IsNull(count(case when (IP = @ip and act = 'like') then 'true' else null end),0) as ip from (select Operate_User_IP as IP, case when Modify_Action = 'like' then 'like' else null end as act, ROW_NUMBER() OVER (PARTITION BY Operate_User_IP ORDER BY Operate_Time DESC) AS rn from UserLog where (Modify_Action='like' or Modify_Action='unlike') and Modify_Id = @aid) a where rn = 1">
                                        <SelectParameters>
                                            <asp:SessionParameter SessionField="IP" Name="ip"></asp:SessionParameter>
                                            <asp:QueryStringParameter QueryStringField="article_id" Name="aid"></asp:QueryStringParameter>
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </ContentTemplate>
                            </asp:UpdatePanel>

                        </div>
                        <div class="ui fitted basic segment fluid card">
                            <div class="content">
                                關鍵字
              <span class="right floated"></span>
                                <asp:Repeater ID="Keyword_Repeater" runat="server">
                                    <ItemTemplate>
                                        <div class="ui yellow tiny label"><%# Container.DataItem %></div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                        <div class="fb-comments" data-href='<%= Request.Url.AbsoluteUri %>' data-width="100%" data-numposts="5"></div>
                    </div>
                </div>
                <div id="recommanded" class="ui five wide pl-0 column">
                    <div class="ui sticky bottom-show">

                        <div class="ui unstackable items">
                            <div id="post_statistic" class="item">
                                <div class="content ui three column grid">
                                    <div class="row">
                                        <div class="center aligned middle aligned seven wide column" style="padding: 0;">
                                            <div class="ui small statistic">
                                                <asp:Repeater ID="ClickRate_Repeater" runat="server" DataSourceID="SqlDataSource2">
                                                    <ItemTemplate>
                                                        <div class="cntdown value">
                                                            <%# Eval("Vi") %>
                                                        </div>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                                <%--<div class="cntdown value">
                        2204
                      </div>--%>
                                                <asp:SqlDataSource runat="server" ID="SqlDataSource2" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT count(*) as Vi FROM [UserLog] WHERE (([Modify_Action] = @Modify_Action) AND ([Modify_Id] = @Modify_Id))">
                                                    <SelectParameters>
                                                        <asp:Parameter DefaultValue="View" Name="Modify_Action" Type="String"></asp:Parameter>
                                                        <asp:QueryStringParameter QueryStringField="article_id" Name="Modify_Id" Type="Int32"></asp:QueryStringParameter>
                                                    </SelectParameters>
                                                </asp:SqlDataSource>
                                                <div class="label">
                                                    瀏覽
                                                </div>
                                            </div>
                                        </div>
                                        <%--<div class="center aligned middle aligned eight wide column" style="padding: 0;">
                      <div class="fb-like" data-href='<%= Request.Url.AbsoluteUri %>' data-width="50"
                        data-layout="button_count" data-action="like" data-size="large" data-share="true">
                      </div>
                    </div>--%>
                                        <div class="center aligned middle aligned five wide column" style="padding: 0;">
                                            <div class="fb-like" data-href='<%= Request.Url.AbsoluteUri %>' data-width="50"
                                                data-layout="button_count" data-action="like" data-size="large" data-share="false">
                                            </div>
                                        </div>
                                        <div class="center aligned middle aligned four wide column" style="padding: 0;">
                                            <div class="fb-share-button" data-href='<%= Request.Url.AbsoluteUri %>'
                                                data-layout="button" data-size="large">
                                                <a target="_blank"
                                                    href='https://www.facebook.com/sharer/sharer.php?u=<%= (Request.Url.AbsoluteUri) %>&amp;src=sdkpreparse' class="fb-xfbml-parse-ignore">分享</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="item">
                                <div class="flex content">
                                </div>
                            </div>
                            <div class="item">

                                <div class="image">
                                    <div class="square">
                                        <asp:Image ID="Article_Img" CssClass="ui image" runat="server" />
                                        <span class="no-img">No Image</span>
                                    </div>
                                </div>

                                <div class="content">
                                    <a id="Article_name" class="header" runat="server"></a>
                                    <div class="meta">
                                        <span id="Article_joindate" runat="server"></span>
                                        <asp:Label ID="fan_post_tag" runat="server" Text=""></asp:Label>
                                    </div>
                                    <div class="description">
                                        <p>
                                            <%--樸實認真--%>
                                        </p>
                                        <div class="ui horizontal mini statistic">
                                            <div class="content">
                                                <a id="Number_of_reports" runat="server"></a>
                                            </div>
                                            <div class="label">
                                                篇報導
                                            </div>
                                        </div>
<%--                                        <div class="extra">
                                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                                <ContentTemplate>
                                                    <asp:ListView ID="ListView1" runat="server" DataKeyNames="Modify_Action,User_Id" DataSourceID="SqlDataSource4" OnItemDataBound="ListView1_ItemDataBound" OnItemCommand="ListView1_ItemCommand">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="unfollow_btn1" runat="server" CssClass='ui yellow icon button' CommandName="Unfollow" Visible='<%# Eval("Modify_Action").Equals("follow") %>'><i class="user times icon"></i> 取消追蹤</asp:LinkButton>
                                                            <asp:LinkButton ID="Follow_btn1" runat="server" CssClass='ui primary icon button' OnClick="Follow_btn_Click" Visible='<%# Eval("Modify_Action").Equals("unfollow") ? true:false %>'><i class="user plus icon"></i> 追蹤</asp:LinkButton>
                                                        </ItemTemplate>
                                                        <EmptyDataTemplate>
                                                        </EmptyDataTemplate>
                                                    </asp:ListView>
                                                    <asp:LinkButton ID="Follow_btn" runat="server" CssClass="ui primary icon button" OnClick="Follow_btn_Click" Visible='<%# ListView1.Items.Count <= 0 %>'><i class="user plus icon"></i> 追蹤</asp:LinkButton>

                                                    <asp:SqlDataSource runat="server" ID="SqlDataSource4" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT TOP (1) ul.Modify_Action, a.User_Id FROM UserLog AS ul LEFT OUTER JOIN Article AS a ON a.User_Id = ul.Modify_Id WHERE (ul.Operate_User_Id = @uid) AND (ul.Modify_Action = 'follow' OR ul.Modify_Action = 'unfollow') AND (a.Id = @aid) ORDER BY ul.Operate_Time DESC">
                                                        <SelectParameters>
                                                            <asp:SessionParameter SessionField="User_Id" Name="uid"></asp:SessionParameter>
                                                            <asp:QueryStringParameter QueryStringField="article_id" Name="aid"></asp:QueryStringParameter>
                                                        </SelectParameters>
                                                    </asp:SqlDataSource>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </div--%>>
                                    </div>
                                    <div class="extra">
                                        <!-- <div class="fb-share-button" data-href="http://www.pinews.com.tw/index.asp" data-layout="button_count"
                    data-size="small"><a target="_blank"
                      href="https://www.facebook.com/sharer/sharer.php?u=http%3A%2F%2Fwww.pinews.com.tw%2Findex.asp&amp;src=sdkpreparse"
                      class="fb-xfbml-parse-ignore">分享</a></div>
                  <div class="fb-like" data-href="http://www.pinews.com.tw/index.asp" data-width="70"
                    data-layout="button_count" data-action="like" data-size="small" data-share="false"></div> -->
                                    </div>
                                </div>
                            </div>
                        </div>


                        <a class="ui med-small centered image" href="/News/all/week/time">
                            <img class="lazy" data-src="img/weeknews.png">
                        </a>
                        <div class="ui link unstackable items">
                            <asp:Repeater ID="Article_Repeater" runat="server" DataSourceID="SqlDataSource1">
                                <ItemTemplate>
                                    <a class="item" href='/News/Info/<%# Eval("Id") %>'>
                                        <div class="ui tiny image">
                                            <div class="long border square">
                                                <img class="lazy" data-src='Image.aspx?ID=<%# Eval("Front_Img_Id") %>'>
                                            </div>
                                        </div>
                                        <div class="content">
                                            <h4 class="ui header"><%# Eval("Title") %></h4>
                                        </div>
                                    </a>
                                </ItemTemplate>
                            </asp:Repeater>
                            <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT Top 5 Id, Title, Front_Img_Id FROM [Article]  where status = 1 order by DateTime Desc"></asp:SqlDataSource>

                            <%--<div class="item">
              <div class="ui tiny image">
                <div class="long border square">
                  <img src="http://www.pinews.com.tw/upload/post/images/120210505192358.JPG">
                </div>
              </div>
              <div class="content">
                <h4 class="ui header">為讓父母過上好生活 　余月如白手起家二年創立千萬企業</h4>
              </div>
            </div>
            <div class="item">
              <div class="ui tiny image">
                <div class="long border square">
                  <img src="http://www.pinews.com.tw/upload/post/images/120210511160025.JPG">
                </div>
              </div>
              <div class="content">
                <h4 class="ui header">歡喜來相逢俱樂部社團嚴振祥團長 助全盲林佩貞妹妹圓音樂夢</h4>
              </div>
            </div>
            <div class="item">
              <div class="ui tiny image">
                <div class="long border square">
                  <img src="http://www.pinews.com.tw/upload/post/images/120210505192358.JPG">
                </div>
              </div>
              <div class="content">
                <h4 class="ui header">為讓父母過上好生活 　余月如白手起家二年創立千萬企業</h4>
              </div>
            </div>
            <div class="item">
              <div class="ui tiny image">
                <div class="long border square">
                  <img src="http://www.pinews.com.tw/upload/post/images/120210511160025.JPG">
                </div>
              </div>
              <div class="content">
                <h4 class="ui header">歡喜來相逢俱樂部社團嚴振祥團長 助全盲林佩貞妹妹圓音樂夢</h4>
              </div>
            </div>
            <div class="item">
              <div class="ui tiny image">
                <div class="long border square">
                  <img src="http://www.pinews.com.tw/upload/post/images/120210505192358.JPG">
                </div>
              </div>
              <div class="content">
                <h4 class="ui header">為讓父母過上好生活 　余月如白手起家二年創立千萬企業</h4>
              </div>
            </div>--%>
                        </div>
                        <div class="fb-page" data-href="https://www.facebook.com/pinews.tw/" data-tabs="" data-width=""
                            data-height="" data-small-header="false" data-adapt-container-width="true" data-hide-cover="true"
                            data-show-facepile="false">
                            <blockquote cite="https://www.facebook.com/pinews.tw/" class="fb-xfbml-parse-ignore">
                                <a href="https://www.facebook.com/pinews.tw/">拍新聞</a>
                            </blockquote>
                        </div>
                        <asp:Repeater ID="Repeater2" runat="server" DataSourceID="SqlDataSource5">
                            <ItemTemplate>
                                <div id="right-banner" class="ui card centered medium rectangle test ad" data-show-title='<%# Eval("Show_T").Equals(true) ? "true":"false" %>' style="padding: 0;">
                                    <i class="right floated inverted close icon" style="margin: .2rem; z-index: 1; position: absolute; top: 0; left: 0;"></i>
                                    <a class='<%# Eval("Show_T").Equals(true)?"blurring dimmable ":"" %>image' href='<%# Eval("link") %>' target="_blank">
                                        <div class="ui inverted center dimmer">
                                            <div class="content">
                                                <div class="center">
                                                    <div class="ui header"><%# Eval("Title") %></div>
                                                </div>
                                            </div>
                                        </div>
                                        <img class="ui medium image" src='Image.aspx?Id=<%# Eval("Img_Id") %>'>
                                    </a>
                                    &nbsp;
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:SqlDataSource runat="server" ID="SqlDataSource5" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT [Img_Id], [Link], [Title], [Show_T] FROM [Advertisement] WHERE ([Type] = @Type)">
                            <SelectParameters>
                                <asp:Parameter DefaultValue="sidebar square" Name="Type" Type="String"></asp:Parameter>
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <div id="fb-root"></div>
    <script async defer crossorigin="anonymous" src="https://connect.facebook.net/zh_TW/sdk.js#xfbml=1&version=v12.0&appId=780152909217089&autoLogAppEvents=1" nonce="N1ObBPhz"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-animateNumber/0.0.14/jquery.animateNumber.min.js"
        integrity="sha512-WY7Piz2TwYjkLlgxw9DONwf5ixUOBnL3Go+FSdqRxhKlOqx9F+ee/JsablX84YBPLQzUPJsZvV88s8YOJ4S/UA=="
        crossorigin="anonymous"></script>
    <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.9/jquery.lazy.min.js"></script>
    <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.9/jquery.lazy.plugins.min.js"></script>
    <script>
        $('.lazy').each(function () {
            console.log($(this).attr('data-src'))
            if (!($(this).attr('data-src').match("^/") || $(this).attr('data-src').match("^http"))) {
                $(this).attr('data-src', '/' + $(this).attr('data-src'))
            }

            console.log('done', $(this).data('src'))
        })

        $('.ui.centered.ad:empty').each(function () {
            var $el = $(this)
            $el.removeClass('test').addClass('card')
            $el.append(
                $('<div />', {
                    class: 'image',
                    style: 'height: unset;'
                }).append(
                    $('<a />', {
                        class: 'long square' + ($el.attr('data-id') && $el.attr('data-source') ? ' hidden' : ' block'),
                        target: '_blank',
                        href: $el.attr('data-href')
                    }).append(
                        $('<img />', {
                            class: 'ui medium image',
                            src: $el.attr('data-img')
                        })
                    )
                ).append(
                    $('<div />', {
                        class: 'ui embed' + ($el.attr('data-id') && $el.attr('data-source') ? '' : ' hidden'),
                        'data-id': $el.attr('data-id'),
                        'data-source': $el.attr('data-source')
                    })
                )
            )
            $el.append(
                $('<a />', {
                    class: 'left aligned content',
                    target: '_blank',
                    href: $el.attr('data-href')
                }).append(
                    $('<div />', {
                        class: 'header',
                        html: $el.attr('data-header')
                    })
                ).append(
                    $('<div />', {
                        class: 'meta',
                        html: $el.attr('data-meta')
                    })
                )
            )

            if ($el.attr('data-id') && $el.attr('data-source')) {
                $el.children('.image').children('.ui.embed').embed({
                    source: $el.attr('data-source'),
                    id: $el.attr('data-id'),
                    autoplay: true,
                    parameters: {
                        rel: 0,
                        autoplay: 1,
                        loop: 1,
                        playlist: $el.attr('data-id'),
                        mute: 1,
                        autohide: 1,
                        showinfo: 0,
                        controls: 0,
                        modestbranding: 1
                    }
                })
            }
        })

        $('#article .ui.image').each(function () {
            console.log($(this).attr('src'))
            if ($(this).attr('src') != "" && $(this).attr('src') != undefined) {
                if (!($(this).attr('src').match("^/") || $(this).attr('src').match("^http"))) {
                    $(this).attr('src', '/' + $(this).attr('src'))
                }
            }

            console.log('done', $(this).data('src'))
        })
        $('.lazy').Lazy({
            effect: "fadeIn",
            effectTime: 1000,
            threshold: 0,
            onFinishedAll: function () {
                if ($(window).outerWidth() >= 768) {
                    $('#recommanded .ui.sticky').sticky({
                        context: '#recommanded',
                        offset: $('.ui.sticky.menu').height(),
                        pushing: false,
                        onTop: function () {
                            console.log('t')
                        },
                        onBottom: function () {
                            console.log('b')
                            $('#recommanded .ui.sticky').css('margin-top', 0)
                            $('#recommanded .ui.sticky').width($('#recommanded').width())
                        }
                    })
                }
            }
        });
        $('#preview .ui.embed:empty').embed();

        //$(".fb-like iframe").on("load", function () {
        //  let head = $(this).contents().find("head");
        //  let css = '<style>table { margin: 0 auto; }</style>';
        //  $(head).append(css);
        //});

        $('.fitted.basic.card .heart.like').on('click', function () {
            if ($(this).hasClass('outline'))
                $(this).removeClass('outline').transition('jiggle')
            else $(this).addClass('outline').transition('pulse')
        })
    </script>
</asp:Content>
