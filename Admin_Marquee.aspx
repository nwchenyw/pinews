<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeFile="Admin_Marquee.aspx.cs" Inherits="piNews.Admin_Marquee" %>

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

  <div class="ui inverted segment">
    <div class="ui inverted breadcrumb">
      <a class="section">Home</a>
      <div class="divider">/ </div>
      <div class="active section">管理首頁跑馬燈</div>
    </div>
  </div>
  <div class="ui segment">
    <p>
      <span class="ui icon labeled button" onclick="javascript: $('.marquee.modal').modal({context: 'form'}).modal('show')"><i class="edit icon"></i>新增首頁跑馬燈</span>
    </p>
    <asp:GridView ID="GridView1" CssClass="ui unstackable celled table" GridLines="None" CellSpacing="5" runat="server" DataSourceID="SqlDataSource1" AutoGenerateColumns="False" DataKeyNames="Id" OnPreRender="GridView1_PreRender" OnRowUpdating="GridView1_RowUpdating">
      <Columns>
        <asp:TemplateField HeaderText="跑馬燈文字">
          <ItemTemplate>
            <%# Eval("Text") %>
            <input type="hidden" name="Marquee_Id" value='<%# Eval("Id") %>' />
          </ItemTemplate>
          <EditItemTemplate>
            <div class="ui fluid input">
              <asp:TextBox ID="Marquee_TB" runat="server" Text='<%# Eval("Text") %>'></asp:TextBox>
            </div>
            <div class="ui selection fluid dropdown">
              <asp:HiddenField ID="fontName_HF" runat="server" Value='<%# DBNull.Value.Equals(Eval("font_name")) ? "Noto Sans, sans-serif":Eval("font_name") %>' />
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
            <div class="flex">
              <div class="ui compact selection dropdown">
                <asp:HiddenField ID="fontSize_HF" runat="server" Value='<%# DBNull.Value.Equals(Eval("font_size")) ? "14px":Eval("font_size") %>' />
                <%--<input type="hidden" id="font_size" name="font-size" value="28px">--%>
                <i class="dropdown icon"></i>
                <div class="default text">size</div>
                <div class="menu">
                  <div class="item" data-value="12px">12</div>
                  <div class="item" data-value="14px">14</div>
                  <div class="item" data-value="16px">16</div>
                  <div class="item" data-value="18px">18</div>
                  <div class="item" data-value="20px">20</div>
                  <%--<div class="item" data-value="22px">22</div>
                  <div class="item" data-value="24px">24</div>
                  <div class="item" data-value="26px">26</div>
                  <div class="item" data-value="28px">28</div>
                  <div class="item" data-value="36px">36</div>
                  <div class="item" data-value="48px">48</div>
                  <div class="item" data-value="72px">72</div>--%>
                </div>
              </div>
              <div class="ui text-color top left pointing dropdown basic icon button" title="文字顏色">
                <i class="font icon" <%# string.Format("style='color: {0};'", DBNull.Value.Equals(Eval("color")) ? "rgba(0,0,0,.87)":Eval("color")) %>></i>
                <div class="menu">
                  <div class="hidden helper item"></div>
                  <asp:TextBox ID="colorPicker_TB" CssClass="text-color-picker" runat="server" Text='<%# DBNull.Value.Equals(Eval("color")) ? "rgba(0,0,0,.87)":Eval("color") %>'></asp:TextBox>
                  <%--<input class="text-color-picker" value='rgba(0,0,0,.87)' />--%>
                </div>
              </div>
              <asp:CheckBox ID="Bold_CB" CssClass="ui basic button" runat="server" Text="粗體" Checked='<%# Eval("font_weight").Equals("bold") %>' />
              <div class="ui basic button" onclick="opBannerPV()">
                預覽
              </div>
            </div>
          </EditItemTemplate>
        </asp:TemplateField>
        <%-- <asp:TemplateField HeaderText="跑馬燈文字">
          <ItemTemplate>
            <asp:LinkButton ID="LinkButton1" runat="server"><%# Eval("Text") %></asp:LinkButton>
          </ItemTemplate>
        </asp:TemplateField> --%>
        <asp:TemplateField HeaderText="連結" ItemStyle-CssClass="center aligned">
          <ItemTemplate>
            <a href='<%# Eval("Link") %>' id="link" runat="server" visible='<%# !DBNull.Value.Equals(Eval("Link")) %>'>Link</a>
            <%# DBNull.Value.Equals(Eval("Link")) ? "-":"" %>
          </ItemTemplate>
          <EditItemTemplate>
            <div class="ui input">
              <asp:TextBox ID="link_TB" runat="server" placeholder="link" Text='<%# Eval("Link") %>'></asp:TextBox>
            </div>
          </EditItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="是否顯示">
          <ItemTemplate>
            <%# Eval("active").Equals(true) ? "<i class='check icon'></i>":"<i class='times icon'></i>" %>
          </ItemTemplate>
          <EditItemTemplate>
            <asp:CheckBox ID="active_CB" runat="server" Checked='<%# Eval("active").Equals(true) %>' />
          </EditItemTemplate>
        </asp:TemplateField>
        <%--<asp:HyperLinkField HeaderText="連結" Text="Link" DataNavigateUrlFields="Link" />--%>
        <asp:BoundField DataField="Add_Time" HeaderText="新增時間" ReadOnly="true" DataFormatString="{0:yyyy/MM/dd tthh:mm}" SortExpression="Add_Time"></asp:BoundField>
        <asp:TemplateField HeaderText="動作">
          <ItemTemplate>
            <asp:LinkButton ID="Edit_LB" CssClass="ui teal icon button" runat="server" CommandName="Edit" title="編輯"><i class="pen nib icon"></i></asp:LinkButton>
            <asp:LinkButton ID="Del_LB" CssClass="ui red icon button" runat="server" CommandName="Delete" title="刪除"><i class="trash alternate icon"></i></asp:LinkButton>
          </ItemTemplate>
          <EditItemTemplate>
            <asp:LinkButton ID="Update_LB" CssClass="ui teal button" CommandName="Update" runat="server">更新</asp:LinkButton>
            <asp:LinkButton ID="Cancel_LB" CssClass="ui button" CommandName="Cancel" runat="server">取消</asp:LinkButton>
          </EditItemTemplate>
        </asp:TemplateField>
      </Columns>
    </asp:GridView>
    <asp:LinkButton ID="Edit_Odr_LB" CssClass="ui button" OnClick="Edit_Odr_LB_Click" runat="server">編輯排序</asp:LinkButton>
    <asp:LinkButton ID="Reorder_LB" CssClass="ui button" OnClick="Reorder_LB_Click" runat="server" Visible="false">更新排序</asp:LinkButton>
    <asp:LinkButton ID="Cancel_Odr_LB" CssClass="ui button" OnClick="Cancel_Odr_LB_Click" runat="server" Visible="false">取消</asp:LinkButton>
    <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT Id, Text, Link, Add_Time, font_size, font_name, color, font_weight, odr, active FROM Marquee ORDER BY odr" DeleteCommand="DELETE FROM [Marquee] WHERE [Id] = @Id" UpdateCommand="UPDATE [Marquee] SET [Text] = @Text, [Link] = @Link, [font_name] = @font_name, [font_size] = @font_size, color = @color, font_weight = @font_weight, active = @active WHERE [Id] = @Id">
      <DeleteParameters>
        <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
      </DeleteParameters>
      <UpdateParameters>
        <asp:Parameter Name="Text" Type="String"></asp:Parameter>
        <asp:Parameter Name="Link" Type="String"></asp:Parameter>
        <asp:Parameter Name="font_name"></asp:Parameter>
        <asp:Parameter Name="font_size"></asp:Parameter>
        <asp:Parameter Name="color"></asp:Parameter>
        <asp:Parameter Name="font_weight"></asp:Parameter>
        <asp:Parameter Name="active"></asp:Parameter>
        <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
      </UpdateParameters>
    </asp:SqlDataSource>
    <div class="ui marquee modal">
      <div class="header">新增首頁跑馬燈</div>
      <div class="content">
        <div class="ui form">
          <div class="field">
            <label>跑馬燈文字</label>
            <asp:TextBox ID="Marquee_Text" runat="server" placeholder="marquee text"></asp:TextBox>
            <div>
              <div class="ui compact selection dropdown">
                <asp:HiddenField ID="fontSize_HF" runat="server" Value="14px" />
                <%--<input type="hidden" id="font_size" name="font-size" value="28px">--%>
                <i class="dropdown icon"></i>
                <div class="default text">size</div>
                <div class="menu">
                  <div class="item" data-value="12px">12</div>
                  <div class="item" data-value="14px">14</div>
                  <div class="item" data-value="16px">16</div>
                  <div class="item" data-value="18px">18</div>
                  <div class="item" data-value="20px">20</div>
                  <%--<div class="item" data-value="22px">22</div>
                  <div class="item" data-value="24px">24</div>
                  <div class="item" data-value="26px">26</div>
                  <div class="item" data-value="28px">28</div>
                  <div class="item" data-value="36px">36</div>
                  <div class="item" data-value="48px">48</div>
                  <div class="item" data-value="72px">72</div>--%>
                </div>
              </div>
              <div class="ui compact selection dropdown">
                <asp:HiddenField ID="fontName_HF" runat="server" Value="Noto Sans TC, sans-serif" />
                <%--<input type="hidden" id="font_name" name="font-name" value="Noto Sans, sans-serif" />--%>
                <i class="dropdown icon"></i>
                <div class="default text">font family</div>
                <div class="menu">
                  <div class="item" data-value="Noto Sans TC, sans-serif" style="font-family: Noto Sans TC, sans-serif;">
                    思源黑體<br />
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
              <div class="ui text-color top left pointing dropdown basic icon button" title="文字顏色">
                <i class="font icon" style="color: rgba(0,0,0,.87);"></i>
                <div class="menu">
                  <div class="hidden helper item"></div>
                  <asp:TextBox ID="colorPicker_TB" CssClass="text-color-picker" runat="server" Text="rgba(0,0,0,.87)"></asp:TextBox>
                  <%--<input class="text-color-picker" name="color" value="rgba(0,0,0,.87)" />--%>
                </div>
              </div>
              <asp:CheckBox ID="Bold_CB" CssClass="bold" runat="server" Checked='<%# Eval("font_weight").Equals("bold") %>' />
            </div>
          </div>
          <div class="field">
            <label>連結(選填)</label>
            <asp:TextBox ID="Link_TB" runat="server" placeholder="link"></asp:TextBox>
          </div>
        </div>
      </div>
      <div class="actions">
        <div class="ui deny button">取消</div>
        <asp:LinkButton ID="Insert_item" CssClass="ui primary button" OnClick="Insert_item_Click" runat="server">新增</asp:LinkButton>
      </div>
    </div>
  </div>
  <div class="ui notify tiny modal">
    <div class="header">
      <asp:Label ID="modal_header" runat="server" Text=""></asp:Label>
    </div>
    <div class="content">
      <asp:Label ID="modal_content" runat="server" Text=""></asp:Label>
      <div class="ui basic fitted segment">
        <div class="ui feed container" style="position: relative;">
          <div class="event">
            <div class="label" style="position: relative;">
              <i class="bullhorn icon"></i>
              <i class="clockwise rotated wifi icon" style="top: 4px; position: absolute; right: -27px;"></i>
            </div>
            <div class="content">
              <p id="banner-text"></p>
            </div>
          </div>
        </div>
      </div>
      <div class="banner-text-config hidden" style="text-align: center;">
        <div class="ui compact selection dropdown">
          <input type="hidden" id="font_size" name="font-size" value="14px">
          <i class="dropdown icon"></i>
          <div class="default text">size</div>
          <div class="menu">
            <div class="item" data-value="12px">12</div>
            <div class="item" data-value="14px">14</div>
            <div class="item" data-value="16px">16</div>
            <div class="item" data-value="18px">18</div>
            <div class="item" data-value="20px">20</div>
            <%--<div class="item" data-value="22px">22</div>
            <div class="item" data-value="24px">24</div>
            <div class="item" data-value="26px">26</div>
            <div class="item" data-value="28px">28</div>
            <div class="item" data-value="36px">36</div>
            <div class="item" data-value="48px">48</div>
            <div class="item" data-value="72px">72</div>--%>
          </div>
        </div>
        <div class="ui compact selection dropdown">
          <input type="hidden" id="font_name" name="font-family" value="Noto Sans TC, sans-serif" />
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
        <div class="ui text-color top left pointing dropdown basic icon button" title="文字顏色">
          <i class="font icon"></i>
          <div class="menu">
            <div class="hidden helper item"></div>
            <input class="text-color-picker" name="color" value="rgba(0,0,0,.87)" />
          </div>
        </div>
        <div class="ui basic button">
          <input type="checkbox" id="bold_cb" />
          <label for="bold_cb">粗體</label>
        </div>
      </div>
    </div>
    <div class="actions">
      <div class="ui deny button">確認</div>
    </div>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/spectrum-colorpicker2/dist/spectrum.min.js"></script>
  <script>
    var opBannerPV;

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

    $('.dropdown').dropdown({
      onChange: function (val, txt, $c) {
        console.log($(this))
        console.log($(this).children('input').attr('name'))
        $('.ui.notify.modal .container #banner-text').css($(this).children('input').attr('name'), val)
      }
    });
    $('#bold_cb').on('change', function () {
      console.log($(this))
      console.log($(this).is(':checked'))
      if ($(this).is(':checked')) {
        $('.ui.notify.modal .container #banner-text').css('font-weight', 'bold')
        $('#<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("Bold_CB").ClientID:"" %>').attr('checked', '');


      } else {
        $('.ui.notify.modal .container #banner-text').css('font-weight', 'normal')
        $('#<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("Bold_CB").ClientID:"" %>').removeAttr('checked');
      }
    })
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
    if (<%= GridView1.EditIndex != -1 ? "true":"false" %>) {
      opBannerPV = function () {
        $('.ui.notify.modal .container #banner-img').attr('src', $('#b_preview').attr('src'))
        $('.ui.notify .banner-text-config').removeClass('hidden')
        if ($('#<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("Bold_CB").ClientID:"" %>').is(':checked')) {
          $('.ui.notify.modal .container #banner-text').css('font-weight', 'bold');
          $('.ui.notify.modal .content #bold_cb').attr('checked', '');
        } else {
          $('.ui.notify.modal .container #banner-text').css('font-weight', 'normal');
          $('.ui.notify.modal .content #bold_cb').removeAttr('checked');
        }
        $('.ui.notify.modal .container #banner-text').html(
          $('#<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("Marquee_TB").ClientID:"" %>').val())
        $('.ui.notify.modal .container #banner-text').css('font-size',
          $('#<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("fontSize_HF").ClientID:"" %>').val())
        $('.ui.notify.modal .banner-text-config #font_size').parents('.dropdown').dropdown('set selected',
          $('#<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("fontSize_HF").ClientID:"" %>').val());
        $('.ui.notify.modal .container #banner-text').css('font-family',
          $('#<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("fontName_HF").ClientID:"" %>').val())
        $('.ui.notify.modal .banner-text-config #font_name').parents('.dropdown').dropdown('set selected',
          $('#<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("fontName_HF").ClientID:"" %>').val())
        $('.ui.notify.modal .container #banner-text, .ui.notify.modal .banner-text-config .dropdown.basic.icon.button .font.icon').css('color',
          $('#<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("colorPicker_TB").ClientID:"" %>').val())
        $('.ui.notify.modal .banner-text-config .text-color-picker').spectrum('set',
          $('#<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("colorPicker_TB").ClientID:"" %>').val())
        $('.ui.notify.modal').modal({
          inverted: true, autofocus: false, allowMultiple: true, context: 'form', onHide: function () {
            $('#<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("fontSize_HF").ClientID:"" %>').parents('.dropdown').dropdown('set selected',
              $('.ui.notify.modal .banner-text-config #font_size').val())
            $('#<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("fontName_HF").ClientID:"" %>').parents('.dropdown').dropdown('set selected',
              $('.ui.notify.modal .banner-text-config #font_name').val())
            $('#<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("colorPicker_TB").ClientID:"" %>').spectrum('set',
              $('.ui.notify.modal .banner-text-config .text-color-picker').val())

          }, onHidden: function () {
            $('.ui.notify .banner-text-config').removeClass('hidden')
          }
        }).modal('show')
      }
    }
  </script>
</asp:Content>
