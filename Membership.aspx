<%@ Page Title="" Language="C#" MasterPageFile="ClientPage.Master" AutoEventWireup="true" CodeFile="Membership.aspx.cs" Inherits="piNews.Membership" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
          <div class="active section">會員中心</div>
        </div>
      </div>
    </div>
  </div>

  <div id="main" class="ui text container">
    <div class="column">
      <h2>會員資料</h2>
      <div class="ui divider"></div>
      <%--<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
      <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>--%>
      <div id="change_userInfo" class="ui form">
        <div class="fields">
          <div class="four wide field">
            <label>
              頭像
            </label>

          <div class="ui medium centered image">
            <div class="square">
              <asp:Image ID="Member_Img" CssClass="ui image" runat="server" />
              <span class="no-img">No Image</span>
            </div>
          </div>

          </div>
          <div class="twelve wide field">
            <label>
              會員帳號(Email)<span id="Certify" class="ui ml-2 red image label"><i class="exclamation triangle icon"></i>未認證
                  <asp:LinkButton ID="SendCertifyMail" CssClass="detail" OnClick="SendCertifyMail_Click" runat="server">補寄認證信</asp:LinkButton>
              </span>
            </label>
            <div class="ui input">
              <input id="email" type="email" class="ui disabled input" value='<%= Session["Email"] %>' readonly>
              <!-- <div class="ui left icon red image label"><i class="exclamation triangle icon"></i>未認證<div class="detail">補寄認證信</div></div> -->
            </div>
          </div>
        </div>
        <div class="field">
          <label>姓名</label>
          <input id="username" runat="server" type="text" placeholder="name">
        </div>
        <div class="field">
          <label>聯絡電話</label>
          <input id="phone" runat="server" type="text" placeholder="phone">
        </div>
        <div class="field">
          <label>地址</label>
          <div class="user-addr fields">
            <asp:HiddenField ID="county_HF" runat="server" />
            <asp:HiddenField ID="district_HF" runat="server" />
            <asp:HiddenField ID="zipcode_HF" runat="server" />
            <div data-role="county" class="six wide field"></div>
            <div data-role="district" class="six wide field"></div>
            <%--<asp:Panel ID="Panel1" runat="server"></asp:Panel>--%>
            <div data-role="zipcode" id="zipcode" runat="server" class="four wide field" style="display: flex;"></div>
          </div>
        </div>
        <div class="field">
          <input id="address" runat="server" type="text" placeholder="address">
        </div>
        <div class="fields">
          <div class="eight wide field" style="display: flex;">
          </div>
          <div class="eight wide field" style="margin: 0;">
            <%--<button id="change_data" class="ui right floated blue button">送出</button>--%>
            <asp:Button ID="change_data" CssClass="ui right floated blue button" runat="server" OnClick="change_data_Click" OnClientClick="javascript: return $('#change_userInfo').form('validate form')" Text="送出" />
          </div>
        </div>
        <div class="ui error message"></div>
      </div>
      <%--</ContentTemplate>
      </asp:UpdatePanel>--%>
      <h2>修改會員密碼</h2>
      <div class="ui divider"></div>
      <div id="pwd_setting" class="ui form">
        <div class="field">
          <label>原密碼</label>
          <input id="old_pwd" runat="server" type="password" placeholder="old password">
        </div>
        <div class="field">
          <label>新密碼</label>
          <input id="new_pwd" runat="server" type="password" placeholder="new password">
        </div>
        <div class="field">
          <label>確認密碼</label>
          <input id="confirm_pwd" runat="server" type="password" placeholder="confirm password">
        </div>
        <div class="fields">
          <div class="eight wide field" style="display: flex;">
          </div>
          <div class="eight wide field" style="margin: 0;">
            <%--<button id="change_pwd" class="ui right floated blue button">送出</button>--%>
            <asp:Button ID="change_pwd" CssClass="ui right floated blue button" OnClientClick="javascript: return $('#pwd_setting').form('validate form')" OnClick="change_pwd_Click" runat="server" Text="送出" />
          </div>
        </div>
        <div class="ui error message"></div>
      </div>

      <h2>修改會員照片</h2>
      <div class="ui divider"></div>
      <div id="picture_setting" class="ui form">
        <%--<div class="two fields">--%>
        <div class="field">
          <div class="ui medium centered image">
            <div class="square">
              <asp:Image ID="Cover_Img" CssClass="ui image" runat="server" />
              <span class="no-img">No Image</span>
            </div>
          </div>
          <asp:FileUpload ID="Member_Img_FU" runat="server" CssClass="hidden" />

          <div class="ui fluid buttons">
            <label for='<%= Member_Img_FU.ClientID %>' class="ui yellow button" style="color: #fff;">
              <i class="ui upload icon"></i>
              選擇圖檔
            </label>

            <asp:Button ID="Send_Btn1" CssClass="ui blue button" OnClientClick="javascript: return $('.ui.form').form('validate form');" OnClick="Upload_picture_Click" runat="server" Text="上傳" />

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
        <div class="field">
        </div>
        <%--</div>--%>
      </div>

    </div>
  </div>

  <div class="ui tiny modal">
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

  <script src="https://cdn.jsdelivr.net/npm/jquery-twzipcode@1.7.15-rc1/jquery.twzipcode.min.js"></script>
  <script>
    $(".user-addr").twzipcode({
      //css: ['six wide field', 'six wide field', 'four wide field'],
      readonly: true,
    });

    $("[data-role]").children().on('change', function () {
      $('#<%= county_HF.ClientID %>').val($(".user-addr").twzipcode('get', 'county'));
      $('#<%= district_HF.ClientID %>').val($(".user-addr").twzipcode('get', 'district'));
      $('#<%= zipcode_HF.ClientID %>').val($(".user-addr").twzipcode('get', 'zipcode'));
    })

    $(window).on('load', function () {
      $('.image:has(#<%= Cover_Img.ClientID %>[src=""])').css('background', 'lightblue');

      $('#<%= Member_Img_FU.ClientID %>').on('change', function () {
        var file = document.getElementById('<%= Member_Img_FU.ClientID %>').files;
        var url = URL.createObjectURL(file[0]);
        $('#<%= Cover_Img.ClientID %>').attr('src', url)
        $('.image:has(#<%= Cover_Img.ClientID %>)').css('background', 'transparent');
      })

      $('#change_userInfo').form({
        fields: {
          name: {
            identifier: '<%= username.ClientID %>',
            rules: [{
              type: 'empty',
              prompt: '請輸入姓名'
            }]
          },
          phone: {
            identifier: '<%= phone.ClientID %>',
            rules: [{
              type: 'empty',
              prompt: '請輸入電話'
            }, {
              type: 'number',
              prompt: '請輸入正確電話'
            }]
          },
          zipCode: {
            identifier: '<%= zipcode_HF.ClientID %>',
            rules: [{
              type: 'empty',
              prompt: '請點選產生郵遞區號'
            }]
          },
          address: {
            identifier: '<%= address.ClientID %>',
            rules: [{
              type: 'empty',
              prompt: '請輸入地址'
            }]
          },
        }
      })
      $('#pwd_setting').form({
        fields: {
          oldPassword: {
            identifier: '<%= old_pwd.ClientID %>',
            rules: [{
              type: 'empty',
              prompt: '請輸入舊密碼'
            }]
          },
          newPassword: {
            identifier: '<%= new_pwd.ClientID %>',
            rules: [{
              type: 'empty',
              prompt: '請輸入新密碼'
            },
            {
              type: 'regExp',
              value: /(([0-9]+[a-zA-Z]+)|([a-zA-Z]+[0-9]+)).*/g,
              prompt: '請輸入含英文和數字之密碼'
            },
            {
              type: 'minLength',
              value: '8',
              prompt: '請輸入8位以上含英文和數字之密碼'
            },
            {
              type: 'maxLength',
              value: '100',
              prompt: '請輸入8位以上100位以下含英文和數字之密碼'
            }]
          },
          confirmPassword: {
            identifier: '<%= confirm_pwd.ClientID %>',
            rules: [{
              type: 'match[<%= new_pwd.ClientID %>]',
              prompt: '確認密碼有誤'
            }]
          },
        }
      })
    })
  </script>
</asp:Content>
