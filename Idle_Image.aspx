<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="AdminPage.Master" CodeFile="Idle_Image.aspx.cs" Inherits="piNews.Idle_Image" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <%--<asp:Repeater ID="Repeater1" runat="server">
    <ItemTemplate>
      <span class="ui label"><%# Container.DataItem %></span>
    </ItemTemplate>
  </asp:Repeater>--%>
  <asp:ListView ID="ListView1" runat="server" DataSourceID="SqlDataSource1" DataKeyNames="Id" OnItemDeleting="ListView1_ItemDeleting">
    <ItemTemplate>
      <label class="ui small image center aligned segment">
        <asp:CheckBox ID="CheckBox1" CssClass="select-img" runat="server" Visible='<%# Eval("r_article").ToString().Trim().Equals("") %>' />
        <%# Eval("r_article").ToString().Trim().Equals("") ? "<span class='ui red right ribbon label'>閒置</span>":"" %>
        <span class="block square" style="margin-bottom: 1.2rem;">
          <img class="lazy image" data-src='Image.aspx?ID=<%# Eval("Id") %>' />
        </span>
        <span class="ui blue image bottom attached label">
          <%# DBNull.Value.Equals(Eval("Size")) ? "- KB":(Convert.ToDecimal(Eval("Size").ToString()) > 1024 ? 
              (Convert.ToDecimal(Eval("Size").ToString())/1024).ToString("#0.0") + "MB":Convert.ToDecimal(Eval("Size")).ToString("#0.0") +"KB") %>
          <span class="detail" style="border-radius: unset;">
          <%# DBNull.Value.Equals(Eval("Content_Type")) ? "":Eval("Content_Type").ToString().Replace("image/","") %>
          </span>
        </span>
        <asp:LinkButton ID="img_Delete" CommandName="Delete" Visible='<%# Eval("r_article").ToString().Trim().Equals("") %>' CssClass="ui right floated red mini button" runat="server">刪除</asp:LinkButton>
      </label>
    </ItemTemplate>
    <LayoutTemplate>
      <div style="display: table;">
        <%--<div class="ui left floated compact segment" style="margin: 0 1em;">
          <asp:CheckBox ID="CheckBox2" Text="全選" CssClass="ui checkbox select-all-img" runat="server" />
        </div>--%>
        <div class="ui left floated compact segment" style="margin: 0 1em;">
          <asp:CheckBox ID="CheckBox3" Text="全選閒置" CssClass="ui checkbox select-all-idle-img" runat="server" />
        </div>
      </div>
      <asp:PlaceHolder ID="ItemPlaceHolder" runat="server"></asp:PlaceHolder>
      <div class="ui fluid red buttons">
        <asp:LinkButton ID="LinkButton1" CssClass="ui red button" OnClick="LinkButton1_Click" OnClientClick="javascript: return alert('若刪除之圖片非閒置,您上傳之部分文章圖片或頭貼將會遺失,確定要刪除嗎?');" runat="server">刪除</asp:LinkButton>
      </div>
    </LayoutTemplate>
  </asp:ListView>
  <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="select i.Id, i.Size, i.Content_Type, i.Upload_time, (SELECT cast(article_id as nvarchar)+',' from (SELECT article_id from Article_Image where image_id = i.Id 
union select -5 from Member m where m.id = i.User_id and m.Member_Img_Id = i.Id
union select a.Id from Article a where a.Front_Img_Id = i.Id
union select b.Id from Banner b where b.Image_Id = i.Id
union select ad.Id from Advertisement ad where ad.Img_id = i.Id) all_usage
FOR XML PATH('')) as r_article from Image i where User_id = @uid and image_type = 1"
    DeleteCommand="Delete from Image Where Id = @id">
    <DeleteParameters>
      <asp:Parameter Name="id"></asp:Parameter>
    </DeleteParameters>
    <SelectParameters>
      <asp:SessionParameter SessionField="User_Id" Name="uid"></asp:SessionParameter>
    </SelectParameters>
  </asp:SqlDataSource>
  
  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.9/jquery.lazy.min.js"></script>
  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.9/jquery.lazy.plugins.min.js"></script>
  <script>

    $('.square .lazy').Lazy({ threshold: 0, effect: 'fadeIn', effectTime: 500, appendScroll: $('.ui.scrolling.basic.segment') });
    $('.image.segment').on('click', function () {
      if ($(this).children('.select-img').children('input[type=checkbox]').is(':checked')) {
        $(this).addClass('blue')
        $(this).transition('bounce')
      }
      else {
        $(this).removeClass('blue')
      }
    })

    $('.select-all-img input[type=checkbox]').on('change', function () {
      //$('.image.segment').click();
      console.log($('.select-img input[type=checkbox]').is(':checked'))
      if ($('.select-img input[type=checkbox]').is(':checked')) {
        $('.select-img input[type=checkbox]').prop('checked', false)
        $('.image.segment').removeClass('blue');
      } else {
        $('.select-img input[type=checkbox]').prop('checked', true)
        $('.image.segment').addClass('blue');
        $('.image.segment').transition('bounce');
      }
    })

    $('.select-all-idle-img input[type=checkbox]').on('change', function () {
      //$('.image.segment').click();
      console.log($('.select-all-idle-img input[type=checkbox]').is(':checked'))
      if (!$('.select-all-idle-img input[type=checkbox]').is(':checked')) {
        $('.image.segment:has(.ribbon) .select-img input[type=checkbox]').prop('checked', false)
        $('.image.segment:has(.ribbon)').removeClass('blue');
      } else {
        $('.image.segment:has(.ribbon) .select-img input[type=checkbox]').prop('checked', true)
        $('.image.segment:has(.ribbon)').addClass('blue');
        $('.image.segment:has(.ribbon)').transition('bounce');
      }
    })
  </script>
</asp:Content>
