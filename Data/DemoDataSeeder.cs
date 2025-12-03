using Microsoft.EntityFrameworkCore;
using PiNewsCore.Models.Reverse;

namespace PiNewsCore.Data
{
    public static class DemoDataSeeder
    {
        public static void SeedDemoData(RemoteDbContext context)
        {
            if (context.Articles.Any()) return;

            context.Banners.AddRange(
                new Banner { Id = 1, Title = "拍新聞歡迎您", Image_Id = 1, Link = "#", active = true, odr = 1 },
                new Banner { Id = 2, Title = "全民創報，百業創聞", Image_Id = 2, Link = "#", active = true, odr = 2 },
                new Banner { Id = 3, Title = "拍出自己的創意新聞", Image_Id = 3, Link = "/OnlinePost", active = true, odr = 3 }
            );

            context.Marquees.AddRange(
                new Marquee { Id = 1, Text = "拍新聞，拍心情，拍美食，拍感動，拍出自己的創意新聞", Link = "#", active = true, odr = 1, Add_Time = DateTime.UtcNow },
                new Marquee { Id = 2, Text = "拍新聞徵求線上創意文稿、圖片、影音，歡迎投稿", Link = "/Account/Login", active = true, odr = 2, Add_Time = DateTime.UtcNow },
                new Marquee { Id = 3, Text = "全民拍起來，繽紛舞色彩", Link = "#", active = true, odr = 3, Add_Time = DateTime.UtcNow }
            );

            context.Articles.AddRange(
                new Article { Id = 1, Title = "新北市板橋觀護協會 支持國旅提振台灣觀光", Content = @"<p>全球疫情衝擊趨緩新北板橋觀護協會，繼去年苗栗秋季旅遊後，再次支持台灣觀光旅遊產業，於4月24日由理事長洪振成率團58人，再度組團發起桃園一日活動，此次行程由執行秘書等人規劃，重點參觀包含郭元益糕餅博物館觀光工廠、埔心牧場園區樂活休閒體驗烤肉活動及餐廳聯誼美食聚會..等。</p><p>隨著COVID-19疫情衝擊，旅遊、觀光、伴手禮、美食餐廳產業顯然是直接且嚴重的受害者，新北板橋觀護協會為了促進會員友誼及用實際行動支持國民旅遊，安排此次桃園一日遊活動。</p>", Author = "拍新聞記者", DateTime = DateTime.UtcNow.AddDays(-1), Status = 1, Category = "1", Relate_Img = "" },
                new Article { Id = 2, Title = "台北市推動智慧城市計畫 打造便利生活圈", Content = @"<p>台北市政府持續推動智慧城市計畫，透過科技創新提升市民生活品質。</p><p>計畫包含智慧交通、智慧醫療、智慧教育等多個面向，期望打造更便利的城市生活圈。</p>", Author = "城市組", DateTime = DateTime.UtcNow.AddDays(-2), Status = 1, Category = "1", Relate_Img = "" },
                new Article { Id = 3, Title = "全球氣候峰會達成重要共識 各國承諾減碳目標", Content = @"<p>聯合國氣候變遷大會在經過激烈討論後，各國代表終於達成重要共識。</p><p>主要工業國家承諾在2030年前將碳排放量減少至少50%，並承諾提供資金協助開發中國家發展綠能。</p>", Author = "國際組", DateTime = DateTime.UtcNow.AddDays(-1), Status = 1, Category = "2", Relate_Img = "" },
                new Article { Id = 4, Title = "美國科技巨頭推出創新產品 引領產業新趨勢", Content = @"<p>美國科技公司在年度大會上發表多項創新產品，包括新一代人工智慧助理和虛擬實境設備。</p><p>新產品整合了最新的AI技術，提供更智慧、更人性化的使用體驗。</p>", Author = "科技組", DateTime = DateTime.UtcNow.AddDays(-3), Status = 1, Category = "2", Relate_Img = "" },
                new Article { Id = 5, Title = "兩岸文化交流持續深化 增進民眾相互理解", Content = @"<p>兩岸文化交流活動持續舉辦，透過藝術、音樂、戲劇等多元形式，增進兩岸民眾的相互理解。</p><p>本次文化周活動包含書畫展覽、傳統戲曲表演、民俗文化體驗等，吸引大批民眾參與。</p>", Author = "兩岸組", DateTime = DateTime.UtcNow.AddDays(-2), Status = 1, Category = "3", Relate_Img = "" },
                new Article { Id = 6, Title = "台股突破萬八大關 投資人信心回升", Content = @"<p>台灣股市在科技股帶動下，加權指數突破18000點大關，創下歷史新高。</p><p>分析師指出，受惠於半導體產業持續成長，以及外資回流，台股表現亮眼。</p>", Author = "財經組", DateTime = DateTime.UtcNow.AddHours(-12), Status = 1, Category = "4", Relate_Img = "" },
                new Article { Id = 7, Title = "央行宣布維持利率不變 持續觀察經濟情勢", Content = @"<p>中央銀行理事會決議維持政策利率不變，重貼現率續為1.375%。</p><p>央行總裁表示，將持續密切關注國內外經濟金融情勢發展，適時調整貨幣政策。</p>", Author = "金融組", DateTime = DateTime.UtcNow.AddDays(-1), Status = 1, Category = "4", Relate_Img = "" },
                new Article { Id = 8, Title = "慈善團體發起冬季送暖活動 關懷弱勢家庭", Content = @"<p>隨著冬季來臨，多個慈善團體聯合發起送暖活動，為弱勢家庭提供物資和關懷。</p><p>活動包含發放禦寒衣物、食物包、以及提供免費健康檢查等服務。</p>", Author = "公益組", DateTime = DateTime.UtcNow.AddDays(-3), Status = 1, Category = "5", Relate_Img = "" },
                new Article { Id = 9, Title = "青年創業家分享成功經驗 鼓勵年輕人勇敢追夢", Content = @"<p>年僅30歲的科技創業家在講座中分享創業歷程，鼓勵年輕人勇敢追求夢想。</p><p>他表示，創業路上雖然充滿挑戰，但只要堅持理念、不斷學習，就能克服困難。</p>", Author = "人物組", DateTime = DateTime.UtcNow.AddDays(-4), Status = 1, Category = "6", Relate_Img = "" },
                new Article { Id = 10, Title = "健康飲食觀念抬頭 有機食品市場持續成長", Content = @"<p>現代人越來越重視健康飲食，有機食品、天然食材備受青睞。</p><p>營養師建議，均衡飲食搭配適度運動，才是維持健康的不二法門。</p>", Author = "生活組", DateTime = DateTime.UtcNow.AddDays(-5), Status = 1, Category = "7", Relate_Img = "" },
                new Article { Id = 11, Title = "台灣離島旅遊正夯 澎湖花火節吸引大批遊客", Content = @"<p>台灣離島旅遊熱度持續攀升，澎湖花火節成為最受歡迎的旅遊景點之一。</p><p>絢爛的煙火搭配海洋美景，讓遊客留下深刻印象。</p>", Author = "旅遊組", DateTime = DateTime.UtcNow.AddDays(-6), Status = 1, Category = "8", Relate_Img = "" },
                new Article { Id = 12, Title = "台灣小吃揚名國際 米其林推薦名單出爐", Content = @"<p>米其林指南公布台灣版推薦名單，多家小吃攤位獲得肯定，再次證明台灣美食的魅力。</p><p>從傳統滷肉飯到創意料理，台灣美食文化豐富多元。</p>", Author = "美食組", DateTime = DateTime.UtcNow.AddDays(-7), Status = 1, Category = "9", Relate_Img = "" },
                new Article { Id = 13, Title = "台積電宣布擴大投資 持續鞏固半導體領先地位", Content = @"<p>台積電宣布在台灣投資數千億元，興建新世代晶圓廠，持續鞏固全球半導體產業領先地位。</p><p>董事長表示，台灣擁有完整的半導體產業鏈，是公司最重要的研發與製造基地。</p>", Author = "企業組", DateTime = DateTime.UtcNow.AddDays(-8), Status = 1, Category = "11", Relate_Img = "" },
                new Article { Id = 14, Title = "教育部推動雙語教育 提升學生國際競爭力", Content = @"<p>教育部積極推動雙語教育政策，希望提升學生的語言能力和國際競爭力。</p><p>政策包含增加英語教學時數、培訓雙語師資、以及建置數位學習平台等。</p>", Author = "教育組", DateTime = DateTime.UtcNow.AddDays(-9), Status = 1, Category = "24", Relate_Img = "" },
                new Article { Id = 15, Title = "大學推動產學合作 培育產業所需人才", Content = @"<p>多所大學與企業簽署產學合作協議，共同培育產業所需的專業人才。</p><p>合作內容包括實習計畫、企業導師制度、以及共同開發研究專案等。</p>", Author = "教育組", DateTime = DateTime.UtcNow.AddDays(-10), Status = 1, Category = "24", Relate_Img = "" }
            );

            context.Members.Add(new Member { Id = 1, Name = "測試會員", Id_number = "A123456789", Password = "test123", Phone = "0912345678", Register_Time = DateTime.UtcNow.AddMonths(-1), Certification = true });
            context.Members.Add(new Member { Id = 2, Name = "測試用戶", Id_number = "K0963822225", Password = "aaa0963822225", Phone = "0963822225", Register_Time = DateTime.UtcNow.AddMonths(-1), Certification = true });

            context.SaveChanges();
        }
    }
}
