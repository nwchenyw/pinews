<%@ Page Title="" Language="C#" MasterPageFile="ClientPage.Master" AutoEventWireup="true" CodeFile="OnlinePost.aspx.cs" Inherits="piNews.OnlinePost" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <link rel="stylesheet" type="text/css"
    href="https://cdn.jsdelivr.net/npm/spectrum-colorpicker2/dist/spectrum.min.css">
  <link rel="stylesheet" href="css/editor.css" />
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
          <a class="section">首頁</a>
          <div class="divider">/ </div>
          <div class="active section">線上投稿</div>
        </div>
      </div>
    </div>
  </div>

  <div id="main" class="ui text container">

    <h2 class="ui header">線上投稿</h2>
    <h2 class="ui sub header"></h2>
    <div class="ui divider"></div>
    <div id="new-article" class="ui large form">
      <div class="field">
        <label>首圖</label>
        <%--<input type="file" class="hidden" id="imageupload" />--%>
        <asp:FileUpload ID="Front_Img_FU" runat="server" CssClass="hidden" />
        <label for='<%= Front_Img_FU.ClientID %>' class="ui large blue button" style="color: #fff;">
          <i class="ui upload icon"></i>
          上傳
        </label>
        <img class="ui centered image" id="Front_img" />
      </div>
      <div class="two fields">
        <div class="field">
          <label>投稿者姓名</label>
          <asp:TextBox ID="Name_TB" runat="server" placeholder="name"></asp:TextBox>
        </div>
        <div class="field">
          <label>E-mail</label>
          <asp:TextBox ID="Email_TB" runat="server" placeholder="E-mail"></asp:TextBox>
        </div>
      </div>
      <div class="field">
        <label>投稿標題</label>
        <asp:TextBox ID="Title_TB" runat="server" placeholder="title"></asp:TextBox>
      </div>
      <div class="field">
        <label>投稿分類</label>
        <div class="ui clearable selection dropdown">
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
        <label>投稿內容</label>
        <asp:TextBox ID="Content_TB" CssClass="hidden" runat="server" placeholder="Type here..."></asp:TextBox>
        <asp:FileUpload ID="img_FU" CssClass="hidden" runat="server" />
        <asp:HiddenField ID="imgUrl_HF" runat="server" />

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
          <div class="ui icon basic buttons">
            <div class="ui text-color top right pointing dropdown button" title="文字顏色">
              <i class="font icon"></i>
              <div class="menu">
                <div class="hidden helper item"></div>
                <input id="text-color-picker" value='rgba(0,0,0,.87)' />
              </div>
            </div>
            <div class="ui text-bg-color top right pointing dropdown icon button" title="背景顏色">
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
            <input type="hidden" id="font_size" name="font-size">
            <i class="dropdown icon"></i>
            <div class="default text">size</div>
            <div class="menu">
              <div class="item" data-value="8px">8</div>
              <div class="item" data-value="9px">9</div>
              <div class="item" data-value="10px">10</div>
              <div class="item" data-value="11px">11</div>
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

        <div id="article-edit" class="ui bottom attached textarea segment" aria-placeholder="Type here..." contenteditable="true"></div>

      </div>
      <div class="field" style="display: flex;">
        <div class="ui action input">
          <input id="vali" type="text" placeholder="驗證碼">
          <canvas id="NumValidate" width="90" height="40" style="border: 1px solid #d3d3d3;"></canvas>
          <button type="button" class="ui icon button" onclick="genValidate()"><i class="sync alternate icon"></i></button>
        </div>
      </div>
      <div class="field">
        <label>上傳圖片</label>
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
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
      <div class="ui right aligned container field">
        <asp:Button ID="Send_Btn" CssClass="ui blue button" OnClientClick="javascript: return editOK();" OnClick="Send_Btn_Click" runat="server" Text="投稿" />
      </div>
    </div>
  </div>

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
              <li>圖片建議尺寸： 750 x 423px，檔案容量不得超過10MB。</li>
              <li>圖片格式：JPG,PNG,GIF</li>
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
  <script src="js/editor.js"></script>
  <script>
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

    $('#<%= Front_Img_FU.ClientID %>').on('change', function () {
      var file = document.getElementById('<%= Front_Img_FU.ClientID %>').files;
      var url = URL.createObjectURL(file[0]);
      if (checkFileSize(file[0])) {
        $('#Front_img').attr('src', url)
      } else {
        document.getElementById('<%= Front_Img_FU.ClientID %>').value = '';
        alert('檔案大小超過10MB!!')
      }
    })

    function checkFileSize(f) {
      if (f.size / 1024 < 10240) {
        return true;
      }
      return false;
    }

    function genValidate() {
      var canvas = document.getElementById("NumValidate");
      var ctx = canvas.getContext("2d");

      ctx.beginPath();
      ctx.rect(0, 0, 90, 40);
      ctx.fillStyle = "white";
      ctx.fill();
      var str = Math.floor(Math.random() * 10000);
      str = ("000" + str.toString()).slice(-4);
      console.log(str)

      for (i = 0; i < str.length; i++) {
        ctx.save();
        ctx.font = "30px Arial";
        ctx.rotate((Math.PI / 180) * Math.random() * 10 * (Math.random() > 0.5 ? 1 : -1));
        ctx.strokeText(str.substring(i, i + 1), 10 + 18 * i, 30);
        ctx.restore();
      }

      $('.ui.form').form({
        fields: {
          name: {
            identifier: '<%= Name_TB.ClientID %>',
            rules: [{
              type: 'empty',
              prompt: '請輸入投稿者姓名'
            }]
          },
          email: {
            identifier: '<%= Email_TB.ClientID %>',
            rules: [{
              type: 'empty',
              prompt: '請輸入E-mail'
            }]
          },
          title: {
            identifier: '<%= Title_TB.ClientID %>',
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
          content: {
            identifier: '<%= Content_TB.ClientID %>',
            rules: [{
              type: 'empty',
              prompt: '請輸入內文'
            }]
          },
          validateCode: {
            identifier: 'vali',
            rules: [{
              type: 'regExp',
              value: RegExp(str, "i"),
              prompt: '請輸入驗證碼'
            }]
          }
        }
      })
    }

    function img_check() {
      $('#article-edit .image').each(function (i) {
        $img = $(this);
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
          $img.parent().dropdown({
            'clearable': ' true', 'keepOnScreen': false, 'onChange': function (val, txt, $choice) {
              //console.log($(this).children('.image'), $img);
              var $el = $(this).children('.image')
              if (val == 'clear') {
                $el.removeClass('left right floated centered mini tiny small medium large big huge massive fluid')
                $el.parent().dropdown('clear')
                $el.parent().children().children('.header').children('.dropdown').dropdown('clear')
              } else if (['mini', 'tiny', 'small', 'medium', 'large', 'big', 'huge', 'massive', 'fluid', ''].indexOf(val) != -1) {
                $el.removeClass('mini tiny small medium large big huge massive fluid')
                console.log(val)
                $el.addClass(val)
                $el.parent().children('.menu').css('top', $el.parent().height());
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

          $img.parent().children('.menu').css('top', $img.parent().height());

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
      })
    }

    function editOK() {
      var ids = $('#article-edit .ui.image').map(function () { return $(this).attr("data-id"); }).get().join();
      console.log(ids);
      $("#<%= HiddenField1.ClientID %>").val(ids);
      $('#article-edit .ui.embed').html('').removeClass('active');
      $('#<%= Content_TB.ClientID %>').val($('#article-edit').html());
      <%--if ($('#<%= article_TB.ClientID %>').val() == "" || !$('.ui.form').form('validate form')) return false;
      else return true;--%>
      console.log($('#new-article.ui.form').form('validate form'));
      if ($('#<%= img_FU.ClientID %>')[0].files.length + $('#<%= Front_Img_FU.ClientID %>')[0].files.length > 3) {
        $('.ui.form').form('add errors', { account: '文章圖片(包含首圖)不能超過3張' });
        return false;
      } else {
      }
      if ($('#new-article.ui.form').form('is valid')) {
        $('#loading').addClass('active');

        $('#article-edit .image').parent().children('.menu').remove();
        $('#article-edit .image').unwrap();

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

    function imgUpload() {
      var formData = new FormData();
      var files = $('#image_file')[0].files;
      $.each(files, function (i, file) {
        formData.append(file.name, file);
        console.log(file.name)
      });

      var img_amount = $('#article-edit .image[data-id]').length;

      console.log(formData);
      if ($('#<%= Front_Img_FU.ClientID %>')[0].files.length + img_amount < 3) {
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
                    if (result.state == "no file") {
                      alert("尚未選取檔案!");
                    } else {
                      alert("檔案大小超過10MB!");
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
            }
            else {
              $('#<%= modal_header.ClientID %>').html('上傳圖片');
              $('#<%= modal_content.ClientID %>').html('圖檔超過10MB!');
              $('.ui.notify.tiny.modal').modal({ inverted: true, autofocus: false, allowmultiple: true }).modal('show');
            }
          } else {
            $('#<%= modal_header.ClientID %>').html('上傳圖片');
            $('#<%= modal_content.ClientID %>').html('未選擇任何圖片');
          $('.ui.notify.tiny.modal').modal({ inverted: true, autofocus: false, allowmultiple: true }).modal('show');
        }
      } else {
        $('#<%= modal_header.ClientID %>').html('上傳圖片');
        $('#<%= modal_content.ClientID %>').html('圖片上傳(包含首圖)超過最大限度3張!');
        $('.ui.notify.tiny.modal').modal({ inverted: true, autofocus: false, allowmultiple: true }).modal('show');
      }
    }

    $(window).on('load', function () {
      genValidate()
      $('.ui.selection.dropdown')
        .dropdown({
          clearable: true,
          className: { menu: 'scrollhint menu' }
        });

      <%--$('#<%= Front_Img_FU.ClientID %>').on('change', function () {
        var file = document.getElementById('<%= Front_Img_FU.ClientID %>').files;
        var url = URL.createObjectURL(file[0]);
        $('#Front_img').attr('src', url)
      })--%>

      init('<%= img_FU.ClientID %>', '<%= imgUrl_HF.ClientID %>', '<%= Content_TB.ClientID %>')
    })
  </script>
</asp:Content>
