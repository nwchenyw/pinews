<%@ Page Title="" Language="C#" MasterPageFile="ClientPage.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="piNews.Default" %>
<%@ OutputCache Duration="300" VaryByParam="none" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@splidejs/splide@latest/dist/css/splide.min.css">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@splidejs/splide-extension-video@latest/dist/css/splide-extension-video.min.css">
	<meta id="keyword" runat="server" name="keywords" content="拍新聞" />
	<style>
		#broadcast .anime-text:hover {
			animation-play-state: paused;
		}

		.splide__slide .splide__video iframe {
			margin: 0 auto;
			display: block;
			width: 100%;
			height: 100%;
		}

		.splide__slide .splide__video div {
			width: 100%;
			height: 100%;
		}

		@media screen and (max-width: 767.98px) {
			#main .splide .splide__slide {
				font-size: 14px !important;
			}
		}

		@media screen and (max-width: 425px) {
			#main .splide .splide__slide h1 {
				font-size: 1.2rem !important;
			}
		}

		@media screen and (max-width: 375px) {
			#main .container {
				margin: 0;
			}
		}

		@media screen and (max-width: 320px) {
			#main {
				margin: 0;
			}

			.pusher .segment+.container {
				margin: 0 !important;
			}
		}

		/* 新增載入優化 */
		.img-responsive {
			max-width: 100%;
			height: auto;
		}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
	<span></span>
	<div id="broadcast" class="ui feed container">
		<div class="event">
			<div class="label" style="position: relative;">
				<i class="bullhorn icon"></i>
				<i class="clockwise rotated wifi icon" style="top: 4px; position: absolute; right: -27px;"></i>
			</div>
			<div class="content">
				<asp:Repeater ID="Repeater3" runat="server" DataSourceID="SqlDataSource4">
					<ItemTemplate>
						<p class="anime-text hidden">
							<a href='<%# DBNull.Value.Equals(Eval("Link")) ? "#":Eval("Link") %>' <%# string.Format("style='color:{0}; font-family: {1}; font-size: {2}; font-weight: {3};'",DBNull.Value.Equals(Eval("color")) ? "":Eval("color"),DBNull.Value.Equals(Eval("font_name")) ? "":Eval("font_name"), DBNull.Value.Equals(Eval("font_size")) ? "":Eval("font_size"), Eval("font_weight")) %>><%# Eval("Text") %></a>
						</p>
					</ItemTemplate>
				</asp:Repeater>
				<asp:SqlDataSource runat="server" ID="SqlDataSource4" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT * FROM [Marquee] where active = 1 ORDER BY [odr]"></asp:SqlDataSource>
			</div>
		</div>
	</div>
	<div id="main" class="ui container">
		<div class="splide left-show ui container">
			<div class="splide__track">
				<ul class="splide__list">
					<asp:Repeater ID="Repeater2" runat="server" DataSourceID="SqlDataSource3">
						<ItemTemplate>
							<li class="splide__slide" <%# Eval("isVideo").Equals(true) ? string.Format("data-splide-{0}='{1}'", Eval("Video_type"), Eval("Video_type").Equals("youtube") ? "https://www.youtube.com/watch?v="+Eval("Video_url"):"https://vimeo.com/"+Eval("Video_url")):"" %> data-font-size='<%# DBNull.Value.Equals( Eval("font_size")) ? "inherit":Eval("font_size") %>' <%# string.Format("style='{0};'", DBNull.Value.Equals( Eval("font_size")) ? "inherit":"font-size: "+Eval("font_size")) %> <%# Eval("Video_type").Equals("vimeo") ? "data-bg-fn='loadDoc'":"" %> <%# Eval("Video_type").Equals("vimeo") ? string.Format("data-bg-val='{0}'", Eval("Video_url")):"" %>>
								<a class="splide__slide__container" href='<%# Eval("Link") %>' target="_blank">
									<img id='<%# Eval("Video_type").Equals("vimeo") ? "vimeo-"+Eval("Video_url"):"" %>' src='<%# Eval("isVideo").Equals(true) ? (Eval("Video_type").Equals("youtube") ? string.Format("https://img.youtube.com/vi/{0}/hqdefault.jpg", Eval("Video_url")):""): string.Format("Image.aspx?ID={0}", Eval("Image_Id")) %>' alt='<%# Eval("Title") %>' />
								</a>
								<a href='<%# Eval("Link") %>' target="_blank">
									<h1 class="ui huge header" <%# string.Format("style='font-family: {0}; color: {1};'", 
  DBNull.Value.Equals( Eval("font_name")) ? "inherit":Eval("font_name"), 
  DBNull.Value.Equals( Eval("color")) ? "inherit":Eval("color")) %>><%# Eval("Title") %></h1>
								</a>
								<script>
									function loadDoc(id) {
										$('.splide__slide__container:has(#vimeo-<%# Eval("Video_url") %>) script').remove()
										const xhttp = new XMLHttpRequest();
										xhttp.onload = function() {
											if ( <%# Eval("Video_type").Equals("vimeo") ? "true" : "false" %> ) {
												$('.splide__slide__container:has(#vimeo-<%# Eval("Video_url") %>)').append($('<script />', {
													html: this.responseText
												}))
											}
										}
										xhttp.open("GET", "//vimeo.com/api/v2/video/" + id + ".json?callback=showThumb");
										xhttp.send();
									}

									function showThumb(data) {
										var id_img = '#vimeo-' + data[0].id;
										$(id_img).attr('src', data[0].thumbnail_large);
										console.log(id_img)
										$('.splide__slide__container:has(#vimeo-<%# Eval("Video_url") %>)').css('background', 'url("' + data[0].thumbnail_large + '")')
										$('.splide__slide__container:has(#vimeo-<%# Eval("Video_url") %>)').css('background-repeat', 'no-repeat')
										$('.splide__slide__container:has(#vimeo-<%# Eval("Video_url") %>)').css('background-size', 'cover')
									}

									<%# Eval("Video_type").Equals("vimeo") ? string.Format("loadDoc({0});", Eval("Video_url")) : "" %>
								</script>
							</li>
						</ItemTemplate>
					</asp:Repeater>
					<asp:SqlDataSource runat="server" ID="SqlDataSource3" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT Image_Id, Title, Link, font_size, font_name, color, isVideo, Video_type, Video_url FROM Banner WHERE (active = 1) ORDER BY odr" EnableCaching="true" CacheDuration="300"></asp:SqlDataSource>
				</ul>
			</div>
			<div class="splide__progress">
				<div class="splide__progress__bar">
				</div>
			</div>
		</div>
		<div class="ui pv-4 container">
			<asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSource1" OnItemDataBound="Repeater1_ItemDataBound">
				<ItemTemplate>
					<h2><a href='<%# Eval("Art_Odr_Duration").Equals(DBNull.Value) ? Eval("Art_Grouping").Equals("all_article") ? 
                  string.Format("/News/all/{0}/time", Eval("Id")): (Eval("Art_Odr_Type").Equals("time")||Eval("Art_Odr_Type").Equals(DBNull.Value) ? 
              string.Format("/News/{0}/{1}/time", Eval("Art_Grouping").Equals(DBNull.Value) ? "cat":Eval("Art_Grouping"), Eval("Id")):"#"
              ):string.Format("/News/{0}/{1}/{2}/{3}", Eval("Art_Grouping"), Eval("Id"), Eval("Art_Odr_Duration"), Eval("Art_Odr_Type")) %>' <%# string.Format("style='color: {0}; font-family: {1};'", Eval("font_color"), Eval("font_name")) %>><%# Eval("Category_Name") %></a></h2>
					<div class="top-show ui four cards">
						<asp:Repeater ID="ChildRepeater" runat="server" DataSourceID="SqlDataSource2">
							<ItemTemplate>
								<a class="ui raised link card" href='News/Info/<%# Eval("Id") %>'>
									<div class="image">
										<div class="long square">
											<img src='Image.aspx?ID=<%# Eval("Front_Img_Id") %>' alt='<%# Eval("Title") %>'>
										</div>
									</div>
									<div class="squeeze content">
										<div class="header"><%# Eval("Title") %></div>
									</div>
									<div class="extra content">
										<div class="left floated author">
											<img class="ui avatar image" src='Image.aspx?ID=<%# Eval("Member_Img_Id") %>' alt='<%# Eval("Author") %>'>
											<%# Eval("Author") %>
										</div>
										<div class="bottom right floated author post-time">
											<div class="meta">
												<i class="calendar icon"></i>
												<span class="category"><%# Eval("t") %></span>
											</div>
										</div>
									</div>
								</a>
							</ItemTemplate>
						</asp:Repeater>
						<asp:Label ID="lblMsg" runat="server" Text="尚無文章上榜" Visible="false"></asp:Label>
					</div>
					<asp:SqlDataSource runat="server" ID="SqlDataSource2" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="select top 4 a.Id, a.Title, format(a.DateTime, 'yyyy/MM/dd tthh:mm') AS t, case m.isAdmin when 1 then a.Author else '拍新聞聯合採訪中心' end as Author, a.Author_Email, a.Front_Img_Id, m.Member_Img_Id From Article As a Left Join Member As m On m.UserId = a.Author_Email left join Article_Rec_Cat arc on arc.Article_id = a.Id Where arc.Rec_cat_id = @Recommand_Category And a.Status = 1 ORDER BY a.DateTime DESC" EnableCaching="true" CacheDuration="300">
						<SelectParameters>
							<asp:Parameter Name="Recommand_Category" Type="String"></asp:Parameter>
						</SelectParameters>
					</asp:SqlDataSource>
				</ItemTemplate>
			</asp:Repeater>
		</div>
		<div id="advertise" class="ui doubling pv-4 three column grid">
			<asp:Repeater ID="Repeater4" runat="server" DataSourceID="SqlDataSource5">
				<ItemTemplate>
					<div class="middle aligned column">
						<a href='<%# Eval("Link") %>' target="_blank">
							<img class="img-responsive" src='Image.aspx?Id=<%# Eval("img_Id") %>' alt="廣告">
						</a>
					</div>
				</ItemTemplate>
			</asp:Repeater>
			<asp:SqlDataSource runat="server" ID="SqlDataSource5" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT [Img_Id], [Link] FROM [Advertisement] WHERE ([Type] = @Type)" EnableCaching="true" CacheDuration="600">
				<SelectParameters>
					<asp:Parameter DefaultValue="long square" Name="Type" Type="String"></asp:Parameter>
				</SelectParameters>
			</asp:SqlDataSource>
		</div>
		<asp:Repeater ID="Repeater5" runat="server" DataSourceID="SqlDataSource6">
			<ItemTemplate>
				<div id="right-banner" class="ui toast card medium rectangle test ad" data-show-title='<%# Eval("Show_T").Equals(true) ? "true":"false" %>' style="padding: 0;">
					<i class="right floated inverted close icon" style="margin: .2rem; z-index: 1;"></i>
					<a class='<%# Eval("Show_T").Equals(true)?"blurring dimmable ":"" %>image' href='<%# Eval("link") %>' target="_blank">
						<div class="ui inverted center dimmer">
							<div class="content">
								<div class="center">
									<div class="ui header"><%# Eval("Title") %></div>
								</div>
							</div>
						</div>
						<img class="ui medium image" src='Image.aspx?Id=<%# Eval("Img_Id") %>' alt='<%# Eval("Title") %>'>
					</a>
				</div>
			</ItemTemplate>
		</asp:Repeater>
		<asp:SqlDataSource runat="server" ID="SqlDataSource6" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT Top 1 Link, Show_T, Title, Img_Id FROM [Advertisement] WHERE ([Type] = @Type)" EnableCaching="true" CacheDuration="600">
			<SelectParameters>
				<asp:Parameter DefaultValue="left square" Name="Type" Type="String"></asp:Parameter>
			</SelectParameters>
		</asp:SqlDataSource>
	</div>

	<!-- 優化的 JavaScript 載入 -->
	<script src="https://cdn.jsdelivr.net/npm/@splidejs/splide@2.4.14/dist/js/splide.min.js" defer></script>
	<script src="https://cdn.jsdelivr.net/npm/@splidejs/splide-extension-video@0.4.1/dist/js/splide-extension-video.min.js" defer></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.9/jquery.lazy.min.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.9/jquery.lazy.plugins.min.js"></script>

	<script defer>
		$(window).on('load', function() {
			// 確保 Video extension 可用
			const {
				Video
			} = window.splide.Extensions || {};
			// Toast 通知優化
			if ( <%= Repeater5.Items.Count > 0 ? "true" : "false" %> ) {
				$('#right-banner').toast({
					class: 'visible',
					position: 'bottom right',
					displayTime: 0,
					closeIcon: true,
					cloneMode: false,
					onShow: function($module) {
						if ($($module).data('show-title') == true) {
							$($module).children('.image').dimmer({
								on: 'hover',
								duration: {
									show: 500,
									hide: 500
								}
							})
						}
					}
				});
			}

			// 優化的 Splide 設定 - 使用與原版相同配置
			console.log('Initializing Banner Splide...');
			var banner_splide = new Splide('.splide', {
				type: 'loop',
				autoplay: true,
				interval: 4000,
				speed: 800,
				pauseOnHover: true,
				pagination: false,
				heightRatio: 5 / 16,
				lazyLoad: 'nearby',
				cover: true,
				video: {
					autoplay: true,
					loop: true,
					hideControls: true,
					playerOptions: {
						youtube: {
							rel: 0,
							autoplay: 1,
							loop: 1,
							mute: 1,
							autohide: 1,
							showinfo: 0,
							controls: 0,
							modestbranding: 1
						},
					}
				}
			}).on('active', function(s) {
				console.log('Active slide:', $(s.slide));
				var fn = $(s.slide).attr('data-bg-fn')
				var val = $(s.slide).attr('data-bg-val')

				if (fn && val) {
					window[fn](val)
				}
				var $btn = $(s.slide).children('.splide__slide__container').children('button.splide__video__play')
				if (!$btn.is("[type=button]"))
					$(s.slide).children('.splide__slide__container').children('button.splide__video__play').attr('type', 'button')
			}).mount(Video ? {
				Video
			} : {});
			console.log('Banner Splide mounted successfully');

			// 啟動輪播並加入調試
			banner_splide.on('ready', function() {
				console.log('Splide is ready, total slides:', banner_splide.length);
			});

			banner_splide.on('moved', function(index) {
				console.log('Moved to slide:', index);
			});

			// 初始化 lazy loading
			$('.lazy').Lazy();
		});
	</script>
	<asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:PiNewsConStr %>' SelectCommand="SELECT * FROM [Recommendation] ORDER BY [Cat_Order]" EnableCaching="true" CacheDuration="300"></asp:SqlDataSource>
</asp:Content>