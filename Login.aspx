<%@ Page Title="" Language="C#" MasterPageFile="ClientPage.Master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="piNews.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <style>
    .ui.placeholder .header:not(:first-child):before, .ui.placeholder .image:not(:first-child):before, .ui.placeholder .paragraph:not(:first-child):before {
      display: none !important;
    }


    .ui.form .ui.transparent.inverted.input {
      border-bottom: 1px solid #E6A732 !important;
    }

      .ui.form .ui.transparent.inverted.input:not(#vali) {
        border-radius: 0 !important;
      }

    .ui.transparent.inverted.input::placeholder {
      color: #E6A732;
    }

    .ui.form .ui.transparent.inverted.input:active, .ui.form .ui.transparent.inverted.input:focus {
      border-bottom: 1px solid rgba(255,255,255,1) !important;
      color: #e6a732;
      font-weight: bold;
    }

    .ui.transparent.inverted.input:active::placeholder, .ui.transparent.inverted.input:focus::placeholder {
      color: rgba(255,255,255,1);
    }

    #vali {
      border: 1px solid #E6A732 !important;
    }

      #vali::placeholder {
        color: #E6A732;
      }

      #vali:active, #vali:focus {
        border: 1px solid rgba(255,255,255,1) !important;
        color: #e6a732;
        font-weight: bold;
      }

        #vali:active::placeholder, #vali:focus::placeholder {
          color: rgba(255,255,255,1);
        }
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
          <a class="section" href="Default.aspx">首頁</a>
          <div class="divider">/ </div>
          <div class="active section">網記登入</div>
        </div>
      </div>
    </div>
  </div>

  <div id="main" class="ui placeholder container blue inverted fitted segment" style="overflow: hidden;">
    <div class="ui stackable two column padded grid">

      <%--<div class="middle aligned row" style="padding: 0;">--%>
      <div class="yellow column">
        <div class="ui basic segment">
          <h2>註冊網記流程</h2>
          <ol class="ui large list">
            <li class="item"><span class="ui black text">註冊-登入網記-立即註冊網記</span></li>
            <li class="item"><span class="ui black text">填表-網記註冊送出(代碼請洽引薦人-或填寫無)</span></li>
            <li class="item"><span class="ui black text">繳費-繳交系統年費(可線上刷卡/或匯款)<br>
			渣打銀行 (052) 0232000-0060520  高維楚
			</span>
			</li>
            <li class="item"><span class="ui black text">認證-個人信箱收信帳密認證</span></li>
            <li class="item"><span class="ui black text">開通-重新帳密登入網記/開通使用</span></li>
            <li class="item"><span class="ui black text">完成-會有專人聯繫服務指導教學</span></li>
          </ol>

          <div class="eight wide flex field" style="margin: 0;">
            <%--<a class="ui inverted blue button left floated " href="/Register.aspx">立即加入拍粉</a>--%>
            <%--<a class="ui inverted blue button right floated" href="/Admin_Register.aspx">立即註冊網記</a>--%>
            <a class="ui inverted blue button right floated" href="/Admin_SimplifyRegister.aspx">快速註冊網記</a>
          </div>
        </div>
      </div>

      <div class="blue column">
        <div class="ui basic segment">
          <%--<div id="find-password" class="ui form">
            <h2>忘記密碼</h2>
            <div class="field">
              <label>會員帳號(Email)</label>
              
            </div>
          </div>--%>
          <div id="login-form" class="ui form">
            <h2>登入網記</h2>
            <div class="field">
              <label>會員帳號(Email)</label>
              <asp:TextBox ID="Account" TextMode="Email" CssClass="ui transparent inverted input" placeholder="account" runat="server"></asp:TextBox>
            </div>
            <div class="pwd field">
              <label>密碼</label>
              <asp:TextBox ID="Password" TextMode="Password" CssClass="ui transparent inverted input" placeholder="password" runat="server"></asp:TextBox>
            </div>
            <div class="field">
              <div class="ui mini action input">
                <input id="vali" type="text" class="ui transparent inverted input" maxlength="4" placeholder="驗證碼">
                <canvas id="NumValidate" class="dimmable" width="90" height="40" style="border: 1px solid #fff;"></canvas>
                <%--<div class="ui active dimmer">
                  <div class="ui indeterminate text loader"></div>
                </div>--%>
                <div class="ui icon yellow button" onclick="genValidate()"><i class="sync alternate icon"></i></div>
              </div>
            </div>
            <div class="fields">
              <div class="sixteen wide field" style="margin: 0;">
                <a class="ui inverted yellow button left floated" onclick="ForgotPwd(this)" href="#">忘記密碼</a>
                <asp:LinkButton ID="Send_Contact" CssClass="ui inverted yellow button login submit right floated" OnClientClick="javascript: return $('.ui.form').form('is valid');" OnClick="Send_Contact_Click" runat="server">送出</asp:LinkButton>
                <asp:LinkButton ID="Send_Email" CssClass="ui right floated fpwd submit inverted yellow hidden button" OnClientClick="javascript: return $('.ui.form').form('is valid');" OnClick="Send_Email_Click" runat="server">寄送密碼信</asp:LinkButton>
                <%--<asp:Button ID="Send_Email" CssClass="ui right floated fpwd submit inverted yellow hidden button" OnClick="Send_Email_Click" runat="server" Text="寄送密碼信" />--%>
                <%--<asp:Button ID="Send_Contact" CssClass="ui inverted yellow button login submit right floated" OnClientClick="javascript: return $('.ui.form').form('validate form')" OnClick="Send_Contact_Click" runat="server" Text="送出" />--%>
              </div>
            </div>
            <div class="ui error message"></div>
          </div>
        </div>
      </div>
      <%--</div>--%>
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

  <script>
    $("#NumValidate").dimmer({
      displayLoader: true,
      loaderVariation: 'slow mini text',
      loaderText: 'Loading'
    }).dimmer('show')
    function ForgotPwd(k) {
      console.log($(k))
      if ($(k).html() == '忘記密碼') {
        $('#<%= Send_Contact.ClientID %>').addClass('hidden')
        $('#<%= Send_Email.ClientID %>').removeClass('hidden')
        $('#login-form .pwd').addClass('hidden')
        $('#main #login-form').form('destroy')
        genPwdVali()
        $(k).html('切換登入')
      } else {

        $('#<%= Send_Contact.ClientID %>').removeClass('hidden')
        $('#<%= Send_Email.ClientID %>').addClass('hidden')
        $('#login-form .pwd').removeClass('hidden')
        $('#main #login-form').form('destroy')
        genValidate()
        $(k).html('忘記密碼')
      }

    }

    function genPwdVali() {
      var canvas = document.getElementById("NumValidate");
      var ctx = canvas.getContext("2d");

      ctx.beginPath();
      ctx.rect(0, 0, 90, 40);
      ctx.fillStyle = "white";
      ctx.fill();
      var str = Math.floor(Math.random() * 10000);
      str = ("000" + str.toString()).slice(-4);
      console.log(str)

      $("#NumValidate").dimmer('hide')

      for (i = 0; i < str.length; i++) {
        ctx.save();
        ctx.font = "30px Arial";
        ctx.rotate((Math.PI / 180) * Math.random() * 10 * (Math.random() > 0.5 ? 1 : -1));
        ctx.strokeText(str.substring(i, i + 1), 10 + 18 * i, 30);
        ctx.restore();
      }

      $('#main #login-form').form({
        on: 'blur',
        preventLeaving: true,
        fields: {
          account: {
            identifier: '<%= Account.ClientID %>',
            rules: [{
              type: 'empty',
              prompt: '請輸入帳號'
            },
            {
              type: 'email',
              prompt: '請輸入有效的E-mail'
            },
            {
              type: 'regExp',
              value: /^(?=[^.\-_])\w\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z]+$/g,
              prompt: '請輸入有效的E-mail'
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
        }, selector: {
          submit: '.fpwd.submit'
        }
        ,
        onSuccess: function (ev, fields) {
          console.log('ok')
          __doPostBack('<%= Send_Email.UniqueID %>', '')
            <%--$('#<%= Send_Email.ClientID %>').click();--%>
          return true;
        }
      })
        <%--.submit(function (e) {
        e.preventDefault()
        if ($('#main #login-form').form('is valid'))
        $('#<%= Send_Email.ClientID %>').click();
      });--%>
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

      $('#main #login-form').form({
        fields: {
          account: {
            identifier: '<%= Account.ClientID %>',
            rules: [{
              type: 'empty',
              prompt: '請輸入帳號'
            },
            {
              type: 'email',
              prompt: '請輸入有效的E-mail'
            },
            {
              type: 'regExp',
              value: /^(?=[^.\-_])\w\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z]+$/g,
              prompt: '請輸入有效的E-mail'
            }]
          },
          password: {
            identifier: '<%= Password.ClientID %>',
            rules: [{
              type: 'empty',
              prompt: '密碼不可爲空'
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
        ,
        on: 'blur',
        selector: {
          submit: '.login.submit'
        },
        onFailure: function (err, fields) {
          console.log('err')
          return false;
        }
        , onSuccess: function (ev, fields) {
          console.log('ok')
          __doPostBack('<%= Send_Contact.UniqueID %>', '')
            /*$().click()*/;
          return true;
        }
      })
<%--        .submit(function (e) {
        console.log('s ok')
        if ($('#main #login-form').form('is valid'))
        $('#<%= Send_Contact.ClientID %>').click();
      })--%>
    }

    $(window).on('load', function () {
      genValidate()
    })
  </script>
</asp:Content>
