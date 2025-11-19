<%@ Page Title="" Language="C#" MasterPageFile="ClientPage.Master" AutoEventWireup="true" CodeFile="TestAdmin_Register.aspx.cs" Inherits="piNews.TestAdmin_Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
      #main {
        background-color: #e6a732 !important;
      }

      .ui.selection.dropdown {
        padding: .62em 1em !important;
      }

      select.ui.dropdown {
        height: auto !important;
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
            <a class="section" href="/Home">首頁</a>
            <div class="divider">/ </div>
            <a class="section" href="/Login">拍粉/網記登入</a>
            <div class="divider">/ </div>
            <div class="active section">網記註冊</div>
          </div>
        </div>
      </div>
    </div>

  <div id="main" class="ui secondary container segment">

    <h2>註冊網記&nbsp;&nbsp;(<i class="red pencil alternate icon"></i>為必填)</h2>
    <div class="ui yellow form">
      <div class="two fields">
        <div class="field">
          <label>會員帳號(Email)&nbsp;&nbsp;<i class="red pencil alternate icon"></i></label>
          <%--<input type="email" placeholder="account">--%>
          <asp:TextBox ID="acc_TB" TextMode="Email" CssClass="byte-chk" runat="server" MaxLength="100" placeholder="account"></asp:TextBox>
        </div>
        <div class="field">
          <label>
            網記使用名稱
              <span style="color: #257fa4;">限填中文8個字內&nbsp;&nbsp;<i class="red pencil alternate icon"></i></span>
          </label>
          <%--<input type="text" placeholder="name">--%>
          <asp:TextBox ID="pinews_name" runat="server" CssClass="byte-chk" MaxLength="20" placeholder="pinews name"></asp:TextBox>
        </div>
      </div>

      <div class="two fields">
        <div class="field">
          <label>密碼&nbsp;&nbsp;<i class="red pencil alternate icon"></i></label>
          <%--<input type="password" placeholder="password">--%>
          <asp:TextBox ID="pwd_TB" TextMode="Password" minlength="8" MaxLength="100" runat="server"
            placeholder="password"></asp:TextBox>
        </div>
        <div class="field">
          <label>確認密碼&nbsp;&nbsp;<i class="red pencil alternate icon"></i></label>
          <%--<input type="password" placeholder="confirm password">--%>
          <asp:TextBox ID="cfmPwd_TB" TextMode="Password" runat="server" placeholder="confirm password">
          </asp:TextBox>
        </div>
      </div>

      <div class="two fields">
        <div class="field">
          <label>申請網記類別&nbsp;&nbsp;<i class="red pencil alternate icon"></i></label>
          <%--<input type="text" placeholder="name">--%>
          <select id="pinews_class" class="ui selection dropdown" runat="server">
            <option value="">pinews class</option>
            <%--<option value="1">網記會員 : 年費10000元</option>--%>
            <option value="2">網記主任 : 年費16000元</option>
          </select>
        </div>
        <div class="field">
          <label>
            平台引薦人ID
              <span style="color: #257fa4;">沒有則填無&nbsp;&nbsp;<i class="red pencil alternate icon"></i></span>
          </label>
          <div class="ui search selection dropdown">
            <%--<asp:HiddenField ID="HiddenField1" runat="server" />--%>
            <asp:HiddenField ID="platform_referrer" runat="server"></asp:HiddenField>
            <div class="default text">platform referrer</div>
            <i class="dropdown icon"></i>
          </div>
        </div>
      </div>

      <div class="two fields">
        <div class="field">
          <label>真實姓名&nbsp;&nbsp;<i class="red pencil alternate icon"></i></label>
          <%--<input type="email" placeholder="account">--%>

          <asp:TextBox ID="name_TB" runat="server" CssClass="byte-chk" MaxLength="100" placeholder="account"></asp:TextBox>
        </div>

        <div class="field">
          <label>身份證字號&nbsp;&nbsp;<i class="red pencil alternate icon"></i></label>
          <div class="two fields">
            <%--<input type="text" placeholder="name">--%>
            <div class="six wide field">
              <select id="id_card" class="ui selection dropdown" runat="server">
                <option value="">card class</option>
                <option value="1">身份證</option>
                <option value="2">護照(尚未開放)</option>
              </select>
            </div>
            <div class="ten wide field">
              <asp:TextBox ID="id_number" runat="server" MaxLength="10" placeholder="id number"></asp:TextBox>
            </div>
          </div>
        </div>
      </div>

      <div class="two fields">
        <div class="field">
          <label>性別</label>
          <select id="gender" class="ui selection dropdown" runat="server">
            <option value="">gender</option>
            <option value="1">男</option>
            <option value="2">女</option>
          </select>
        </div>
        <div class="field">
          <label>出生日期&nbsp;&nbsp;<i class="red pencil alternate icon"></i></label>
          <asp:TextBox ID="birthday" TextMode="Date" runat="server"></asp:TextBox>
        </div>
      </div>

      <div class="two fields">
        <div class="field">
          <label>聯絡電話&nbsp;&nbsp;<i class="red pencil alternate icon"></i></label>
          <asp:TextBox ID="tel_TB" TextMode="Phone" runat="server" CssClass="byte-chk" MaxLength="10" placeholder="phone"></asp:TextBox>
        </div>
        <div class="field">
          <label>職業性質</label>
          <asp:TextBox ID="job" runat="server" CssClass="byte-chk" MaxLength="30" placeholder="job description"></asp:TextBox>
        </div>
      </div>

      <div class="field">
        <label>地址&nbsp;&nbsp;<i class="red pencil alternate icon"></i></label>
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

      <div class="two fields">
        <div class="field">
          <label>
            銀行戶名
              <span style="color: #257fa4;">完成填寫後請再次確認</span>
          </label>
          <asp:TextBox ID="Bank_username" runat="server" CssClass="byte-chk" MaxLength="30" placeholder="Bank account name"></asp:TextBox>
        </div>
        <div class="field">
          <label>
            銀行名稱/代碼
              <span style="color: #257fa4;">完成填寫後請再次確認</span>
          </label>
          <asp:TextBox ID="Bank_name" runat="server" CssClass="byte-chk" MaxLength="30" placeholder="Bank name/code"></asp:TextBox>
        </div>
      </div>

      <div class="two fields">
        <div class="field">
          <label>
            分行名稱
              <span style="color: #257fa4;">完成填寫後請再次確認</span>
          </label>
          <asp:TextBox ID="Bank_branch" runat="server" CssClass="byte-chk" MaxLength="30" placeholder="Bank branch"></asp:TextBox>
        </div>
        <div class="field">
          <label>
            銀行帳號
              <span style="color: #257fa4;">完成填寫後請再次確認</span>
          </label>
          <asp:TextBox ID="Bank_usernum" runat="server" CssClass="byte-chk" MaxLength="30" placeholder="Bank account"></asp:TextBox>
        </div>
      </div>


      <div class="field">
        <div class="two fields">
          <div class="field">

            <div class="two fields">
              <div class="field">
                <label>上傳證件(國民身分證正面)</label>
                <asp:FileUpload ID="id_number_img_front" runat="server" accept="image/*" />
              </div>
              <div class="field">
                <label>上傳證件(國民身分證反面)</label>
                <asp:FileUpload ID="id_number_img_Negative" runat="server" accept="image/*" />
              </div>
            </div>

          </div>
          <div class="field">
            <label>請輸入驗證碼&nbsp;&nbsp;<i class="red pencil alternate icon"></i></label>
            <div class="ui action input">
              <input id="vali" type="text" placeholder="驗證碼" maxlength="4" />
              <canvas id="NumValidate" width="90" height="40" style="border: 1px solid #d3d3d3;"></canvas>
              <button type="button" class="ui icon button" onclick="genValidate()">
                <i
                  class="sync alternate icon"></i>
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="field">
        <div class="two fields">
          <div class="eight wide field">
            <div class="ui checkbox">
              <input type="checkbox" id="rule1">
              <label style="padding-left: 1.85714em;">
                我已閱讀並同意<a href='http://www.pinews.asia/Regulations1.aspx'
                  style="color: #257fa4;" target='_blank'> PiNews拍新聞 系統服務條例、自律公約暨各項準則規範</a>&nbsp;&nbsp;<i class="red pencil alternate icon"></i></label>
            </div>
            <div class="ui checkbox">
              <input type="checkbox" id="rule2">
              <label style="padding-left: 1.85714em;">
                我已閱讀並同意<a href='http://www.pinews.asia/Regulations2.aspx'
                  style="color: #257fa4;" target='_blank'> PiNews拍新聞 蒐集個資告知事項暨隱私權政策同意書</a>&nbsp;&nbsp;<i class="red pencil alternate icon"></i></label>
            </div>
          </div>

          <div class="eight wide field">
            <asp:Button ID="register_Btn" CssClass="ui blue button" Style="float: right; margin-top: 10px;"
              runat="server" OnClientClick="javascript: loading(); return checkall();"
              OnClick="only_register_Btn_Click" Text="送出並註冊" />
            <asp:Button ID="register_pay_Btn" CssClass="ui blue button" Style="float: right; margin-top: 10px;"
              runat="server" OnClientClick="javascript: loading(); return checkall();"
              OnClick="Admin_register_Btn_Click" Text="註冊並付費" />
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
    <script src="js/main.js"></script>

  <%-- Bankusername: { identifier: '<%= Bank_username.ClientID %>' , rules: [{ type: 'empty' , prompt: '請輸入銀行戶名' }] },
      Bankname: { identifier: '<%= Bank_name.ClientID %>' , rules: [{ type: 'empty' , prompt: '請輸入銀行名稱/代號' }] },
      Bankbranch: { identifier: '<%= Bank_branch.ClientID %>' , rules: [{ type: 'empty' , prompt: '請輸入分行名稱' }] },
      Bankusernum: { identifier: '<%= Bank_usernum.ClientID %>' , rules: [{ type: 'empty' , prompt: '請輸入銀行帳號' }] }, 
              
                  idcardphoto: {
                    identifier: '<%= id_number_img_front.ClientID %>',
                    rules: [{
                      type: 'empty',
                      prompt: '請選擇身份證正面圖片檔案'
                    }]
                  },
                  idcardphoto2: {
                    identifier: '<%= id_number_img_Negative.ClientID %>',
                    rules: [{
                      type: 'empty',
                      prompt: '請選擇身份證反面圖片檔案'
                    }]
                  },
                  gender: {
                    identifier: '<%= gender.ClientID %>',
                    rules: [{
                      type: 'empty',
                      prompt: '請點選性別'
                    }]
                  },
                  job: {
                    identifier: '<%= job.ClientID %>',
                    rules: [{
                      type: 'empty',
                      prompt: '請輸入職業性質'
                    }]
                  },

      --%>


  <script>
    $('.ui.search.dropdown:has(#<%= platform_referrer.ClientID %>)').dropdown({
          apiSettings: {
              url: '/RID/Search/{query}'
          }, minCharacters: 1
    });

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
                  pinewsname: {
                    identifier: '<%= pinews_name.ClientID %>',
                    rules: [{
                      type: 'empty',
                      prompt: '請輸入網記名稱'
                    },
                    {
                      type: 'maxLength',
                      value: '8',
                      prompt: '請輸入8位以下中文字'
                    },
                    {
                      type: 'regExp',
                      value: /[\u4E00-\u9FFF]/g,
                      prompt: '網記名稱只限中文字'
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
                    }
                      ,
                      {
                        type: 'empty',
                        prompt: '確認密碼不可爲空'
                      }
                    ]
                  },
                  pinewsclass: {
                    identifier: '<%= pinews_class.ClientID %>',
                    rules: [{
                      type: 'empty',
                      prompt: '請點選網記類別'
                    }]
                  },
                  platformreferrer: {
                    identifier: '<%= platform_referrer.ClientID %>',
                    rules: [{
                      type: 'empty',
                      prompt: '請輸入引薦人'
                    }]
                  },
                  name: {
                    identifier: '<%= name_TB.ClientID %>',
                    rules: [{
                      type: 'empty',
                      prompt: '請輸入姓名'
                    }]
                  },
                  idnumberclass: {
                    identifier: '<%= id_card.ClientID %>',
                    rules: [{
                      type: 'empty',
                      prompt: '請點選證件類別'
                    }]
                  },
                  idnumber: {
                    identifier: '<%= id_number.ClientID %>',
                    rules: [{
                      type: 'empty',
                      prompt: '請輸入身份證字號'
                    },
                    {
                      type: 'regExp',
                      value: /^[A-Z]{1}[1-2]{1}[0-9]{8}$/g,
                      prompt: '請輸入正確的身份證字號格式'
                    }]
                  },
                  birthday: {
                    identifier: '<%= birthday.ClientID %>',
                    rules: [{
                      type: 'empty',
                      prompt: '請輸入生日'
                    }]
                  },
                  phone: {
                    identifier: '<%= tel_TB.ClientID %>',
                    rules: [{
                      type: 'empty',
                      prompt: '請輸入電話'
                    },
                    {
                      type: 'regExp',
                      value: /^[0-9]{10}$/g,
                      prompt: '請輸入正確的電話格式'
                    }
                    ]
                  },
                  validateCode: {
                    identifier: 'vali',
                    rules: [{
                      type: 'regExp',
                      value: RegExp(str, "i"),
                      prompt: '請輸入驗證碼'
                    }]
                  },
                  rulecheckbox1: {
                    identifier: 'rule1',
                    rules: [{
                      type: 'empty',
                      prompt: '請同意條例、規範'
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
                  rulecheckbox2: {
                    identifier: 'rule2',
                    rules: [{
                      type: 'empty',
                      prompt: '請同意隱私權政策'
                    }]
                  }
                }
              })
    }

    function verifyId() {
          var idnum = document.getElementById('<%= id_number.ClientID %>').value;
      id = idnum.trim();


      verification = id.match("^[A-Z][12]\\d{8}$")
      if (!verification) {
        return false
      }
      let conver = "ABCDEFGHJKLMNPQRSTUVXYWZIO"
      let weights = [1, 9, 8, 7, 6, 5, 4, 3, 2, 1, 1]
      id = String(conver.indexOf(id[0]) + 10) + id.slice(1);
      checkSum = 0
      for (let i = 0; i < id.length; i++) {
        c = parseInt(id[i])
        w = weights[i]
        checkSum += c * w
      }
      return checkSum % 10 == 0
    }

    function checkall() {
      if (!verifyId()) {
        console.log('national id error')
            $('#<%= id_number.ClientID %>').parent('.field').addClass('error')
            $('.ui.form').form('add errors', { account: '身分證輸入錯誤，請再次確認!' });
        }
        return $('.ui.form').form('validate form') && verifyId();
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

    function loading() {
      if ($('.ui.form').form('validate form') && verifyId()) {
        $('.dimmer')
          .dimmer({
            closable: false
          })
          .dimmer('show');
      }
    };

    $(window).on('load', function () {
      genValidate();
      $(".user-addr").twzipcode({
        //css: ['six wide field', 'six wide field', 'four wide field'],
        readonly: true,
      });
      $("[data-role]").children().on('change', function () {
        $('#<%= county_HF.ClientID %>').val($(".user-addr").twzipcode('get', 'county'));
            $('#<%= district_HF.ClientID %>').val($(".user-addr").twzipcode('get', 'district'));
            $('#<%= zipcode_HF.ClientID %>').val($(".user-addr").twzipcode('get', 'zipcode'));
          });
        })
  </script>
</asp:Content>
