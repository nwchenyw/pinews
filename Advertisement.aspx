<%@ Page Title="" Language="C#" MasterPageFile="AdminPage.Master" AutoEventWireup="true" CodeFile="Advertisement.aspx.cs" Inherits="piNews.Advertisement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
  <div class="ui inverted segment">
    <div class="ui inverted breadcrumb">
      <a class="section">Home</a>
      <div class="divider">/ </div>
      <div class="active section">管理個人廣告</div>
    </div>
  </div>
  <div class="ui segment">
    <div class="ui three column grid">
      <div class="column">
        <div class='ui centered card test <%= ListView1.Items.Count > 0 ? "":"medium rectangle" %> ad' data-text="" <%= ListView1.Items.Count > 0 ? "style='max-width: 100%; height: 100%; cursor: pointer;'":"style='max-width: 100%; cursor: pointer;'" %> onclick="new_advertise()">
          <i class="plus icon" style="position: absolute; top: 50%; left: 50%; width: 100%; text-align: center; -webkit-transform: translateX(-50%) translateY(-50%); font-weight: 700; transform: translateX(-50%) translateY(-50%); color: #fff; font-size: 3em;"></i>
        </div>
      </div>
      <asp:ListView ID="ListView1" runat="server" DataKeyNames="id" DataSourceID="SqlDataSource1">
        <ItemTemplate>
          <div class="column" style="display: flex;">
            <div class="ui centered card blurring dimmable ad" style="max-width: 100%; display: table; justify-content: center;" data-text="Medium Rectangle">
              <div class="ui inverted center dimmer">
                <div class="content">
                  <div class="center">
                    <asp:LinkButton ID="select_LB" CssClass="ui primary button" CommandName="Select" runat="server">詳細</asp:LinkButton>
                    <%--<div class="ui primary button">詳細</div>--%>
                  </div>
                </div>
              </div>
              <div class="image" style="height: unset;">
                <div class='ui <%# !Eval("video_url").Equals(DBNull.Value) && !Eval("video_type").Equals(DBNull.Value) ? "":"hidden" %> embed' data-id='<%# Eval("video_url") %>' data-source='<%# Eval("video_type") %>'></div>
                <a data-href="#" class='long <%# !Eval("video_url").Equals(DBNull.Value) && !Eval("video_type").Equals(DBNull.Value) ? "hidden":"" %> square' target="_blank" style="display: block;">
                  <img class="ui medium image" src='Image.aspx?Id=<%# Eval("Img_Id") %>'></a>
              </div>
              <div class="content">
                <div class="header" style="opacity: .7;"><%# Eval("Title") %></div>
                <div class="meta"><%# Eval("Remark") %></div>
              </div>
            </div>
          </div>
        </ItemTemplate>
      </asp:ListView>
      <asp:ListView ID="ListView2" runat="server" DataKeyNames="id" DataSourceID="SqlDataSource2" OnItemCreated="ListView2_ItemCreated" OnPreRender="ListView2_PreRender" OnLoad="ListView2_Load" OnItemUpdating="ListView2_ItemUpdating">
        <ItemTemplate>
          <div class="ui advertise modal">
            <div class="header">個人廣告詳細</div>
            <div class="scrolling content">
              <div class="ui form">
                <div class="two fields">
                  <div class="field">
                    <label>標題</label>
                    <asp:Label ID="title_L" runat="server" Text='<%# Eval("Title") %>'></asp:Label>
                  </div>
                  <%--<div class="two fields">
                    <div class="field">
                      <label>顯示標題</label>
                      <%# Eval("Show_T") %>
                    </div>--%>
                  <div class="field">
                    <label>預覽</label>
                    <div class="ui button" onclick='previewSetAd(&#34;<%# string.Format("Image.aspx?Id={0}", Eval("Img_Id")) %>&#34;)'>
                      預覽
                    </div>
                  </div>
                  <%--</div>--%>
                </div>
                <div class="field">
                  <label>廣告連結</label>
                  <a class="ui link" href='<%# Eval("Link") %>' runat="server" id="ad_link" target="_blank" data-content='<%# Eval("Link") %>' data-position="right center" data-variation="inverted">連結</a>
                </div>
                <div class="field">
                  <label>廣告圖</label>
                  <img class="ui medium image" src='Image.aspx?Id=<%# Eval("Img_Id") %>' />
                </div>
                <div class="fields">
                  <div class="four wide field">
                    <label>影片類型</label>
                    <span id="vi_video_type"><%# Eval("video_type") %></span>
                  </div>
                  <div class="twelve wide field">
                    <label>影片嵌入</label>
                    <span id="vi_videl"><%# Eval("video_url") %></span>
                  </div>
                </div>
                <div class="field">
                  <label>描述</label>
                  <asp:Label ID="Remark_L" runat="server" Text='<%# Eval("Remark") %>'></asp:Label>
                </div>
              </div>
            </div>
            <div class="actions">
              <asp:LinkButton ID="LinkButton3" CssClass="ui primary button" CommandName="Edit" runat="server">編輯</asp:LinkButton>
              <asp:LinkButton ID="LinkButton2" CssClass="ui deny button" OnClick="LinkButton2_Click" runat="server">關閉</asp:LinkButton>
            </div>
          </div>
        </ItemTemplate>
        <EditItemTemplate>
          <div class="ui advertise modal">
            <div class="header">個人廣告詳細</div>
            <div class="scrolling content">
              <div class="ui form">
                <div class="two fields">
                  <div class="field">
                    <label>標題</label>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Eval("Title") %>'></asp:TextBox>
                  </div>
                  <%--<div class="two fields">
                    <div class="field">
                      <label>顯示標題</label>
                      <div class="ui toggle checkbox">
                        <asp:CheckBox ID="CheckBox2" runat="server" Checked='<%# "1".Equals(Eval("Show_T")) %>' Text=" " />
                      </div>
                    </div>--%>
                  <div class="field">
                    <label>預覽</label>
                    <div class="ui button" onclick="previewSetAd('edit')">
                      預覽
                    </div>
                  </div>
                  <%--</div>--%>
                </div>
                <div class="field">
                  <label>廣告連結</label>
                  <asp:TextBox ID="TextBox2" runat="server" Text='<%# Eval("Link") %>'></asp:TextBox>
                </div>
                <div class="field">
                  <label>廣告圖</label>
                  <asp:FileUpload ID="FileUpload1" runat="server" accept="image/gif, image/jpeg, image/png" />
                  <img class="ui medium image" src='Image.aspx?Id=<%# Eval("Img_Id") %>' />

                  <div class="ui message">
                    <div class="header">
                      注意事項
                    </div>
                    <ul class="list">
                      <%--<li>圖片建議尺寸： 360 x 300px，寬高超過360 x 300px將自動壓縮至360 x 300px，檔案容量不得超過5MB。</li>--%>
                      <li>圖片建議尺寸： 320 x 180px，寬高超過320 x 180px將自動壓縮至360 x 300px，檔案容量不得超過5MB。</li>
                      <%--<li>圖片比例： 6:5，比例不符將無法上傳。</li>--%>
                      <li>圖片比例： 16:9，比例不符將無法上傳。</li>
                      <li>圖片格式：JPG,PNG,GIF</li>
                    </ul>
                  </div>
                </div>
                <div class="fields">
                  <div class="four wide field">
                    <label>影片類型</label>
                    <div class="ui selection dropdown">
                      <asp:HiddenField ID="video_type_HF" Value="https://youtu.be/" runat="server" />
                      <%--<input type="hidden" id="video_type" value="https://youtu.be/" />--%>
                      <div class="default text">type</div>
                      <i class="dropdown icon"></i>
                      <div class="menu">
                        <div class="item" data-value="https://youtu.be/">Youtube</div>
                        <div class="item" data-value="https://vimeo.com/">Vimeo</div>
                      </div>
                    </div>
                  </div>
                  <div class="twelve wide field">
                    <label>影片嵌入</label>
                    <div class="ui right labeled input">
                      <div class="ui label">
                        <!-- https://youtu.be/ or https://vimeo.com/ -->
                        <span class="format_url">https://youtu.be/</span>
                      </div>
                      <asp:TextBox ID="Video_id_TB" runat="server" placeholder="video id"></asp:TextBox>
                      <div class="ui label" style="cursor: pointer" onclick="preview('edit')">
                        預覽
                      </div>
                    </div>
                  </div>
                </div>
                <div class="field">
                  <label>描述</label>
                  <asp:TextBox ID="TextBox3" TextMode="MultiLine" Text='<%# Eval("Remark") %>' runat="server"></asp:TextBox>
                </div>
              </div>
            </div>
            <div class="actions">
              <asp:LinkButton ID="LinkButton3" CssClass="ui primary button" CommandName="Update" runat="server">更新</asp:LinkButton>
              <asp:LinkButton ID="LinkButton2" CssClass="ui deny button" CommandName="Cancel" runat="server">取消</asp:LinkButton>
            </div>
          </div>
        </EditItemTemplate>
      </asp:ListView>
      <asp:SqlDataSource runat="server" ID="SqlDataSource2" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT [Img_Id], [Link], [Title], [Show_T], [User_Id], [Upd_Time], [Remark], [Id], [video_type], [video_url] FROM [Advertisement] WHERE ([Id] = @Id)" DeleteCommand="DELETE FROM [Advertisement] WHERE [Id] = @Id" UpdateCommand="UPDATE [Advertisement] SET [Img_Id] = @Img_Id, [Link] = @Link, [Title] = @Title, [Remark] = @Remark, [video_url] = @url, [video_type] = @type WHERE [Id] = @Id">
        <DeleteParameters>
          <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
        </DeleteParameters>
        <SelectParameters>
          <asp:ControlParameter ControlID="ListView1" PropertyName="SelectedValue" Name="Id" Type="Int32"></asp:ControlParameter>
        </SelectParameters>
        <UpdateParameters>
          <asp:Parameter Name="Img_Id" Type="Int32"></asp:Parameter>
          <asp:Parameter Name="Link" Type="String"></asp:Parameter>
          <asp:Parameter Name="Title" Type="String"></asp:Parameter>
          <asp:Parameter Name="Remark" Type="String"></asp:Parameter>
          <asp:Parameter Name="url"></asp:Parameter>
          <asp:Parameter Name="type"></asp:Parameter>
          <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
        </UpdateParameters>
      </asp:SqlDataSource>
      <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT [Img_Id], [Link], [Title], [Show_T], [Remark], [Id], [video_url], [video_type] FROM [Advertisement] WHERE ([Type] = @Type) and User_Id = @uid">
        <SelectParameters>
          <asp:Parameter DefaultValue="personal" Name="Type" Type="String"></asp:Parameter>
          <asp:SessionParameter SessionField="User_Id" DefaultValue="" Name="uid"></asp:SessionParameter>
        </SelectParameters>
      </asp:SqlDataSource>
      <%--<div class="column">
        <div class="ui card medium rectangle center test ad" style="max-width: 100%;" data-text="Medium Rectangle">
          <div class="blurring dimmable image">
            <div class="ui inverted center dimmer">
              <div class="content">
                <div class="center">
                  <div class="ui primary button">Add Friend</div>
                </div>
              </div>
            </div>
            <img src="https://fomantic-ui.com/images/avatar/large/steve.jpg">
          </div>
        </div>
      </div>--%>
    </div>
  </div>
  <div id="new-ad" class="ui small modal">
    <div class="header">新增個人廣告</div>
    <div class="scrolling content">
      <div class="ui form">
        <div class="two fields">
          <div class="field">
            <label>標題</label>
            <asp:TextBox ID="title_TB" runat="server" placeholder="title"></asp:TextBox>
          </div>
          <%--<div class="two fields">
            <div class="field">
              <label>顯示標題</label>
              <div class="ui toggle checkbox">
                <asp:CheckBox ID="CheckBox1" runat="server" Text=" " />
              </div>
            </div>--%>
          <div class="field">
            <label>預覽</label>
            <div class="ui button" onclick="previewSetAd('new')">
              預覽
            </div>
          </div>
          <%--</div>--%>
        </div>
        <div class="field">
          <label>廣告連結</label>
          <asp:TextBox ID="link_TB" runat="server" placeholder="link"></asp:TextBox>
        </div>
        <div class="field">
          <label>廣告圖</label>
          <asp:FileUpload ID="ads_FU" runat="server" accept="image/gif, image/jpeg, image/png" />
          <img class="ui medium image" />

          <div class="ui message">
            <div class="header">
              注意事項
            </div>
            <ul class="list">
              <%--<li>圖片建議尺寸： 360 x 300px，寬高超過360 x 300px將自動壓縮至360 x 300px，檔案容量不得超過5MB。</li>--%>
              <li>圖片建議尺寸： 320 x 180px，寬高超過320 x 180px將自動壓縮至320 x 180px，檔案容量不得超過5MB。</li>
              <%--<li>圖片比例： 6:5，比例不符將無法上傳。</li>--%>
              <li>圖片比例： 16:9，比例不符將無法上傳。</li>
              <li>圖片格式：JPG,PNG,GIF</li>
            </ul>
          </div>
        </div>
        <div class="fields">
          <div class="four wide field">
            <label>影片類型</label>
            <div class="ui selection dropdown">
              <asp:HiddenField ID="video_type_HF" Value="https://youtu.be/" runat="server" />
              <%--<input type="hidden" id="video_type" value="https://youtu.be/" />--%>
              <div class="default text">type</div>
              <i class="dropdown icon"></i>
              <div class="menu">
                <%--  --%>
                <div class="item" data-value="https://youtu.be/">Youtube</div>
                <div class="item" data-value="https://vimeo.com/">Vimeo</div>
              </div>
            </div>
          </div>
          <div class="twelve wide field">
            <label>影片嵌入</label>
            <div class="ui right labeled input">
              <div class="ui label">
                <!-- https://youtu.be/ or https://vimeo.com/ -->
                <span class="format_url">https://youtu.be/</span>
              </div>
              <asp:TextBox ID="Video_id_TB" runat="server" placeholder="video id"></asp:TextBox>
              <%--<input type="text" id="video_id" placeholder="video id">--%>
              <div class="ui label" style="cursor: pointer" onclick="previewSetAd('new')">
                預覽
              </div>
            </div>
          </div>
        </div>
        <div class="field">
          <label>描述</label>
          <asp:TextBox ID="Remark_TB" TextMode="MultiLine" runat="server"></asp:TextBox>
        </div>
      </div>
    </div>
    <div class="actions">
      <asp:LinkButton ID="LinkButton1" CssClass="ui olive button" runat="server" OnClick="LinkButton1_Click">新增</asp:LinkButton>
      <div class="ui cancel button">取消</div>
    </div>
  </div>
  <div id="preview-ad" class="ui toast card ad" data-text="Medium Rectangle" style="padding: 0;">
    <i class="right floated inverted close icon" style="margin: .2rem; z-index: 1;"></i>
    <div class="image">
      <div class="ui hidden embed"></div>
      <a href="http://pinews.asia" target="_blank" class="long square block">
        <img class="ui medium image" src="https://fomantic-ui.com/images/avatar/large/steve.jpg">
      </a>
    </div>
    <div class="content">
      <a class="header" style="opacity: .7"><span></span><i class="right floated ad icon"></i></a>
      <a class="meta"></a>
    </div>
  </div>

  <div class="ui notify tiny modal">
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

    $('.dimmable.ad .ui.embed').embed()

    //video
    $('.modal .content .dropdown').dropdown({
      onChange: function (value, text) {
        console.log(value)
        $('.modal .content .format_url').html(value);
      }
    });

    //$('.modal .actions .primary.button').on('click', function () {
    //  doRestore();
    //  var video = $('#preview-ad .content .ui.embed').clone()[0];
    //  //console.log(video);
    //  var vid = "&zwnj;" + video.outerHTML.toString() + "&zwnj;";
    //  document.execCommand('insertHTML', false, vid);
    //  $('.modal').modal('hide');
    //})

    $('.modal #<%= Video_id_TB.ClientID %>').on('change', function () {
      var val = $(this).val();
      var $sel = $('#<%= video_type_HF.ClientID %>').val();
      if ($sel == 'https://youtu.be/') {
        var isYoutube = val.match(/(?:http:|https:|)\/\/(www\.)?(?:youtube\.com|youtu\.be)\/?(?:watch\?|embed)?(^|\/|v=)?([a-z0-9_-]{11})/i);
        if (isYoutube != null) {
          var match = val.match(/(^|\/|v=)?([a-z0-9_-]{11})/i);
          if (match != null) {
            var final = match[0].replace(/(\/|v=)/i, '');
            $(this).val(final);
            if (checkYoutubeValid(final)) {
              var setting = {};
              setting.source = 'youtube';
              setting.id = final;
              setting.autoplay = true;
              console.log(setting);
              $('#preview-ad .image .ui.embed').attr('data-id', final);
              $('#preview-ad .image .ui.embed').attr('data-source', 'youtube');
              $('#preview-ad .image .ui.embed').attr('contenteditable', 'false');
              // $('#preview-ad .image .ui.embed').embed(setting);
              $('#preview-ad .image .ui.embed').removeClass('hidden')
              $('#preview-ad .image .long.square').addClass('hidden')
            }
          }
        } else if (val.match(/^[a-z0-9_-]{11}$/i).length > 0) {
          console.log(val.match(/^[a-z0-9_-]{11}$/i)[0])
          if (checkYoutubeValid(val)) {
            var setting = {};
            setting.source = 'youtube';
            setting.id = val;
            setting.autoplay = true;
            console.log(setting);
            $('#preview-ad .image .ui.embed').attr('data-id', val);
            $('#preview-ad .image .ui.embed').attr('data-source', 'youtube');
            $('#preview-ad .image .ui.embed').attr('contenteditable', 'false');
            // $('#preview-ad .image .ui.embed').embed(setting);
            $('#preview-ad .image .ui.embed').removeClass('hidden')
            $('#preview-ad .image .long.square').addClass('hidden')
          }
        }
      } else {
        var isVimeo = val.match(/(?:http:|https:|)\/\/(?:player.|www.)?vimeo\.com\/(?:video\/|embed\/|watch\?\S*v=|v\/)?(\d*)/i);
        var isVimeoId = val.match(/^\d+$/i);
        if (isVimeo != null) {
          var match = val.match(/\/(?:video\/|embed\/|watch\?\S*v=|v\/)?(\d+)/i);
          if (match != null) {
            var final = match[0].replace(/\/(?:video\/|embed\/|watch\?\S*v=|v\/)?/i, '');
            $(this).val(final);
            console.log(match, final);
            var setting = {};
            setting.source = 'vimeo';
            setting.id = final;
            setting.autoplay = true;
            console.log(setting);
            $('#preview-ad .image .ui.embed').attr('data-id', final);
            $('#preview-ad .image .ui.embed').attr('data-source', 'vimeo');
            $('#preview-ad .image .ui.embed').attr('contenteditable', 'false');
            // $('#preview-ad .image .ui.embed').embed(setting);
            $('#preview-ad .image .ui.embed').removeClass('hidden')
            $('#preview-ad .image .long.square').addClass('hidden')
          }
        } else if (isVimeoId != null) {
          console.log(val.match(/^\d+$/i)[0])
          var setting = {};
          setting.source = 'vimeo';
          setting.id = val;
          setting.autoplay = true;
          console.log(setting);
          $('#preview-ad .image .ui.embed').attr('data-id', val);
          $('#preview-ad .image .ui.embed').attr('data-source', 'vimeo');
          $('#preview-ad .image .ui.embed').attr('contenteditable', 'false');
          // $('#preview-ad .image .ui.embed').embed(setting);
          $('#preview-ad .image .ui.embed').removeClass('hidden')
          $('#preview-ad .image .long.square').addClass('hidden')
        }

        //regex reference: https://regexr.com/4lrm3 and https://regexr.com/3nsop
        //youtube url valid check reference: https://gist.github.com/tonY1883/a3b85925081688de569b779b4657439b
      }
    });

    function checkYoutubeValid(id) {
      var img = new Image();
      var valid = true;
      img.src = "http://img.youtube.com/vi/" + id + "/mqdefault.jpg";
      img.onload = function () {
        valid = checkThumbnail(this.width);
      }
      return valid;
    }

    function checkThumbnail(width) {
      if (width === 120) {
        console.log('Error: video not found!');
        return false;
      }
    }

    function new_advertise() {
      $('#new-ad').modal({ inverted: true, context: 'form' }).modal('show')
    }
    $('.ui.dimmable.ad').dimmer({
      on: 'hover', duration: {
        show: 500,
        hide: 500
      }
    })

    function checkFileSize(f) {
      if (f.size / 1024 < 5120) {
        return true;
      }
      return false;
    }

    $('#<%= ads_FU.ClientID %>').on('change', function () {
      var file = document.getElementById($(this).attr("id")).files;
      var url = URL.createObjectURL(file[0]);
      var $el = $(this);
      if (checkFileSize(file[0])) {
        const img = new Image();
        img.onload = function () {
          if (this.width / this.height != 16 / 9) {
            console.log(this.width, this.height, this.width / this.height)
            console.log(this)
            console.log(16, 9, 16 / 9)
            alert('請修正長寬比');
            document.getElementById($(this).attr('id')).value = '';
            //$(this).removeAttr('src');
          } else if (this.width > 320 || this.height > 180) {
            alert('注意！圖片寬高超過320 x 180px,上傳後將進行壓縮！');
            $('#' + $el.attr('id') + ' + img').attr('src', url)
          } else {
            console.log($el.attr('id'))
            $('#' + $el.attr('id') + ' + img').attr('src', url)
          }
        }
        img.src = url;
      } else {
        document.getElementById($(this).attr("id")).value = '';
        alert('檔案大小超過5MB!!')
      }
    })

    function previewSetAd(opt) {
      var $embed = $('#<%= Video_id_TB.ClientID %>')
      var $embed_type_dd = $('.ui.dropdown:has(#<%= video_type_HF.ClientID %>)')
      var $img = $('#<%= ads_FU.ClientID %> + img')
      var $link = $('#<%= link_TB.ClientID %>')
      var $title = $('#<%= title_TB.ClientID %>')
      var $content = $('#<%= Remark_TB.ClientID %>')
      if (<%= ListView2.EditIndex != -1 ? "true": "false" %>) {
        if (opt == 'edit') {
          $img = $('#<%= ListView2.EditIndex != -1 ? ListView2.Items[ListView2.EditIndex].FindControl("FileUpload1").ClientID:"" %> + img')
          $link = $('#<%= ListView2.EditIndex != -1 ? ListView2.Items[ListView2.EditIndex].FindControl("TextBox2").ClientID:"" %>')
          $title = $('#<%= ListView2.EditIndex != -1 ? ListView2.Items[ListView2.EditIndex].FindControl("TextBox1").ClientID:"" %>')
          $content = $('#<%= ListView2.EditIndex != -1 ? ListView2.Items[ListView2.EditIndex].FindControl("TextBox3").ClientID:"" %>')
          $embed = $('#<%= ListView2.EditIndex != -1 ? ListView2.Items[ListView2.EditIndex].FindControl("Video_id_TB").ClientID:"" %>')
          $embed_type_dd = $('.ui.dropdown:has(#<%= ListView2.EditIndex != -1 ? ListView2.Items[ListView2.EditIndex].FindControl("video_type_HF").ClientID:"" %>)')
        }
      }
      var link = $link.val();
      //var file = document.getElementById($img.attr("id")).files;
      //var url = URL.createObjectURL(file[0]);
      var url = $img.attr('src');
      var title = $title.val();
      var meta = $content.val();
      var embed_type = $embed_type_dd.dropdown('get text').toLowerCase();
      if (opt != 'edit' && opt != 'new') {
        url = opt;
        $link = $('#<%= (ListView2.EditIndex == -1 && ListView2.Items.Count > 0) ? ListView2.Items[0].FindControl("ad_link").ClientID:"" %>')
        $title = $('#<%= (ListView2.EditIndex == -1 && ListView2.Items.Count > 0) ? ListView2.Items[0].FindControl("title_L").ClientID:"" %>')
        $content = $('#<%= (ListView2.EditIndex == -1 && ListView2.Items.Count > 0) ? ListView2.Items[0].FindControl("Remark_L").ClientID:"" %>')
        $embed = $('#vi_video_url')
        $embed_type_dd = $('#vi_video_type')
        link = $link.attr('href')
        title = $title.html();
        meta = $content.html();
        embed_type = $embed_type_dd.html();
        console.log('<%= ListView2.Items.Count > 0 %>', '<%= ListView2.EditIndex == -1 %>')
      }
      console.log($embed.val())
      console.log(!$embed.val())
      console.log($embed.val() != '' && $embed.val() != undefined)
      console.log($embed.val() != '' || $embed.val() != undefined)
      if ($embed.val() != '' && $embed.val() != undefined) {
        $('#preview-ad .image .ui.embed').attr('data-id', $embed.val());
        $('#preview-ad .image .ui.embed').attr('data-source', embed_type)
        console.log(embed_type)
      } else {
        $('#preview-ad .image .ui.embed').attr('data-id', '');
        $('#preview-ad .image .ui.embed').attr('data-source', '')
      }
      $('#preview-ad img').attr('src', url);
      $('#preview-ad a').attr('href', link)
      $('#preview-ad .content .header span').html(title)
      $('#preview-ad .content .meta').html(meta)

      preview()
    }

    function preview() {
      $('#preview-ad').toast({
        class: 'visible',
        position: 'bottom right',
        // showProgress: 'bottom',
        displayTime: 0,
        // classProgress: 'pink',
        closeIcon: true,
        cloneMode: false,
        onVisible: function ($mod) {
          if ($('#preview-ad .image .ui.embed').attr('data-id') != '') {
            var $embed = $('#<%= Video_id_TB.ClientID %>')
            var $embed_type_dd = $('.ui.dropdown:has(#<%= video_type_HF.ClientID %>)')
            var setting = {};
            setting.source = $embed_type_dd.dropdown('get text').toLowerCase();
            setting.id = $embed.val();
            setting.autoplay = true;
            //?rel=0&amp;autoplay=1&amp;loop=1&amp;playlist={0}&amp;mute=1&amp;autohide=1&amp;showinfo=0&amp;controls=0&amp;modestbranding=1
            if (setting.source == 'youtube') {
              setting.parameters = {
                rel: 0,
                autoplay: 1,
                loop: 1,
                playlist: $embed.val(),
                mute: 1,
                autohide: 1,
                showinfo: 0,
                controls: 0,
                modestbranding: 1
              };
            } else {
              setting.parameters = {
                autoplay: 1,
                loop: 1,
                autopause: 0,
                mute: 1
              }
            }
            setting.onCreated = function () {
              $('.ui.embed iframe').attr('allow', 'autoplay; fullscreen; picture-in-picture')
            }
            console.log($mod)
            console.log(setting);
            $($mod).children('.image').children('.ui.embed')
            $($mod).children('.image').children('.ui.embed').removeClass('hidden')
            $($mod).children('.image').children('.long.square').addClass('hidden')
            $($mod).children('.image').children('.ui.embed').embed(setting)
          } else {
            $($mod).children('.image').children('.ui.embed').addClass('hidden')
            $($mod).children('.image').children('.long.square').removeClass('hidden')
          }
        }, onHidden: function ($mod) {
          $($mod).children('.image').children('.ui.embed').embed('destroy')
        }
      })
    }
  </script>
</asp:Content>
