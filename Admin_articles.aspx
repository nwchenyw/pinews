<%@ Page Title="" Language="C#" MasterPageFile="AdminPage.Master" AutoEventWireup="true" CodeFile="Admin_articles.aspx.cs" Inherits="piNews.Admin_articles" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <link rel="stylesheet" type="text/css"
    href="https://cdn.jsdelivr.net/npm/spectrum-colorpicker2/dist/spectrum.min.css">
  <link rel="stylesheet" href="css/editor.css" />
  <link rel="stylesheet" href="css/cropper.min.css" />
  <style>
    .ui.disabled.tagged.dropdown, .ui.dropdown .menu > .disabled.item {
      opacity: 1;
    }

      .ui.disabled.tagged.dropdown .ui.label > .close.icon, .ui.disabled.tagged.dropdown .ui.label > .delete.icon {
        display: none;
      }

    .ui.card .three.grid .author {
      padding: 1rem 0 0;
    }

    .ui.ad {
      max-width: 100% !important;
    }

    input[type=radio][name$=personal_ad]:checked + label {
      border: 1px solid #257fa4;
      padding: .4em .5em;
      border-radius: 5px;
    }

    #article-detail .result canvas {
      max-width: 100%;
    }

    #image_container {
      position: relative;
    }

    .preview {
      position: absolute;
      top: 10px;
      right: 10px;
      z-index: 5;
      border: 1px solid #fff;
    }

      .preview .ui.tiny.image {
        position: relative;
        overflow: hidden;
      }

    @media screen and (max-width: 797.98px) {
      #main .ui.segment {
        display: inline-block;
      }
    }
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <script src="js/cropper.min.js"></script>
  <script src="js/heic2any.js"></script>
  <script src="js/jquery-cropper.min.js"></script>
  <div class="ui inverted segment">
    <div class="ui inverted breadcrumb">
      <a class="section">Home</a>
      <div class="divider">/ </div>
      <div class="active section">管理投稿文章</div>
    </div>
  </div>
  <div class="ui segment">

    <asp:HiddenField ID="Email_HF" runat="server" />
    <asp:HiddenField ID="UID_HF" runat="server" />
    <asp:HiddenField ID="Name_HF" runat="server" />
    <asp:HiddenField ID="Pname_HF" runat="server" />
    <%--<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>--%>
    <%--<asp:UpdatePanel ID="UpdatePanel1" runat="server">
      <ContentTemplate>--%>
    <p>
      <a class="ui icon left labeled button" href="Admin_newArticle.aspx"><i class="plus icon"></i>新增投稿文章</a>

      <asp:RadioButtonList ID="RadioButtonList1" CssClass="ui right floated teal icon buttons" AutoPostBack="true" OnSelectedIndexChanged="RadioButtonList1_SelectedIndexChanged" RepeatLayout="Flow" RepeatDirection="Horizontal" runat="server">
        <asp:ListItem Value="table" Text="<i class='table icon'></i>"></asp:ListItem>
        <asp:ListItem Value="grid" Selected="True" Text="<i class='th large icon' style='font-size: 1em;'></i>"></asp:ListItem>
      </asp:RadioButtonList>
      <%--<span class="ui icon buttons">
        <span class="ui button">
          <i class="th large icon"></i>
        </span>
        <span class="ui button">
          <i class="table icon"></i>
        </span>
      </span>--%>
    </p>

    <asp:GridView ID="GridView1" CssClass="ui unstackable celled selectable table" GridLines="None" CellSpacing="5" AllowPaging="true" PageSize="6" Visible="false" runat="server" AutoGenerateColumns="False" DataKeyNames="Id,Recommand_Category" DataSourceID="SqlDataSource1" OnRowDeleting="GridView1_RowDeleting" OnRowDataBound="GridView1_RowDataBound" OnRowEditing="GridView1_RowEditing" OnRowUpdating="GridView1_RowUpdating" OnRowCreated="GridView1_RowCreated">
      <Columns>
        <asp:BoundField DataField="Title" HeaderText="標題" SortExpression="Title" ReadOnly="true"></asp:BoundField>
        <asp:TemplateField HeaderText="分類">
          <ItemTemplate>
            <div class="ui multiple disabled tagged dropdown">
              <asp:HiddenField ID="Category_HF" runat="server" Value='<%# Eval("Category") %>' />
              <%--<i class="dropdown icon"></i>--%>
              <div class="default text">Category</div>
              <div class="menu">
                <asp:Repeater ID="Category_R" runat="server" DataSourceID="SqlDataSource3">
                  <ItemTemplate>
                    <div class="item" data-value='<%# Eval("Id") %>'><%# Eval("Name") %></div>
                  </ItemTemplate>
                </asp:Repeater>
                <asp:SqlDataSource runat="server" ID="SqlDataSource3" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT * FROM [Menu]"></asp:SqlDataSource>
              </div>
            </div>
          </ItemTemplate>
          <EditItemTemplate>
            <div class="ui multiple selection restrict dropdown">
              <asp:HiddenField ID="Category_HF" runat="server" Value='<%# Eval("Category") %>' />
              <i class="dropdown icon"></i>
              <div class="default text">Category</div>
              <div class="menu">
                <asp:Repeater ID="Category_R" runat="server" DataSourceID="SqlDataSource3">
                  <ItemTemplate>
                    <div class="item" data-value='<%# Eval("Id") %>'><%# Eval("Name") %></div>
                  </ItemTemplate>
                </asp:Repeater>
                <asp:SqlDataSource runat="server" ID="SqlDataSource3" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT * FROM [Menu]"></asp:SqlDataSource>
              </div>
            </div>
          </EditItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="首頁投放類別">
          <ItemTemplate>
            <div class="ui multiple disabled tagged dropdown">
              <asp:HiddenField ID="Recommend_HF" runat="server" Value='<%# Eval("Recommand_Category") %>' />
              <%--<i class="dropdown icon"></i>--%>
              <div class="default text">None</div>
              <div class="menu">
                <asp:Repeater ID="Recommend_R" runat="server" DataSourceID="SqlDataSource4">
                  <ItemTemplate>
                    <div class="item" data-value='<%# Eval("Id") %>'><%# Eval("Category_Name") %></div>
                  </ItemTemplate>
                </asp:Repeater>
                <asp:SqlDataSource runat="server" ID="SqlDataSource4" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT * FROM [Recommendation] WHERE (([Art_Grouping] = @Art_Grouping) OR ([Art_Grouping] IS NULL))">
                  <SelectParameters>
                    <asp:Parameter DefaultValue="cat" Name="Art_Grouping" Type="String"></asp:Parameter>
                  </SelectParameters>
                </asp:SqlDataSource>
              </div>
            </div>
          </ItemTemplate>
          <EditItemTemplate>
            <div class="ui multiple selection dropdown">
              <asp:HiddenField ID="Recommend_HF" runat="server" Value='<%# Eval("Recommand_Category") %>' />
              <i class="dropdown icon"></i>
              <div class="default text">None</div>
              <div class="menu">
                <asp:Repeater ID="Recommend_R" runat="server" DataSourceID="SqlDataSource4">
                  <ItemTemplate>
                    <div class="item" data-value='<%# Eval("Id") %>'><%# Eval("Category_Name") %></div>
                  </ItemTemplate>
                </asp:Repeater>
                <asp:SqlDataSource runat="server" ID="SqlDataSource4" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT * FROM [Recommendation] WHERE (([Art_Grouping] = @Art_Grouping) OR ([Art_Grouping] IS NULL))">
                  <SelectParameters>
                    <asp:Parameter DefaultValue="cat" Name="Art_Grouping" Type="String"></asp:Parameter>
                  </SelectParameters>
                </asp:SqlDataSource>
              </div>
            </div>
          </EditItemTemplate>
        </asp:TemplateField>
        <asp:BoundField DataField="DateTime" HeaderText="上傳時間" SortExpression="DateTime" ReadOnly="true"></asp:BoundField>
        <%--<asp:BoundField DataField="Status" HeaderText="狀態" SortExpression="Status"></asp:BoundField>--%>
        <asp:TemplateField HeaderText="上架" ItemStyle-CssClass="center aligned">
          <ItemTemplate>
            <%# Eval("Status").Equals(1) ? "<i class='ui green check icon'></i>":"<i class='ui red times icon'></i>" %>
          </ItemTemplate>
          <EditItemTemplate>
            <asp:CheckBox ID="Status_CB" CssClass="ui toggle checkbox" runat="server" Text=" " Checked='<%# Eval("Status").Equals(1) %>' />
          </EditItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="動作">
          <ItemTemplate>
            <asp:LinkButton ID="Edit_LB" CssClass="ui teal icon button" title="快速編輯" CommandName="Edit" runat="server"><i class="pen nib icon"></i></asp:LinkButton>
            <asp:LinkButton ID="Select_LB" CssClass="ui blue icon button" title="瀏覽" CommandName="Select" runat="server"><i class="newspaper outline icon"></i></asp:LinkButton>
            <asp:LinkButton ID="Delete_LB" CssClass="ui red icon button" title="刪除" CommandName="Delete" runat="server"><i class="trash alternate icon"></i></asp:LinkButton>
          </ItemTemplate>
          <EditItemTemplate>
            <asp:LinkButton ID="Update_LB" CssClass="ui blue button" CommandName="Update" runat="server">更新</asp:LinkButton>
            <asp:LinkButton ID="Cancel_LB" CssClass="ui button" CommandName="Cancel" runat="server">取消</asp:LinkButton>
          </EditItemTemplate>
        </asp:TemplateField>
      </Columns>
      <PagerTemplate>
        <nav role="navigation">
          <ul class="ui pagination menu" style="padding: 0;">

            <asp:LinkButton ID="lbtnFirst" runat="server" CssClass="item" Font-Overline="false" CommandName="Page"
              CommandArgument="1">First</asp:LinkButton>

            <asp:LinkButton ID="lbtnPrev" runat="server" CssClass="item" Font-Overline="false"><i>Prev</i></asp:LinkButton>
            <asp:PlaceHolder ID="phdPageNumber" runat="server"></asp:PlaceHolder>

            <asp:LinkButton ID="lbtnNext" runat="server" CssClass="item" Font-Overline="false"><i>Next</i></asp:LinkButton>

            <asp:LinkButton ID="lbtnLast" runat="server" CssClass="item" Font-Overline="false" CommandName="Page"
              CommandArgument='<%# GridView1.PageCount %>'>Last</asp:LinkButton>
            <asp:PlaceHolder ID="phdPagenl" runat="server"></asp:PlaceHolder>
          </ul>
        </nav>
      </PagerTemplate>
      <EmptyDataTemplate>
        尚無發布任何文章
      </EmptyDataTemplate>
    </asp:GridView>

    <asp:ListView ID="ListView1" runat="server" DataKeyNames="Id" DataSourceID="SqlDataSource1" Visible="true">
      <EmptyDataTemplate>
        尚無發布任何文章
      </EmptyDataTemplate>
      <LayoutTemplate>
        <div class="ui three centered cards">
          <asp:PlaceHolder ID="itemPlaceHolder" runat="server"></asp:PlaceHolder>
        </div>
      </LayoutTemplate>
      <ItemTemplate>
        <asp:LinkButton ID="LinkButton3" CommandName="Select" CssClass="hidden" runat="server">LinkButton</asp:LinkButton>
        <%--<button onclick='<%# Page.ClientScript.GetPostBackEventReference(Container.NamingContainer, "Select$" + DataBinder.Eval(Container, "DataItemIndex")) %>'>a</button>--%>
        <div class="ui horizontal link card" onclick='<%# string.Format("__doPostBack(&#39;{0}&#39;, &#39;&#39;)", Container.FindControl("LinkButton3").UniqueID) %>'>
          <div class="image">
            <img class="lazy" data-src='Image.aspx?ID=<%# Eval("Front_Img_Id") %>'>
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
            <div class="extra content ui three column grid" style="margin: 0 0 1rem;">
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
        </div>
      </ItemTemplate>
    </asp:ListView>
    <%--<asp:DataPager ID="DataPager1" runat="server" PageSize="2" PagedControlID="GridView1">
      <Fields>
        <asp:NextPreviousPagerField ShowNextPageButton="False"></asp:NextPreviousPagerField>
        <asp:NumericPagerField></asp:NumericPagerField>
        <asp:NextPreviousPagerField ShowPreviousPageButton="False"></asp:NextPreviousPagerField>
      </Fields>
    </asp:DataPager>--%>

    <asp:HiddenField ID="imgUrl_HF" runat="server" />
    <asp:FileUpload ID="img_FU" CssClass="hidden" runat="server" accept="image/gif, image/jpeg, image/png" />
    <asp:HiddenField ID="f_extension_HF" runat="server" />
    <asp:HiddenField ID="contenttype_HF" runat="server" />
    <asp:HiddenField ID="Front_Img_HF" runat="server" />
    <asp:FormView ID="FormView1" runat="server" RenderOuterTable="False" DataKeyNames="Id,Relate_Img,r_img" OnItemUpdating="FormView1_ItemUpdating" OnPreRender="FormView1_PreRender" DataSourceID="SqlDataSource2">
      <EditItemTemplate>
        <div id="article_detail" class="ui fullscreen overlay modal">
          <i class="close icon"></i>
          <div class="header">編輯文章</div>
          <div class="scrolling content">
            <div class="ui form text container">
              <div class="field">
                <label>
                  首圖
                  <asp:Repeater ID="Repeater2" runat="server" DataSourceID="SqlDataSource6">
                    <ItemTemplate>
                      <span class='ui image right floated label <%# (float)Convert.ToDouble(Eval("mb", "{0:0.00}")) > 5 ? "red":"teal" %>'><i class='images icon <%# (float)Convert.ToDouble(Eval("mb", "{0:0.00}")) > 5 ? "hidden":"" %>'></i><i class='corner exclamation triangle icon <%# (float)Convert.ToDouble(Eval("mb", "{0:0.00}")) > 5 ? "":"hidden" %>'></i>閒置圖片<asp:Label CssClass="detail" Text='<%# Eval("mb", "{0:0.00}") + "MB" %>' runat="server" ID="mbLabel" /></span>
                    </ItemTemplate>
                  </asp:Repeater>
                </label>
                <asp:SqlDataSource runat="server" ID="SqlDataSource6" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT ISNULL(SUM(i.Size) / 1024, 0) AS mb FROM Image AS i LEFT OUTER JOIN Article_Image AS ai ON i.Id = ai.image_id LEFT OUTER JOIN Article AS a ON i.Id = a.Front_Img_Id LEFT OUTER JOIN Advertisement AS ad ON i.Id = ad.Img_Id LEFT OUTER JOIN Member AS m ON i.Id = m.Member_Img_Id LEFT OUTER JOIN Banner AS b ON i.Id = b.Image_Id WHERE (i.Image_Type <> 2) AND (i.User_id = @Id) AND (ai.article_id IS NULL) AND (ad.Id IS NULL) AND (m.Id IS NULL) AND (b.Id IS NULL) AND (a.Id IS NULL)">
                  <SelectParameters>
                    <asp:SessionParameter SessionField="User_Id" Name="Id"></asp:SessionParameter>
                  </SelectParameters>
                </asp:SqlDataSource>
                </label>
                <asp:FileUpload ID="front_IU" runat="server" accept="image/gif, image/jpeg, image/png, image/heic" />
                <div class="result"></div>
                <div id="image_container">
                  <div class="hidden preview">
                    <div class="ui tiny image"></div>
                  </div>
                  <div class="ui hidden view button" onclick="get_img('view')">預覽</div>
                  <div class="ui hidden ok button" onclick="get_img('ok')">完成</div>
                  <img class="ui image" id="Front_img" height="auto" width="100%" src='Image.aspx?ID=<%# Eval("Front_Img_Id") %>' />
                </div>
              </div>
              <div class="field">
                <label>標題</label>
                <asp:TextBox Text='<%# Bind("Title") %>' runat="server" ID="TitleTextBox" />
              </div>
              <div class="field">
                <label>分類</label>
                <div class="ui multiple selection dropdown">
                  <asp:HiddenField ID="Category_HF" runat="server" Value='<%# Bind("Category") %>' />
                  <i class="dropdown icon"></i>
                  <div class="default text">Category</div>
                  <div class="menu">
                    <asp:Repeater ID="Category_R" runat="server" DataSourceID="SqlDataSource3">
                      <ItemTemplate>
                        <div class="item" data-value='<%# Eval("Id") %>'><%# Eval("Name") %></div>
                      </ItemTemplate>
                    </asp:Repeater>
                    <asp:SqlDataSource runat="server" ID="SqlDataSource3" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT * FROM [Menu]"></asp:SqlDataSource>
                  </div>
                </div>
              </div>
              <div class="field">
                <label>簡短介紹(中文最多200字/英文400字)</label>
                <div class="ui input">
                  <asp:TextBox ID="Description" TextMode="MultiLine" MaxLength="400" Rows="4" runat="server" Text='<%# DBNull.Value.Equals(Eval("Description")) ? "":HttpUtility.HtmlDecode(Eval("Description").ToString()) %>'></asp:TextBox>
                  <span class="ui bottom right attached label">0/400</span>
                </div>
              </div>
              <div class="field">
                <label>標籤</label>
                <div class="ui multiple selection search dropdown">
                  <asp:HiddenField ID="Keywords_HF" runat="server" Value='<%# Eval("Keyword").ToString() %>' />
                  <i class="dropdown icon"></i>
                  <div class="default text">Keyword</div>
                  <div class="menu">
                    <asp:Repeater ID="Keyword_R" runat="server" DataSourceID="SqlDataSource4">
                      <ItemTemplate>
                        <div class="item" data-value='<%# Eval("keyword") %>'><%# Eval("keyword") %></div>
                      </ItemTemplate>
                    </asp:Repeater>
                    <asp:SqlDataSource runat="server" ID="SqlDataSource4" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT TOP 20 kw.Item AS keyword
