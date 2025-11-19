<%@ Page Title="" Language="C#" MasterPageFile="ClientPage.Master" AutoEventWireup="true"
  CodeFile="Admin_SimplifyRegister.aspx.cs" Inherits="piNews.Admin_Register" %>
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
					<asp:TextBox ID="acc_TB" TextMode="Email" CssClass="byte-chk" runat="server" MaxLength="100" placeholder="Email"></asp:TextBox>
				</div>

				<div class="field">
					<label>
						網記使用名稱
						<span style="color: #257fa4;">限填中文8個字內&nbsp;&nbsp;<i class="red pencil alternate icon"></i></span>
					</label>
					<asp:TextBox ID="pinews_name" runat="server" CssClass="byte-chk" MaxLength="20" placeholder="網記使用名稱"></asp:TextBox>
				</div>
			</div>

			<div class="two fields">
				<div class="field">
					<label>密碼&nbsp;&nbsp;<i class="red pencil alternate icon"></i></label>
					<%--<input type="password" placeholder="password">--%>
					<asp:TextBox ID="pwd_TB" TextMode="Password" minlength="8" MaxLength="100" runat="server" placeholder="輸入密碼"></asp:TextBox>
				</div>

				<div class="field">
					<label>確認密碼&nbsp;&nbsp;<i class="red pencil alternate icon"></i></label>
					<%--<input type="password" placeholder="confirm password">--%>
					<asp:TextBox ID="cfmPwd_TB" TextMode="Password" runat="server" placeholder="確認密碼">
					</asp:TextBox>
				</div>
			</div>

			<div class="two fields">
				<div class="field">
					<label>
						平台引薦人ID
						<span style="color: #257fa4;">沒有則填無&nbsp;&nbsp;<i class="red pencil alternate icon"></i></span>
					</label>
					<asp:TextBox ID="platform_referrer" runat="server" placeholder="推薦人"></asp:TextBox>
				</div>

				<div class="field">
					<label>聯絡電話&nbsp;&nbsp;<i class="red pencil alternate icon"></i></label>
					<asp:TextBox ID="tel_TB" TextMode="Phone" runat="server" CssClass="byte-chk" MaxLength="10" placeholder="聯絡電話"></asp:TextBox>
				</div>
			</div>

			<div class="two fields">

				<div class="field">
					<label>真實姓名&nbsp;&nbsp;<i class="red pencil alternate icon"></i></label>
					<asp:TextBox ID="name_TB" runat="server" CssClass="byte-chk" MaxLength="100" placeholder="真實姓名"></asp:TextBox>
				</div>

			</div>

			<div class="field">
				<label>請輸入驗證碼&nbsp;&nbsp;<i class="red pencil alternate icon"></i></label>
				<div class="ui action input">
					<input id="vali" type="text" placeholder="驗證碼" maxlength="4" />
					<canvas id="NumValidate" width="90" height="40" style="border: 1px solid #d3d3d3;"></canvas>
					<button type="button" class="ui icon button" onclick="genValidate()">
						<i class="sync alternate icon"></i>
					</button>
				</div>


				<div class="field">
					<div class="two fields">
						<div class="eight wide field">
							<div class="ui checkbox">
								<input type="checkbox" id="rule1">
								<label style="padding-left: 1.85714em;">
									我已閱讀並同意<a href='http://www.pinews.asia/Regulations1.aspx' style="color: #257fa4;" target='_blank'> PiNews拍新聞 系統服務條例、自律公約暨各項準則規範</a>&nbsp;&nbsp;<i class="red pencil alternate icon"></i></label>
							</div>
							<div class="ui checkbox">
								<input type="checkbox" id="rule2">
								<label style="padding-left: 1.85714em;">
									我已閱讀並同意<a href='http://www.pinews.asia/Regulations2.aspx' style="color: #257fa4;" target='_blank'> PiNews拍新聞 蒐集個資告知事項暨隱私權政策同意書</a>&nbsp;&nbsp;<i class="red pencil alternate icon"></i></label>
							</div>
						</div>

						<div class="eight wide field">
							<asp:Button ID="register_Btn" CssClass="ui blue button" Style="float: right; margin-top: 10px;" runat="server" OnClick="Register" Text="送出並註冊" />
							<asp:Button ID="register_pay_Btn" CssClass="ui blue button" Style="float: right; margin-top: 10px;" runat="server" OnClick="RegisterAndPayAdmin" Text="註冊並付費" />
							
							<%--<asp:Button ID="register_Btn" CssClass="ui blue button" Style="float: right; margin-top: 10px;" runat="server" OnClientClick="javascript: loading(); return checkall();" OnClick="Register" Text="送出並註冊" />
							<asp:Button ID="register_pay_Btn" CssClass="ui blue button" Style="float: right; margin-top: 10px;" runat="server" OnClientClick="javascript: loading(); return checkall();" OnClick="RegisterAndPayAdmin" Text="註冊並付費" />--%>
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



		<script>
			$('.ui.search.dropdown:has(#<%= platform_referrer.ClientID %>)').dropdown({
				apiSettings: {
					url: '/RID/Search/{query}'
				},
				minCharacters: 1
			});

			function verifyId() {
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
				return checkSum % 10 == 0;
			}

			function stringBytes(c) {
				var n = c.length,
					s;
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

			$('.ui.form .byte-chk').on('input', function() {
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
						}
						i++;
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
								}
							]
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
								}
							]
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
								}
							]
						},
						confirmPassword: {
							identifier: '<%= cfmPwd_TB.ClientID %>',
							rules: [{
									type: 'match[<%= pwd_TB.ClientID %>]',
									prompt: '確認密碼有誤'
								},
								{
									type: 'empty',
									prompt: '確認密碼不可爲空'
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

			function loading() {
				if ($('.ui.form').form('validate form') && verifyId()) {
					$('.dimmer')
						.dimmer({
							closable: false
						})
						.dimmer('show');
				}
			};

			$(window).on('load', function() {
				genValidate()
				$(".user-addr").twzipcode({
					//css: ['six wide field', 'six wide field', 'four wide field'],
					readonly: true,
				});
			})
		</script>
</asp:Content>