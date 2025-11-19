<%@ Page Title="" Language="C#" MasterPageFile="AdminPage.Master" AutoEventWireup="true" CodeFile="testMember.aspx.cs" Inherits="piNews.testMember" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <div class="ui inverted segment">
    <div class="ui inverted breadcrumb">
      <a class="section">Home</a>
      <div class="divider">/ </div>
      <div class="active section">會員中心</div>
    </div>
  </div>
  <div class="ui segment">
    <div class="column ui text container">
      <h2>會員資料</h2>
      <div class="ui divider" style="border-color: #257fa4"></div>
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
          <div class="twelve wide field" style="display: table;">
            <div class="field" style="display: table-row; vertical-align: middle;">
              <label>
                會員帳號(Email)&nbsp;&nbsp;<span id="Certify" class="ui ml-2 image mini label" style="background:red; color:white !important; opacity: 1;"><i class="exclamation triangle icon"></i>未認證
                  <asp:LinkButton ID="SendCertifyMail" CssClass="detail" OnClick="SendCertifyMail_Click" runat="server" style="background:#257fa4; color:white !important; opacity: 1;">補寄認證信</asp:LinkButton>
                </span>
              </label>
              <div class="ui input">
                <input id="email" type="email" class="ui disabled input" value='<%= Session["Email"] %>' readonly>               
              </div>
            </div>
            <div class="field" style="display: table-row; vertical-align: middle;">
              <label>
                會員簡介(Intro)
              </label>
              <div class="ui input">
                <asp:TextBox ID="Intro_DTB" runat="server" CssClass="ui disabled input" TextMode="MultiLine" placeholder="簡介" Text='<%# Eval("Intro") %>' Enabled="false"></asp:TextBox>
              </div>
            </div>
          </div>
        </div>
        <div class="two fields">
          <div class="field">
            <label>姓名</label>
            <input id="username" runat="server" type="text" class="ui disabled input" placeholder="name" readonly>
          </div>
          <div class="field">
            <label id="pinews_name" runat="server"></label>
            <input id="nickname" runat="server" type="text" class="ui disabled input" placeholder="name" readonly>
          </div>
        </div>

        <div id="IsAdmin_area" runat="server">
          <div class="two fields">		  
            <div class="field" runat="server">						  
					<label>網紀類別&nbsp;&nbsp; <span id="pay_Certify" class="ui ml-2 image mini label" style="background:red; color:white !important; opacity: 1;"><i class="exclamation triangle icon"></i>未付款
							<asp:LinkButton ID="Pay_ment" CssClass="detail" OnClick="memberpay_Click" runat="server" style="background:#257fa4; color:white !important; opacity: 1;">我要付款</asp:LinkButton>
							</span>
					</label>
					<input id="pinews_class" runat="server" type="text" class="ui disabled input" readonly>									  
            </div>
			
            <div class="field" runat="server">			             
				    <label>專業效期&nbsp;&nbsp; <span id="paydate_Certify" class="ui ml-2 image mini label" style="background:red; color:white !important; opacity: 1;"><i class="exclamation triangle icon"></i>尚無效期</span>
					</label>
					<input id="pinews_date" runat="server" type="text" class="ui disabled input" placeholder="Date" readonly>				  
            </div>		
          </div>


          <div class="two fields">		  
            <div class="field">
			  <div class="two fields">
                <div class="eight wide field" runat="server">
				    <label>您的引薦人ID(需認證信箱)</label>
					<input id="pfr_id" runat="server" type="text" class="ui disabled input" readonly>
                </div>
				
                <div class="eight wide field" runat="server">
				    <label>平台引薦人</label>
					<input id="pfr" runat="server" type="text" class="ui disabled input" readonly>
                </div>
			  </div>	
            </div>
			
            <div class="field">			  
              <label>證件</label>
              <div class="two fields">
                <div class="six wide field" runat="server">
                  <input id="card_class" runat="server" type="text" class="ui disabled input" readonly>
                </div>
                <div class="ten wide field" runat="server">
                  <input id="id_number" runat="server" type="text" class="ui disabled input" readonly>
                </div>
              </div>	  
            </div>			
          </div>


          <div class="two fields">
		  
            <div class="field">
				<label>職業性質</label>
				<input id="job" runat="server" type="text" class="ui disabled input" placeholder="job description" readonly>
            </div>
			
            <div class="field">			  
			  <div class="two fields">			  
                <div class="eight wide field" runat="server">
					<label>性別</label>
					<input id="gender" runat="server" type="text" class="ui disabled input" readonly>
                </div>
				
                <div class="eight wide field" runat="server">
					<label>出生日期</label>
					<input id="birthday" runat="server" type="text" class="ui disabled input" readonly>
                </div>				
              </div>		  
            </div>
			
          </div>

          <div class="two fields">
            <div class="field">
              <label>銀行戶名</label>
              <input id="Bank_username" runat="server" type="text" class="ui disabled input" placeholder="Bank account name" readonly>
            </div>
            <div class="field">
              <label>銀行名稱/代碼</label>
              <input id="Bank_name" runat="server" type="text" class="ui disabled input" placeholder="Bank name/code" readonly>
            </div>
          </div>

          <div class="two fields">
            <div class="field">
              <label>分行名稱</label>
              <input id="Bank_branch" runat="server" type="text" class="ui disabled input" placeholder="Bank branch" readonly>
            </div>
            <div class="field">
              <label>銀行帳號</label>
              <input id="Bank_usernum" runat="server" type="text" class="ui disabled input" placeholder="Bank account" readonly>
            </div>
          </div>


          <h2>證件照片</h2>
          <div class="ui divider" style="border-color: #257fa4"></div>
          <div id="idcard_picture" class="ui form">
            <div class="field">
              <div class="ui medium centered image">
                <div class="square">
                  <asp:Image ID="idcard_fImage" CssClass="ui image" runat="server" />
                  <span class="no-img">No Image</span>
                </div>
                <div class="square">
                  <asp:Image ID="idcard_nImage" CssClass="ui image" runat="server" />
                  <span class="no-img">No Image</span>
                </div>
              </div>
            </div>
          </div>
        </div>


        <h2>修改會員資料</h2>
        <div class="ui divider" style="border-color: #257fa4"></div>

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
        <div class="field">
          <label>
            會員簡介(Intro)
          </label>
          <div class="ui input">
            <asp:TextBox ID="Intro_TB" runat="server" TextMode="MultiLine" placeholder="簡介" Text='<%# Eval("Intro") %>'></asp:TextBox>
            <span class="ui bottom right attached label">0/200</span>
          </div>
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
      <div class="ui divider" style="border-color: #257fa4"></div>
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
      <div class="ui divider" style="border-color: #257fa4"></div>
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
          <br />
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

    $('#<%= Intro_TB.ClientID %>').on('input', function () {
      var cnt = stringBytes($(this).val());
      console.log(cnt);
      if (cnt >= 200) {
        console.log('overflow')
        var i = Math.ceil((cnt - 200) / 2);
        console.log(i)
        while (stringBytes($(this).val()) > 200) {
          if (cnt - stringBytes($(this).val().slice(-i)) <= 200) {
            $(this).val($(this).val().slice(0, -i))
          } i++;
        }
        //$(this).attr('maxlength', $(this).val().length);
      }
      cnt = stringBytes($(this).val());
      $('#<%= Intro_TB.ClientID %> + .right.attached.label').html(cnt + '/200');
      if (cnt > 200) {
        $(this).parents('.field').addClass('error');
      } else {
        $(this).parents('.field').removeClass('error');
      }
    })
    var event = new Event('input', {
      'bubbles': true,
      'cancelable': true
    });

    document.getElementById('<%= Intro_TB.ClientID %>').dispatchEvent(event);
    $("input").trigger("select");

    $('#<%= Intro_TB.ClientID %>').children().on('change', function () {
      $('#<%= county_HF.ClientID %>').val($(".user-addr").twzipcode('get', 'county'));
      $('#<%= district_HF.ClientID %>').val($(".user-addr").twzipcode('get', 'district'));
      $('#<%= zipcode_HF.ClientID %>').val($(".user-addr").twzipcode('get', 'zipcode'));
    })

    $(window).on('load', function () {
      $('.image:has(.image[src=""])').css('background', 'lightblue');

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
