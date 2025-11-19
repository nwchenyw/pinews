<%@ Page Title="" Language="C#" MasterPageFile="AdminPage.Master" AutoEventWireup="true" CodeFile="Admin_HomeSetting.aspx.cs" Inherits="piNews.Admin_HomeSetting" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <link rel="stylesheet" type="text/css"
    href="https://cdn.jsdelivr.net/npm/spectrum-colorpicker2/dist/spectrum.min.css">
  
  <style>
    .sp-container:not(.sp-palette-only) {
      min-width: 420px;
    }

    .sp-container.sp-palette-only {
      min-width: 200px;
    }

    .dropdown .text span {
      display: none;
    }
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <script
    src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"
    integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU="
    crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/spectrum-colorpicker2/dist/spectrum.min.js"></script>
  <div class="ui inverted segment">
    <div class="ui inverted breadcrumb">
      <a class="section">Home</a>
      <div class="divider">/ </div>
      <div class="active section">首頁標題設定</div>
    </div>
  </div>
  <div class="ui segment" style="margin-bottom: 2rem;">
    <asp:GridView ID="GridView1" runat="server" ShowFooter="true" CssClass="ui unstackable celled table" GridLines="None" CellSpacing="5" OnPreRender="GridView1_PreRender" OnRowEditing="GridView1_RowEditing" OnRowDeleting="GridView1_RowDeleting" OnRowUpdating="GridView1_RowUpdating" AutoGenerateColumns="False" DataKeyNames="Id" DataSourceID="SqlDataSource1">
      <Columns>
        <asp:TemplateField HeaderText="首頁標題分類">
          <ItemTemplate>
            <%# Eval("Category_Name") %>
            <input type="hidden" name="Reco_Id" value='<%# Eval("Id") %>' />
          </ItemTemplate>
          <ItemStyle Width="100%" CssClass="collapsing" />
          <EditItemTemplate>
            <div class="ui input">
              <asp:TextBox ID="TextBox1" runat="server" Text='<%# Eval("Category_Name") %>'></asp:TextBox>
            </div>
            <div class="ui text-color top left pointing dropdown basic icon button" title="文字顏色">
                <i class="font icon" <%# string.Format("style='color: {0};'", DBNull.Value.Equals(Eval("font_color")) ? "#4183c4":Eval("font_color")) %>></i>
                <div class="menu">
                  <div class="hidden helper item"></div>
                  <asp:TextBox ID="colorPicker_TB" CssClass="text-color-picker" runat="server" Text='<%# DBNull.Value.Equals(Eval("font_color")) ? "#4183c4":Eval("font_color") %>'></asp:TextBox>
                  <%--<input class="text-color-picker" name="color" value="rgba(0,0,0,.87)" />--%>
                </div>
              </div>
            <div class="ui selection compact dropdown">
              <asp:HiddenField ID="fontName_HF" runat="server" Value='<%# DBNull.Value.Equals(Eval("font_name")) ? "Noto Sans TC, sans-serif":Eval("font_name") %>' />
              <%--<input type="hidden" id="font_name" name="font-name" value="Noto Sans, sans-serif" />--%>
              <i class="dropdown icon"></i>
              <div class="default text">font family</div>
              <div class="menu">
                <div class="item" data-value="Noto Sans TC, sans-serif" style="font-family: Noto Sans TC, sans-serif;">
                  思源黑體<br />
                  <span>abc123</span>
                </div>
                <div class="item" data-value="Noto Serif TC, serif" style="font-family: 'Noto Serif TC', serif;">
                  思源宋體<br />
                  <span>abc123</span>
                </div>
                <div class="item" data-value="Microsoft JhengHei, Noto Sans TC, sans-serif" style="font-family: 'Microsoft JhengHei', Noto Sans TC, sans-serif;">
                  微軟正黑體<br />
                  <span>abc123</span>
                </div>
                <div class="item" data-value="DFKai-sb, Noto Sans TC, sans-serif" style="font-family: DFKai-sb, Noto Sans TC, sans-serif;">
                  標楷體<br />
                  <span>abc123</span>
                </div>
                <div class="item" data-value="PMingLiU, Noto Sans TC, sans-serif" style="font-family: PMingLiU, Noto Sans TC, sans-serif;">
                  新細明體<br />
                  <span>abc123</span>
                </div>
                <div class="item" data-value="MingLiU, Noto Sans TC, sans-serif" style="font-family: MingLiU, Noto Sans TC, sans-serif;">
                  細明體<br />
                  <span>abc123</span>
                </div>
                <div class="item" data-value="Arial, sans-serif" style="font-family: Arial, sans-serif;">
                  Arial<br />
                  <span>字型123</span>
                </div>
                <div class="item" data-value="Comic Sans MS, Comic Sans, cursive" style="font-family: Comic Sans MS, Comic Sans, cursive;">
                  Comic Sans MS<br />
                  <span>字型123</span>
                </div>
                <div class="item" data-value="Times, Times New Roman, serif" style="font-family: Times, Times New Roman, serif;">
                  Times New Roman<br />
                  <span>字型123</span>
                </div>
                <div class="item" data-value="Courier New, monospace" style="font-family: Courier New, monospace;">
                  Courier New<br />
                  <span>字型123</span>
                </div>
                <div class="item" data-value="Helvetica, sans-serif" style="font-family: Helvetica, sans-serif;">
                  Helvetica<br />
                  <span>字型123</span>
                </div>
                <div class="item" data-value="Impact, fantasy" style="font-family: Impact, fantasy;">
                  Impact<br />
                  <span>字型123</span>
                </div>
              </div>
            </div>
          </EditItemTemplate>
          <FooterTemplate>
            <div class="ui input">
              <asp:TextBox ID="TextBox2" runat="server" placeholder="首頁標題分類"></asp:TextBox>
            </div>
            <div class="ui text-color top left pointing dropdown basic icon button" title="文字顏色">
                <i class="font icon" <%# string.Format("style='color: {0};'", DBNull.Value.Equals(Eval("font_color")) ? "#4183c4":Eval("font_color")) %>></i>
                <div class="menu">
                  <div class="hidden helper item"></div>
                  <asp:TextBox ID="colorPicker_TB" CssClass="text-color-picker" runat="server" Text='<%# DBNull.Value.Equals(Eval("font_color")) ? "#4183c4":Eval("font_color") %>'></asp:TextBox>
                  <%--<input class="text-color-picker" name="color" value="rgba(0,0,0,.87)" />--%>
                </div>
              </div>
            <div class="ui selection compact dropdown">
              <asp:HiddenField ID="fontName_HF" runat="server" Value='<%# DBNull.Value.Equals(Eval("font_name")) ? "Noto Sans TC, sans-serif":Eval("font_name") %>' />
              <%--<input type="hidden" id="font_name" name="font-name" value="Noto Sans, sans-serif" />--%>
              <i class="dropdown icon"></i>
              <div class="default text">font family</div>
              <div class="menu">
                <div class="item" data-value="Noto Sans TC, sans-serif" style="font-family: Noto Sans TC, sans-serif;">
                  思源黑體<br />
                  <span>abc123</span>
                </div>
                <div class="item" data-value="Noto Serif TC, serif" style="font-family: 'Noto Serif TC', serif;">
                  思源宋體<br />
                  <span>abc123</span>
                </div>
                <div class="item" data-value="Microsoft JhengHei, Noto Sans TC, sans-serif" style="font-family: 'Microsoft JhengHei', Noto Sans TC, sans-serif;">
                  微軟正黑體<br />
                  <span>abc123</span>
                </div>
                <div class="item" data-value="DFKai-sb, Noto Sans TC, sans-serif" style="font-family: DFKai-sb, Noto Sans TC, sans-serif;">
                  標楷體<br />
                  <span>abc123</span>
                </div>
                <div class="item" data-value="PMingLiU, Noto Sans TC, sans-serif" style="font-family: PMingLiU, Noto Sans TC, sans-serif;">
                  新細明體<br />
                  <span>abc123</span>
                </div>
                <div class="item" data-value="MingLiU, Noto Sans TC, sans-serif" style="font-family: MingLiU, Noto Sans TC, sans-serif;">
                  細明體<br />
                  <span>abc123</span>
                </div>
                <div class="item" data-value="Arial, sans-serif" style="font-family: Arial, sans-serif;">
                  Arial<br />
                  <span>字型123</span>
                </div>
                <div class="item" data-value="Comic Sans MS, Comic Sans, cursive" style="font-family: Comic Sans MS, Comic Sans, cursive;">
                  Comic Sans MS<br />
                  <span>字型123</span>
                </div>
                <div class="item" data-value="Times, Times New Roman, serif" style="font-family: Times, Times New Roman, serif;">
                  Times New Roman<br />
                  <span>字型123</span>
                </div>
                <div class="item" data-value="Courier New, monospace" style="font-family: Courier New, monospace;">
                  Courier New<br />
                  <span>字型123</span>
                </div>
                <div class="item" data-value="Helvetica, sans-serif" style="font-family: Helvetica, sans-serif;">
                  Helvetica<br />
                  <span>字型123</span>
                </div>
                <div class="item" data-value="Impact, fantasy" style="font-family: Impact, fantasy;">
                  Impact<br />
                  <span>字型123</span>
                </div>
              </div>
            </div>
          </FooterTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="排序">
          <ItemTemplate>
            <%# Eval("Art_Odr_Duration").Equals("week") ? "週":
                Eval("Art_Odr_Duration").Equals("month") ? "月":
                Eval("Art_Odr_Duration").Equals("year") ? "年":"預設(所有區間)" %>
            <%# Eval("Art_Odr_Type").Equals("time") ? "時間":
                Eval("Art_Odr_Type").Equals("like") ? "喜歡":
                Eval("Art_Odr_Type").Equals("like_click") ? "點擊、喜歡(以喜歡優先)":
                Eval("Art_Odr_Type").Equals("like_click_total") ? "點擊、喜歡(加成後加總)":
                Eval("Art_Odr_Type").Equals("click") ? "點擊":"預設(時間)" %>
            <%# Eval("Art_Grouping").Equals("cat") ? "依分類":
                Eval("Art_Grouping").Equals("all") ? "所有類別":
                Eval("Art_Grouping").Equals("all_article") ? "全站文章(依時間)":"預設(依分類)" %>
          </ItemTemplate>
          <ItemStyle Width="100%" CssClass="collapsing" />
          <EditItemTemplate>
            <div class="ui selection fluid dropdown">
              <asp:HiddenField ID="HiddenField2" runat="server" Value='<%# Eval("Art_Odr_Duration") %>' />
              <i class="dropdown icon"></i>
              <div class="default text">Order</div>
              <div class="menu">
                <div class="item" data-value="week">週</div>
                <div class="item" data-value="month">月</div>
                <div class="item" data-value="year">年</div>
                <div class="item" data-value="">預設(所有區間)</div>
              </div>
            </div>
            <div class="ui selection fluid dropdown">
              <asp:HiddenField ID="HiddenField1" runat="server" Value='<%# Eval("Art_Odr_Type") %>' />
              <i class="dropdown icon"></i>
              <div class="default text">Order</div>
              <div class="menu">
                <div class="item" data-value="time">時間</div>
                <div class="item" data-value="click">點擊</div>
                <div class="item" data-value="like">喜歡</div>
                <div class="item" data-value="like_click">點擊、喜歡(以喜歡優先)</div>
                <div class="item" data-value="like_click_total">點擊、喜歡(加成後加總)</div>
                <div class="item" data-value="">預設(時間)</div>
              </div>
            </div>
            <div class="ui selection fluid dropdown">
              <asp:HiddenField ID="HiddenField3" runat="server" Value='<%# Eval("Art_Grouping") %>' />
              <i class="dropdown icon"></i>
              <div class="default text">Order</div>
              <div class="menu">
                <div class="unfilterable item" data-value="cat">依分類</div>
                <div class="item" data-value="all">所有類別</div>
                <div class="item" data-value="all_article">全站文章(依時間)</div>
                <div class="unfilterable item" data-value="">預設(依分類)</div>
              </div>
            </div>
          </EditItemTemplate>
          <FooterTemplate>
            <div class="ui selection fluid dropdown">
              <asp:HiddenField ID="HiddenField2" runat="server" />
              <i class="dropdown icon"></i>
              <div class="default text">Order</div>
              <div class="menu">
                <div class="item" data-value="week">週</div>
                <div class="item" data-value="month">月</div>
                <div class="item" data-value="year">年</div>
                <div class="item" data-value="">預設(所有區間)</div>
              </div>
            </div>
            <div class="ui selection fluid dropdown">
              <asp:HiddenField ID="HiddenField1" runat="server" />
              <i class="dropdown icon"></i>
              <div class="default text">Order</div>
              <div class="menu">
                <div class="item" data-value="time">時間</div>
                <div class="item" data-value="click">點擊</div>
                <div class="item" data-value="like">喜歡</div>
                <div class="item" data-value="like_click">點擊、喜歡(以喜歡優先)</div>
                <div class="item" data-value="like_click_total">點擊、喜歡(加成後加總)</div>
                <div class="item" data-value="">預設(時間)</div>
              </div>
            </div>
            <div class="ui selection fluid dropdown">
              <asp:HiddenField ID="HiddenField3" runat="server" />
              <i class="dropdown icon"></i>
              <div class="default text">Order</div>
              <div class="menu">
                <div class="unfilterable item" data-value="cat">依分類</div>
                <div class="item" data-value="all">所有類別</div>
                <div class="item" data-value="all_article">全站文章(依時間)</div>
                <div class="unfilterable item" data-value="">預設(依分類)</div>
              </div>
            </div>
          </FooterTemplate>
        </asp:TemplateField>
        <asp:TemplateField ItemStyle-CssClass="collapsing" FooterStyle-CssClass="center aligned">
          <ItemTemplate>
            <asp:LinkButton ID="LinkButton1" runat="server" CssClass="ui tiny button" CommandName="Edit">編輯</asp:LinkButton>
            <asp:LinkButton ID="LinkButton2" runat="server" CssClass="ui tiny button" CommandName="Delete">刪除</asp:LinkButton>
          </ItemTemplate>
          <ItemStyle CssClass="collapsing" />
          <EditItemTemplate>
            <asp:LinkButton ID="LinkButton4" runat="server" CssClass="ui tiny button" CommandName="Update">更新</asp:LinkButton>
            <asp:LinkButton ID="LinkButton5" runat="server" CssClass="ui tiny button" CommandName="Cancel">取消</asp:LinkButton>
          </EditItemTemplate>
          <FooterTemplate>
            <asp:LinkButton ID="LinkButton3" CssClass="ui tiny button" OnClick="LinkButton3_Click" runat="server">新增</asp:LinkButton>
          </FooterTemplate>
        </asp:TemplateField>
      </Columns>
    </asp:GridView>
    <asp:LinkButton ID="Edit_Order_LB" CssClass="ui button" runat="server" OnClick="Edit_Order_LB_Click">編輯排序</asp:LinkButton>
    <asp:LinkButton ID="Reorder_LB" CssClass="ui button" Visible="false" runat="server" OnClick="Reorder_LB_Click">更新排序</asp:LinkButton>
    <asp:LinkButton ID="Cancel_Order_LB" CssClass="ui button" Visible="false" runat="server" OnClick="Cancel_Order_LB_Click">取消</asp:LinkButton>

    <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT [Id], [Category_Name], [Cat_Order], [Art_Odr_Type], [Art_Grouping], [Art_Odr_Duration], font_color, font_name FROM [Recommendation] ORDER BY [Cat_Order]" DeleteCommand="DELETE FROM [Recommendation] WHERE [Id] = @Id" InsertCommand="INSERT INTO [Recommendation] ([Category_Name], [Cat_Order], [Art_Odr_Type], [Art_Grouping], [Art_Odr_Duration], [font_name], [font_color]) VALUES (@Category_Name, @Cat_Order, @Art_Odr_Type, @Art_Grouping, @Art_Odr_Duration, @fn, @fc)" UpdateCommand="UPDATE [Recommendation] SET [Category_Name] = @Category_Name, [Art_Odr_Type] = @Art_Odr_Type, [Art_Grouping] = @Art_Grouping, [Art_Odr_Duration] = @Art_Odr_Duration, [font_name] = @fn, [font_color] = @fc WHERE [Id] = @Id">
      <DeleteParameters>
        <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
      </DeleteParameters>
      <InsertParameters>
        <asp:Parameter Name="Category_Name" Type="String"></asp:Parameter>
        <asp:Parameter Name="Cat_Order" Type="Int32"></asp:Parameter>
        <asp:Parameter Name="Art_Odr_Type" Type="String"></asp:Parameter>
        <asp:Parameter Name="Art_Grouping" Type="String"></asp:Parameter>
        <asp:Parameter Name="Art_Odr_Duration" Type="String"></asp:Parameter>
        <asp:Parameter Name="fn"></asp:Parameter>
        <asp:Parameter Name="fc"></asp:Parameter>
      </InsertParameters>
      <UpdateParameters>
        <asp:Parameter Name="Category_Name" Type="String"></asp:Parameter>
        <asp:Parameter Name="Art_Odr_Type" Type="String"></asp:Parameter>
        <asp:Parameter Name="Art_Grouping" Type="String"></asp:Parameter>
        <asp:Parameter Name="Art_Odr_Duration" Type="String"></asp:Parameter>
        <asp:Parameter Name="fn"></asp:Parameter>
        <asp:Parameter Name="fc"></asp:Parameter>
        <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
      </UpdateParameters>
    </asp:SqlDataSource>
  </div>
  <script>
    $('.text-color-picker').spectrum({
      type: "flat",
      showPaletteOnly: true,
      togglePaletteOnly: true,
      showInput: true,
      showInitial: true,
      change: function (color) {
        var col = 'rgba(' + color._r.toFixed(2) + ',' + color._g.toFixed(2) + ',' + color._b.toFixed(2) + ',' + color._a.toFixed(2) + ')';
        console.log(col);
        $(this).val(col);
        $(this).parents('.text-color').children('.font.icon').css('color', col)
        $('.ui.notify.modal .container #banner-text').css('color', col)
      },
      move: function (color) {
        var col = 'rgba(' + color._r.toFixed(2) + ',' + color._g.toFixed(2) + ',' + color._b.toFixed(2) + ',' + color._a.toFixed(2) + ')';
        console.log(col);
        $(this).val(col);
        $(this).parents('.text-color').children('.font.icon').css('color', col)
        $('.ui.notify.modal .container #banner-text').css('color', col)
        //document.execCommand('foreColor', 'false', col);
      }
    });
    $('#<%= GridView1.ClientID %> .ui.dropdown').dropdown();
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
