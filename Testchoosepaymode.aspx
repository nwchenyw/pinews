<%@ Page Title="" Language="C#" MasterPageFile="ClientPage.Master" AutoEventWireup="true" CodeFile="Testchoosepaymode.aspx.cs" Inherits="piNews.Testchoosepaymode" %>

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
        .required {
	        color: Red;
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
          <div class="active section">網記註冊付費方式</div>
        </div>
      </div>
    </div>
  </div>

<div id="main" class="ui placeholder container blue inverted fitted segment" style="overflow:hidden;">
    <div class="ui stackable column padded grid">

      <div class="yellow column">
        <div class="ui basic segment">
		  <h2 style="text-align: center;">開立發票細項</h2>		
							
		  <div class="field" style="text-align: center;">
            <h3 style="text-align: center;">統一編號(無可免填)</h3>
			<div class="twelve wide field">				
                <asp:TextBox ID="BuyerIdentifier" runat="server"></asp:TextBox>
        	</div>
            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" ControlToValidate="BuyerIdentifier" runat="server" ErrorMessage="僅限8位數字" ValidationExpression="\d{8}" ForeColor="Red" CssClass="required"></asp:RegularExpressionValidator>			
		  </div>
		  <div class="field" style="text-align: center;">
            <h3 style="text-align: center;">發票載具(無可免填)</h3>            
            <div class="twelve wide field">				
                <asp:RadioButton ID="invoice1" runat="server" Text="悠遊卡載具(條碼須至便利超商機器感應查詢)" GroupName="invoicemode"/>
        	</div>
            <div class="twelve wide field">	
                <asp:RadioButton ID="invoice2" runat="server" Text="手機條碼載具(共有8位數，輸入後請再次確認)" GroupName="invoicemode"/>
        	</div>
            <div class="twelve wide field">	
                <asp:RadioButton ID="invoice3" runat="server" Text="愛心碼(發票捐贈時，請查明捐贈單位愛心碼)" GroupName="invoicemode"/>
        	</div>

			<div class="twelve wide field">				
                <asp:TextBox ID="Invoice_carrier" runat="server" ></asp:TextBox>
        	</div>
            <div class="twelve wide field">				
                <asp:Label ID="invoiceRemark" runat="server" ></asp:Label>
        	</div>
		  </div>

          <h2 style="text-align: center;">超商選擇(超商代碼與超商條碼付費時選擇)</h2>		
							
		  <div class="field" style="text-align: center;">
			<div class="twelve wide field">				
                <asp:RadioButton ID="Family" runat="server" Text="全家" GroupName="Supermarket"/>
                <asp:RadioButton ID="Ok" runat="server" Text="Ok Mart" GroupName="Supermarket"/>
                <asp:RadioButton ID="Lairfu" runat="server" Text="萊爾富" GroupName="Supermarket"/>
                <asp:RadioButton ID="Seven" runat="server" Text="7-11" GroupName="Supermarket"/>
        	</div>
            <div class="twelve wide field">				
                <asp:Label ID="Remark" runat="server" ></asp:Label>
        	</div>
		  </div>

		  <h2 style="text-align: center;">選擇付費方式</h2>		
							
		  <div class="field" style="text-align: center;">		
			<div class="twelve wide field">
				<asp:Button ID="pay_Btn1" OnClick="pay_Btn1_Click" CssClass="ui blue button" style="float:center; margin-top: 10px; width: 19rem !Important;" runat="server" Text="信用卡刷卡付費" />
			</div>			
		  </div>
		  <div class="field" style="text-align: center;">		
			<div class="twelve wide field">
				<asp:Button ID="pay_Btn2" OnClick="pay_Btn2_Click" CssClass="ui blue button" style="float:center; margin-top: 10px; width: 19rem !Important;" runat="server" Text="虛擬帳號付費(匯款)" />
			</div>			
		  </div>
		  <div class="field" style="text-align: center;">		
			<div class="twelve wide field">
				<asp:Button ID="pay_Btn3" OnClick="pay_Btn3_Click" CssClass="ui blue button" style="float:center; margin-top: 10px; width: 19rem !Important;" runat="server" Text="超商代碼付費" />
			</div>			
		  </div>
		  <div class="field" style="text-align: center;">		
			<div class="twelve wide field">
				<asp:Button ID="pay_Btn4" disabled="disabled" CssClass="ui blue button" style="float:center; margin-top: 10px; width: 19rem !Important;" runat="server" Text="銀聯卡付費(尚未開放)" />
			</div>			
		  </div>
		  <div class="field" style="text-align: center;">		
			<div class="twelve wide field">
				<asp:Button ID="pay_Btn5" disabled="disabled" CssClass="ui blue button" style="float:center; margin-top: 10px; width: 19rem !Important;" runat="server" Text="超商條碼付費(尚未開放)" />
			</div>			
		  </div>
		  <div class="field" style="text-align: center;">		
			<div class="twelve wide field">
				<asp:Button ID="pay_Btn6" disabled="disabled" CssClass="ui blue button" style="float:center; margin-top: 10px; width: 19rem !Important;" runat="server" Text="WebAtm付費(尚未開放)" />
			</div>			
		  </div>
		  <div class="field" style="text-align: center;">		
			<div class="twelve wide field">
				<asp:Button ID="pay_Btn7" disabled="disabled" CssClass="ui blue button" style="float:center; margin-top: 10px; width: 19rem !Important;" runat="server" Text="LinePay付費(尚未開放)" />
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
      <div class="ui deny button">確認</div>
    </div>
  </div>


</asp:Content>