FROM Article A OUTER APPLY dbo.SplitString (A.Keyword, ',') kw
group by kw.Item"></asp:SqlDataSource>
                  </div>
                </div>
                <%--<asp:TextBox Text='<%# Bind("Keyword") %>' runat="server" ID="KeywordTextBox" />--%>
              </div>



              <div class="field">
                <label>是否上架</label>
                <asp:CheckBox Checked='<%# Eval("Status").Equals(1) %>' Enabled='<%# Session["IsAdmin"].Equals("True") %>' CssClass="ui toggle checkbox" Text=" " runat="server" ID="StatusCheckBox" />
              </div>


              <div class="field">
                <label>文章上架期間(上架中若無設定上架期間則無限期上架)</label>
                <asp:TextBox Text='<%# Bind("Active_Time") %>' TextMode="DateTimeLocal" runat="server" ID="Active_TimeTextBox" />
                <asp:TextBox Text='<%# Bind("inActive_Time") %>' TextMode="DateTimeLocal" runat="server" ID="inActive_TimeTextBox" />
              </div>
              <div class="field">
                <label>文章</label>
                <div class="ui floating info icon visible message">
                  <i class="close icon"></i>
                  <i class="info circle icon"></i>
                  <div class="content">
                    <div class="header">提示</div>
                    爲避免影響字體大小設定，請將瀏覽器設定之最小字體大小調至12px。
                  </div>
                </div>
                <asp:TextBox Text='<%# HttpUtility.HtmlDecode(Eval("Content").ToString()) %>' TextMode="MultiLine" CssClass="hidden" runat="server" ID="ContentTextBox" />
                <div class="ui top attached textarea-option segment">
                  <div class="ui icon basic buttons">
                    <%--<button class="ui button" type="button" data-method="code" title="檢視源碼"><i class="file code outline icon"></i></button>--%>
                    <button class="ui icon button" type="button" data-method="view" title="預覽">
                      <i class="icons">
                        <i class="file outline icon"></i>
                        <i class="corner search icon"></i>
                      </i>
                    </button>
                  </div>
                  <div class="ui icon basic buttons">
                    <button class="ui button" type="button" data-method="cut" title="剪下" disabled><i class="cut icon"></i></button>
                    <button class="ui button" type="button" data-method="copy" title="複製" disabled><i class="copy outline icon"></i></button>
                    <button class="ui icon button" type="button" title="貼上" data-method="paste-text">
                      <i class="paste icon"></i>
                    </button>
                  </div>
                  <div class="ui icon basic buttons">
                    <button class="ui button" type="button" data-method="undo" title="復原"><i class="undo alternate icon"></i></button>
                    <button class="ui button" type="button" data-method="redo" title="取消復原"><i class="redo alternate icon"></i></button>
                  </div>
                  <div class="ui icon basic buttons">
                    <button class="ui button" type="button" data-method="bold" title="粗體"><i class="bold icon"></i></button>
                    <button class="ui button" type="button" data-method="italic" title="斜體"><i class="italic icon"></i></button>
                    <button class="ui button" type="button" data-method="underline" title="底線"><i class="underline icon"></i></button>
                    <button class="ui button" type="button" data-method="strikethrough" title="刪除線"><i class="strikethrough icon"></i></button>
                  </div>
                  <div class="ui icon basic buttons">
                    <button class="ui button" type="button" data-method="subscript" title="下標"><i class="subscript icon"></i></button>
                    <button class="ui button" type="button" data-method="superscript" title="上標"><i class="superscript icon"></i></button>
                  </div>
                  <div class="ui icon basic buttons">
                    <button class="ui button" type="button" data-method="addlink" title="新增連結"><i class="linkify icon"></i></button>
                    <button class="ui button" type="button" data-method="unlink" title="取消連結" disabled><i class="unlink icon"></i></button>
                    <button type="button" class="ui icon basic button" data-method="newading" title="新增廣告">
                      <i class="ad icon"></i>
                    </button>
                  </div>
                  <div class="ui icon basic buttons">
                    <div class="ui text-color top left pointing dropdown button" title="文字顏色">
                      <i class="font icon"></i>
                      <div class="menu">
                        <div class="hidden helper item"></div>
                        <input id="text-color-picker" value='rgba(0,0,0,.87)' />
                      </div>
                    </div>
                    <div class="ui text-bg-color top left pointing dropdown icon button" title="背景顏色">
                      <i class="icons">
                        <i class="square icon"></i>
                        <i class="font icon"></i>
                      </i>
                      <div class="menu">
                        <div class="hidden helper item"></div>
                        <input id="text-bg-color-picker" value='rgba(0,0,255,.0)' />
                      </div>
                    </div>
                    <button class="ui icon button" type="button" data-method="removeFormat" title="清除樣式">
                      <i class="icons">
                        <i class="font icon"></i>
                        <i class="corner times icon"></i>
                      </i>
                    </button>
                  </div>
                  <div class="ui compact selection dropdown">
                    <input type="hidden" id="font_name" name="font-name" />
                    <i class="dropdown icon"></i>
                    <div class="default text">font family</div>
                    <div class="menu">
                      <div class="item" data-value="Noto Sans, sans-serif" style="font-family: Noto Sans, sans-serif;">
                        思源黑體<br />
                        abc123
                      </div>
                      <div class="item" data-value="Noto Serif TC, serif" style="font-family: 'Noto Serif TC', serif;">
                        思源宋體<br />
                        <span>abc123</span>
                      </div>
                      <div class="item" data-value="'Microsoft JhengHei', Noto Sans, sans-serif" style="font-family: 'Microsoft JhengHei', Noto Sans, sans-serif;">
                        微軟正黑體<br />
                        abc123
                      </div>
                      <div class="item" data-value="DFKai-sb, Noto Sans, sans-serif" style="font-family: DFKai-sb, Noto Sans, sans-serif;">
                        標楷體<br />
                        abc123
                      </div>
                      <div class="item" data-value="PMingLiU, Noto Sans, sans-serif" style="font-family: PMingLiU, Noto Sans, sans-serif;">
                        新細明體<br />
                        abc123
                      </div>
                      <div class="item" data-value="MingLiU, Noto Sans, sans-serif" style="font-family: MingLiU, Noto Sans, sans-serif;">
                        細明體<br />
                        abc123
                      </div>
                      <div class="item" data-value="Arial, sans-serif" style="font-family: Arial, sans-serif;">
                        Arial<br />
                        字型123
                      </div>
                      <div class="item" data-value="Comic Sans MS, Comic Sans, cursive" style="font-family: Comic Sans MS, Comic Sans, cursive;">
                        Comic Sans MS<br />
                        字型123
                      </div>
                      <div class="item" data-value="Times, Times New Roman, serif" style="font-family: Times, Times New Roman, serif;">
                        Times New Roman<br />
                        字型123
                      </div>
                      <div class="item" data-value="Courier New, monospace" style="font-family: Courier New, monospace;">
                        Courier New<br />
                        字型123
                      </div>
                      <div class="item" data-value="Helvetica, sans-serif" style="font-family: Helvetica, sans-serif;">
                        Helvetica<br />
                        字型123
                      </div>
                      <div class="item" data-value="Impact, fantasy" style="font-family: Impact, fantasy;">
                        Impact<br />
                        字型123
                      </div>
                    </div>
                  </div>
                  <div class="ui compact selection dropdown">
                    <input type="hidden" id="font_size" name="font-size">
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
                  <div class="ui icon basic buttons">
                    <button class="ui button" type="button" data-method="insertOrderedList" title="編號清單"><i class="list ol icon"></i></button>
                    <button class="ui button" type="button" data-method="insertUnorderedList" title="項目符號清單"><i class="list ul icon"></i></button>
                  </div>
                  <div class="ui icon basic buttons">
                    <button class="ui button" type="button" data-method="outdent" title="減少縮排"><i class="outdent icon"></i></button>
                    <button class="ui button" type="button" data-method="indent" title="增加縮排"><i class="indent icon"></i></button>
                  </div>
                  <div class="ui icon basic buttons">
                    <button class="ui button" type="button" data-method="justifyLeft" title="靠左對齊"><i class="align left icon"></i></button>
                    <button class="ui button" type="button" data-method="justifyCenter" title="置中"><i class="align center icon"></i></button>
                    <button class="ui button" type="button" data-method="justifyRight" title="靠右對齊"><i class="align right icon"></i></button>
                    <button class="ui button" type="button" data-method="justifyFull" title="左右對齊"><i class="align justify icon"></i></button>
                  </div>
                  <div class="ui icon basic buttons">
                    <button type="button" class="ui button" data-method="insertVideo" title="插入影片(Youtube/Vimeo)"><i class="film icon"></i></button>
                    <button class="ui button" type="button" data-method="insertImg" title="插入圖片"><i class="images icon"></i></button>
                  </div>
                  <div class="ui icon basic buttons">
                    <%--<button class="ui button" type="button" data-method="insertImg"><i class="images icon"></i></button>--%>
                    <button class="ui button" type="button" data-method="inserTable" title="插入表格">
                      <i class="table icon"></i>
                    </button>
                    <button class="ui button" type="button" data-method="symbols" title="特殊符號"><i class="char icon">Ω</i></button>
                  </div>
                  <%--<div class="ui floating yellow icon visible message">
                    <i class="close icon"></i>
                    <i class="wrench icon"></i>
                    <div class="content">
                      <div class="header">提示</div>
                      圖片上傳目前維修中，造成不便深感抱歉
                    </div>
                  </div>--%>
                </div>
                <div id="article-edit" class="ui bottom attached textarea segment" tabindex="-1" aria-placeholder="Type here..." contenteditable="true"><%# HttpUtility.HtmlDecode(Eval("Content").ToString()) %></div>
                <div class="ui paste-text mini modal">
                  <div class="header">貼上</div>
                  <div class="scrolling content">
                    <p>由於瀏覽器的安全性設定，本編輯器無法直接存取您的剪貼簿資料，請您自行使用快捷鍵做貼上動作。</p>
                    <p><b>快捷鍵教學:</b></p>
                    <div class="ui label">
                      貼上
                      <i class="keyboard icons" style="margin-left: .6em;">
                        <i class="square icon"></i>
                        <i class="top right corner icon" style="font-size: 1.1em; transform: scale(.55);">Ctrl</i>
                      </i>
                      <i class="plus icon" style="margin: 0 .75em 0;"></i>
                      <i class="keyboard icons">
                        <i class="square icon"></i>
                        <i class="top right corner icon" style="font-size: .75em;">V</i>
                      </i>
                    </div>
                    <div class="ui label">
                      純文字貼上
                      <i class="keyboard icons" style="margin-left: .6em;">
                        <i class="square icon"></i>
                        <i class="top right corner icon" style="font-size: 1.1em; transform: scale(.55);">Ctrl</i>
                      </i>
                      <i class="plus icon" style="margin: 0 0 0 .75em;"></i>
                      <i class="keyboard icons" style="margin-left: .6em;">
                        <i class="square icon"></i>
                        <i class="top right corner icon" style="font-size: 1em; transform: scale(.5) translateX(-5px);">Shift</i>
                      </i>
                      <i class="plus icon" style="margin: 0 .75em 0;"></i>
                      <i class="keyboard icons">
                        <i class="square icon"></i>
                        <i class="top right corner icon" style="font-size: .75em;">V</i>
                      </i>
                    </div>
                    <%--<textarea class=""></textarea>--%>
                  </div>
                  <div class="actions">
                    <div class="ui ok button">確定</div>
                  </div>
                </div>
                <div class="ui symbols tiny modal">
                  <div class="header">特殊符號</div>
                  <div class="scrolling content">
                    <div class="ui top attached tabular menu">
                      <a class="active item" data-tab="first">標點</a>
                      <a class="item" data-tab="second">數學</a>
                      <a class="item" data-tab="third">圖形</a>
                    </div>
                    <div class="ui bottom attached active tab center aligned segment" data-tab="first"></div>
                    <div class="ui bottom attached tab center aligned segment" data-tab="second"></div>
                    <div class="ui bottom attached tab center aligned segment" data-tab="third"></div>
                  </div>
                  <div class="actions">
                    <div class="ui basic cancel button">取消</div>
                  </div>
                </div>
                <div class="ui addlink tiny modal">
                  <div class="header">建立連結</div>
                  <div class="scrolling content">
                    <div class="ui form">
                      <div class="field">
                        <label>連結文字</label>
                        <input type="text" id="link_text">
                      </div>
                      <div class="field">
                        <label>連結網址</label>
                        <input type="url" id="link_url">
                      </div>
                    </div>
                  </div>
                  <div class="actions">
                    <div class="ui basic cancel button">取消</div>
                    <div class="ui basic primary button">建立</div>
                  </div>
                </div>
                <div class="ui insertImg tiny modal">
                  <div class="header">插入圖片</div>
                  <div class="scrolling content">
                    <div class="ui form">
                      <div class="fields">
                        <div class="six wide field">
                          <label>圖片來源</label>
                          <div class="ui selection dropdown">
                            <input id="upload_type" name="upload_type" value="file" type="hidden">
                            <i class="dropdown icon"></i>
                            <div class="default text">請選擇</div>
                            <div class="menu">
                              <div class="item" data-value="file">圖檔</div>
                              <div class="item" data-value="url">URL</div>
                            </div>
                          </div>
                        </div>
                        <div class="ten wide field">
                          <label>圖檔</label>
                          <input type="file" id="image_file" class="hidden" accept="image/gif, image/jpeg, image/png" />
                          <div class="ui fluid buttons basic fitted segment" id="image_btn" style="margin: 0;">
                            <label for="image_file" class="ui basic primary icon button"><i class="images icon"></i>選擇圖檔</label>
                            <span class="ui bottom attached indicating progress">
                              <span class="bar"></span>
                            </span>
                            <button type="button" id="img_upload" class="ui basic olive icon button" onclick="imgUpload()"><i class="upload icon"></i>上傳</button>
                          </div>
                          <span id="file-name"></span>
                          <input type="url" id="img_url" class="hidden" placeholder="URL" />
                        </div>
                      </div>
                      <div class="field">
                        <div class="ui message">
                          <div class="header">
                            注意事項
                          </div>
                          <ul class="list">
                            <li>圖片建議尺寸： 800 x 450px，寬高超過800 x 450px將自動壓縮至800 x 450px，檔案容量不得超過5MB。</li>
                            <li>圖片比例： 16:9，比例不符將無法上傳。</li>
                            <li>圖片格式：JPG,PNG,GIF</li>
                            <li>上傳限制：閒置圖片超過3天將進行清理，若期間閒置圖片超過5MB以上，將不開放文內圖片上傳，請至管理圖片上傳頁面將閒置圖片刪除後再編輯。</li>
                          </ul>
                        </div>
                      </div>
                      <div class="flex center aligned field">
                        <input type="radio" id="align_left" class="hidden" name="alignment" value="left floated">
                        <input type="radio" id="align_center" class="hidden" name="alignment" value="centered">
                        <input type="radio" id="align_right" class="hidden" name="alignment" value="right floated">
                        <div class="ui basic buttons">
                          <label for="align_left" class="ui flex icon button" style="align-items: center;">
                            <i class="icons">
                              <i class="align justify icon" style="transform: scaleX(1.2);"></i>
                              <i class="corner square icon"
                                style="font-size: .6em; transform: scale(0.78) translate(-5.5px, -8px);"></i>
                            </i>
                          </label>
                          <label for="align_center" class="ui flex icon button" style="align-items: center;">
                            <i class="icons">
                              <i class="align justify icon" style="transform: scaleX(1.2);"></i>
                              <i class="corner square icon"
                                style="font-size: .6em; transform: scale(0.78) translate(-1.3px, -8px); text-shadow: -1px -1px 0 #fff, 1px -1px 0 #fff, -1px 1px 0 #fff, 1px 1px 0 #fff, 6px 1px 0 #fff, -6px 1px 0 #fff, 6px -1px 0 #fff, -6px -1px 0 #fff;"></i>
                            </i>
                          </label>
                          <label for="align_right" class="ui flex icon button" style="align-items: center;">
                            <i class="icons">
                              <i class="align justify icon" style="transform: scaleX(1.2);"></i>
                              <i class="corner square icon"
                                style="font-size: .6em; transform: scale(0.78) translate(3px, -8px);"></i>
                            </i>
                          </label>
                        </div>
                        <div class="ui ml-1 mini flex selection dropdown button" style="align-items: center;">
                          <input id="img_size" name="img_size" type="hidden">
                          <i class="dropdown flex icon" style="align-items: center;"></i>
                          <div class="default text">size</div>
                          <div class="menu">
                            <div class="item" data-value="mini">
                              mini<br>
                              (最大寬度 &nbsp;&nbsp;&nbsp;38px)
                            </div>
                            <div class="item" data-value="tiny">
                              tiny<br>
                              (最大寬度 &nbsp;&nbsp;&nbsp;80px)
                            </div>
                            <div class="item" data-value="small">
                              small<br>
                              (最大寬度 150px)
                            </div>
                            <div class="item" data-value="medium">
                              medium<br>
                              (最大寬度 300px)
                            </div>
                            <div class="item" data-value="large">
                              large<br>
                              (最大寬度 450px)
                            </div>
                            <div class="item" data-value="big">
                              big<br>
                              (最大寬度 600px)
                            </div>
                            <div class="item" data-value="huge">
                              huge<br>
                              (最大寬度 800px)
                            </div>
                            <div class="item" data-value="massive">
                              Massive<br>
                              (最大寬度 960px)
                            </div>
                            <div class="item" data-value="fluid">
                              fluid<br>
                              (不限制最大寬度)
                            </div>
                          </div>
                        </div>
                      </div>
                      <div class="flex field">
                        <div class="ui basic icon button checkbox">
                          <!-- <div class="ui checkbox"> -->
                          <input type="checkbox" tabindex="0" class="toIcon hidden">
                          <label>
                            <i class="icons icon"></i>
                            貼圖化</label>
                          <!-- </div> -->
                        </div>
                        <div class="ui ml-1 selection dropdown hidden">
                          <input id="font_v_align" name="font_v_align" type="hidden" value="middle aligned">
                          <i class="dropdown flex icon"></i>
                          <div class="default text">vertical align</div>
                          <div class="menu">
                            <div class="item" data-value="top aligned">文字上方對齊</div>
                            <div class="item" data-value="middle aligned">文字置中對齊</div>
                            <div class="item" data-value="bottom aligned">文字下方對齊</div>
                          </div>
                        </div>
                      </div>
                      <div class="upload-preview ui justified container">
                        <div class="ui placeholder">
                          <img class="image" />
                        </div>
                        Lorem Ipsum，也稱亂數假文或者啞元文本， 是印刷及排版領域所常用的虛擬文字。由於曾經一台匿名的打印機刻意打亂了一盒印刷字體從而造出一本字體樣品書，Lorem
                Ipsum從西元15世紀起就被作為此領域的標准文本使用。它不僅延續了五個世紀，還通過了電子排版的挑戰，其雛形卻依然保存至今。在1960年代，“Leatraset”公司發布了印刷著Lorem
                Ipsum段落的紙張，從而廣泛普及了它的使用。最近，計算機桌面出版軟體“Aldus PageMaker”也通過同樣的方式使Lorem Ipsum落入大眾的視野。
                      </div>
                    </div>
                  </div>
                  <div class="actions">
                    <div class="ui basic deny button">取消</div>
                    <div class="ui basic primary button">確定</div>
                  </div>
                </div>
                <div class="ui inserTable tiny modal">
                  <div class="header">插入表格</div>
                  <div class="scrolling content">
                    <div class="ui form">
                      <div class="two fields">
                        <div class="field">
                          <label>欄</label>
                          <input type="number" id="tb_col" class="tbcell_amount" value="2">
                        </div>
                        <div class="field">
                          <label>列</label>
                          <input type="number" id="tb_row" class="tbcell_amount" value="2">
                        </div>
                      </div>
                      <div class="field">
                        <label>間距</label>
                        <div class="ui basic button radio checkbox">
                          <input type="radio" id="tb_compact" name="tb_pad" class="tb-option pad">
                          <label for="tb_compact">窄</label>
                        </div>
                        <div class="ui basic button radio checkbox">
                          <input type="radio" id="tb_normal" name="tb_pad" class="tb-option pad" checked>
                          <label for="tb_normal">適中</label>
                        </div>
                        <div class="ui basic button radio checkbox">
                          <input type="radio" id="tb_padded" name="tb_pad" class="tb-option pad">
                          <label for="tb_padded">寬</label>
                        </div>
                        <div class="ui basic button radio checkbox">
                          <input type="radio" id="tb_very_padded" name="tb_pad" class="tb-option pad">
                          <label for="tb_very_padded">更寬</label>
                        </div>
                      </div>
                      <div class="field">
                        <label>標題</label>
                        <div class="ui basic button checkbox">
                          <input type="checkbox" id="tb_th_col" class="tb-th-option">
                          <label for="tb_th_col">欄</label>
                        </div>
                        <div class="ui basic button checkbox">
                          <input type="checkbox" id="tb_th_row" class="tb-th-option" checked>
                          <label for="tb_th_row">列</label>
                        </div>
                        <div class="ui basic button checkbox">
                          <input type="checkbox" id="tb_th_footer" class="tb-th-option">
                          <label for="tb_th_footer">頁腳</label>
                        </div>
                        <div class="ui basic button checkbox hidden">
                          <input type="checkbox" id="tb_th_full_width" class="tb-th-option">
                          <label for="tb_th_full_width">全寬</label>
                        </div>
                      </div>
                      <div class="field">
                        <label>設定</label>
                        <div class="ui basic button checkbox">
                          <input type="checkbox" id="tb_striped" class="tb-option">
                          <label for="tb_striped">單、雙數列分色</label>
                        </div>
                        <div class="ui basic button checkbox">
                          <input type="checkbox" id="tb_celled" class="tb-option" checked>
                          <label for="tb_celled">欄分格線</label>
                        </div>
                        <div class="ui basic button checkbox">
                          <input type="checkbox" id="tb_very_basic" class="tb-option">
                          <label for="tb_very_basic">簡化</label>
                        </div>
                      </div>
                    </div>
                    <table id="preview-tb" class="ui celled table">
                      <thead>
                        <tr>
                          <th></th>
                          <th></th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td></td>
                          <td></td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                  <div class="actions">
                    <div class="ui basic cancel button">取消</div>
                    <div class="ui basic blue button">確定</div>
                  </div>
                </div>
                <div class="ui insertVideo tiny modal">
                  <div class="header">影片嵌入</div>
                  <div class="content">
                    <div class="ui form">
                      <div class="fields">
                        <div class="four wide field">
                          <label>影片類型</label>
                          <div class="ui selection dropdown">
                            <input type="hidden" id="video_type" value="https://youtu.be/" />
                            <div class="default text">type</div>
                            <i class="dropdown icon"></i>
                            <div class="menu">
                              <div class="item" data-value="https://youtu.be/">Youtube</div>
                              <div class="item" data-value="https://vimeo.com/">Vimeo</div>
                            </div>
                          </div>
                        </div>
                        <div class="twelve wide field">
                          <label>影片連結</label>
                          <div class="ui right labeled input">
                            <div class="ui label">
                              <!-- https://youtu.be/ or https://vimeo.com/ -->
                              <span class="format_url">https://youtu.be/</span>
                            </div>
                            <input type="text" id="video_id" placeholder="video id">
                            <div class="ui label" style="cursor: pointer">
                              預覽
                            </div>
                          </div>
                        </div>
                      </div>
                      <div class="field">
                        <label>預覽</label>
                        <div class="ui embed"></div>
                      </div>
                    </div>
                  </div>
                  <div class="actions">
                    <button type="button" class="ui basic cancel button">取消</button>
                    <button type="button" class="ui basic primary button">建立</button>
                  </div>
                </div>
                <div class="ui newading modal">
                  <div class="header">新增廣告</div>
                  <div class="scrolling content">

                    <div class="ui top attached tabular menu">
                      <a class="active item" data-tab="first">個人廣告</a>
                      <a class="disabled item" data-tab="second">Google廣告</a>
                    </div>
                    <div class="ui bottom attached active tab cards segment" data-tab="first">
                      <asp:ListView ID="ListView1" runat="server" DataSourceID="SqlDataSource5">
                        <ItemTemplate>
                          <input type="radio" id='personal_ad<%# Container.DataItemIndex %>' class="hidden" name="personal_ad" <%# Container.DataItemIndex == 0 ? "checked":"" %> />
                          <label for='personal_ad<%# Container.DataItemIndex %>' style="display: inline-table;">
                            <div class="ui centered card ad" style="padding: 0; display: inline-table;">
                              <div class="image" style="height: unset;">
                                <div class='ui <%# !Eval("video_url").Equals(DBNull.Value) && !Eval("video_type").Equals(DBNull.Value) ? "":"hidden" %> embed' data-id='<%# Eval("video_url") %>' data-source='<%# Eval("video_type") %>'></div>
                                <a data-href='<%# Eval("Link") %>' class='long <%# !Eval("video_url").Equals(DBNull.Value) && !Eval("video_type").Equals(DBNull.Value) ? "hidden":"" %> square block' target="_blank">
                                  <img class="ui medium image" src='<%# Eval("Img_Id").Equals(DBNull.Value) ? "":Eval("Img_Id") %>'>
                                </a>
                              </div>
                              <div class="left aligned content">
                                <div class="header" style="opacity: .7;"><span class="left floated"><%# Eval("Title") %></span><i class="right floated ad icon"></i></div>
                                <div class="meta"><%# Eval("Remark") %></div>
                              </div>
                            </div>
                          </label>
                        </ItemTemplate>
                      </asp:ListView>
                      <asp:SqlDataSource runat="server" ID="SqlDataSource5" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT [Img_Id], [Link], [Title], [Show_T], [Remark], [video_url], [video_type] FROM [Advertisement] WHERE (([Type] = @Type) AND ([User_Id] = @User_Id))">
                        <SelectParameters>
                          <asp:Parameter DefaultValue="personal" Name="Type" Type="String"></asp:Parameter>
                          <asp:SessionParameter SessionField="User_Id" Name="User_Id" Type="Int32"></asp:SessionParameter>
                        </SelectParameters>
                      </asp:SqlDataSource>
                    </div>
                    <div class="ui bottom attached tab aligned segment" data-tab="second">
                      廣告
                          <div class="ui top banner test ad" data-text="Banner"></div>
                      預覽
                          <div class="ui top banner test ad" data-text="Banner">
                            <ins class="adsbygoogle"
                              style="display: block; text-align: center;"
                              data-ad-layout="in-article"
                              data-ad-format="fluid"
                              data-ad-client="ca-pub-7266289617887477"
                              data-ad-slot="4457922783"></ins>
                            <script>
                              (adsbygoogle = window.adsbygoogle || []).push({});
                            </script>
                          </div>
                    </div>
                  </div>
                  <div class="actions">
                    <button type="button" class="ui basic cancel button">取消</button>
                    <button type="button" class="ui basic primary button">建立</button>
                  </div>
                </div>
              </div>
              <div class="field">
                <label>上傳圖片</label>
                <asp:HiddenField ID="HiddenField1" runat="server" Value='<%# Eval("Relate_Img") %>' OnValueChanged="HiddenField1_ValueChanged" />
                <div id="uploaded_img" class="ui small images">
                  <asp:Repeater ID="Repeater1" runat="server" OnItemDataBound="Repeater1_ItemDataBound">
                    <ItemTemplate>
                      <div class="ui image">
                        <img class="ui lazy image" data-src='Image.aspx?ID=<%# Container.DataItem %>' />
                      </div>
                    </ItemTemplate>
                  </asp:Repeater>
                </div>
              </div>
              <div class="field">
                <label>投稿日期</label>
                <asp:Label Text='<%# Bind("DateTime") %>' runat="server" ID="DateTimeLabel" />
              </div>
            </div>
          </div>
          <div class="actions">
            <asp:LinkButton runat="server" Text="更新" CssClass="ui olive button" OnClientClick="javascript: return editOK();" CommandName="Update" ID="UpdateButton" CausesValidation="True" />
            <asp:LinkButton runat="server" Text="取消" CssClass="ui red button" CommandName="Cancel" ID="UpdateCancelButton" CausesValidation="False" />
          </div>
        </div>
      </EditItemTemplate>
      <ItemTemplate>
        <div id="article_detail" class="ui fullscreen overlay modal">
          <i class="close icon"></i>
          <div class="header">瀏覽文章</div>
          <div class="scrolling content">
            <div class="ui form text fluid container" style="margin: 0 auto;">
              <div class="field">
                <img class="ui lazy centered image" data-src='Image.aspx?ID=<%# Eval("Front_Img_Id") %>' />
              </div>
              <div class="field">
                <label>標題</label>
                <asp:Label Text='<%# Bind("Title") %>' runat="server" ID="TitleLabel" />
              </div>
              <div class="field">
                <label>分類</label>
                <div class="ui multiple disabled tagged dropdown">
                  <asp:HiddenField ID="Category_HF" runat="server" Value='<%# Eval("Category") %>' />
                  <%--<i class="dropdown icon"></i>--%>
                  <div class="default text">Category</div>
                  <div class="menu">
                    <asp:Repeater ID="Category_R" runat="server" DataSourceID="SqlDataSource3">
                      <ItemTemplate>
                        <div class="item" data-value='<%# Eval("Id") %>'><%# Eval("Name") %></div>
                      </ItemTemplate>
                    </asp:Repeater>
                    <asp:SqlDataSource runat="server" ID="SqlDataSource3" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT * FROM [Menu]"></asp:SqlDataSource>
                  </div>
                </div>
              </div>
              <div class="field">
                <label>簡短介紹</label>
                <%# DBNull.Value.Equals(Eval("Description")) ? "":HttpUtility.HtmlDecode(Eval("Description").ToString()) %>
              </div>
              <div class="field">
                <label>標籤</label>
                <asp:Label Text='<%# Bind("Keyword") %>' runat="server" ID="KeywordLabel" />
              </div>

              <div class="field">
                <label>是否上架</label>
                <asp:CheckBox Checked='<%# Eval("Status").Equals(1) %>' Text=" " CssClass="ui toggle checkbox" runat="server" ID="StatusCheckBox" Enabled="false" />
              </div>

              <div class="field">
                <label>文章上架期間(上架中若無設定上架期間則無限期上架)</label>
                <asp:Label Text='<%# Bind("Active_Time") %>' runat="server" ID="Active_TimeLabel" />
                <asp:Label Text='<%# Bind("inActive_Time") %>' runat="server" ID="inActive_TimeLabel" />
              </div>
              <div class="field">
                <label>文章</label>
                <div id="article">
                  <asp:Label Text='<%# HttpUtility.HtmlDecode(Eval("Content").ToString()) %>' runat="server" ID="ContentLabel" />
                </div>
              </div>
              <div class="field">
                <label>投稿日期</label>
                <asp:Label Text='<%# Bind("DateTime") %>' runat="server" ID="DateTimeLabel" />
              </div>
            </div>
          </div>
          <div class="actions">
            <asp:LinkButton ID="LinkButton1" CssClass="ui blue button" runat="server" OnClientClick="javascript:$('#article_detail').modal('hide');" CommandName="Edit">編輯</asp:LinkButton>
            <%--<div class="ui deny button">關閉</div>--%>
            <asp:LinkButton ID="LinkButton2" CssClass="ui deny button" runat="server" OnClick="LinkButton2_Click">關閉</asp:LinkButton>
          </div>
        </div>
      </ItemTemplate>
    </asp:FormView>

    <asp:SqlDataSource runat="server" ID="SqlDataSource2" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT a.Id, a.Title, a.[Content], a.Front_Img_Id, a.Category, a.Keyword, a.Description,
