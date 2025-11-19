<%@ Page Title="" Language="C#" MasterPageFile="~/ClientPage.Master" AutoEventWireup="true" CodeFile="FindPassword.aspx.cs" Inherits="piNews.FindPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <style>
  </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <div class="ui feed container">
    <div class="event">
      <div class="label">
        <i class="history icon"></i>
      </div>
      <div class="content">
        <div class="ui breadcrumb">
          <a class="section" href="Default.aspx">首頁</a>
          <div class="divider">/ </div>
          <div class="active section">忘記密碼</div>
        </div>
      </div>
    </div>
  </div>
  <div id="main" class="ui placeholder container yellow inverted segment">
    <%--<div class="ui unstackable padded grid">
      <div class="row">
        <div class="column">
    <div class="ui form">
      <div class="field">
        <label>帳號(E-mail)</label>
        
      </div>
    </div>--%>
    <%--<div class="ui labaled input">
    <asp:LinkButton ID="LinkButton1" runat="server" CssClass="ui button">寄送認證信</asp:LinkButton>
    </div>--%>
    <%--<div class="column">--%>
    <div class="inline">
    <div class="ui form">
      <div class="two fields">
        <div class="field">
        <label>帳號</label>
          <asp:TextBox ID="acc" Enabled="false" runat="server"></asp:TextBox>
        </div>
        <div class="field">
          <label>姓名</label>
          <asp:Label ID="name" runat="server" Text=""></asp:Label>
        </div>
      </div>
      <div class="two fields">
        <div class="field">
          <label>密碼</label>
          <asp:TextBox ID="pwd_TB" TextMode="Password" minlength="8" MaxLength="100" runat="server"></asp:TextBox>
        </div>
        <div class="field">
          <label>確認密碼</label>
          <asp:TextBox ID="cfmPwd_TB" TextMode="Password" runat="server"></asp:TextBox>
        </div>
      </div>
      <div class="field" style="max-width: unset;">
        <asp:LinkButton ID="Confirm_LB" runat="server" CssClass="ui blue button" style="max-width: unset;" OnClientClick="javascript: return $('.ui.form').form('is valid');" OnClick="Confirm_LB_Click">確定</asp:LinkButton>
      </div>
      <div class="ui error message"></div>
    </div></div>
    <%--</div>
      </div>
    </div>--%>
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
    $('#main .ui.form').form({
      on: 'blur',
      fields: {
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
        }
      }
    })
  </script>
</asp:Content>
