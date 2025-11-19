<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeFile="Admin_Banners.aspx.cs" Inherits="piNews.Admin_Banners" %>

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
      <div class="active section">管理首頁橫幅</div>
    </div>
  </div>
  <div class="ui segment">
    <p><span class="ui button" onclick="opmodal()">新增橫幅</span></p>
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="ui unstackable celled table" DataKeyNames="Id" GridLines="None" CellSpacing="5" DataSourceID="SqlDataSource1" OnPreRender="GridView1_PreRender" OnRowUpdating="GridView1_RowUpdating">
      <Columns>
        <asp:TemplateField HeaderText="橫幅圖片" ItemStyle-CssClass="hidden">
          <ItemTemplate>
            <td>
              <input type="hidden" name="Banner_Id" value='<%# Eval("Id") %>' />
              <img class="ui large lazy image" data-src='Image.aspx?ID=<%# Eval("Image_Id") %>' />
            </td>
          </ItemTemplate>
          <EditItemTemplate>
            <td class="collapsing">
              <div class="ui form">
              <span class="ui text" id="cb_type_img" style="padding-right: 0.8rem;">圖片</span>
              <div class="ui right aligned slider checkbox">
                <asp:CheckBox ID="b_type_CB" runat="server" />
                <label for="banner-type">影片</label>
              </div>
              <div class="hidden field">
                <div class="field">
                  <label>影片類型</label>
                  <div class="ui selection dropdown">
                    <asp:HiddenField ID="video_type_HF" Value="https://youtu.be/" runat="server" />
                    <%--<input type="hidden" id="video_type" value="https://youtu.be/" />--%>
                    <div class="default text">type</div> 
                    <div class="menu">
                      <div class="item" data-value="https://youtu.be/">Youtube</div>
                      <div class="item" data-value="https://vimeo.com/">Vimeo</div>
                    </div>
                  </div>
                </div>
                <div class="field">
                  <label>影片嵌入</label>
                  <div class="ui right labeled input">
                    <div class="ui label">
                      <!-- https://youtu.be/ or https://vimeo.com/ -->
                      <span class="format_url">https://youtu.be/</span>
                    </div>
                    <asp:TextBox ID="Video_id_TB" runat="server" style="max-width:90px;" placeholder=""></asp:TextBox>
                    <div class="ui label" style="cursor: pointer;" onclick="preview('edit')">
                      確定
                    </div>
                  </div>
                </div>
              </div>
              <div class="field">
                <asp:FileUpload ID="img_FU" runat="server" accept="image/gif, image/jpeg, image/png" />
                <img class="ui medium image" id="b_preview" src='Image.aspx?ID=<%# Eval("Image_Id") %>' />
                <div class="ui message" style="max-width: 300px; white-space: normal;">
                  <div class="header">
                    注意事項
                  </div>
                  <ul class="list">
                    <li>圖片建議尺寸： 1200 x 375px，寬高超過1200 x 375px將自動壓縮至1200 X 375px，檔案容量不得超過5MB。</li>
                    <li>圖片比例： 16:5，比例不符將無法上傳。</li>
                    <li>圖片格式：JPG,PNG,GIF</li>
                  </ul>
                </div>
              </div></div>
            </td>
          </EditItemTemplate>
        </asp:TemplateField>
        <%--<asp:BoundField HeaderText="標題" DataField="Title" NullDisplayText="-" SortExpression="Title"></asp:BoundField>--%>
        <asp:TemplateField HeaderText="標題">
          <ItemTemplate>
            <%# DBNull.Value.Equals(Eval("Title")) ? "-":Eval("Title") %>
          </ItemTemplate>
          <EditItemTemplate>
            <div class="ui fluid input">
              <asp:TextBox ID="TextBox4" runat="server" placeholder="title" Text='<%# Eval("Title") %>'></asp:TextBox>
            </div>
            <br />
            <div class="ui selection dropdown">
              <asp:HiddenField ID="fontName_HF" runat="server" Value='<%# DBNull.Value.Equals(Eval("font_name")) ? "":Eval("font_name") %>' />
              <%--<input type="hidden" id="font_name" name="font-name" value="Noto Sans, sans-serif" />--%>
              <i class="dropdown icon"></i>
              <div class="default text">font family</div>
              <div class="menu">
                <div class="item" data-value="Noto Sans, sans-serif" style="font-family: Noto Sans, sans-serif;">
                  思源黑體<br />
                  <span>abc123</span>
                </div>
                <div class="item" data-value="Noto Serif TC, serif" style="font-family: 'Noto Serif TC', serif;">
                  思源宋體<br />
                  <span>abc123</span>
                </div>
                <div class="item" data-value="Microsoft JhengHei, Noto Sans, sans-serif" style="font-family: 'Microsoft JhengHei', Noto Sans, sans-serif;">
                  微軟正黑體<br />
                  <span>abc123</span>
                </div>
                <div class="item" data-value="DFKai-sb, Noto Sans, sans-serif" style="font-family: DFKai-sb, Noto Sans, sans-serif;">
                  標楷體<br />
                  <span>abc123</span>
                </div>
                <div class="item" data-value="PMingLiU, Noto Sans, sans-serif" style="font-family: PMingLiU, Noto Sans, sans-serif;">
                  新細明體<br />
                  <span>abc123</span>
                </div>
                <div class="item" data-value="MingLiU, Noto Sans, sans-serif" style="font-family: MingLiU, Noto Sans, sans-serif;">
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
                <asp:HiddenField ID="fontSize_HF" runat="server" Value='<%# DBNull.Value.Equals(Eval("font_size")) ? "28px":Eval("font_size") %>' />
                <%--<input type="hidden" id="font_size" name="font-size" value="28px">--%>
                <i class="dropdown icon"></i>
                <div class="default text">size</div>
                <div class="menu">
                  <div class="item" data-value="12px">12</div>
                  <div class="item" data-value="14px">14</div>
                  <div class="item" data-value="16px">16</div>
                  <div class="item" data-value="18px">18</div>
                  <div class="item" data-value="20px">20</div>
                  <div class="item" data-value="22px">22</div>
                  <div class="item" data-value="24px">24</div>
                  <div class="item" data-value="26px">26</div>
                  <div class="item" data-value="28px">28</div>
                  <div class="item" data-value="36px">36</div>
                  <div class="item" data-value="48px">48</div>
                  <div class="item" data-value="72px">72</div>
                </div>
              </div>
              <div class="ui text-color top right pointing dropdown basic icon button" title="文字顏色">
                <i class="font icon" <%# string.Format("style='color: {0};'", DBNull.Value.Equals(Eval("color")) ? "rgba(0,0,0,.87)":Eval("color")) %>></i>
                <div class="menu">
                  <div class="hidden helper item"></div>
                  <asp:TextBox ID="colorPicker_TB" CssClass="text-color-picker" runat="server" Text='<%# DBNull.Value.Equals(Eval("color")) ? "rgba(0,0,0,.87)":Eval("color") %>'></asp:TextBox>
                  <%--<input class="text-color-picker" value='rgba(0,0,0,.87)' />--%>
                </div>
              </div>
              <div class="ui basic button" onclick="opBannerPV()">
                預覽
              </div>
            </div>
          </EditItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="連結">
          <ItemTemplate>
            <a class='<%# DBNull.Value.Equals(Eval("Link")) ? "hidden":"" %>' href='<%# Eval("Link") %>' target="_blank">Link</a>
            <%# DBNull.Value.Equals(Eval("Link")) ? "-":"" %>
          </ItemTemplate>
          <EditItemTemplate>
            <div class="ui input">
              <asp:TextBox ID="TextBox3" runat="server" placeholder="link" Text='<%# Eval("Link") %>'></asp:TextBox>

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
        <asp:TemplateField>
          <ItemTemplate>
            <asp:LinkButton ID="edit_btn" CssClass="ui blue icon button" CommandName="Edit" title="編輯" runat="server"><i class="pencil alternate icon"></i></asp:LinkButton>
            <asp:LinkButton ID="del_btn" CssClass="ui red icon button" CommandName="Delete" title="刪除" runat="server"><i class="trash alternate icon"></i></asp:LinkButton>
          </ItemTemplate>
          <EditItemTemplate>
            <asp:LinkButton ID="upd_btn" CssClass="ui blue button" CommandName="Update" title="更新" runat="server">更新</asp:LinkButton>
            <asp:LinkButton ID="cnl_btn" CssClass="ui red button" CommandName="Cancel" title="取消" runat="server">取消</asp:LinkButton>
          </EditItemTemplate>
        </asp:TemplateField>
      </Columns>
    </asp:GridView>

    <asp:LinkButton ID="Edit_Odr_LB" CssClass="ui button" OnClick="Edit_Odr_LB_Click" runat="server">編輯排序</asp:LinkButton>
    <asp:LinkButton ID="Reorder_LB" CssClass="ui button" OnClick="Reorder_LB_Click" runat="server" Visible="false">更新排序</asp:LinkButton>
    <asp:LinkButton ID="Cancel_Odr_LB" CssClass="ui button" OnClick="Cancel_Odr_LB_Click" runat="server" Visible="false">取消</asp:LinkButton>
    <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT [Image_Id], [Title], [Link], [Id], [font_size], [font_name], [color], [active] FROM [Banner] ORDER BY [odr]" DeleteCommand="DELETE FROM [Banner] WHERE [Id] = @Id" UpdateCommand="UPDATE [Banner] SET [Image_Id] = @Image_Id, [Title] = @Title, [Link] = @Link, [font_size] = @font_size, [font_name] = @font_name, [color] = @color, [active] = @active WHERE [Id] = @Id" InsertCommand="INSERT INTO [Banner] ([Image_Id], [Title], [Link], [font_size], [font_name], [color], [active]) VALUES (@Image_Id, @Title, @Link, @font_size, @font_name, @color, @active)">
      <DeleteParameters>
        <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
      </DeleteParameters>
      <InsertParameters>
        <asp:Parameter Name="Image_Id" Type="Int32"></asp:Parameter>
        <asp:Parameter Name="Title" Type="String"></asp:Parameter>
        <asp:Parameter Name="Link" Type="String"></asp:Parameter>
        <asp:Parameter Name="font_size" Type="String"></asp:Parameter>
        <asp:Parameter Name="font_name" Type="String"></asp:Parameter>
        <asp:Parameter Name="color" Type="String"></asp:Parameter>
        <asp:Parameter Name="active" Type="Boolean"></asp:Parameter>
      </InsertParameters>
      <UpdateParameters>
        <asp:Parameter Name="Image_Id" Type="Int32"></asp:Parameter>
        <asp:Parameter Name="Title" Type="String"></asp:Parameter>
        <asp:Parameter Name="Link" Type="String"></asp:Parameter>
        <asp:Parameter Name="font_size" Type="String"></asp:Parameter>
        <asp:Parameter Name="font_name" Type="String"></asp:Parameter>
        <asp:Parameter Name="color" Type="String"></asp:Parameter>
        <asp:Parameter Name="active" Type="Boolean"></asp:Parameter>
        <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
      </UpdateParameters>
    </asp:SqlDataSource>
    <div id="insert_banner" class="ui tiny modal">
      <i class="close icon"></i>
      <div class="header">新增橫幅</div>
      <div class="scrolling content">
        <div class="ui form">
          <div class="ui field">
            <label>橫幅類型</label>
            <span class="ui text" id="b-type-img" style="padding-right: 0.8rem;">圖片</span>
            <div class="ui right aligned slider checkbox">
              <asp:CheckBox ID="b_type_CB" runat="server" />
              <%--<input type="checkbox" id="banner-type">--%>
              <label for="banner-type">影片</label>
            </div>
          </div>
          <div class="ui field" id="b-img">
            <label>橫幅圖片</label>
            <asp:FileUpload ID="FileUpload1" runat="server" accept="image/gif, image/jpeg, image/png" />
            <img class="ui medium image" id="banner-review" src='Image.aspx?ID=<%# Eval("ID") %>' />
            <div class="ui message">
              <div class="header">
                注意事項
              </div>
              <ul class="list">
                <li>圖片建議尺寸： 1200 x 375px，寬高超過1200 x 375px將自動壓縮至1200 X 375px，檔案容量不得超過5MB。</li>
                <li>圖片比例： 16:5，比例不符將無法上傳。</li>
                <li>圖片格式： JPG,PNG,GIF</li>
              </ul>
            </div>
          </div>
          <div class="hidden fields">
            <div class="four wide field">
              <label>影片類型</label>
              <div class="ui selection dropdown">
                <asp:HiddenField ID="video_type_HF" Value="https://youtu.be/" runat="server" />
                <%--<input type="hidden" id="video_type" value="https://youtu.be/" />--%>
                <div class="default text">type</div>
                <i class="dropdown icon"></i>
                <div class="menu">
                  <div class="item" data-value="https://youtu.be/">Youtube</div>
                  <div class="item" data-value="https://vimeo.com/">Vimeo</div>
                </div>
              </div>
            </div>
            <div class="twelve wide field">
              <label>影片嵌入</label>
              <div class="ui right labeled input">
                <div class="ui label">
                  <!-- https://youtu.be/ or https://vimeo.com/ -->
                  <span class="format_url">https://youtu.be/</span>
                </div>
                <asp:TextBox ID="Video_id_TB" runat="server" placeholder=""></asp:TextBox>
                <div class="ui label" style="cursor: pointer" onclick="preview('edit')">
                  確定
                </div>
              </div>
            </div>
          </div>
          <div class="ui field">
            <label>標題</label>
            <asp:TextBox ID="TextBox1" runat="server" placeholder="title"></asp:TextBox>
            <div>
              <div class="ui compact selection dropdown">
                <asp:HiddenField ID="fontSize_HF" runat="server" Value="28px" />
                <%--<input type="hidden" id="font_size" name="font-size" value="28px">--%>
                <i class="dropdown icon"></i>
                <div class="default text">size</div>
                <div class="menu">
                  <div class="item" data-value="12px">12</div>
                  <div class="item" data-value="14px">14</div>
                  <div class="item" data-value="16px">16</div>
                  <div class="item" data-value="18px">18</div>
                  <div class="item" data-value="20px">20</div>
                  <div class="item" data-value="22px">22</div>
                  <div class="item" data-value="24px">24</div>
                  <div class="item" data-value="26px">26</div>
                  <div class="item" data-value="28px">28</div>
                  <div class="item" data-value="36px">36</div>
                  <div class="item" data-value="48px">48</div>
                  <div class="item" data-value="72px">72</div>
                </div>
              </div>
              <div class="ui compact selection dropdown">
                <asp:HiddenField ID="fontName_HF" runat="server" Value="Noto Sans, sans-serif" />
                <%--<input type="hidden" id="font_name" name="font-name" value="Noto Sans, sans-serif" />--%>
                <i class="dropdown icon"></i>
                <div class="default text">font family</div>
                <div class="menu">
                  <div class="item" data-value="'Noto Sans TC', sans-serif" style="font-family: 'Noto Sans TC', sans-serif;">
                    思源黑體<br />
                    <span>abc123</span>
                  </div>
                  <div class="item" data-value="Noto Serif TC, serif" style="font-family: 'Noto Serif TC', serif;">
                    思源宋體<br />
                    <span>abc123</span>
                  </div>
                  <div class="item" data-value="Microsoft JhengHei, Noto Sans, sans-serif" style="font-family: 'Microsoft JhengHei', Noto Sans, sans-serif;">
                    微軟正黑體<br />
                    <span>abc123</span>
                  </div>
                  <div class="item" data-value="DFKai-sb, Noto Sans, sans-serif" style="font-family: DFKai-sb, Noto Sans, sans-serif;">
                    標楷體<br />
                    <span>abc123</span>
                  </div>
                  <div class="item" data-value="PMingLiU, Noto Sans, sans-serif" style="font-family: PMingLiU, Noto Sans, sans-serif;">
                    新細明體<br />
                    <span>abc123</span>
                  </div>
                  <div class="item" data-value="MingLiU, Noto Sans, sans-serif" style="font-family: MingLiU, Noto Sans, sans-serif;">
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
              <div class="ui text-color top right pointing dropdown basic icon button" title="文字顏色">
                <i class="font icon"></i>
                <div class="menu">
                  <div class="hidden helper item"></div>

                  <asp:TextBox ID="colorPicker_TB" CssClass="text-color-picker" runat="server" Text="rgba(0,0,0,.87)"></asp:TextBox>
                  <%--<input class="text-color-picker" name="color" value="rgba(0,0,0,.87)" />--%>
                </div>
              </div>
            </div>
          </div>
          <div class="ui field">
            <label>連結</label>
            <asp:TextBox ID="TextBox2" runat="server" placeholder="link"></asp:TextBox>
          </div>
        </div>
      </div>
      <div class="actions">
        <asp:LinkButton ID="LinkButton1" CssClass="ui button" OnClick="LinkButton1_Click" runat="server">新增</asp:LinkButton>
        <div class="ui deny button">取消</div>
        <%--<asp:LinkButton ID="LinkButton2" runat="server"></asp:LinkButton>--%>
      </div>
    </div>
  </div>

  <div class="ui notify tiny modal">
    <div class="header">
      <asp:Label ID="modal_header" runat="server" Text=""></asp:Label>
    </div>
    <div class="content">
      <asp:Label ID="modal_content" runat="server" Text=""></asp:Label>
      <div class="ui container" style="position: relative;">
        <img id="banner-img" class="ui image" />
        <h1 id="banner-text" class="ui huge header" style="position: absolute; bottom: 0; left: 0;"></h1>
      </div>
      <div class="banner-text-config hidden" style="text-align: center;">
        <div class="ui compact selection dropdown">
          <input type="hidden" id="font_size" name="font-size" value="28px">
          <i class="dropdown icon"></i>
          <div class="default text">size</div>
          <div class="menu">
            <div class="item" data-value="12px">12</div>
            <div class="item" data-value="14px">14</div>
            <div class="item" data-value="16px">16</div>
            <div class="item" data-value="18px">18</div>
            <div class="item" data-value="20px">20</div>
            <div class="item" data-value="22px">22</div>
            <div class="item" data-value="24px">24</div>
            <div class="item" data-value="26px">26</div>
            <div class="item" data-value="28px">28</div>
            <div class="item" data-value="36px">36</div>
            <div class="item" data-value="48px">48</div>
            <div class="item" data-value="72px">72</div>
          </div>
        </div>
        <div class="ui compact selection dropdown">
          <input type="hidden" id="font_name" name="font-family" value="Noto Sans, sans-serif" />
          <i class="dropdown icon"></i>
          <div class="default text">font family</div>
          <div class="menu">
            <div class="item" data-value="Noto Sans, sans-serif" style="font-family: Noto Sans, sans-serif;">
              思源黑體<br />
              <span>abc123</span>
            </div>
            <div class="item" data-value="Noto Serif TC, serif" style="font-family: 'Noto Serif TC', serif;">
              思源宋體<br />
              <span>abc123</span>
            </div>
            <div class="item" data-value="Microsoft JhengHei, Noto Sans, sans-serif" style="font-family: 'Microsoft JhengHei', Noto Sans, sans-serif;">
              微軟正黑體<br />
              <span>abc123</span>
            </div>
            <div class="item" data-value="DFKai-sb, Noto Sans, sans-serif" style="font-family: DFKai-sb, Noto Sans, sans-serif;">
              標楷體<br />
              <span>abc123</span>
            </div>
            <div class="item" data-value="PMingLiU, Noto Sans, sans-serif" style="font-family: PMingLiU, Noto Sans, sans-serif;">
              新細明體<br />
              <span>abc123</span>
            </div>
            <div class="item" data-value="MingLiU, Noto Sans, sans-serif" style="font-family: MingLiU, Noto Sans, sans-serif;">
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
        <div class="ui text-color top right pointing dropdown basic icon button" title="文字顏色">
          <i class="font icon"></i>
          <div class="menu">
            <div class="hidden helper item"></div>

            <input class="text-color-picker" name="color" value="rgba(0,0,0,.87)" />
          </div>
        </div>
      </div>
    </div>
    <div class="actions">
      <div class="ui deny button">確認</div>
    </div>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/spectrum-colorpicker2/dist/spectrum.min.js"></script>
  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.9/jquery.lazy.min.js"></script>
  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.9/jquery.lazy.plugins.min.js"></script>
  <script>

    $('#<%= b_type_CB.ClientID %>').on('click', function () {
      if ($('#<%= b_type_CB.ClientID %>').is(':checked')) {
        $('#b-type-img').addClass('disabled')
        $('#insert_banner .fields').removeClass('hidden')
        $('#insert_banner #b-img').addClass('hidden')
      } else {
        $('#b-type-img').removeClass('disabled')
        $('#insert_banner .fields').addClass('hidden')
        $('#insert_banner #b-img').removeClass('hidden')
      }
    })

    $('<%= GridView1.EditIndex != -1 ? "#"+GridView1.Rows[GridView1.EditIndex].FindControl("b_type_CB").ClientID:"" %>').on('click', function () {
      if ($(this).is(':checked')) {
        $('#cb_type_img').addClass('disabled')
        $('#cb_type_img ~ .field:has(.field)').removeClass('hidden')
        $('.field:has(<%= GridView1.EditIndex != -1 ? "#"+GridView1.Rows[GridView1.EditIndex].FindControl("img_FU").ClientID:"" %>)').addClass('hidden')
      } else {
        $('#cb_type_img').removeClass('disabled')
        $('#cb_type_img ~ .field:has(.field)').addClass('hidden')
        $('.field:has(<%= GridView1.EditIndex != -1 ? "#"+GridView1.Rows[GridView1.EditIndex].FindControl("img_FU").ClientID:"" %>)').removeClass('hidden')
      }
    })
    $('.dropdown').dropdown({
      onChange: function (val, txt, $c) {
        console.log($(this))
        console.log($(this).children('input').attr('name'))
        if ($(this).children('input').attr('name') == 'font-size')
          $('.ui.notify.modal .container').css($(this).children('input').attr('name'), val)
        else
          $('.ui.notify.modal .container #banner-text').css($(this).children('input').attr('name'), val)
      }
    });

    //video
    $('.modal .content .fields .dropdown').dropdown({
      onChange: function (value, text) {
        console.log(value)
        $('.modal .content .format_url').html(value);
      }
    });

    //video
    $('.table #cb_type_img ~ .field:has(.field) .dropdown').dropdown({
      onChange: function (value, text) {
        console.log(value)
        $('.table #cb_type_img ~ .field:has(.field) .format_url').html(value);
      }
    });

    $('.modal #<%= Video_id_TB.ClientID %>').on('change', function () {
      var val = $(this).val();
      var $sel = $('#<%= video_type_HF.ClientID %>').val();
      if ($sel == 'https://youtu.be/') {
        var isYoutube = val.match(/(?:http:|https:|)\/\/(www\.)?(?:youtube\.com|youtu\.be)\/?(?:watch\?|embed)?(^|\/|v=)?([a-z0-9_-]{11})/i);
        if (isYoutube != null) {
          var match = val.match(/(^|\/|v=)?([a-z0-9_-]{11})/i);
          if (match != null) {
            var final = match[0].replace(/(\/|v=)/i, '');
            $(this).val(final);
            if (checkYoutubeValid(final)) {
              var setting = {};
              setting.source = 'youtube';
              setting.id = final;
              setting.autoplay = true;
              console.log(setting);
              $('#preview-ad .image .ui.embed').attr('data-id', final);
              $('#preview-ad .image .ui.embed').attr('data-source', 'youtube');
              $('#preview-ad .image .ui.embed').attr('contenteditable', 'false');
              // $('#preview-ad .image .ui.embed').embed(setting);
              $('#preview-ad .image .ui.embed').removeClass('hidden')
              $('#preview-ad .image .long.square').addClass('hidden')
            }
          }
        } else if (val.match(/^[a-z0-9_-]{11}$/i).length > 0) {
          console.log(val.match(/^[a-z0-9_-]{11}$/i)[0])
          if (checkYoutubeValid(val)) {
            var setting = {};
            setting.source = 'youtube';
            setting.id = val;
            setting.autoplay = true;
            console.log(setting);
            $('#preview-ad .image .ui.embed').attr('data-id', val);
            $('#preview-ad .image .ui.embed').attr('data-source', 'youtube');
            $('#preview-ad .image .ui.embed').attr('contenteditable', 'false');
            // $('#preview-ad .image .ui.embed').embed(setting);
            $('#preview-ad .image .ui.embed').removeClass('hidden')
            $('#preview-ad .image .long.square').addClass('hidden')
          }
        }
      } else {
        var isVimeo = val.match(/(?:http:|https:|)\/\/(?:player.|www.)?vimeo\.com\/(?:video\/|embed\/|watch\?\S*v=|v\/)?(\d*)/i);
        var isVimeoId = val.match(/^\d+$/i);
        if (isVimeo != null) {
          var match = val.match(/\/(?:video\/|embed\/|watch\?\S*v=|v\/)?(\d+)/i);
          if (match != null) {
            var final = match[0].replace(/\/(?:video\/|embed\/|watch\?\S*v=|v\/)?/i, '');
            $(this).val(final);
            console.log(match, final);
            var setting = {};
            setting.source = 'vimeo';
            setting.id = final;
            setting.autoplay = true;
            console.log(setting);
            $('#preview-ad .image .ui.embed').attr('data-id', final);
            $('#preview-ad .image .ui.embed').attr('data-source', 'vimeo');
            $('#preview-ad .image .ui.embed').attr('contenteditable', 'false');
            // $('#preview-ad .image .ui.embed').embed(setting);
            $('#preview-ad .image .ui.embed').removeClass('hidden')
            $('#preview-ad .image .long.square').addClass('hidden')
          }
        } else if (isVimeoId != null) {
          console.log(val.match(/^\d+$/i)[0])
          var setting = {};
          setting.source = 'vimeo';
          setting.id = val;
          setting.autoplay = true;
          console.log(setting);
          $('#preview-ad .image .ui.embed').attr('data-id', val);
          $('#preview-ad .image .ui.embed').attr('data-source', 'vimeo');
          $('#preview-ad .image .ui.embed').attr('contenteditable', 'false');
          // $('#preview-ad .image .ui.embed').embed(setting);
          $('#preview-ad .image .ui.embed').removeClass('hidden')
          $('#preview-ad .image .long.square').addClass('hidden')
        }

        //regex reference: https://regexr.com/4lrm3 and https://regexr.com/3nsop
        //youtube url valid check reference: https://gist.github.com/tonY1883/a3b85925081688de569b779b4657439b
      }
    });

    function checkYoutubeValid(id) {
      var img = new Image();
      var valid = true;
      img.src = "http://img.youtube.com/vi/" + id + "/mqdefault.jpg";
      img.onload = function () {
        valid = checkThumbnail(this.width);
      }
      return valid;
    }

    function checkThumbnail(width) {
      if (width === 120) {
        console.log('Error: video not found!');
        return false;
      }
    }

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

    var prm = Sys.WebForms.PageRequestManager.getInstance();
    prm.add_endRequest(function () {
      $('.lazy').Lazy({ threshold: 500, effect: 'fadeIn', effectTime: 500, appendScroll: $('.ui.scrolling.basic.segment') });
    })
    $('.lazy').Lazy({ threshold: 500, effect: 'fadeIn', effectTime: 500, appendScroll: $('.ui.scrolling.basic.segment') });
    var opBannerPV;
    function opmodal() {
      $('#insert_banner').modal({
        inverted: true, autofocus: false, allowMultiple: true, context: 'form'
      }).modal('show');
    }
    $('#<%= FileUpload1.ClientID %>').on('change', function () {
      var file = document.getElementById('<%= FileUpload1.ClientID %>').files;
      var url = URL.createObjectURL(file[0]);

      $('#banner-review').attr('src', url);
    })

    function checkFileSize(f) {
      if (f.size / 1024 < 5120) {
        return true;
      }
      return false;
    }
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
        $('.ui.notify.modal .container #banner-text').html(
          $('#<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("TextBox4").ClientID:"" %>').val())
        $('.ui.notify.modal .container').css('font-size',
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
        $('.ui.notify.modal').removeClass('tiny').addClass('fullscreen').modal({
          inverted: true, autofocus: false, allowMultiple: true, context: 'form', onHide: function () {
            $('#<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("fontSize_HF").ClientID:"" %>').parents('.dropdown').dropdown('set selected',
              $('.ui.notify.modal .banner-text-config #font_size').val())
            $('#<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("fontName_HF").ClientID:"" %>').parents('.dropdown').dropdown('set selected',
              $('.ui.notify.modal .banner-text-config #font_name').val())
            $('#<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("colorPicker_TB").ClientID:"" %>').spectrum('set',
              $('.ui.notify.modal .banner-text-config .text-color-picker').val())

          }, onHidden: function () {
            $('.ui.notify .banner-text-config').removeClass('hidden')
            $('.ui.notify.modal').removeClass('fullscreen').addClass('tiny')
          }
        }).modal('show')
      }
      $('#<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("img_FU").ClientID:"" %>').on('change', function () {

        var file = document.getElementById('<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("img_FU").ClientID:"" %>').files;
        var url = URL.createObjectURL(file[0]);
        if (checkFileSize(file[0])) {
          const img = new Image();
          img.onload = function () {
            if (this.width / this.height != 16 / 5) {
              console.log(this.width, this.height, this.width / this.height)
              console.log(this)
              console.log(16, 5, 16 / 5)
              alert('請修正長寬比');
              document.getElementById('<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("img_FU").ClientID:"" %>').value = '';
              //$(this).removeAttr('src');
            } else if (this.width > 1200 || this.height > 375) {
              alert('注意！圖片寬高超過1200 x 375px,上傳後將進行壓縮！');
              $('#b_preview').attr('src', url);
            } else {
              $('#b_preview').attr('src', url);
            }
          }
          img.src = url;
        <%--$('#b_preview').on('load', function () {
          if ($(this).width() / $(this).height() != 3.2) {
            alert('請修正長寬比');
            document.getElementById('<%= GridView1.EditIndex !=-1 ? GridView1.Rows[GridView1.EditIndex].FindControl("img_FU").ClientID:"" %>').files = '';
            $(this).removeAttr('src');
          }
          if ($(this).width() > 1200 || $(this).height() > 375) {
            alert('注意！圖片寬高超過1200 x 375px,上傳後將進行壓縮！');
          }
        })--%>
        } else {
          alert('檔案大小超過5MB');
        }
      })
    }
  </script>

</asp:Content>
