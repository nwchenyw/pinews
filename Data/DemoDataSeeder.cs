using Microsoft.EntityFrameworkCore;
using PiNewsCore.Models.Reverse;

namespace PiNewsCore.Data
{
    /// <summary>
    /// Service to seed demo data for testing and UI preview
    /// </summary>
    public static class DemoDataSeeder
    {
        public static void SeedDemoData(RemoteDbContext context)
        {
            // Only seed if database is empty
            if (context.Articles.Any())
            {
                return;
            }

            // Add demo banners
            var banners = new List<Banner>
            {
                new Banner
                {
                    Id = 1,
                    Title = "拍新聞歡迎您",
                    Image_Id = 1,
                    Link = "#",
                    active = true,
                    odr = 1
                },
                new Banner
                {
                    Id = 2,
                    Title = "全民創報，百業創聞",
                    Image_Id = 2,
                    Link = "#",
                    active = true,
                    odr = 2
                }
            };
            context.Banners.AddRange(banners);

            // Add demo marquees
            var marquees = new List<Marquee>
            {
                new Marquee
                {
                    Id = 1,
                    Text = "拍新聞，拍心情，拍美食，拍感動，拍出自己的創意新聞",
                    Link = "#",
                    active = true,
                    odr = 1,
                    Add_Time = DateTime.UtcNow
                },
                new Marquee
                {
                    Id = 2,
                    Text = "拍新聞徵求線上創意文稿、圖片、影音，歡迎投稿",
                    Link = "/Account/Login",
                    active = true,
                    odr = 2,
                    Add_Time = DateTime.UtcNow
                },
                new Marquee
                {
                    Id = 3,
                    Text = "全民拍起來，繽紛舞色彩",
                    Link = "#",
                    active = true,
                    odr = 3,
                    Add_Time = DateTime.UtcNow
                }
            };
            context.Marquees.AddRange(marquees);

            // Add demo articles
            var articles = new List<Article>
            {
                new Article
                {
                    Id = 1,
                    Title = "新北市板橋觀護協會 支持國旅提振台灣觀光",
                    Content = @"<p>全球疫情衝擊趨緩新北板橋觀護協會，繼去年苗栗秋季旅遊後，再次支持台灣觀光旅遊產業，於4月24日由理事長洪振成率團58人，再度組團發起桃園一日活動，此次行程由執行秘書等人規劃，重點參觀包含郭元益糕餅博物館觀光工廠、埔心牧場園區樂活休閒體驗烤肉活動及餐廳聯誼美食聚會..等。</p>
<p>隨著COVID-19疫情衝擊，旅遊、觀光、伴手禮、美食餐廳產業顯然是直接且嚴重的受害者，新北板橋觀護協會為了促進會員友誼及用實際行動支持國民旅遊，安排此次桃園一日遊活動。</p>",
                    Author = "拍新聞記者",
                    DateTime = DateTime.UtcNow.AddDays(-1),
                    Status = 1,
                    Relate_Img = "http://www.pinews.com.tw/upload/post/images/120210427150639.JPG"
                },
                new Article
                {
                    Id = 2,
                    Title = "台灣文化創意產業蓬勃發展",
                    Content = @"<p>台灣文化創意產業近年來蓬勃發展，從電影、音樂到設計，都展現出驚人的創造力。</p>
<p>政府也持續推動相關政策，協助文創業者發展。</p>",
                    Author = "文化組",
                    DateTime = DateTime.UtcNow.AddDays(-2),
                    Status = 1,
                    Relate_Img = ""
                },
                new Article
                {
                    Id = 3,
                    Title = "環保永續成為企業新顯學",
                    Content = @"<p>隨著全球暖化日益嚴重，越來越多企業開始重視環保永續議題。</p>
<p>許多企業紛紛提出碳中和目標，展現對環境保護的承諾。</p>",
                    Author = "環境組",
                    DateTime = DateTime.UtcNow.AddDays(-3),
                    Status = 1,
                    Relate_Img = ""
                },
                new Article
                {
                    Id = 4,
                    Title = "科技創新帶動產業轉型",
                    Content = @"<p>人工智慧、物聯網等新興科技快速發展，正在改變各行各業的運作模式。</p>
<p>企業必須及早因應，才能在數位轉型浪潮中保持競爭力。</p>",
                    Author = "科技組",
                    DateTime = DateTime.UtcNow.AddDays(-4),
                    Status = 1,
                    Relate_Img = ""
                },
                new Article
                {
                    Id = 5,
                    Title = "健康飲食觀念抬頭",
                    Content = @"<p>現代人越來越重視健康飲食，有機食品、天然食材備受青睞。</p>
<p>營養師建議，均衡飲食搭配適度運動，才是維持健康的不二法門。</p>",
                    Author = "生活組",
                    DateTime = DateTime.UtcNow.AddDays(-5),
                    Status = 1,
                    Relate_Img = ""
                }
            };
            context.Articles.AddRange(articles);

            // Add demo member for testing
            var member = new Member
            {
                Id = 1,
                Name = "測試會員",
                Id_number = "A123456789",
                Password = "test123", // Note: Plain text for demo only
                Phone = "0912345678",
                Register_Time = DateTime.UtcNow.AddMonths(-1),
                Certification = true
            };
            context.Members.Add(member);

            context.SaveChanges();
        }
    }
}
