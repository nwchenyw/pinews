<%@ Page Title="" Language="C#" MasterPageFile="AdminPage.Master" AutoEventWireup="true" CodeFile="Admin_newArticle.aspx.cs" Inherits="piNews.Admin_newArticle" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <link rel="stylesheet" type="text/css"
    href="https://cdn.jsdelivr.net/npm/spectrum-colorpicker2/dist/spectrum.min.css">
  <link rel="stylesheet" href="css/editor.css" />
  <link rel="stylesheet" href="css/cropper.min.css" />

  <%--<script data-ad-client="ca-pub-7266289617887477" async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>--%>
  <style>
    input[type=radio][name$=personal_ad]:checked + label {
      border: 1px solid #257fa4;
      padding: .4em .5em;
      border-radius: 5px;
    }

    .ui.text.container {
      font-family: Lato,'Helvetica Neue',Arial,Helvetica,sans-serif;
      line-height: 1.5;
      font-size: 1.14285714rem;
    }

    #new-article .result canvas {
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
      <div class="active section">新增投稿文章</div>
    </div>
  </div>
  <div class="ui segment">
    <asp:HiddenField ID="Email_HF" runat="server" />
    <asp:HiddenField ID="UID_HF" runat="server" />
    <asp:HiddenField ID="Name_HF" runat="server" />
    <asp:HiddenField ID="Pname_HF" runat="server" />
    <p><a class="ui icon left labeled button" href="Admin_articles.aspx"><i class="newspaper outline icon"></i>投稿文章管理</a></p>
    <div id="new-article" class="ui form text container">
      <div class="field">
        <label>
          首圖

        <asp:Repeater ID="Repeater2" runat="server" DataSourceID="SqlDataSource4">
          <ItemTemplate>
            <span class='ui image right floated label <%# (float)Convert.ToDouble(Eval("mb", "{0:0.00}")) > 5 ? "red":"teal" %>'><i class='images icon <%# (float)Convert.ToDouble(Eval("mb", "{0:0.00}")) > 5 ? "hidden":"" %>'></i><i class='corner exclamation triangle icon <%# (float)Convert.ToDouble(Eval("mb", "{0:0.00}")) > 5 ? "":"hidden" %>'></i>閒置圖片<asp:Label CssClass="detail" Text='<%# Eval("mb", "{0:0.00}") + "MB" %>' runat="server" ID="mbLabel" /></span>
          </ItemTemplate>
        </asp:Repeater>
        </label>
        <asp:SqlDataSource runat="server" ID="SqlDataSource4" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT ISNULL(SUM(i.Size) / 1024, 0) AS mb FROM Image AS i LEFT OUTER JOIN Article_Image AS ai ON i.Id = ai.image_id LEFT OUTER JOIN Article AS a ON i.Id = a.Front_Img_Id LEFT OUTER JOIN Advertisement AS ad ON i.Id = ad.Img_Id LEFT OUTER JOIN Member AS m ON i.Id = m.Member_Img_Id LEFT OUTER JOIN Banner AS b ON i.Id = b.Image_Id WHERE (i.Image_Type <> 2) AND (i.User_id = @Id) AND (ai.article_id IS NULL) AND (ad.Id IS NULL) AND (m.Id IS NULL) AND (b.Id IS NULL) AND (a.Id IS NULL)">
          <SelectParameters>
            <asp:SessionParameter SessionField="User_Id" Name="Id"></asp:SessionParameter>
          </SelectParameters>
        </asp:SqlDataSource>
        <asp:FileUpload ID="Front_img_FU" runat="server" accept="image/gif, image/jpeg, image/png, image/heic" />
        <div class="result"></div>
        <div id="image_container">
          <div class="hidden preview">
            <div class="ui tiny image"></div>
          </div>
          <div class="ui hidden view button" onclick="get_img('view')">預覽</div>
          <div class="ui hidden ok button" onclick="get_img('ok')">完成</div>
          <img class="ui image" id="Front_img" height="auto" width="100%" />
        </div>
        <asp:HiddenField ID="f_extension_HF" runat="server" />
        <asp:HiddenField ID="contenttype_HF" runat="server" />
        <asp:HiddenField ID="Front_Img_HF" runat="server" />
        <div class="ui message">
          <div class="header">
            注意事項
          </div>
          <ul class="list">
            <li>圖片建議尺寸： 800 x 450px，寬高超過800 x 450px將自動壓縮至800 x 450px，檔案容量不得超過5MB。</li>
            <li>圖片比例： 16:9，比例不符將無法上傳。</li>
            <li>圖片格式：JPG,PNG,GIF</li>
            <li>上傳限制：閒閒置圖片超過3天將進行清理，若期間閒置圖片超過5MB以上，將不開放文內圖片上傳，請至管理圖片上傳頁面將閒置圖片刪除後再編輯。</li>
          </ul>
        </div>
      </div>
      <div class="field">
        <label>標題</label>
        <asp:TextBox ID="title_TB" runat="server" placeholder="Title"></asp:TextBox>
      </div>
      <div class="field">
        <label>分類</label>
        <div class="ui multiple selection dropdown">
          <asp:HiddenField ID="Category_HF" runat="server" />
          <i class="dropdown icon"></i>
          <div class="default text">Category</div>
          <div class="menu">
            <asp:Repeater ID="Category_R" runat="server" DataSourceID="SqlDataSource1">
              <ItemTemplate>
                <div class="item" data-value='<%# Eval("Id") %>'><%# Eval("Name") %></div>
              </ItemTemplate>
            </asp:Repeater>
            <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT * FROM [Menu]"></asp:SqlDataSource>
          </div>
        </div>
      </div>
      <div class="field">
        <label>
          簡短介紹
           <span style="color: red;">(中文最多200字/英文400字)</span>
        </label>
        <div class="ui input">
          <asp:TextBox ID="Description" TextMode="MultiLine" MaxLength="400" Rows="4" runat="server"></asp:TextBox>
          <span class="ui bottom right attached label">0/400</span>
        </div>
      </div>

      <div class="field">
        <label>是否上架</label>
        <asp:CheckBox ID="status_CB" CssClass="ui toggle checkbox" runat="server" Text=" " />
      </div>

      <div class="field">
        <label>
          設定上架期間
           <span style="color: red;">(空值則無限制上架期限)</span>
        </label>
        <div class="two fields">
          <div class="field">
            <asp:TextBox ID="s_time" TextMode="DateTimeLocal" runat="server"></asp:TextBox>
          </div>
          <div class="field">
            <asp:TextBox ID="e_time" TextMode="DateTimeLocal" runat="server"></asp:TextBox>
          </div>
        </div>
      </div>
      <div class="field">
        <label>
          關鍵字<%--<span class="ui yellow label"><i class="info circle icon"></i>請在關鍵字輸入後按Enter鍵產生關鍵字標籤</span>--%>
        </label>
        <div class="ui multiple selection search dropdown">
          <asp:HiddenField ID="Keywords_HF" runat="server" />
          <i class="dropdown icon"></i>
          <div class="default text">Keyword</div>
          <div class="menu">
            <asp:Repeater ID="Keyword_R" runat="server" DataSourceID="SqlDataSource2">
              <ItemTemplate>
                <div class="item" data-value='<%# Eval("keyword") %>'><%# Eval("keyword") %></div>
              </ItemTemplate>
            </asp:Repeater>
            <asp:SqlDataSource runat="server" ID="SqlDataSource2" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT kw.Item AS keyword
