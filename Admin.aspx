<%@ Page Title="" Language="C#" MasterPageFile="AdminPage.Master" AutoEventWireup="true" CodeFile="Admin.aspx.cs" Inherits="piNews.Admin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <style>
    .ui.disabled.tagged.dropdown, .ui.dropdown .menu > .disabled.item {
      opacity: 1;
    }

      .ui.disabled.tagged.dropdown .ui.label > .close.icon, .ui.disabled.tagged.dropdown .ui.label > .delete.icon {
        display: none;
      }

    .ui.card .three.grid .author {
      padding-bottom: 0;
    }

    .pusher {
      min-width: 300px !important;
    }

@media only screen and (max-width: 767.98px){
    .ui.column.grid>[class*="five wide"].column, .ui.grid>.column.row>[class*="five wide"].column, .ui.grid>.row>[class*="five wide"].column, .ui.grid>[class*="five wide"].column {
        width: 100%!important;
    }
    .ui.column.grid>[class*="eleven wide"].column, .ui.grid>.column.row>[class*="eleven wide"].column, .ui.grid>.row>[class*="eleven wide"].column, .ui.grid>[class*="eleven wide"].column {
        width: 100%!important;
    }
}
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <div class="ui inverted segment">
    <div class="ui inverted breadcrumb">
      <a class="section">Home</a>
      <div class="divider">/ </div>
      <div class="active section">個人專頁總覽</div>
    </div>
  </div>
  <div class="ui segment">
    <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.9/jquery.lazy.min.js"></script>
    <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.9/jquery.lazy.plugins.min.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/core.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/charts.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/themes/animated.js"></script>
    <%--<div id="chartdiv" style="height: 400px;"></div>--%>
    <div class="ui grid">
      <div class="row">
        <div class="ui five wide column">
          <div class="ui items">
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
              於<span id="Article_joindate" runat="server" style="display:contents !important;"></span>加入
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
              <table class="ui unstackable definition compact table">
                <tbody>
                  <asp:ListView ID="ListView2" runat="server" DataSourceID="SqlDataSource2">
                    <%--<LayoutTemplate>
                  <table class="ui unstackable definition compact table">
                    <tbody>
                      <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
                    </tbody>
                  </table>
                </LayoutTemplate>--%>
                    <ItemTemplate>
                      <tr>
                        <td class="collapsing"><%# Eval("t") %></td>
                        <td class="right aligned">
                          <%# Eval("c") %>
                        </td>
                      </tr>
                    </ItemTemplate>
                  </asp:ListView>

                  <asp:ListView ID="ListView3" runat="server" DataSourceID="SqlDataSource3">
                    <%--<LayoutTemplate>
                  <table class="ui unstackable definition compact table">
                    <tbody>
                      <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
                    </tbody>
                  </table>
                </LayoutTemplate>--%>
                    <ItemTemplate>
                      <tr>
                        <td class="collapsing">本月引薦獎金</td>
                        <td class="right aligned">
                          <%# Eval("total_bonus") %>
                        </td>
                      </tr>
                    </ItemTemplate>
                  </asp:ListView>
                </tbody>
              </table>
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
              <asp:SqlDataSource runat="server" ID="SqlDataSource2" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT '累計瀏覽' AS t, COUNT(ul.Id) AS c FROM UserLog AS ul LEFT OUTER JOIN Article AS a ON a.Id = ul.Modify_Id WHERE (ul.Modify_Table = 'Article') AND (ul.Modify_Action = 'View') AND (a.Author_Email = @email)">
                <SelectParameters>
                  <asp:SessionParameter SessionField="Email" Name="email"></asp:SessionParameter>
                </SelectParameters>
              </asp:SqlDataSource>
            </div>
            <div class="item">
              <%--<asp:GridView ID="GridView1" runat="server" CssClass="ui unstackable definition compact table" GridLines="None" CellSpacing="5" ShowHeader="false" AutoGenerateColumns="False" DataSourceID="SqlDataSource3">
                <Columns>
                  <asp:TemplateField ItemStyle-CssClass="collapsing">
                    <ItemTemplate>
                      本月引薦獎金
                    </ItemTemplate>
                  </asp:TemplateField>
                  <asp:BoundField DataField="total_bonus" ReadOnly="True" SortExpression="total_bonus"></asp:BoundField>
                </Columns>
              </asp:GridView>--%>
            </div>

            <%--<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>--%>
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
        <div class="ui eleven wide column">
          <h3>文章總覽</h3>
          <div class="ui divider"></div>
          <asp:UpdatePanel ID="UpdatePanel2" runat="server">
            <ContentTemplate>
              <asp:ListView ID="ListView1" runat="server" DataKeyNames="Id" DataSourceID="SqlDataSource1" Visible="true">
                <EmptyDataTemplate>
                  尚無發布任何文章
                </EmptyDataTemplate>
                <LayoutTemplate>
                  <div class="ui three stackable doubling centered cards">
                    <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
                  </div>
                </LayoutTemplate>
                <ItemTemplate>
                  <a class="ui link card" title="在前端瀏覽報導" href='News/Info/<%# Eval("Id") %>'>
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
              <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>'
                SelectCommand="SELECT Title, Category, Format(DateTime, 'yyyy/MM/dd tthh:mm') AS DateTime, Status, Recommand_Category, a.Id, Front_Img_Id, count(ul.Id) as cnt FROM Article a LEFT JOIN UserLog ul on ul.Modify_Id = a.Id and ul.Modify_Table = 'Article' and ul.Modify_Action = 'View' WHERE (Author_Email = @email) GROUP BY TItle,Category,DateTime,Status,Recommand_Category,a.Id,Front_Img_Id order by DateTime DESC">
                <SelectParameters>
                  <asp:SessionParameter SessionField="Email" Name="email"></asp:SessionParameter>
                  <%--<asp:Parameter Name="search"></asp:Parameter>--%>
                </SelectParameters>
              </asp:SqlDataSource>
              <asp:SqlDataSource runat="server" ID="Sql3" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT Title, Category, Format(DateTime, 'yyyy/MM/dd tthh:mm') AS DateTime, Status, Recommand_Category, a.Id, Front_Img_Id, count(ul.Id) as cnt FROM Article a LEFT JOIN UserLog ul on ul.Modify_Id = a.Id and ul.Modify_Table = 'Article' and ul.Modify_Action = 'View' WHERE (Author_Email = @email) and (Title like '%' + @search + '%' OR Keyword like '%' + @search + '%') GROUP BY TItle,Category,DateTime,Status,Recommand_Category,a.Id,Front_Img_Id">
                <SelectParameters>
                  <asp:SessionParameter SessionField="Email" Name="email"></asp:SessionParameter>
                  <asp:Parameter Name="search"></asp:Parameter>
                </SelectParameters>
              </asp:SqlDataSource>
            </ContentTemplate>
          </asp:UpdatePanel>
          <div id="visitLine-Pie" style="height: 70px;"></div>
        </div>
      </div>
      <div class="row">
        <div class="ui eight wide column">
        </div>
        <div class="ui eight wide column">
        </div>
        <asp:SqlDataSource runat="server" ID="SqlDataSource3" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="select IsNULL(sum(bonus), 0) as total_bonus from