a.DateTime, a.Status, a.Name_Status, a.Active_Time, a.inActive_Time, a.Author, a.Author_Email, 
a.Relate_Img, a.Recommand_Category , (SELECT cast(image_id AS NVARCHAR ) + ',' from Article_Image where article_id = a.Id 
FOR XML PATH('')) as r_img
FROM Article AS a WHERE (a.Id = @Id)"
      DeleteCommand="DELETE FROM [Article] WHERE [Id] = @Id"
      UpdateCommand="UPDATE Article SET Title = @Title, [Content] = @Content, Category = @Category, Keyword = @Keyword, Status = @Status, Active_Time = @Active_Time, inActive_Time = @inActive_Time, Relate_Img = @Relate_Img, Description = @Description, Front_Img_Id = @fiid WHERE (Id = @Id)">
      <DeleteParameters>
        <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
      </DeleteParameters>
      <SelectParameters>
        <asp:ControlParameter ControlID="GridView1" PropertyName="SelectedValue" Name="Id" Type="Int32"></asp:ControlParameter>
      </SelectParameters>
      <UpdateParameters>
        <asp:Parameter Name="Title" Type="String"></asp:Parameter>
        <asp:Parameter Name="Content" Type="String"></asp:Parameter>
        <asp:Parameter Name="Category" Type="String"></asp:Parameter>
        <asp:Parameter Name="Keyword" Type="String"></asp:Parameter>
        <asp:Parameter Name="Status" Type="Int32"></asp:Parameter>
        <asp:Parameter Name="Active_Time" Type="DateTime"></asp:Parameter>
        <asp:Parameter Name="inActive_Time" Type="DateTime"></asp:Parameter>
        <asp:Parameter Name="Relate_Img" Type="String"></asp:Parameter>
        <asp:Parameter Name="Description"></asp:Parameter>
        <asp:Parameter Name="fiid"></asp:Parameter>
        <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
      </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' OnSelecting="SqlDataSource1_Selecting"
      SelectCommand="SELECT Title, Category, Format(DateTime, 'yyyy/MM/dd tthh:mm') AS DateTime, Status, Recommand_Category, a.Id, Front_Img_Id, count(ul.Id) as cnt FROM Article a LEFT JOIN UserLog ul on ul.Modify_Id = a.Id and ul.Modify_Table = 'Article' and ul.Modify_Action = 'View' WHERE (Author_Email = @email) GROUP BY TItle,Category,DateTime,Status,Recommand_Category,a.Id,Front_Img_Id order by DateTime Desc"
      DeleteCommand="DELETE FROM [Article] WHERE [Id] = @Id; --DELETE FROM [Image] WHERE [Id] IN (SELECT image_id FROM Article_Image WHERE article_id = @Id) and [Id] NOT IN (SELECT image_id FROM Article_Image WHERE article_id <> @Id and image_id is not null);DELETE FROM [Article_Image] WHERE article_id = @Id;"
      UpdateCommand="UPDATE Article SET Category = @Category, Status = @Status, Recommand_Category = @rcat, [DateTime] = Case When @Status = '1' then GETDATE() else [DateTime] end WHERE (Id = @Id)">
      <DeleteParameters>
        <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
      </DeleteParameters>
      <SelectParameters>
        <asp:SessionParameter SessionField="Email" Name="email"></asp:SessionParameter>
      </SelectParameters>
      <UpdateParameters>
        <asp:Parameter Name="Category" Type="String"></asp:Parameter>
        <asp:Parameter Name="Status" Type="Int32" DefaultValue="False"></asp:Parameter>
        <asp:Parameter Name="rcat"></asp:Parameter>
        <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
      </UpdateParameters>
    </asp:SqlDataSource>
    <%--</ContentTemplate>
    </asp:UpdatePanel>--%>
  </div>

  <div class="ui notify tiny modal">
    <div class="header">
      <asp:Label ID="modal_header" runat="server" Text="Label"></asp:Label>
    </div>
    <div class="content">
      <asp:Label ID="modal_content" runat="server" Text="Label"></asp:Label>
    </div>
    <div class="actions">
      <div class="ui deny button">確認</div>
    </div>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/spectrum-colorpicker2/dist/spectrum.min.js"></script>
  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.9/jquery.lazy.min.js"></script>
  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.9/jquery.lazy.plugins.min.js"></script>
  <script src="js/editor.js?3"></script>
  <script>
    $('.newading .ui.embed').embed()

    var mh = $(window).height() - $('.ui.textarea-option.segment').outerHeight() - 135;
    if (mh < 150) mh = 150
    $('#article-edit').css('max-height', mh)

    $(window).on('resize', function () {
      var mh = $(window).height() - $('.ui.textarea-option.segment').outerHeight() - 135;
      if (mh < 150) mh = 150
      $('#article-edit').css('max-height', mh)
      console.log($(window).height(), - $('.ui.textarea-option.segment').outerHeight() - 135)
    })
    console.log($(window).height(), - ($('.ui.textarea-option.segment').outerHeight() + 135))
    //$('#article-edit').css('max-height', $('#main').height() - $('.ui.textarea-option.segment').outerHeight() - 135)

    function init_cropper() {
      var previewReady = false;
      $('#Front_img').cropper({
        viewMode: 1,
        dragMode: 'move',
        aspectRatio: 16 / 9,
        autoCropArea: 1,
        restore: false,
        guides: false,
        highlight: false,
        cropBoxMovable: false,
        cropBoxResizable: false,
        toggleDragModeOnDblclick: false,
        ready: function () {
          var clone = this.cloneNode();

          clone.className = '';
          clone.id = '';
          clone.style.cssText = (
            'display: block;' +
            'width: 100%;' +
            'min-width: 0;' +
            'min-height: 0;' +
            'max-width: none;' +
            'max-height: none;'
          );

          $('#image_container .preview').removeClass('hidden')
          $('#image_container .preview').css('top', $('#image_container .ui.ok.button').outerHeight() + 10)
          $('#image_container .preview .ui.tiny.image').html('')
          $('#image_container .preview .ui.tiny.image').append(clone.cloneNode());
          setTimeout(function () { $('#Front_img').cropper('setCropBoxData', $('#Front_img').cropper('getCropBoxData')) }, 300)

          previewReady = true;
        },
        crop: function (event) {
          if (!previewReady) {
            return;
          }

          var data = event.detail;
          var cropper = this.cropper;
          var imageData = cropper.getImageData();
          var previewAspectRatio = data.width / data.height;

          var previewImage = $('#image_container .preview .ui.tiny.image img')[0];
          var previewWidth = $('#image_container .preview .ui.tiny.image')[0].offsetWidth;
          var previewHeight = previewWidth / previewAspectRatio;
          var imageScaledRatio = data.width / previewWidth;

          $('#image_container .preview .ui.tiny.image')[0].style.height = previewHeight + 'px';
          previewImage.style.width = imageData.naturalWidth / imageScaledRatio + 'px';
          previewImage.style.height = imageData.naturalHeight / imageScaledRatio + 'px';
          previewImage.style.marginLeft = -data.x / imageScaledRatio + 'px';
          previewImage.style.marginTop = -data.y / imageScaledRatio + 'px';

        },
      });

      $('#image_container .ui.ok.button').removeClass('hidden')
      $('#image_container .ui.view.button').removeClass('hidden')
      $('#Front_img').cropper('setCropBoxData', $('#Front_img').cropper('getCropBoxData'))
    }

    function get_img(x) {
      $('.result:has( + #image_container)').html('')
      $('.result:has( + #image_container)').append($('#Front_img').cropper('getCroppedCanvas'))
      if (x == 'ok') {
        $('#<%= Front_Img_HF.ClientID %>').val($('.result:has( + #image_container) canvas')[0].toDataURL($('#<%= contenttype_HF.ClientID %>').val()).replace('data:'
          + $('#<%= contenttype_HF.ClientID %>').val() + ';base64,', ''))
        $('#Front_img').cropper('destroy')
        $('#Front_img').removeAttr('src')
        $('#image_container .preview').addClass('hidden')
        $('#image_container .preview .ui.tiny.image').html('')
        $('#image_container .ui.ok.button').addClass('hidden')
        $('#image_container .ui.view.button').addClass('hidden')
      }
    }

    function ui_rander() {
      $('.card .lazy').Lazy({ threshold: 0, effect: 'fadeIn', effectTime: 500, appendScroll: $('.ui.scrolling.basic.segment') });
      $('.scrolling.content .lazy').Lazy({ appendScroll: $('#article_detail .scrolling.content') });

      $('#<%= RadioButtonList1.ClientID %> label').addClass('ui button').removeClass('active')
      $('#<%= RadioButtonList1.ClientID %> input:checked + label').addClass('active')
      $('#<%= RadioButtonList1.ClientID %> input').addClass('hidden')
      $($('#<%= RadioButtonList1.ClientID %> label')[0]).prependTo($('#<%= RadioButtonList1.ClientID %>'));
      $('#<%= RadioButtonList1.ClientID %> label:has(.table)').attr('title', '表格')
      $('#<%= RadioButtonList1.ClientID %> label:has(.th)').attr('title', '圖示')

      $('.ui.disabled.dropdown').dropdown();
      $('.ui.multiple.selection.dropdown').dropdown();
      $('.ui.dropdown.restrict').dropdown({ maxSelections: 3 });
    }

    <%--$('#<%= UpdatePanel1.ClientID %>').on('change', function () {
      console.log('cng');

      ui_rander();
    })--%>

    var prm = Sys.WebForms.PageRequestManager.getInstance();
    prm.add_endRequest(function () {
      ui_rander();
    })

    ui_rander();

    function stringBytes(c) {
      var n = c.length, s;
      var len = 0;
      for (var i = 0; i < n; i++) {
        s = c.charCodeAt(i);
        while (s > 0) {
          len++;
          s = s >> 8;
        }
      }
      return len;
    }

    $('#article-edit').on('input', function () {
      $('#article-edit img').each(function () {
        if (!$(this).hasClass('image')) {
          $(this).addClass('ui image')
          $(this).before('&zwnj;').after('&zwnj;')
        }
      })
      img_check();
      $('#article-edit .ui.dropdown:has(.image)').each(function () {
        var prev = $('<div>', { 'html': this.previousSibling.nodeValue }).html();
        var next = $('<div>', { 'html': this.nextSibling.nodeValue }).html();
        console.log(prev, prev.indexOf('\u200C'), next, next.indexOf('\u200C'))
        if (prev.indexOf('\u200C') == -1) {
          $(this).before('&zwnj;')
        }
        if (next.indexOf('\u200C') == -1) {
          $(this).after('&zwnj;')
        }
      })
    })

    function img_check() {
      $('#<%= FormView1.CurrentMode == FormViewMode.Edit ? FormView1.FindControl("front_IU").ClientID:"" %>').on('change', function () {
        $('#Front_img').cropper('destroy')
        $('.result:has( + #image_container)').html('')
        $('#<%= f_extension_HF.ClientID %>').val('')
        $('#<%= contenttype_HF.ClientID %>').val('')
        $('#<%= Front_Img_HF.ClientID %>').val('')
        var $el = $(this);
        var file = document.getElementById($el.attr('id')).files;
        var url = URL.createObjectURL(file[0]);
        if (checkFileSize(file[0])) {
          $('#<%= f_extension_HF.ClientID %>').val(file[0].name.split('.')[1])
          $('#<%= contenttype_HF.ClientID %>').val(file[0].type)
          const img = new Image();
          img.onload = function () {
            if (this.width / this.height != 16 / 9) {
              console.log(this.width, this.height, this.width / this.height)
              console.log(this)
              console.log(16, 9, 16 / 9)
              alert('請修正長寬比');
              $('#Front_img').attr('src', url)
              if ($('#Front_img').hasClass('hidden')) $('#Front_img').removeClass('hidden')
              document.getElementById('<%= FormView1.CurrentMode == FormViewMode.Edit ? FormView1.FindControl("front_IU").ClientID:"" %>').value = '';
              init_cropper();
              if ($('#new-article.ui.form').form('has field', '<%= FormView1.CurrentMode == FormViewMode.Edit ? FormView1.FindControl("front_IU").ClientID:"" %>'))
                $('#new-article.ui.form').form('remove field', 'front_img')
              $('#new-article.ui.form').form('add fields', {
                hf_front_img: {
                  identifier: '<%= Front_Img_HF.ClientID %>',
                  rules: [{
                    type: 'empty',
                    prompt: '請確認首圖裁切',
                  }]
                }
              })
              //$(this).removeAttr('src');
            } else {
              if (this.width > 800 || this.height > 450) {
                alert('注意！圖片寬高超過800 x 450px,上傳後將進行壓縮！');
              }
              $('#image_container .ui.ok.button').addClass('hidden')
              $('#image_container .ui.view.button').addClass('hidden')
              $('#Front_img').attr('src', url)
              if ($('#new-article.ui.form').form('has field', '<%= Front_Img_HF.ClientID %>')) $('#new-article.ui.form').form('remove field', 'hf_front_img')
              $('#new-article.ui.form').form('add fields', {
                front_img: {
                  identifier: '<%= FormView1.CurrentMode == FormViewMode.Edit ? FormView1.FindControl("front_IU").ClientID:"" %>',
                  rules: [{
                    type: 'empty',
                    prompt: '請上傳首圖'
                  }]
                }
              })
              console.log($el)
              console.log($el.siblings('.image'))
              $el.siblings('.image').attr('src', url);
            }
          }
          if (file[0].type == 'image/heic' || file[0].name.substring(file[0].name.lastIndexOf('.')) == '.heic') {
            $('#<%= contenttype_HF.ClientID %>').val('image/jpeg')
            $('#<%= f_extension_HF.ClientID %>').val('.jpg')
            heic2any({
              blob: file[0],
              toType: "image/jpeg",
            })
              .then(function (resultBlob) {
                console.log('heic2jpg')
                uploadedImageURL = URL.createObjectURL(resultBlob);
                url = uploadedImageURL;
                img.src = url;
              })
              .catch(function (x) {
                console.log("Error code: <code>" + x.code + "</code> " + x.message);
              });
          } else
            img.src = url;
        } else {
          document.getElementById('<%= FormView1.CurrentMode == FormViewMode.Edit ? FormView1.FindControl("front_IU").ClientID:"" %>').value = '';
          alert('檔案大小超過5MB!!')
        }
      })

      $('#article-edit .image').each(function (i) {
        $img = $(this);
        if ($img.parents('.ad').length == 0) {
          if ($img.parent('.dropdown').length == 0) {
            $img.wrap($('<div></div>', { 'class': 'ui top left pointing column block dropdown' }))
          }
          if ($img.parent().children('.menu').length == 0) {
            $img.parent('.dropdown').append($('<div></div>', { 'class': 'menu', 'contenteditable': 'false' }))
            $img.parent('.dropdown').children('.menu').append($("<div></div>", {
              'class': 'item', 'data-value': 'left floated', 'html': `<i class="icons">
                      <i class="align justify icon" style="transform: scaleX(1.2);"></i>
                      <i class="corner square icon"
                        style="font-size: .6em; transform: scale(0.78) translate(-5.5px, -8px);"></i>
                    </i>`}));
            $img.parent('.dropdown').children('.menu').append($("<div></div>", {
              'class': 'item', 'data-value': 'centered', 'html': `<i class="icons">
                      <i class="align justify icon" style="transform: scaleX(1.2);"></i>
                      <i class="corner square icon"
                        style="font-size: .6em; transform: scale(0.78) translate(-1.3px, -8px); text-shadow: -1px -1px 0 #fff, 1px -1px 0 #fff, -1px 1px 0 #fff, 1px 1px 0 #fff, 6px 1px 0 #fff, -6px 1px 0 #fff, 6px -1px 0 #fff, -6px -1px 0 #fff;"></i>
                    </i>`}));
            $img.parent('.dropdown').children('.menu').append($("<div></div>", {
              'class': 'item', 'data-value': 'right floated', 'html': `<i class="icons">
                      <i class="align justify icon" style="transform: scaleX(1.2);"></i>
                      <i class="corner square icon"
                        style="font-size: .6em; transform: scale(0.78) translate(3px, -8px);"></i>
                    </i>`}));
            $img.parent('.dropdown').children('.menu').append($('<div></div>', {
              'class': 'header', 'html': `<div class="ui mini one column scrolling dropdown button labeled" style="align-items: center;">
                  <input name="current_img_size" type="hidden" class="noselection">
                  <div class="default text">size</div>
                  <i class="dropdown flex icon" style="align-items: center;"></i>
                  <i class="remove icon"></i>
                  <div class="menu">
                    <div class="item" data-value="mini">
                      mini<br>
                      (最大寬度 &nbsp;&nbsp;&nbsp;38px)
                    </div>
                    <div class="item" data-value="tiny">
                      tiny<br>
                      (最大寬度 &nbsp;&nbsp;&nbsp;80px)
                    </div>
                    <div class="item" data-value="small">
                      small<br>
                      (最大寬度 150px)
                    </div>
                    <div class="item" data-value="medium">
                      medium<br>
                      (最大寬度 300px)
                    </div>
                    <div class="item" data-value="large">
                      large<br>
                      (最大寬度 450px)
                    </div>
                    <div class="item" data-value="big">
                      big<br>
                      (最大寬度 600px)
                    </div>
                    <div class="item" data-value="huge">
                      huge<br>
                      (最大寬度 800px)
                    </div>
                    <div class="item" data-value="massive">
                      Massive<br>
                      (最大寬度 960px)
                    </div>
                    <div class="item" data-value="fluid">
                      fluid<br>
                      (不限制最大寬度)
                    </div>
                  </div>
                </div>` }))
            $img.parent('.dropdown').children('.menu').append($('<div></div>', { 'class': 'item', 'data-value': 'clear', 'html': '清除樣式' }))
            $img.parent('.dropdown').children('.menu').append($('<div></div>', { 'class': 'item', 'data-value': 'delete', 'html': '刪除圖片' }))
            $img.parent().dropdown({
              'clearable': ' true', 'keepOnScreen': false, 'allowTab': false, 'onChange': function (val, txt, $choice) {
                //console.log($(this).children('.image'), $img);
                var $el = $(this).children('.image')
                if (val == 'clear') {
                  $el.removeClass('left right floated centered mini tiny small medium large big huge massive fluid')
                  $el.parent().dropdown('clear')
                  $el.parent().children().children('.header').children('.dropdown').dropdown('clear')
                } else if (val == 'delete') {
                  $(this).remove();
                } else if (['mini', 'tiny', 'small', 'medium', 'large', 'big', 'huge', 'massive', 'fluid', ''].indexOf(val) != -1) {
                  $el.removeClass('mini tiny small medium large big huge massive fluid')
                  console.log(val)
                  $el.addClass(val)
                  $el.parent().children('.menu').css('top', $el.height());
                } else {
                  $el.removeClass('left right floated centered')
                  console.log(val)
                  $el.addClass(val)
                  if (val == 'centered') {
                    $el.parent().addClass('fluid')
                    $el.parent().removeClass('left right')
                    $el.parent().children('.menu').css('left', '50%')
                    $el.parent().children('.menu').css('transform', 'translateX(-50%)')
                  } else {
                    $el.parent().removeClass('fluid')
                    if (val == 'left floated') {
                      $el.parent().removeClass('right').addClass('left')
                      $el.parent().children('.menu').css('left', '')
                      $el.parent().children('.menu').css('transform', '')
                    } else if (val == 'right floated') {
                      $el.parent().removeClass('left').addClass('right')
                      $el.parent().children('.menu').css('left', '')
                      $el.parent().children('.menu').css('transform', '')
                    }
                  }
                }
              }
            });

            $img.parent().children('.menu').css('top', $img.height());

            $("#article-edit .menu .dropdown").dropdown({
              'clearable': ' true', 'onChange': function (val, txt, $choice) {
                var $el = $(this).children('.image')
                $el.removeClass('mini tiny small medium large big huge massive fluid')
                console.log(val)
                $el.addClass(val)
              }
            });
            $img.parent().children().children('.header').children('.dropdown').dropdown('clear')
          }
        }
      })
    }

    function editOK() {
      var ids = $('#article-edit .ui.image').map(function () { return $(this).attr("data-id"); }).get().join();
      console.log(ids);

      var $desc = $('#<%= FormView1.CurrentMode == FormViewMode.Edit ? FormView1.FindControl("Description").ClientID:"" %>');
      var $desc_label = $('#<%= FormView1.CurrentMode == FormViewMode.Edit ? FormView1.FindControl("Description").ClientID:"" %> + .right.attached.label');
      if (stringBytes($desc.val()) > 400) {
        $desc.parents('.field').addClass('error');
        return false;
      } else {
        $desc.parents('.field').removeClass('error');
      }
      if ($('#new-article.ui.form').form('is valid')) {
        $('#loading').addClass('active');

        $('#article-edit .image').parent().children('.menu').remove();
        $('#article-edit div.dropdown .image').unwrap();

        $('#article-edit .ui.image').each(function () {
          if (typeof $(this).attr('src') != 'undefined' && typeof $(this).attr('data-src') == 'undefined') {
            $(this).attr('data-src', $(this).attr('src'));
            $(this).addClass('lazy');
            $(this).removeAttr('src');
          }
        })
      }

      $("#<%= FormView1.CurrentMode == FormViewMode.Edit ? FormView1.FindControl("HiddenField1").ClientID:"" %>").val(ids);
      $('#article-edit .ui.embed').html('').removeClass('active');
      $('#<%= FormView1.CurrentMode == FormViewMode.Edit ? FormView1.FindControl("ContentTextBox").ClientID:"" %>').val($('#article-edit').html());
      if ($('#<%= FormView1.CurrentMode == FormViewMode.Edit ? FormView1.FindControl("ContentTextBox").ClientID:"" %>').val() == "") return false;
      else return true;
    }

    $('#article-edit .ui.embed, #article .ui.embed').embed();

    function checkFileSize(f) {
      if (f.size / 1024 < 5120) {
        return true;
      }
      return false;
    }

    function imgUpload() {
      var formData = new FormData();
      var files = $('#image_file')[0].files;
      $.each(files, function (i, file) {
        formData.append(file.name, file);
        console.log(file.name)
      });

      console.log(formData);
      if (files.length > 0) {
        if (checkFileSize(files[0])) {
          $.ajax({
            method: "POST",
            type: "POST",
            //url: "Admin_newArticle.aspx/UploadFile",
            url: "UserAction/Handler1.ashx",
            contentType: false, // Not to set any content header  
            processData: false, // Not to process data  
            dataType: 'json',
            cache: false,
            data: formData,
            success: function (result) {
              console.log(result)
              $('.upload-preview .image').removeClass('visibility-hidden')
              var file = document.getElementById('image_file').files;
              //console.log(img_files.files)
              var r = result.id.substring(0, result.id.length - 1).split(',');
              if (r != -1) {
                url = "Image.aspx?ID=" + r[r.length - 1];

                $('.upload-preview .image').attr('src', url).on('load', function () {
                  $('.insertImg.modal').modal('refresh');
                })
                $('.upload-preview .image').addClass('ui').attr('data-id', r[r.length - 1]);

                if ($('.upload-preview img.ui').parent().is('.ui.placeholder')) {
                  $('.upload-preview img.ui').unwrap();
                }
                $("#<%= FormView1.CurrentMode == FormViewMode.Edit ? FormView1.FindControl("HiddenField1").ClientID:"" %>").val(result.id);//.trigger('change');
                //__doPostBack("<%= FormView1.CurrentMode == FormViewMode.Edit ? FormView1.FindControl("HiddenField1").UniqueID:"" %>", "");

                $('.upload-preview .image').clone().attr('class', '').wrap('<div class="ui image"></div>').parent().appendTo('#uploaded_img')
              } else {
                if (result.state == "no file") {
                  alert("尚未選取檔案!");
                } else if (result.state == "overflow") {
                  alert("檔案大小超過5MB!");
                } else {
                  alert("您已上傳過多閒置圖檔，請至管理圖片上傳頁面整理圖檔！");
                }
              }
            }, xhr: function () {
              var xhr = $.ajaxSettings.xhr();
              if (xhr.upload) {
                xhr.upload.addEventListener("progress", function (e) {
                  if (e.lengthComputable) {
                    $('#image_btn .progress').progress({
                      percent: e.loaded / e.total * 100
                    });
                  }
                }, false);
                return xhr;
              }
            }
            , error: function (err) {
              console.log(err);
              alert(err.statusText);
            }
          });
        } else {
          $('#<%= modal_header.ClientID %>').html('上傳圖片');
          $('#<%= modal_content.ClientID %>').html('圖檔超過5MB!');
          $('.ui.notify.tiny.modal').modal({ inverted: true, autofocus: false, allowmultiple: true }).modal('show');
        }
      } else {
        $('#<%= modal_header.ClientID %>').html('上傳圖片');
        $('#<%= modal_content.ClientID %>').html('未選擇任何圖片');
        $('.ui.notify.tiny.modal').modal({ inverted: true, autofocus: false, allowmultiple: true }).modal('show');
      }
    }

    if (<%= FormView1.CurrentMode == FormViewMode.Edit ? "true":"false" %>) {
      img_check();
      var $desc = $('#<%= FormView1.CurrentMode == FormViewMode.Edit ? FormView1.FindControl("Description").ClientID:"" %>');
      var $desc_label = $('#<%= FormView1.CurrentMode == FormViewMode.Edit ? FormView1.FindControl("Description").ClientID:"" %> + .right.attached.label');

      $desc_label.html(stringBytes($desc.val()) + '/400');

      $desc.on('input', function () {
        var cnt = stringBytes($(this).val());
        console.log(cnt);
        $desc_label.html(cnt + '/400');
        if (cnt >= 400) {
          console.log('overflow')
          var i = Math.ceil((cnt - 400) / 2);
          console.log(i)
          while (stringBytes($(this).val()) > 400) {
            if (cnt - stringBytes($(this).val().slice(-i)) <= 400) {
              $(this).val($(this).val().slice(0, -i))
            } i++;
          }
          //$(this).attr('maxlength', $(this).val().length);
        }
        cnt = stringBytes($(this).val());
        $desc_label.html(cnt + '/400');
        if (cnt > 400) {
          $(this).parents('.field').addClass('error');
        } else {
          $(this).parents('.field').removeClass('error');
        }
      })
      $('.ui.dropdown:has(#<%= FormView1.CurrentMode == FormViewMode.Edit ? FormView1.FindControl("Category_HF").ClientID:"" %>)').dropdown({ maxSelections: 3 });
      $('.ui.dropdown:has(#<%= FormView1.CurrentMode == FormViewMode.Edit ? FormView1.FindControl("Keywords_HF").ClientID:"" %>)').dropdown({ allowAdditions: true, forceSelection: false });
      init('<%= img_FU.ClientID %>', '<%= imgUrl_HF.ClientID %>', '<%= FormView1.CurrentMode == FormViewMode.Edit ? FormView1.FindControl("ContentTextBox").ClientID:"" %>')
    }
  </script>
</asp:Content>