FROM Article A OUTER APPLY dbo.SplitString (A.Keyword, ',') kw
group by kw.Item"></asp:SqlDataSource>
          </div>
        </div>
        <div class="ui floating info icon visible message">
          <i class="close icon"></i>
          <i class="info circle icon"></i>
          <div class="content">
            <div class="header">提示</div>
            請在關鍵字輸入後按<b>Enter鍵</b>產生關鍵字標籤。
          </div>
        </div>
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
        <div class="ui top attached textarea-option segment">
          <div class="ui icon basic buttons">
            <button class="ui button" type="button" data-method="code" title="檢視源碼"><i class="file code outline icon"></i></button>
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
          </div>
          <button type="button" class="ui icon basic button" data-method="newading" title="新增廣告">
            <i class="ad icon"></i>
          </button>
          <div></div>
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
        </div>

        <asp:TextBox ID="article_TB" CssClass="hidden" runat="server"></asp:TextBox>
        <asp:FileUpload ID="img_FU" CssClass="hidden" runat="server" AllowMultiple="true" />
        <asp:HiddenField ID="imgUrl_HF" runat="server" />
        <div id="article-edit" class="ui bottom attached textarea segment" tabindex="-1" aria-placeholder="Type here..." contenteditable="true"></div>

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
          <div class="content">
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
          <div class="content">
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
                  <asp:FileUpload ID="img_UL" runat="server" CssClass="hidden" />
                  <div class="ui fluid buttons basic fitted segment" id="image_btn" style="margin: 0;">
                    <label for="image_file" class="ui basic primary icon button">
                      <i class="images icon"></i>選擇圖檔
                    </label>
                    <%--<label for='<%= img_UL.ClientID %>' class="ui basic primary icon button">
                      <i class="images icon"></i>選擇圖檔
                    </label>--%>
                    <span class="ui bottom attached indicating progress">
                      <span class="bar"></span>
                    </span>
                    <button type="button" id="img_upload" class="ui basic olive icon button" onclick="imgUpload()"><i class="upload icon"></i>上傳</button>
                    <%--<button type="button" id="img_upload1" class="ui basic olive icon button" onclick="imgUL()"><i class="upload icon"></i>上傳</button>--%>
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
                    <li>圖片建議尺寸： 800 x 450px，檔案容量不得超過5MB。</li>
                    <li>圖片建議比例： 16:9</li>
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
          <div class="content">
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
              <asp:ListView ID="ListView1" runat="server" DataSourceID="SqlDataSource3">
                <ItemTemplate>
                  <input type="radio" id='personal_ad<%# Container.DataItemIndex %>' class="hidden" name="personal_ad" <%# Container.DataItemIndex == 0 ? "checked":"" %> />
                  <label for='personal_ad<%# Container.DataItemIndex %>' style="display: inline-table;">
                    <div class="ui centered card ad" style="padding: 0; display: inline-table;">
                      <div class="image" style="height: unset;">
                        <div class='ui <%# !Eval("video_url").Equals(DBNull.Value) && !Eval("video_type").Equals(DBNull.Value) ? "":"hidden" %> embed' data-id='<%# Eval("video_url") %>' data-source='<%# Eval("video_type") %>'></div>
                        <a data-href='<%# Eval("Link") %>' class='long <%# !Eval("video_url").Equals(DBNull.Value) && !Eval("video_type").Equals(DBNull.Value) ? "hidden":"" %> square block' target="_blank">
                          <img class="ui medium image" src='<%# Eval("Img_Id").Equals(DBNull.Value) ? "":"Image.aspx?Id="+Eval("Img_Id") %>'>
                        </a>
                      </div>
                      <div class="left aligned content">
                        <a data-href='<%# Eval("Link") %>' class="header" style="opacity: .7;"><span class="left floated"><%# Eval("Title") %></span><i class="right floated ad icon"></i></a>
                        <a data-href='<%# Eval("Link") %>' class="meta"><%# Eval("Remark") %></a>
                      </div>
                    </div>
                  </label>
                </ItemTemplate>
              </asp:ListView>
              <asp:SqlDataSource runat="server" ID="SqlDataSource3" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT [Img_Id], [Link], [Title], [Remark], [video_type], [video_url] FROM [Advertisement] WHERE (([Type] = @Type) AND ([User_Id] = @User_Id))">
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
        <%--<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>--%>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server" OnLoad="UpdatePanel1_Load">
          <ContentTemplate>
            <asp:HiddenField ID="HiddenField1" runat="server" OnValueChanged="HiddenField1_ValueChanged" />
            <div id="uploaded_img" class="ui small images">
              <asp:Repeater ID="Repeater1" runat="server">
                <ItemTemplate>
                  <div class="ui image">
                    <img class="ui lazy image" src='Image.aspx?ID=<%# Container.DataItem %>' />
                  </div>
                </ItemTemplate>
              </asp:Repeater>
            </div>
          </ContentTemplate>
        </asp:UpdatePanel>

      </div>
      <div class="ui error message"></div>
      <asp:LinkButton ID="Submit_Btn" CssClass="ui primary button" OnClientClick="javascript: return editOK();" OnClick="Submit_Btn_Click" runat="server">完成</asp:LinkButton>
    </div>
  </div>

  <%--<div class="ui crop-img modal">
    <div class="header">
      裁切首圖
    </div>
    <div class="content">
      <img class="" />
    </div>
    <div class="actions">
      <div class="ui button">確定</div>
      <div class="ui deny button">取消</div>
    </div>
  </div>--%>

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
  <script src="js/editor.js?2"></script>
  <script>

    $('.newading .ui.embed').embed()

    var mh = $(window).height() - $('.ui.textarea-option.segment').outerHeight();
    if (mh < 150) mh = 150
    $('#article-edit').css('max-height', 'calc( ' + mh + 'px - 3rem )')
    console.log($(window).height(), - $('.ui.textarea-option.segment').outerHeight())

    $(window).on('resize', function () {
      var mh = $(window).height() - $('.ui.textarea-option.segment').outerHeight();
      if (mh < 150) mh = 150
      $('#article-edit').css('max-height', 'calc( ' + mh + 'px - 3rem )')
    })

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

    $('#<%= Description.ClientID %>').on('input', function () {
      var cnt = stringBytes($(this).val());
      console.log(cnt);
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
      $('#<%= Description.ClientID %> + .right.attached.label').html(cnt + '/400');
      if (cnt > 400) {
        $(this).parents('.field').addClass('error');
      } else {
        $(this).parents('.field').removeClass('error');
      }
    })

    $('.ui.multiple.selection.dropdown:has(#' + '<%= Keywords_HF.ClientID %>)').dropdown({ allowAdditions: true, forceSelection: false, apiSettings: { url: '/Tag/Search/{query}' } });
    $('#<%= Keywords_HF.ClientID %> + #search').attr('tabindex', '-1')
    $('.ui.info.visible.message .close.icon').on('click', function () {
      $('.ui.info.message').removeClass('visible');
    })

    $('.ui.dropdown:has(#<%= Category_HF.ClientID %>)').dropdown({ maxSelections: 3 });
    $('#<%= Front_img_FU.ClientID %>').on('change', function () {
      $('#Front_img').cropper('destroy')
      $('#image_container .preview').addClass('hidden')
      $('.result:has( + #image_container)').html('')
      $('#<%= f_extension_HF.ClientID %>').val('')
      $('#<%= contenttype_HF.ClientID %>').val('')
      $('#<%= Front_Img_HF.ClientID %>').val('')
      var $el = $(this);
      var file = document.getElementById('<%= Front_img_FU.ClientID %>').files;
      var url = URL.createObjectURL(file[0]);
      if (checkFileSize(file[0])) {
        console.log(file[0].type, file[0].name.substring(file[0].name.lastIndexOf('.')))
        $('#<%= f_extension_HF.ClientID %>').val(file[0].name.split('.')[1])
        $('#<%= contenttype_HF.ClientID %>').val(file[0].type)
        const img = new Image();
        img.onload = function () {
          if (Math.floor(this.width / this.height * 100) / 100 != Math.floor(16 / 9 * 100) / 100) {
            console.log(this.width, this.height, Math.floor(this.width / this.height * 100) / 100)
            console.log(this)
            console.log(16, 9, Math.floor(16 / 9 * 100) / 100)
            alert('請修正長寬比');
            $('#Front_img').attr('src', url)
            if ($('#Front_img').hasClass('hidden')) $('#Front_img').removeClass('hidden')
            document.getElementById($el.attr("id")).value = '';
            init_cropper();
            if ($('#new-article.ui.form').form('has field', '<%= Front_img_FU.ClientID %>')) $('#new-article.ui.form').form('remove field', 'front_img')
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
                identifier: '<%= Front_img_FU.ClientID %>',
                rules: [{
                  type: 'empty',
                  prompt: '請上傳首圖'
                }]
              }
            })
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
        document.getElementById('<%= Front_img_FU.ClientID %>').value = '';
        alert('檔案大小超過5MB!!')
      }
    })

    $('#new-article.ui.form').form({
      fields: {
        front_img: {
          identifier: '<%= Front_img_FU.ClientID %>',
          rules: [{
            type: 'empty',
            prompt: '請上傳首圖'
          }]
        },
        title: {
          identifier: '<%= title_TB.ClientID %>',
          rules: [{
            type: 'empty',
            prompt: '請輸入標題'
          }]
        },
        category: {
          identifier: '<%= Category_HF.ClientID %>',
          rules: [{
            type: 'empty',
            prompt: '請選擇分類'
          }]
        },
        keyword: {
          identifier: '<%= Keywords_HF.ClientID %>',
          rules: [{
            type: 'empty',
            prompt: '請輸入關鍵字'
          }]
        },
        content: {
          identifier: '<%= article_TB.ClientID %>',
          rules: [{
            type: 'empty',
            prompt: '請輸入內文'
          }]
        },
      }
    })

    function checkFileSize(f) {
      if (f.size / 1024 < 5120) {
        return true;
      }
      return false;
    }

    function editOK() {
      var ids = $('#article-edit .ui.image').map(function () { return $(this).attr("data-id"); }).get().join();
      console.log(ids);
      $("#<%= HiddenField1.ClientID %>").val(ids);
      $('#article-edit .ui.embed').html('').removeClass('active');
      $('#<%= article_TB.ClientID %>').val($('#article-edit').html());
      <%--if ($('#<%= article_TB.ClientID %>').val() == "" || !$('.ui.form').form('validate form')) return false;
      else return true;--%>

      if (stringBytes($('#<%= Description.ClientID %>').val()) > 400) {
        $('#<%= Description.ClientID %>').parents('.field').addClass('error');
        return false;
      } else {
        $('#<%= Description.ClientID %>').parents('.field').removeClass('error');
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
      return $('#new-article.ui.form').form('validate form');
    }

    function imgUL() {
      $.ajax({
        method: "POST",
        type: "POST",
        url: "Admin_newArticle.aspx/UploadImage",
        dataType: 'json',
        success: function (result) {
          console.log(result)
          $('.upload-preview .image').removeClass('visibility-hidden')
          var file = document.getElementById('image_file').files;
          url = "Image.aspx?ID=" + result.id;
          $('.upload-preview .image').attr('src', url).on('load', function () {
            $('.insertImg.modal').modal('refresh');
          })
          $('.upload-preview .image').addClass('ui')

          if ($('.upload-preview img.ui').parent().is('.ui.placeholder')) {
            $('.upload-preview img.ui').unwrap();
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
    }

    function img_check() {
      $('#article-edit .image').each(function (i) {
        $img = $(this);
        console.log($img.parents('.ad').length)
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
              'clearable': ' true', 'keepOnScreen': false, allowTab: false, 'onChange': function (val, txt, $choice) {
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
                $("#<%= HiddenField1.ClientID %>").val(result.id).trigger('change');
                __doPostBack("<%= HiddenField1.UniqueID %>", "");
              } else {
                if (result.stat == "no file") {
                  alert("尚未選取檔案!");
                } else if (result.stat == "overflow") {
                  alert("檔案大小超過5MB!");
                } else if (result.stat == "idle_overflow") {
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
    //var $drop_el;
    //document.addEventListener('drop', function (ev) {
    //  //ev.preventDefault();
    //  console.log('drop')
    //  console.log(ev.target)
    //  var $el = $(ev.dataTransfer.getData("text/html"));
    //  $drop_el = $el;
    //  console.log($el.prop('tagName'));
    //  //if ($el.prop('tagName') == 'IMG' && !$el.hasClass('image')) {
    //  //  $el.addClass('ui image');
    //  //}
    //})

    init('<%= img_FU.ClientID %>', '<%= imgUrl_HF.ClientID %>', '<%= article_TB.ClientID %>');
  </script>
</asp:Content>
