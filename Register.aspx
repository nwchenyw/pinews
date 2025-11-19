<%@ Page Title="" Language="C#" MasterPageFile="ClientPage.Master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="piNews.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <style>
    #main {
      background-color: #e6a732 !important;
    }
  </style>
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
          <a class="section" href="Login.aspx">拍粉/網記登入</a>
          <div class="divider">/ </div>
          <div class="active section">拍粉註冊</div>
        </div>
      </div>
    </div>
  </div>

  <div id="main" class="ui secondary container segment">

    <h2>註冊拍粉</h2>
    <div class="ui yellow form">
      <div class="two fields">
        <div class="field">
          <label>會員帳號(Email)</label>
          <%--<input type="email" placeholder="account">--%>
          <asp:TextBox ID="acc_TB" TextMode="Email" CssClass="byte-chk" MaxLength="100" runat="server" placeholder="account"></asp:TextBox>
        </div>
        <div class="field">
          <div class="two fields">
            <div class="eight wide field">
              <label>
                姓名
              <span style="color: #257fa4;">請填寫真實姓名</span>
              </label>
              <%--<input type="text" placeholder="name">--%>
              <asp:TextBox ID="name_TB" runat="server" CssClass="byte-chk" MaxLength="100" placeholder="name"></asp:TextBox>
            </div>
            <div class="eight wide field">
              <label>
                暱稱
              <span style="color: #257fa4;">可顯示於文章刊登處</span>
              </label>
              <%--<input type="text" placeholder="name">--%>
              <asp:TextBox ID="pinews_name" runat="server" CssClass="byte-chk" MaxLength="20" placeholder="pinews name"></asp:TextBox>
            </div>
          </div>
        </div>
      </div>

      <div class="two fields">
        <div class="field">
          <label>密碼</label>
          <%--<input type="password" placeholder="password">--%>
          <asp:TextBox ID="pwd_TB" TextMode="Password" minlength="8" MaxLength="100" runat="server" placeholder="password"></asp:TextBox>
        </div>
        <div class="field">
          <label>確認密碼</label>
          <%--<input type="password" placeholder="confirm password">--%>
          <asp:TextBox ID="cfmPwd_TB" TextMode="Password" runat="server" placeholder="confirm password"></asp:TextBox>
        </div>
      </div>

      <div class="field">
        <label>地址</label>
        <div class="two fields">
          <div class="field">
            <asp:HiddenField ID="county_HF" runat="server" />
            <asp:HiddenField ID="district_HF" runat="server" />
            <asp:HiddenField ID="zipcode_HF" runat="server" />
            <div class="user-addr fields">
              <div data-role="county" class="six wide field"></div>
              <div data-role="district" class="six wide field"></div>
              <div data-role="zipcode" class="four wide field" style="display: flex;"></div>
            </div>
          </div>
          <div class="field">
            <%--<input type="text" placeholder="address">--%>
            <asp:TextBox ID="addr_TB" runat="server" CssClass="byte-chk" MaxLength="200" placeholder="address"></asp:TextBox>
          </div>
        </div>
      </div>

      <div class="field">
        <div class="two fields">
          <div class="field">
        <label>聯絡電話</label>
            <asp:TextBox ID="tel_TB" TextMode="Phone" CssClass="byte-chk" MaxLength="10" runat="server"></asp:TextBox>
          </div>
          <div class="field">
            <label>請輸入驗證碼</label>
            <div class="ui action input">
              <input id="vali" type="text" placeholder="驗證碼">
              <canvas id="NumValidate" width="90" height="40" style="border: 1px solid #d3d3d3;"></canvas>
              <button type="button" class="ui icon button" onclick="genValidate()"><i class="sync alternate icon"></i></button>
            </div>
          </div>
        </div>
      </div>

      <div class="field">
        <div class="two fields">
          <div class="eight wide field">
            <div class="ui checkbox">
              <input type="checkbox" id="rule">
              <label for="rule" style="padding: 0 0 5px; padding-left: 1.85714em;">我已閱讀並同意<a href='http://www.pinews.asia/Regulations1.aspx' style="color: #257fa4;" target='_blank'> PiNews拍新聞 系統服務條例、自律公約暨各項準則規範</a></label>
            </div>
          </div>
          <div class="eight wide field">
            <asp:Button ID="register_Btn" CssClass="ui blue button" Style="float: right;" runat="server" OnClientClick="javascript: return $('.ui.form').form('validate form')" OnClick="register_Btn_Click" Text="註冊" />
          </div>
        </div>
      </div>



      <div class="ui error message"></div>
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

  <script src="https://cdn.jsdelivr.net/npm/jquery-twzipcode@1.7.15-rc1/jquery.twzipcode.min.js"></script>
  <%--<script src="js/main.js"></script>--%>
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

    $('.ui.form .byte-chk').on('input', function () {
      var $el = $(this);
      var max_cnt = $el.attr('maxlength');
      var cnt = stringBytes($el.val());
      console.log(cnt);
      if (cnt >= max_cnt) {
        console.log('overflow')
        var i = Math.ceil((cnt - max_cnt) / 2);
        console.log(i)
        while (stringBytes($el.val()) > max_cnt) {
          if (cnt - stringBytes($el.val().slice(-i)) <= max_cnt) {
            $el.val($el.val().slice(0, -i))
          } i++;
        }
      }
    })

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
          account: {
            identifier: '<%= acc_TB.ClientID %>',
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
          name: {
            identifier: '<%= name_TB.ClientID %>',
            rules: [{
              type: 'empty',
              prompt: '請輸入姓名'
            }]
          },
          pinewsname: {
            identifier: '<%= pinews_name.ClientID %>',
            rules: [{
              type: 'empty',
              prompt: '請輸入暱稱'
            }]
          },
          password: {
            identifier: '<%= pwd_TB.ClientID %>',
            rules: [{
              type: 'empty',
              prompt: '密碼不可爲空'
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
            identifier: '<%= cfmPwd_TB.ClientID %>',
            rules: [{
              type: 'match[<%= pwd_TB.ClientID %>]',
              prompt: '確認密碼有誤'
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
            identifier: '<%= addr_TB.ClientID %>',
            rules: [{
              type: 'empty',
              prompt: '請輸入地址'
            }]
          },
          phone: {
            identifier: '<%= tel_TB.ClientID %>',
            rules: [{
              type: 'empty',
              prompt: '請輸入電話'
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
          rulecheckbox: {
            identifier: 'rule',
            rules: [{
              type: 'empty',
              prompt: '請同意條例、規範'
            }]
          }
        }
      })
    }

    $(window).on('load', function () {
      genValidate()
      $(".user-addr").twzipcode({
        //css: ['six wide field', 'six wide field', 'four wide field'],
        readonly: true,
      });
      $("[data-role]").children().on('change', function () {
        $('#<%= county_HF.ClientID %>').val($(".user-addr").twzipcode('get', 'county'));
        $('#<%= district_HF.ClientID %>').val($(".user-addr").twzipcode('get', 'district'));
        $('#<%= zipcode_HF.ClientID %>').val($(".user-addr").twzipcode('get', 'zipcode'));
      })


    })
  </script>
</asp:Content>