(select distinct r.User_Id, mp.pay_time, caf.fee*cb.Bonus_Rate/100 as bonus 
from Referral r 
left join class_Bonus cb on cb.class_id = r.Introducer_Class 
left join class_annual_fee caf on caf.class_id = r.User_Class
left join Member_Payment mp on mp.User_Id = r.User_Id where r.Introducer_Id = @id
and format(mp.pay_time, 'yyyy/MM') = format(GetDate(), 'yyyy/MM')) l">
          <SelectParameters>
            <asp:SessionParameter SessionField="User_Id" Name="id"></asp:SessionParameter>
          </SelectParameters>
        </asp:SqlDataSource>
      </div>
    </div>
    <script>

      $('.image:has(.image[src=""])').css('background', 'lightblue');
      //$('.ui.disabled.dropdown').dropdown();
      $('#<%= Master.FindControl("UpdatePanel1").ClientID %>').addClass('ui list');
      $('#<%= Master.FindControl("UpdatePanel1").ClientID %>').on('change', function () {
        console.log('cng')
        $('.lazy').Lazy({ threshold: 0, effect: 'fadeIn', effectTime: 500, appendScroll: $('.ui.scrolling.basic.segment') });
      });

      $('.lazy').Lazy({ threshold: 0, effect: 'fadeIn', effectTime: 500, appendScroll: $('.ui.scrolling.basic.segment') });
      $(window).on('load', function () {
        $('.ui.sidebar').sidebar({
          context: 'form',
          dimPage: false,
          closable: false,
          duration: 300,
          onVisible: function () {
            $('.pusher').width($(window).width() - $('.ui.sidebar').width())
            //$('.ui.two.cards .card').removeClass('horizontal')
            $('.ui.two.cards .card .grid .author').css('padding', '.6em .6em 0')
            $('.ui.two.cards .card .squeeze.content').css('padding-bottom', '.6em')
          }, onHide: function () {
            $('.pusher').width($(window).width())
            //$('.ui.two.cards .card').addClass('horizontal')
            $('.ui.two.cards .card .grid .author').css('padding', '')
            $('.ui.two.cards .card .squeeze.content').css('padding-bottom', '')
          }
        });
        if ($('.ui.sidebar').sidebar('is visible')) {
          //$('.ui.two.cards .card').removeClass('horizontal
          $('.ui.two.cards .card .grid .author').css('padding', '.6em .6em 0')
          $('.ui.two.cards .card .squeeze.content').css('padding-bottom', '.6em')
        }

        console.log($(window).width())
        if ($(window).width() <= 1318) {
          $('#<%= P_Img.ClientID %>').parent('.square').parent('.ui.image').removeClass('small mini').addClass('tiny')
        }
        if ($(window).width() <= 991) {

          $('#<%= P_Img.ClientID %>').parent('.square').parent('.ui.image').removeClass('small tiny').addClass('mini')
        }
      })

      $(window).on('resize', function () {
        console.log($(window).width())
        if ($(window).width() <= 1318) {
          $('#<%= P_Img.ClientID %>').parent('.square').parent('.ui.image').removeClass('small mini').addClass('tiny')
        }
        if ($(window).width() <= 991) {
          $('#<%= P_Img.ClientID %>').parent('.square').parent('.ui.image').removeClass('small tiny').addClass('mini')
        }
      })

      //// Themes begin
      //am4core.useTheme(am4themes_animated);
      //// Themes end

      //// Create chart instance
      //var v30chart = am4core.create("chartdiv", am4charts.XYChart);

      //// Set input format for the dates
      //v30chart.dateFormatter.inputDateFormat = "yyyy-MM-dd";

      //// Create axes
      //var dateAxis = v30chart.xAxes.push(new am4charts.DateAxis());
      //var valueAxis = v30chart.yAxes.push(new am4charts.ValueAxis());

      //// Create series
      //var series = v30chart.series.push(new am4charts.LineSeries());
      //series.dataFields.valueY = "v";
      //series.dataFields.dateX = "d";
      //series.tooltipText = "{value}"
      //series.strokeWidth = 2;
      //series.minBulletDistance = 15;

      //// Drop-shaped tooltips
      //series.tooltip.background.cornerRadius = 20;
      //series.tooltip.background.strokeOpacity = 0;
      //series.tooltip.pointerOrientation = "vertical";
      //series.tooltip.label.minWidth = 40;
      //series.tooltip.label.minHeight = 40;
      //series.tooltip.label.textAlign = "middle";
      //series.tooltip.label.textValign = "middle";

      //// Make bullets grow on hover
      //var bullet = series.bullets.push(new am4charts.CircleBullet());
      //bullet.circle.strokeWidth = 2;
      //bullet.circle.radius = 4;
      //bullet.circle.fill = am4core.color("#fff");

      //var bullethover = bullet.states.create("hover");
      //bullethover.properties.scale = 1.3;

      //// Make a panning cursor
      //v30chart.cursor = new am4charts.XYCursor();
      //v30chart.cursor.behavior = "panXY";
      //v30chart.cursor.xAxis = dateAxis;
      //v30chart.cursor.snapToSeries = series;

      //// Create vertical scrollbar and place it before the value axis
      //v30chart.scrollbarY = new am4core.Scrollbar();
      //v30chart.scrollbarY.parent = v30chart.leftAxesContainer;
      //v30chart.scrollbarY.toBack();

      //// Create a horizontal scrollbar with previe and place it underneath the date axis
      //v30chart.scrollbarX = new am4charts.XYChartScrollbar();
      //v30chart.scrollbarX.series.push(series);
      //v30chart.scrollbarX.parent = v30chart.bottomAxesContainer;

      //dateAxis.start = 0.79;
      //dateAxis.keepSelection = true;

      // Themes begin
      am4core.useTheme(am4themes_animated);
      // Themes end

      // Create chart instance
      var v7container = am4core.create("visitLine-Pie", am4core.Container);
      v7container.layout = "grid";
      v7container.fixedWidthGrid = false;
      v7container.width = am4core.percent(100);
      v7container.height = am4core.percent(100);

      // Color set
      var colors = new am4core.ColorSet();

      // Functions that create various sparklines
      function createv7Line(title, data, color) {

        var v7chart = v7container.createChild(am4charts.XYChart);
        v7chart.width = am4core.percent(40);
        v7chart.height = 70;
        // Set input format for the dates
        v7chart.dateFormatter.inputDateFormat = "yyyy-MM-dd";

        v7chart.data = data;

        v7chart.titles.template.fontSize = 10;
        v7chart.titles.template.textAlign = "left";
        v7chart.titles.template.isMeasured = false;
        v7chart.titles.create().text = title;

        v7chart.padding(20, 5, 2, 5);

        var dateAxis = v7chart.xAxes.push(new am4charts.DateAxis());
        dateAxis.renderer.grid.template.disabled = true;
        dateAxis.renderer.labels.template.disabled = true;
        dateAxis.startLocation = 0.5;
        dateAxis.endLocation = 0.7;
        dateAxis.cursorTooltipEnabled = false;

        var valueAxis = v7chart.yAxes.push(new am4charts.ValueAxis());
        valueAxis.min = 0;
        valueAxis.renderer.grid.template.disabled = true;
        valueAxis.renderer.baseGrid.disabled = true;
        valueAxis.renderer.labels.template.disabled = true;
        valueAxis.cursorTooltipEnabled = false;

        v7chart.cursor = new am4charts.XYCursor();
        v7chart.cursor.lineY.disabled = true;
        v7chart.cursor.behavior = "none";

        var series = v7chart.series.push(new am4charts.LineSeries());
        series.tooltip.fontSize = 12;
        series.tooltipText = "{date}: [bold]{value}人次";
        series.dataFields.dateX = "date";
        series.dataFields.valueY = "value";
        series.tensionX = 0.8;
        series.strokeWidth = 2;
        series.stroke = color;

        // render data points as bullets
        var bullet = series.bullets.push(new am4charts.CircleBullet());
        bullet.circle.opacity = 0;
        bullet.circle.fill = color;
        bullet.circle.propertyFields.opacity = "opacity";
        bullet.circle.radius = 3;

        return v7chart;
      }

      function createv7Pie(data, color) {

        var v7chart = v7container.createChild(am4charts.PieChart);
        v7chart.width = am4core.percent(10);
        v7chart.height = 70;
        v7chart.padding(20, 0, 2, 0);

        v7chart.data = data;

        // Add and configure Series
        var pieSeries = v7chart.series.push(new am4charts.PieSeries());
        pieSeries.dataFields.value = "value";
        pieSeries.dataFields.category = "category";
        //pieSeries.labels.template.fontSize = 12;
        //pieSeries.labels.template.text = "{value.percent.formatNumber('#.0')}%";
        pieSeries.labels.template.disabled = true;
        pieSeries.ticks.template.disabled = true;
        pieSeries.tooltip.fontSize = 12;
        pieSeries.slices.template.fill = color;
        pieSeries.slices.template.adapter.add("fill", function (fill, target) {
          return fill.lighten(0.1 * target.dataItem.index);
        });
        pieSeries.slices.template.stroke = am4core.color("#fff");

        // chart.chartContainer.minHeight = 40;
        // chart.chartContainer.minWidth = 40;

        return v7chart;
      }
    </script>
  </div>
</asp:Content>
