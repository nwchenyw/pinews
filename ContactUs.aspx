<%@ Page Title="" Language="C#" MasterPageFile="ClientPage.Master" AutoEventWireup="true" CodeFile="ContactUs.aspx.cs" Inherits="piNews.ContactUs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <style>
    .ui.form .ui.transparent.inverted.input {
      border-bottom: 1px solid rgba(255,255,255,.5) !important;
    }

      .ui.form .ui.transparent.inverted.input:not(#vali) {
        border-radius: 0 !important;
      }

    .ui.transparent.inverted.input::placeholder {
      color: rgba(255,255,255,.5);
    }

    .ui.form .ui.transparent.inverted.input:active, .ui.form .ui.transparent.inverted.input:focus {
      border-bottom: 1px solid rgba(255,255,255,.8) !important;
      color: #257fa4;
      font-weight: bold;
    }

    .ui.transparent.inverted.input:active::placeholder, .ui.transparent.inverted.input:focus::placeholder {
      color: rgba(255,255,255,.8);
    }

    #vali {
      border: 1px solid rgba(255,255,255,.5) !important;
    }

      #vali::placeholder {
        color: rgba(255,255,255,.5);
      }

      #vali:active, #vali:focus {
        border: 1px solid rgba(255,255,255,.8) !important;
      }

        #vali:active::placeholder, #vali:focus::placeholder {
          color: rgba(255,255,255,.8);
        }

    @media screen and (min-width: 991px) {
      #fm1, #fm2, #fm3 {
        font-size: 1.45em !important;
      }
    }

    @media screen and (max-width: 767px) {
      #fm1, #fm2, #fm3 {
        font-size: 1.5em !important;
      }
    }

    .ui.list .item .primary.header {
      color: #e6a732;
      font-size: 2em;
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
          <div class="active section">聯絡我們</div>
        </div>
      </div>
    </div>
  </div>

  <div id="main" class="ui placeholder container blue inverted fitted segment" style="overflow: auto;">
    <div class="ui stackable padded grid">
      <div class="ui eleven vertical divider">Or</div>
      <div class="middle aligned row" style="padding: 0;">
        <div class="eleven wide yellow column" style="padding-top: 1rem; padding-bottom: 1rem;">
          <div class="ui icon header" style="margin: 0;">
            聯絡我們
          </div>
          <div class="content">
            <div class="ui padded form">
              <div class="fields">
                <div class="five wide field">
                  <label>姓名</label>
                  <asp:TextBox ID="name" CssClass="ui transparent inverted input" runat="server" placeholder="Name"></asp:TextBox>
                </div>
                <div class="six wide field">
                  <label>Email</label>
                  <asp:TextBox ID="mail" runat="server" CssClass="ui transparent inverted input" placeholder="Email"></asp:TextBox>
                </div>
                <div class="five wide field">
                  <label>電話</label>
                  <asp:TextBox ID="phone" runat="server" CssClass="ui transparent inverted input" placeholder="Phone"></asp:TextBox>
                </div>
              </div>
              <div class="field">
                <label>留言</label>
                <textarea id="messsage" placeholder="Message" class="ui transparent inverted input" runat="server"></textarea>
                <input type="text" class="hidden" id="test-view" />
              </div>
              <div class="fields" style="margin-bottom: 0;">
                <div class="eight wide flex field">
                  <div class="ui action input">
                    <input id="vali" type="text" class="ui transparent inverted input" maxlength="4" placeholder="驗證碼">
                    <canvas id="NumValidate" width="90" height="40" style="border: 1px solid #fff;"></canvas>
                    <button type="button" class="ui icon blue button" onclick="genValidate()">
                      <i
                        class="sync alternate icon"></i>
                    </button>
                  </div>
                </div>
                <div class="eight wide field" style="margin: 0;">
                  <asp:Button ID="send_contact" CssClass="ui right floated blue button" runat="server" OnClientClick="javascript: return $('.ui.form').form('validate form')" OnClick="ContactUs_Btn_Click" Text="送出" />
                </div>
              </div>
              <div class="ui error message"></div>
            </div>
          </div>
        </div>
        <div class="five wide column">
          <div class="ui ph-2 list">
            <div class="item">
              <i class="bullseye icon" style="color: #e6a732;"></i>
              <div class="content">
                <h3 class="ui primary header">服務據點</h3>
                <div id="fm1">
                  全國
                </div>
              </div>
            </div>
            <div class="item">
              <i class="bullseye icon" style="color: #e6a732;"></i>
              <div class="content">
                <h3 class="ui primary header">聯絡信箱</h3>
                <div id="fm2">
                  Pinews.tw@gmail.com
                </div>
              </div>
            </div>
            <div class="item">
              <i class="bullseye icon" style="color: #e6a732;"></i>
              <div class="content">
                <h3 class="ui primary header">客服專線</h3>
                <div id="fm3">
                  0976-129791
                </div>
              </div>
            </div>
          </div>
        </div>
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
      <div class="ui olive deny button">確認</div>
    </div>
  </div>
  <%--<script src="https://www.google.com/recaptcha/api.js?render=6LepWx8cAAAAACr5ZaFhT6aC5ArMXQAbxPQo2VuY"></script>--%>
  <script src="js/main.js"></script>
  <script>

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
            identifier: '<%= name.ClientID %>',
              rules: [{
                type: 'empty',
                prompt: '請輸入姓名'
              }]
            },
            account: {
              identifier: '<%= mail.ClientID %>',
              rules: [{
                type: 'empty',
                prompt: '請輸入帳號'
              },
              {
                type: 'regExp',
                value: /^(?=[^.\-_])\w\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z]+$/g,
                prompt: '請輸入有效的E-mail'
              }]
            },
            phone: {
              identifier: '<%= phone.ClientID %>',
              rules: [{
                type: 'empty',
                prompt: '請輸入電話'
              }]
            },
            messsage: {
              identifier: '<%= messsage.ClientID %>',
              rules: [{
                type: 'empty',
                prompt: '請輸入訊息內容'
              }]
            },
            validateCode: {
              identifier: 'vali',
              rules: [{
                type: 'regExp',
                value: RegExp(str, "i"),
                prompt: '請輸入驗證碼'
              }]
          },
          field: {
            identifier: 'test-view',
            rules: [{
              type: 'regExp',
              value: '^$',
              prompt: ':)))'
            }]
          }

          }
        })

    }

    $(window).on('load', function () {
      genValidate()
    })


  </script>
</asp:Content>
