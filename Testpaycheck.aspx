<%@ Page Title="" Language="C#" MasterPageFile="ClientPage.Master" AutoEventWireup="true" CodeFile="Testpaycheck.aspx.cs" Inherits="piNews.Testpaycheck" %>

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
          <div class="active section">網記註冊付費資訊</div>
        </div>
      </div>
    </div>
  </div>

<div id="main" class="ui placeholder container blue inverted fitted segment" style="overflow:hidden;">
    <div class="ui stackable column padded grid">

      <div class="yellow column">
        <div class="ui basic segment">
            <asp:Label runat="server" ID="labelTest" Text="" Font-Size="32"></asp:Label><br />
          <h2 id="payifo" style="text-align: center;" runat="server">付費成功</h2>
          <h3 id="payifm" class="ui black header" style="text-align: center;" runat="server">註冊、付費成功，請至信箱收取驗證信，驗證信箱</h3>
          <h3 id="payifm2" class="ui black header" style="text-align: center;" runat="server"></h3>    
          <h3 id="payifm3" class="ui black header" style="text-align: center;" runat="server"></h3>
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
      <div class="ui deny button">確認</div>
    </div>
  </div>


</asp:Content>
