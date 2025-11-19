<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeFile="Website_Ads.aspx.cs" Inherits="piNews.Website_Ads" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

  <div class="ui inverted segment">
    <div class="ui inverted breadcrumb">
      <a class="section">Home</a>
      <div class="divider">/ </div>
      <div class="active section">管理網站廣告</div>
    </div>
  </div>

  <div class="ui segment">
    <asp:HiddenField ID="Type_HF" runat="server" />
    <h2>好友連結</h2>
    <div class="ui divider" style="border-color: #257fa4"></div>

    <div class="ui middle aligned animated divided list">
      <asp:ListView ID="ListView1" runat="server" DataSourceID="SqlDataSource1" DataKeyNames="id" OnPreRender="ListView1_PreRender" OnDataBound="ListView1_DataBound" OnItemDeleting="ListView1_ItemDeleting" OnItemUpdating="ListView1_ItemUpdating" InsertItemPosition="FirstItem">
        <ItemTemplate>
          <div class="item">
            <img class="image" src='Image.aspx?Id=<%# Eval("Img_Id") %>' style="height: 35px;" />
            <div class="content"></div>
            <div class="right floated content">
              <asp:LinkButton ID="select_LB" CssClass="ui primary button" CommandName="Select" runat="server">詳細</asp:LinkButton>
            </div>
          </div>
        </ItemTemplate>
        <SelectedItemTemplate>
          <div class="item">
            <img class="image" src='Image.aspx?Id=<%# Eval("Img_Id") %>' style="height: 35px;" />
            <div class="content"></div>
            <div class="right floated content">
              <asp:LinkButton ID="select_LB" CssClass="ui primary button" CommandName="Select" runat="server">詳細</asp:LinkButton>
            </div>
          </div>
          <div class="ui advertise modal">
            <div class="header">好友詳細</div>
            <div class="scrolling content">
              <div class="ui form">
                <div class="two fields">
                  <div class="field">
                    <label>標題</label>
                    <%# Eval("Title") %>
                  </div>
                  <%--<div class="two fields">
                    <div class="field">
                      <label>顯示標題</label>
                      <%# Eval("Show_T") %>
                    </div>
                    <div class="field">
                      <label>預覽</label>
                      <div class="ui button" onclick='previewSetAd(&#34;<%# string.Format("Image.aspx?Id={0}", Eval("Img_Id")) %>&#34;)'>
                        預覽
                      </div>
                    </div>
                  </div>--%>
                </div>
                <div class="field">
                  <label>廣告連結</label>
                  <a class="ui link" href='<%# Eval("Link") %>' runat="server" id="ad_link" target="_blank" data-content='<%# Eval("Link") %>' data-position="right center" data-variation="inverted">連結</a>
                </div>
                <div class="field">
                  <label>廣告圖</label>
                  <img class="ui medium image" src='Image.aspx?Id=<%# Eval("Img_Id") %>' />
                </div>
                <div class="field">
                  <label>備註</label>
                  <span><%# Eval("Remark") %></span>
                </div>
              </div>
            </div>
            <div class="actions">
              <asp:LinkButton ID="LinkButton3" CssClass="ui primary button" CommandName="Edit" runat="server">編輯</asp:LinkButton>
              <asp:LinkButton ID="LinkButton4" CssClass="ui red button" CommandName="Delete" runat="server">刪除</asp:LinkButton>
              <asp:LinkButton ID="Select_Cancel" CssClass="ui deny button" OnClick="Select_Cancel_Click" runat="server">關閉</asp:LinkButton>
            </div>
          </div>
        </SelectedItemTemplate>
        <EditItemTemplate>
          <div class="item">
            <img class="image" src='Image.aspx?Id=<%# Eval("Img_Id") %>' style="height: 35px;" />
            <div class="content"></div>
            <div class="right floated content">
              <asp:LinkButton ID="select_LB" CssClass="ui primary button" CommandName="Select" runat="server">詳細</asp:LinkButton>
            </div>
          </div>
          <div class="ui advertise modal">
            <div class="header">好友詳細</div>
            <div class="scrolling content">
              <div class="ui form">
                <div class="two fields">
                  <div class="field">
                    <label>標題</label>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Eval("Title") %>'></asp:TextBox>
                  </div>
                </div>
                <div class="field">
                  <label>廣告連結</label>
                  <asp:TextBox ID="TextBox2" runat="server" Text='<%# Eval("Link") %>'></asp:TextBox>
                </div>
                <div class="field">
                  <label>廣告圖</label>
                  <asp:FileUpload ID="FileUpload1" runat="server" />
                  <asp:HiddenField ID="HiddenField1" Value='<%# Eval("Img_Id") %>' runat="server" />
                  <img class="ui medium image" src='Image.aspx?Id=<%# Eval("Img_Id") %>' />

                  <div class="ui message">
                    <div class="header">
                      注意事項
                    </div>
                    <ul class="list">
                      <li>圖片建議尺寸： 高不超過35px，超過35px將自動按比例壓縮至高35px，檔案容量不得超過5MB。</li>
                      <li>圖片比例： 建議比例30:7，高不得大於寬的二分之一。</li>
                      <li>圖片格式：JPG,PNG,GIF</li>
                    </ul>
                  </div>
                </div>
                <div class="field">
                  <label>備註</label>
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
        <InsertItemTemplate>
          <div class="item">
            <asp:LinkButton ID="New_LB" runat="server" CssClass="ui primary button" OnClick="New_LB_Click">新增拍新聞好友</asp:LinkButton>
          </div>
        </InsertItemTemplate>
      </asp:ListView>
    </div>
    <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT DISTINCT [Img_Id], [Link], [Title], [Show_T], [Id], [Remark] FROM [Advertisement] WHERE ([Type] = @Type)" UpdateCommand="Update [Advertisement] set [Link]=@link, [Title]=@title,[Img_Id] = @iid, [Remark] = @rmrk WHERE ([Type] = @Type) AND [Id] = @id" DeleteCommand="Delete From Advertisement Where [Id] = @id">
      <DeleteParameters>
        <asp:Parameter Name="id"></asp:Parameter>
      </DeleteParameters>
      <SelectParameters>
        <asp:Parameter DefaultValue="friend" Name="Type" Type="String"></asp:Parameter>
      </SelectParameters>
      <UpdateParameters>
        <asp:Parameter Name="link"></asp:Parameter>
        <asp:Parameter Name="title"></asp:Parameter>
        <asp:Parameter Name="iid"></asp:Parameter>
        <asp:Parameter Name="rmrk"></asp:Parameter>
        <asp:Parameter Name="Type" DefaultValue="friend" Type="String"></asp:Parameter>
        <asp:Parameter Name="id"></asp:Parameter>
      </UpdateParameters>
    </asp:SqlDataSource>

    <h2>首頁下幅廣告</h2>
    <div class="ui divider" style="border-color: #257fa4"></div>
    <div class="ui middle aligned animated divided list">
      <asp:ListView ID="ListView2" runat="server" DataKeyNames="id" InsertItemPosition="FirstItem" OnItemDeleting="ListView2_ItemDeleting" OnPreRender="ListView2_PreRender" OnDataBound="ListView2_DataBound" OnItemUpdating="ListView2_ItemUpdating" DataSourceID="SqlDataSource2">
        <ItemTemplate>
          <div class="item">
            <img class="image" src='Image.aspx?Id=<%# Eval("Img_Id") %>' style="width: 357px;" />
            <div class="content"></div>
            <div class="right floated content">
              <asp:LinkButton ID="select_LB" CssClass="ui primary button" CommandName="Select" runat="server">詳細</asp:LinkButton>
            </div>
          </div>
        </ItemTemplate>
        <SelectedItemTemplate>
          <div class="item">
            <img class="image" src='Image.aspx?Id=<%# Eval("Img_Id") %>' style="width: 357px;" />
            <div class="content"></div>
            <div class="right floated content">
              <asp:LinkButton ID="select_LB" CssClass="ui primary button" CommandName="Select" runat="server">詳細</asp:LinkButton>
            </div>
          </div>

          <div class="ui advertise modal">
            <div class="header">橫條廣告詳細</div>
            <div class="scrolling content">
              <div class="ui form">
                <div class="two fields">
                  <div class="field">
                    <label>標題</label>
                    <asp:Label ID="title_L" runat="server" Text='<%# Eval("Title") %>'></asp:Label>
                  </div>
                </div>
                <div class="field">
                  <label>廣告連結</label>
                  <a class="ui link" href='<%# Eval("Link") %>' runat="server" id="ad_link" target="_blank" data-content='<%# Eval("Link") %>' data-position="right center" data-variation="inverted">連結</a>
                </div>
                <div class="field">
                  <label>廣告圖</label>
                  <img class="ui medium image" src='Image.aspx?Id=<%# Eval("Img_Id") %>' />
                </div>
                <div class="field">
                  <label>備註</label>
                  <asp:Label ID="Remark_L" runat="server" Text='<%# Eval("Remark") %>'></asp:Label>
                </div>
              </div>
            </div>
            <div class="actions">
              <asp:LinkButton ID="LinkButton3" CssClass="ui primary button" CommandName="Edit" runat="server">編輯</asp:LinkButton>
              <asp:LinkButton ID="LinkButton5" CssClass="ui red button" CommandName="Delete" runat="server">刪除</asp:LinkButton>
              <asp:LinkButton ID="Select_Cancel" CssClass="ui deny button" OnClick="Select_Cancel_Click" runat="server">關閉</asp:LinkButton>
            </div>
          </div>
        </SelectedItemTemplate>
        <EditItemTemplate>
          <div class="item">
            <img class="image" src='Image.aspx?Id=<%# Eval("Img_Id") %>' style="width: 357px;" />
            <div class="content"></div>
            <div class="right floated content">
              <asp:LinkButton ID="select_LB" CssClass="ui primary button" CommandName="Select" runat="server">詳細</asp:LinkButton>
            </div>
          </div>

          <div class="ui advertise modal">
            <div class="header">首頁下幅廣告詳細</div>
            <div class="scrolling content">
              <div class="ui form">
                <div class="two fields">
                  <div class="field">
                    <label>標題</label>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Eval("Title") %>'></asp:TextBox>
                  </div>
                </div>
                <div class="field">
                  <label>廣告連結</label>
                  <asp:TextBox ID="TextBox2" runat="server" Text='<%# Eval("Link") %>'></asp:TextBox>
                </div>
                <div class="field">
                  <label>廣告圖</label>
                  <asp:FileUpload ID="FileUpload1" runat="server" />
                  <asp:HiddenField ID="HiddenField1" Value='<%# Eval("Img_Id") %>' runat="server" />
                  <img class="ui medium image" src='Image.aspx?Id=<%# Eval("Img_Id") %>' />

                  <div class="ui message">
                    <div class="header">
                      注意事項
                    </div>
                    <ul class="list">
                      <%--<li>圖片建議尺寸： 寬不超過360px，超過360px將自動按比例壓縮至寬360px，檔案容量不得超過5MB。</li>--%>
                      <li>圖片建議尺寸： 320 x 180px，寬高超過320 x 180px將自動壓縮至320 X 180px，檔案容量不得超過5MB。</li>
                      <%--<li>圖片比例： 建議比例3:1，高不得大於寬的二分之一。</li>--%>
                      <li>圖片比例： 16:9，比例不符將無法上傳。</li>
                      <li>圖片格式：JPG,PNG,GIF</li>
                    </ul>
                  </div>
                </div>
                <div class="field">
                  <label>備註</label>
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
        <InsertItemTemplate>
          <div class="item">
            <asp:LinkButton ID="New_long_LB" runat="server" CssClass="ui primary button" OnClick="New_long_LB_Click">新增拍新聞橫條廣告</asp:LinkButton>
          </div>
        </InsertItemTemplate>
      </asp:ListView>
      <asp:SqlDataSource runat="server" ID="SqlDataSource2" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT [Id], [Img_Id], [Link], [Title], [Show_T], [Remark] FROM [Advertisement] WHERE ([Type] = @Type)" DeleteCommand="DELETE FROM [Advertisement] WHERE [Id] = @Id" InsertCommand="INSERT INTO [Advertisement] ([Img_Id], [Link], [Title], [Show_T], [Remark]) VALUES (@Img_Id, @Link, @Title, @Show_T, @Remark)" UpdateCommand="UPDATE [Advertisement] SET [Img_Id] = @Img_Id, [Link] = @Link, [Title] = @Title, [Show_T] = @Show_T, [Remark] = @Remark WHERE [Id] = @Id">
        <DeleteParameters>
          <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
        </DeleteParameters>
        <InsertParameters>
          <asp:Parameter Name="Img_Id" Type="Int32"></asp:Parameter>
          <asp:Parameter Name="Link" Type="String"></asp:Parameter>
          <asp:Parameter Name="Title" Type="String"></asp:Parameter>
          <asp:Parameter Name="Show_T" Type="Boolean"></asp:Parameter>
          <asp:Parameter Name="Remark" Type="String"></asp:Parameter>
        </InsertParameters>
        <SelectParameters>
          <asp:Parameter DefaultValue="long square" Name="Type" Type="String"></asp:Parameter>
        </SelectParameters>
        <UpdateParameters>
          <asp:Parameter Name="Img_Id" Type="Int32"></asp:Parameter>
          <asp:Parameter Name="Link" Type="String"></asp:Parameter>
          <asp:Parameter Name="Title" Type="String"></asp:Parameter>
          <asp:Parameter Name="Show_T" Type="Boolean" DefaultValue="false"></asp:Parameter>
          <asp:Parameter Name="Remark" Type="String"></asp:Parameter>
          <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
        </UpdateParameters>
      </asp:SqlDataSource>
    </div>

    <h2>方格廣告</h2>
    <div class="ui divider" style="border-color: #257fa4"></div>
    <div class="ui middle aligned divided list">
      <div class="item">
        <div class="content">
          <div class="header">首頁右幅</div>

          <div class="ui middle aligned divided list">
            <div class="item">
              <div class="ui three column grid">
                <asp:ListView ID="ListView3" runat="server" DataSourceID="SqlDataSource3" DataKeyNames="Id" OnPreRender="ListView3_PreRender" OnItemUpdating="ListView3_ItemUpdating" OnDataBound="ListView3_DataBound" OnItemDeleting="ListView3_ItemDeleting" InsertItemPosition="FirstItem">
                  <ItemTemplate>
                    <div class="column" style="display: flex;">
                      <div class="ui centered card blurring dimmable ad" style="max-width: 100%; display: table; justify-content: center;" data-text="Medium Rectangle">
                        <div class="ui inverted center dimmer">
                          <div class="content">
                            <div class="center">
                              <asp:LinkButton ID="LinkButton6" CssClass="ui primary button" CommandName="Select" runat="server">詳細</asp:LinkButton>
                              <%--<div class="ui primary button">詳細</div>--%>
                            </div>
                          </div>
                        </div>
                        <div class="image" style="height: unset;">
                          <a data-href="#" class="long square" target="_blank" style="display: block;">
                            <img class="ui medium image" src='Image.aspx?Id=<%# Eval("Img_Id") %>'></a>
                        </div>
                        <div class="content">
                          <div class="header" style="opacity: .7;"><%# Eval("Title") %></div>
                          <div class="meta"><%# Eval("Remark") %></div>
                        </div>
                      </div>
                    </div>
                  </ItemTemplate>
                  <SelectedItemTemplate>
                    <div class="column" style="display: flex;">
                      <div class="ui card medium rectangle center test ad" style="max-width: 100%; display: flex; justify-content: center;" data-text="Medium Rectangle">
                        <div class="blurring dimmable image">
                          <div class="ui inverted center dimmer">
                            <div class="content">
                              <div class="center">
                                <asp:LinkButton ID="select_LB" CssClass="ui primary button" CommandName="Select" runat="server">詳細</asp:LinkButton>
                                <%--<div class="ui primary button">詳細</div>--%>
                              </div>
                            </div>
                          </div>
                          <img src='Image.aspx?Id=<%# Eval("Img_Id") %>'>
                        </div>
                      </div>
                    </div>
                    <div class="ui advertise modal">
                      <div class="header">方格廣告(右)詳細</div>
                      <div class="scrolling content">
                        <div class="ui form">
                          <div class="two fields">
                            <div class="field">
                              <label>標題</label>
                              <%# Eval("Title") %>
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
                          <div class="field">
                            <label>備註</label>
                            <span><%# Eval("Remark") %></span>
                          </div>
                        </div>
                      </div>
                      <div class="actions">
                        <asp:LinkButton ID="LinkButton3" CssClass="ui primary button" CommandName="Edit" runat="server">編輯</asp:LinkButton>
                        <asp:LinkButton ID="Delete" CssClass="ui red button" CommandName="Delete" runat="server">刪除</asp:LinkButton>
                        <asp:LinkButton ID="Select_Cancel" CssClass="ui deny button" OnClick="Select_Cancel_Click" runat="server">關閉</asp:LinkButton>
                      </div>
                    </div>
                  </SelectedItemTemplate>
                  <EditItemTemplate>
                    <div class="column" style="display: flex;">
                      <div class="ui card medium rectangle center test ad" style="max-width: 100%; display: flex; justify-content: center;" data-text="Medium Rectangle">
                        <div class="blurring dimmable image">
                          <div class="ui inverted center dimmer">
                            <div class="content">
                              <div class="center">
                                <asp:LinkButton ID="select_LB" CssClass="ui primary button" CommandName="Select" runat="server">詳細</asp:LinkButton>
                                <%--<div class="ui primary button">詳細</div>--%>
                              </div>
                            </div>
                          </div>
                          <img src='Image.aspx?Id=<%# Eval("Img_Id") %>'>
                        </div>
                      </div>
                    </div>

                    <div class="ui advertise modal">
                      <div class="header">方格廣告詳細</div>
                      <div class="scrolling content">
                        <div class="ui form">
                          <div class="two fields">
                            <div class="field">
                              <label>標題</label>
                              <asp:TextBox ID="TextBox1" runat="server" Text='<%# Eval("Title") %>'></asp:TextBox>
                            </div>
                            <%--<div class="two fields">--%>
                            <%--<div class="field">
                                <label>顯示標題</label>
                                <asp:CheckBox ID="CheckBox2" runat="server" Checked='<%# Eval("Show_T").Equals(true) %>' Text=" " />
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
                            <asp:TextBox ID="TextBox2" runat="server" Text='<%# Eval("Link") %>'></asp:TextBox>
                          </div>
                          <div class="field">
                            <label>廣告圖</label>
                            <asp:FileUpload ID="FileUpload1" runat="server" />
                            <asp:HiddenField ID="HiddenField1" Value='<%# Eval("Img_Id") %>' runat="server" />
                            <img class="ui medium image" src='Image.aspx?Id=<%# Eval("Img_Id") %>' />

                            <div class="ui message">
                              <div class="header">
                                注意事項
                              </div>
                              <ul class="list">
                                <%--<li>圖片建議尺寸： 寬不超過360px，超過360px將自動按比例壓縮至寬360px，檔案容量不得超過5MB。</li>--%>
                                <li>圖片建議尺寸： 360 x 300px，寬高超過360 x 300px將自動壓縮至360 X 300px，檔案容量不得超過5MB。</li>
                                <%--<li>圖片比例： 建議比例3:1，高不得大於寬的二分之一。</li>--%>
                                <li>圖片比例： 6:5，比例不符將無法上傳。</li>
                                <li>圖片格式：JPG,PNG,GIF</li>
                              </ul>
                            </div>
                          </div>
                          <div class="field">
                            <label>備註</label>
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
                  <InsertItemTemplate>
                    <div class="column">
                      <asp:LinkButton ID="LinkButton2" CssClass="ui card medium rectangle center test ad" Style="max-width: 100%; background-color: #545454;" runat="server" OnClick="LinkButton2_Click">
                      <%--<div class="ui card medium rectangle center test ad" data-text="" style="max-width: 100%; cursor: pointer;" onclick="new_advertise()">--%>
                        <i class="plus icon" style="position: absolute; top: 50%; left: 50%; width: 100%; text-align: center; -webkit-transform: translateX(-50%) translateY(-50%); font-weight: 700; transform: translateX(-50%) translateY(-50%); color: #fff; font-size: 3em;"></i>
                      <%--</div>--%>
                      </asp:LinkButton>
                    </div>
                  </InsertItemTemplate>
                </asp:ListView>
              </div>
            </div>
          </div>
          <asp:SqlDataSource runat="server" ID="SqlDataSource3" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT [Id], [Img_Id], [Link], [Show_T], [Title], [Remark] FROM [Advertisement] WHERE ([Type] = @Type)" DeleteCommand="DELETE FROM [Advertisement] WHERE [Id] = @Id" InsertCommand="INSERT INTO [Advertisement] ([Img_Id], [Link], [Show_T], [Title], [Remark]) VALUES (@Img_Id, @Link, @Show_T, @Title, @Remark)" UpdateCommand="UPDATE [Advertisement] SET [Img_Id] = @Img_Id, [Link] = @Link, [Show_T] = @Show_T, [Title] = @Title, [Remark] = @Remark WHERE [Id] = @Id">
            <DeleteParameters>
              <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
            </DeleteParameters>
            <InsertParameters>
              <asp:Parameter Name="Img_Id" Type="Int32"></asp:Parameter>
              <asp:Parameter Name="Link" Type="String"></asp:Parameter>
              <asp:Parameter Name="Show_T" Type="Boolean"></asp:Parameter>
              <asp:Parameter Name="Title" Type="String"></asp:Parameter>
              <asp:Parameter Name="Remark" Type="String"></asp:Parameter>
            </InsertParameters>
            <SelectParameters>
              <asp:Parameter DefaultValue="right square" Name="Type" Type="String"></asp:Parameter>
            </SelectParameters>
            <UpdateParameters>
              <asp:Parameter Name="Img_Id" Type="Int32"></asp:Parameter>
              <asp:Parameter Name="Link" Type="String"></asp:Parameter>
              <asp:Parameter Name="Show_T" Type="Boolean"></asp:Parameter>
              <asp:Parameter Name="Title" Type="String"></asp:Parameter>
              <asp:Parameter Name="Remark" Type="String"></asp:Parameter>
              <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
            </UpdateParameters>
          </asp:SqlDataSource>
        </div>
      </div>
      <div class="item">
        <div class="content">

          <div class="header">文章右幅</div>
          <div class="ui middle aligned divided list">
            <div class="item">
              <div class="ui three column grid">
                <asp:ListView ID="ListView4" runat="server" DataSourceID="SqlDataSource4" DataKeyNames="id" OnPreRender="ListView4_PreRender" OnItemUpdating="ListView4_ItemUpdating" OnDataBound="ListView4_DataBound" OnItemDeleting="ListView4_ItemDeleting" InsertItemPosition="FirstItem">
                  <ItemTemplate>
                    <div class="column" style="display: flex;">
                      <div class="ui card medium rectangle center test ad" style="max-width: 100%; display: flex; justify-content: center;" data-text="Medium Rectangle">
                        <div class="blurring dimmable image">
                          <div class="ui inverted center dimmer">
                            <div class="content">
                              <div class="center">
                                <asp:LinkButton ID="select_LB" CssClass="ui primary button" CommandName="Select" runat="server">詳細</asp:LinkButton>
                                <%--<div class="ui primary button">詳細</div>--%>
                              </div>
                            </div>
                          </div>
                          <img src='Image.aspx?Id=<%# Eval("Img_Id") %>'>
                        </div>
                      </div>
                    </div>
                  </ItemTemplate>
                  <SelectedItemTemplate>
                    <div class="column" style="display: flex;">
                      <div class="ui card medium rectangle center test ad" style="max-width: 100%; display: flex; justify-content: center;" data-text="Medium Rectangle">
                        <div class="blurring dimmable image">
                          <div class="ui inverted center dimmer">
                            <div class="content">
                              <div class="center">
                                <asp:LinkButton ID="select_LB" CssClass="ui primary button" CommandName="Select" runat="server">詳細</asp:LinkButton>
                                <%--<div class="ui primary button">詳細</div>--%>
                              </div>
                            </div>
                          </div>
                          <img src='Image.aspx?Id=<%# Eval("Img_Id") %>'>
                        </div>
                      </div>
                    </div>
                    <div class="ui advertise modal">
                      <div class="header">方格廣告(右)詳細</div>
                      <div class="scrolling content">
                        <div class="ui form">
                          <div class="two fields">
                            <div class="field">
                              <label>標題</label>
                              <%# Eval("Title") %>
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
                          <div class="field">
                            <label>備註</label>
                            <span><%# Eval("Remark") %></span>
                          </div>
                        </div>
                      </div>
                      <div class="actions">
                        <asp:LinkButton ID="LinkButton3" CssClass="ui primary button" CommandName="Edit" runat="server">編輯</asp:LinkButton>
                        <asp:LinkButton ID="Delete" CssClass="ui red button" CommandName="Delete" runat="server">刪除</asp:LinkButton>
                        <asp:LinkButton ID="Select_Cancel" CssClass="ui deny button" OnClick="Select_Cancel_Click" runat="server">關閉</asp:LinkButton>
                      </div>
                    </div>
                  </SelectedItemTemplate>
                  <EditItemTemplate>

                    <div class="column" style="display: flex;">
                      <div class="ui card medium rectangle center test ad" style="max-width: 100%; display: flex; justify-content: center;" data-text="Medium Rectangle">
                        <div class="blurring dimmable image">
                          <div class="ui inverted center dimmer">
                            <div class="content">
                              <div class="center">
                                <asp:LinkButton ID="select_LB" CssClass="ui primary button" CommandName="Select" runat="server">詳細</asp:LinkButton>
                                <%--<div class="ui primary button">詳細</div>--%>
                              </div>
                            </div>
                          </div>
                          <img src='Image.aspx?Id=<%# Eval("Img_Id") %>'>
                        </div>
                      </div>
                    </div>

                    <div class="ui advertise modal">
                      <div class="header">方格廣告詳細</div>
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
                                <asp:CheckBox ID="CheckBox2" runat="server" Checked='<%# Eval("Show_T").Equals(true) %>' Text=" " />
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
                            <asp:TextBox ID="TextBox2" runat="server" Text='<%# Eval("Link") %>'></asp:TextBox>
                          </div>
                          <div class="field">
                            <label>廣告圖</label>
                            <asp:FileUpload ID="FileUpload1" runat="server" />
                            <asp:HiddenField ID="HiddenField1" Value='<%# Eval("Img_Id") %>' runat="server" />
                            <img class="ui medium image" src='Image.aspx?Id=<%# Eval("Img_Id") %>' />

                            <div class="ui message">
                              <div class="header">
                                注意事項
                              </div>
                              <li>圖片建議尺寸： 360 x 300px，寬高超過360 x 300px將自動壓縮至360 X 300px，檔案容量不得超過5MB。</li>
                              <li>圖片比例： 6:5，比例不符將無法上傳。</li>
                              <li>圖片格式：JPG,PNG,GIF</li>
                              </ul>
                            </div>
                          </div>
                          <div class="field">
                            <label>備註</label>
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
                  <InsertItemTemplate>
                    <div class="column">
                      <asp:LinkButton ID="New_sidebar_LB" CssClass="ui card medium rectangle center test ad" Style="max-width: 100%; background-color: #545454;" runat="server" OnClick="New_sidebar_LB_Click">
                      <%--<div class="ui card medium rectangle center test ad" data-text="" style="max-width: 100%; cursor: pointer;" onclick="new_advertise()">--%>
                        <i class="plus icon" style="position: absolute; top: 50%; left: 50%; width: 100%; text-align: center; -webkit-transform: translateX(-50%) translateY(-50%); font-weight: 700; transform: translateX(-50%) translateY(-50%); color: #fff; font-size: 3em;"></i>
                      <%--</div>--%>
                      </asp:LinkButton>
                    </div>
                  </InsertItemTemplate>
                </asp:ListView>
                <asp:SqlDataSource runat="server" ID="SqlDataSource4" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT * FROM [Advertisement] WHERE ([Type] = @Type)" DeleteCommand="DELETE FROM [Advertisement] WHERE [Id] = @Id" InsertCommand="INSERT INTO [Advertisement] ([Type], [Img_Id], [Link], [Title], [Show_T], [Upd_Time], [User_Id], [Remark], [odr]) VALUES (@Type, @Img_Id, @Link, @Title, @Show_T, @Upd_Time, @User_Id, @Remark, @odr)" UpdateCommand="UPDATE [Advertisement] SET [Type] = @Type, [Img_Id] = @Img_Id, [Link] = @Link, [Title] = @Title, [Show_T] = @Show_T, [Remark] = @Remark WHERE [Id] = @Id">
                  <DeleteParameters>
                    <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
                  </DeleteParameters>
                  <InsertParameters>
                    <asp:Parameter Name="Type" Type="String"></asp:Parameter>
                    <asp:Parameter Name="Img_Id" Type="Int32"></asp:Parameter>
                    <asp:Parameter Name="Link" Type="String"></asp:Parameter>
                    <asp:Parameter Name="Title" Type="String"></asp:Parameter>
                    <asp:Parameter Name="Show_T" Type="Boolean"></asp:Parameter>
                    <asp:Parameter Name="Upd_Time" Type="DateTime"></asp:Parameter>
                    <asp:Parameter Name="User_Id" Type="Int32"></asp:Parameter>
                    <asp:Parameter Name="Remark" Type="String"></asp:Parameter>
                    <asp:Parameter Name="odr" Type="Int32"></asp:Parameter>
                  </InsertParameters>
                  <SelectParameters>
                    <asp:Parameter DefaultValue="sidebar square" Name="Type" Type="String"></asp:Parameter>
                  </SelectParameters>
                  <UpdateParameters>
                    <asp:Parameter Name="Type" Type="String"></asp:Parameter>
                    <asp:Parameter Name="Img_Id" Type="Int32"></asp:Parameter>
                    <asp:Parameter Name="Link" Type="String"></asp:Parameter>
                    <asp:Parameter Name="Title" Type="String"></asp:Parameter>
                    <asp:Parameter Name="Show_T" Type="Boolean"></asp:Parameter>
                    <asp:Parameter Name="Remark" Type="String"></asp:Parameter>
                    <asp:Parameter Name="Id" Type="Int32"></asp:Parameter>
                  </UpdateParameters>
                </asp:SqlDataSource>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div id="new-ad" class="ui small modal">
    <%--<div class="header">新增網站廣告</div>--%>
    <asp:Label ID="header_L" runat="server" CssClass="header" Text="新增網站廣告"></asp:Label>
    <div class="scrolling content">
      <div class="ui form">
        <div class="two fields">
          <div class="field">
            <label>名稱</label>
            <asp:TextBox ID="title_TB" runat="server" placeholder="title"></asp:TextBox>
          </div>
          <div id="show_title" class="two fields" runat="server" visible="false">
            <%--<div class="field">
              <label>顯示名稱</label>
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
          </div>
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
            <ul id="friend-msg" class="hidden list">
              <li>圖片建議尺寸： 高不超過35px，超過35px將自動按比例壓縮至高35px，檔案容量不得超過5MB。</li>
              <li>圖片比例： 建議比例30:7，高不得大於寬的二分之一。</li>
              <li>圖片格式：JPG,PNG,GIF</li>
            </ul>
            <ul id="lsquare-msg" class="hidden list">
              <li>圖片建議尺寸： 320 x 180px，寬高超過320 x 180px將自動壓縮至320 X 180px，檔案容量不得超過5MB。</li>
              <li>圖片比例： 16:9，比例不符將無法上傳。</li>
              <li>圖片格式：JPG,PNG,GIF</li>
            </ul>
            <ul id="othersquare-msg" class="hidden list">
              <li>圖片建議尺寸： 360 x 300px，寬高超過360 x 300px將自動壓縮至360 X 300px，檔案容量不得超過5MB。</li>
              <li>圖片比例： 6:5，比例不符將無法上傳。</li>
              <li>圖片格式：JPG,PNG,GIF</li>
            </ul>
          </div>
        </div>
        <div class="field">
          <label>備註</label>
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
      <a href="http://pinews.asia" target="_blank" class="long square block">
        <img class="ui medium image" src="https://fomantic-ui.com/images/avatar/large/steve.jpg">
      </a>
    </div>
    <div class="content">
      <div class="header" style="opacity: .7"><span></span><i class="right floated ad icon"></i></div>
      <div class="meta"></div>
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
        if ($('#<%= Type_HF.ClientID %>').val() == "left square" || $('#<%= Type_HF.ClientID %>').val() == "right square") {
          const img = new Image();
          img.onload = function () {
            if (this.width / this.height != 6 / 5) {
              console.log(this.width, this.height, this.width / this.height)
              console.log(this)
              console.log(6, 5, 6 / 5)
              alert('請修正長寬比');
              document.getElementById($el.attr('id')).value = '';
              //$(this).removeAttr('src');
            } else if (this.width > 360 || this.height > 300) {
              alert('注意！圖片寬高超過360 x 300px,上傳後將進行壓縮！');
              $('#' + $el.attr('id') + ' + img').attr('src', url)
            } else {
              console.log($el.attr('id'))
              $('#' + $el.attr('id') + ' + img').attr('src', url)
            }
          }
          img.src = url;
        } else {
          $('#' + $el.attr('id') + ' + img').attr('src', url)
        }
      } else {
        document.getElementById($(this).attr("id")).value = '';
        alert('檔案大小超過5MB!!')
      }
    })

    function previewSetAd(opt) {
      var $img = $('#<%= ads_FU.ClientID %> + img');
      var $link = $('#<%= link_TB.ClientID %>');
      var $title = $('#<%= title_TB.ClientID %>')
      var $content = $('#<%= Remark_TB.ClientID %>')
      var show_dimm = false;
      <%--var $header = $('#<%= title_TB.ClientID %>');
      var header = "";--%>
      if (<%= (ListView3.EditIndex != -1 || ListView3.SelectedIndex != -1) ? "true": "false" %>) {
        if (opt == 'edit') {
          if (<%= ListView3.EditIndex != -1 ? "true": "false" %>) {
            $img = $('#<%= ListView3.EditIndex != -1 ? ListView3.Items[ListView3.EditIndex].FindControl("FileUpload1").ClientID:"" %> + img')
            $link = $('#<%= ListView3.EditIndex != -1 ? ListView3.Items[ListView3.EditIndex].FindControl("TextBox2").ClientID:"" %>')
            $title = $('#<%= ListView2.EditIndex != -1 ? ListView2.Items[ListView2.EditIndex].FindControl("TextBox1").ClientID:"" %>')
            $content = $('#<%= ListView2.EditIndex != -1 ? ListView2.Items[ListView2.EditIndex].FindControl("TextBox3").ClientID:"" %>')
          }
        }
      }
      var link = $link.val();
      //var file = document.getElementById($img.attr("id")).files;
      //var url = URL.createObjectURL(file[0]);
      var url = $img.attr('src');
      var title = $title.val();
      var meta = $content.val();
      if (opt != 'edit' && opt != 'new') {
        url = opt;
        $link = $('#<%= (ListView3.SelectedIndex != -1) ? ListView3.Items[ListView3.SelectedIndex].FindControl("ad_link").ClientID:"" %>')
        $title = $('#<%= (ListView2.EditIndex == -1 && ListView2.SelectedIndex != -1) ? ListView2.Items[ListView2.SelectedIndex].FindControl("title_L").ClientID:"" %>')
        $content = $('#<%= (ListView2.EditIndex == -1 && ListView2.SelectedIndex != -1) ? ListView2.Items[ListView2.SelectedIndex].FindControl("Remark_L").ClientID:"" %>')
        link = $link.attr('href')
        title = $title.html();
        meta = $content.html();
        console.log('<%= ListView2.Items.Count > 0 %>', '<%= ListView2.EditIndex == -1 %>')
      }

      if (<%= (Type_HF.Value == "left square" || Type_HF.Value == "right square") ? "true":"false" %>) {
        show_dimm = true;
        //header = $header.val();
      }
      //$('#preview-ad .image .header').html(header)

      $('#preview-ad img').attr('src', url);
      $('#preview-ad a').attr('href', link)
      $('#preview-ad .content .header span').html(title)
      $('#preview-ad .content .meta').html(meta)
      preview(show_dimm)
    }

    $('.ui.ad .image').dimmer({
      on: 'hover', duration: {
        show: 500,
        hide: 500
      }
    })

    function preview(opt) {
      $('#preview-ad').toast({
        class: 'visible',
        position: 'bottom right',
        // showProgress: 'bottom',
        displayTime: 0,
        // classProgress: 'pink',
        closeIcon: true,
        cloneMode: false,
        onShow: function ($module) {
          console.log($($module))
          if (opt) {
            //$($module).children('.image').children('.dimmer').css('margin-top', -$($module).children('i').height())
            $($module).children('.image').dimmer({
              on: 'hover', duration: {
                show: 500,
                hide: 500
              }
            })
          }
        }
      })
    }
  </script>
</asp:Content>
