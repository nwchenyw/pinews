using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PiNewsCore.Models.Reverse;
using System.Diagnostics;

namespace PiNewsCore.Controllers
{
    public class HomeController : Controller
    {
        private readonly RemoteDbContext _remoteDb;
        private readonly ILogger<HomeController> _logger;

        public HomeController(RemoteDbContext remoteDb, ILogger<HomeController> logger)
        {
            _remoteDb = remoteDb;
            _logger = logger;
        }

        public async Task<IActionResult> Index()
        {
            try
            {
                var overallStopwatch = Stopwatch.StartNew();
                var stopwatch = new Stopwatch();

                // 改為順序執行以確保連接穩定性
                // 稍後可再次優化為並行查詢

                // 1. Banners
                stopwatch.Restart();
                var banners = await _remoteDb.Banners
                    .Where(b => b.active == true)
                    .OrderBy(b => b.odr)
                    .AsNoTracking()
                    .ToListAsync();
                stopwatch.Stop();
                _logger.LogInformation($"[性能] Banners 查詢耗時: {stopwatch.ElapsedMilliseconds}ms");

                // 2. Marquees
                stopwatch.Restart();
                var marquees = await _remoteDb.Marquees
                    .Where(m => m.active == true)
                    .OrderBy(m => m.odr)
                    .AsNoTracking()
                    .ToListAsync();
                stopwatch.Stop();
                _logger.LogInformation($"[性能] Marquees 查詢耗時: {stopwatch.ElapsedMilliseconds}ms");

                // 3. Recommendations
                stopwatch.Restart();
                var recommendations = await _remoteDb.Recommendations
                    .OrderBy(r => r.Cat_Order)
                    .AsNoTracking()
                    .ToListAsync();
                stopwatch.Stop();
                _logger.LogInformation($"[性能] Recommendations 查詢耗時: {stopwatch.ElapsedMilliseconds}ms");

                // 4. LongSquareAds
                stopwatch.Restart();
                var longSquareAds = await _remoteDb.Advertisements
                    .Where(a => a.Type == "long square")
                    .AsNoTracking()
                    .ToListAsync();
                stopwatch.Stop();
                _logger.LogInformation($"[性能] LongSquareAds 查詢耗時: {stopwatch.ElapsedMilliseconds}ms");

                // 5. LeftSquareAd
                stopwatch.Restart();
                var leftSquareAd = await _remoteDb.Advertisements
                    .Where(a => a.Type == "left square")
                    .AsNoTracking()
                    .FirstOrDefaultAsync();
                stopwatch.Stop();
                _logger.LogInformation($"[性能] LeftSquareAd 查詢耗時: {stopwatch.ElapsedMilliseconds}ms");

                // 6. 獲取推薦分類文章
                stopwatch.Restart();
                var recommendationIds = recommendations.Select(r => r.Id).ToList();
                _logger.LogInformation($"[診斷] Recommendation IDs: {string.Join(", ", recommendationIds)}");

                var allRecommendationArticles = await GetArticlesForRecommendations(recommendationIds, 4);
                _logger.LogInformation($"[診斷] 總共獲取 {allRecommendationArticles.Count} 篇文章");

                var recommendationArticles = new Dictionary<int, List<ArticleViewModel>>();
                foreach (var rec in recommendations)
                {
                    var recArticles = allRecommendationArticles
                        .Where(a => a.RecommendationCategoryId == rec.Id)
                        .Take(4)
                        .ToList();
                    recommendationArticles[rec.Id] = recArticles;

                    if (recArticles.Any())
                    {
                        _logger.LogInformation($"[診斷] 分類 {rec.Id} ({rec.Category_Name}): {recArticles.Count} 篇, 最新: {recArticles.First().DateTime:yyyy/MM/dd HH:mm}");
                    }
                    else
                    {
                        _logger.LogWarning($"[診斷] 分類 {rec.Id} ({rec.Category_Name}): 無文章");
                    }
                }
                stopwatch.Stop();
                _logger.LogInformation($"[性能] RecommendationArticles 查詢耗時: {stopwatch.ElapsedMilliseconds}ms");

                overallStopwatch.Stop();
                _logger.LogInformation($"[性能] Index 頁面總耗時: {overallStopwatch.ElapsedMilliseconds}ms (順序執行版本)");

                ViewData["Banners"] = banners;
                ViewData["Marquees"] = marquees;
                ViewData["Recommendations"] = recommendations;
                ViewData["RecommendationArticles"] = recommendationArticles;
                ViewData["LongSquareAds"] = longSquareAds;
                ViewData["LeftSquareAd"] = leftSquareAd;

                return View();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error querying data for Index page");

                string errorDetails = ex.Message;
                if (ex.InnerException != null)
                {
                    errorDetails += $" | Inner: {ex.InnerException.Message}";
                }

                _logger.LogError($"[診斷] 完整錯誤: {errorDetails}");

                ViewData["DbError"] = $"資料庫連接錯誤: {errorDetails}";
                ViewData["Banners"] = new List<Banner>();
                ViewData["Marquees"] = new List<Marquee>();
                ViewData["Recommendations"] = new List<Recommendation>();
                ViewData["RecommendationArticles"] = new Dictionary<int, List<ArticleViewModel>>();
                ViewData["LongSquareAds"] = new List<Advertisement>();
                ViewData["LeftSquareAd"] = null;
                return View();
            }
        }

        private async Task<List<ArticleViewModel>> GetArticlesForRecommendation(int recCatId, int take)
        {
            // 對應舊專案 SQL:
            // select top 4 a.Id, a.Title, format(a.DateTime, 'yyyy/MM/dd tthh:mm') AS t, 
            // case m.isAdmin when 1 then a.Author else '拍新聞聯合採訪中心' end as Author, 
            // a.Author_Email, a.Front_Img_Id, m.Member_Img_Id 
            // From Article As a 
            // Left Join Member As m On m.UserId = a.Author_Email 
            // left join Article_Rec_Cat arc on arc.Article_id = a.Id 
            // Where arc.Rec_cat_id = @Recommand_Category And a.Status = 1 
            // ORDER BY a.DateTime DESC

            var query = from a in _remoteDb.Articles
                        join arc in _remoteDb.Article_Rec_Cats on a.Id equals arc.Article_id
                        join m in _remoteDb.Members on a.Author_Email equals m.UserId into memberJoin
                        from m in memberJoin.DefaultIfEmpty()
                        where arc.Rec_cat_id == recCatId && a.Status == 1
                        orderby a.DateTime descending
                        select new ArticleViewModel
                        {
                            Id = a.Id,
                            Title = a.Title ?? "",
                            DateTime = a.DateTime,
                            Author = m != null && m.IsAdmin == true ? (a.Author ?? "拍新聞") : "拍新聞聯合採訪中心",
                            Author_Email = a.Author_Email,
                            Front_Img_Id = a.Front_Img_Id,
                            Member_Img_Id = m != null ? m.Member_Img_Id : null
                        };

            return await query.Take(take).ToListAsync();
        }

        /// <summary>
        /// 批量獲取多個推薦分類的文章
        /// </summary>
        private async Task<List<ArticleViewModel>> GetArticlesForRecommendations(List<int> recCatIds, int take)
        {
            if (!recCatIds.Any())
                return new List<ArticleViewModel>();

            var result = new List<ArticleViewModel>();

            // 逐一查詢每個推薦分類，避免 OPENJSON 問題（舊版 SQL Server 不支援）
            foreach (var recCatId in recCatIds)
            {
                // 先獲取該分類的設定
                var rec = await _remoteDb.Recommendations
                    .Where(r => r.Id == recCatId)
                    .AsNoTracking()
                    .FirstOrDefaultAsync();

                if (rec == null) continue;

                List<ArticleViewModel> articles;

                // 根據 Art_Grouping 使用不同的查詢邏輯
                if (rec.Art_Grouping == "all_article")
                {
                    // 「全部文章」模式：直接從 Article 表取最新文章，不需要 Article_Rec_Cat 關聯
                    articles = await (from a in _remoteDb.Articles
                                      join m in _remoteDb.Members on a.Author_Email equals m.UserId into memberJoin
                                      from m in memberJoin.DefaultIfEmpty()
                                      where a.Status == 1
                                      orderby a.DateTime descending
                                      select new ArticleViewModel
                                      {
                                          Id = a.Id,
                                          Title = a.Title ?? "",
                                          DateTime = a.DateTime,
                                          Author = m != null && m.IsAdmin == true ? (a.Author ?? "拍新聞") : "拍新聞聯合採訪中心",
                                          Author_Email = a.Author_Email,
                                          Front_Img_Id = a.Front_Img_Id,
                                          Member_Img_Id = m != null ? m.Member_Img_Id : null,
                                          RecommendationCategoryId = rec.Id
                                      })
                        .Take(take)
                        .AsNoTracking()
                        .ToListAsync();
                }
                else
                {
                    // 其他模式：需要 Article_Rec_Cat 關聯
                    articles = await (from a in _remoteDb.Articles
                                      join arc in _remoteDb.Article_Rec_Cats on a.Id equals arc.Article_id
                                      join m in _remoteDb.Members on a.Author_Email equals m.UserId into memberJoin
                                      from m in memberJoin.DefaultIfEmpty()
                                      where arc.Rec_cat_id == rec.Id && a.Status == 1
                                      orderby a.DateTime descending
                                      select new ArticleViewModel
                                      {
                                          Id = a.Id,
                                          Title = a.Title ?? "",
                                          DateTime = a.DateTime,
                                          Author = m != null && m.IsAdmin == true ? (a.Author ?? "拍新聞") : "拍新聞聯合採訪中心",
                                          Author_Email = a.Author_Email,
                                          Front_Img_Id = a.Front_Img_Id,
                                          Member_Img_Id = m != null ? m.Member_Img_Id : null,
                                          RecommendationCategoryId = rec.Id
                                      })
                        .Take(take)
                        .AsNoTracking()
                        .ToListAsync();
                }

                _logger.LogInformation($"[診斷] 分類 {rec.Id} ({rec.Category_Name}), Art_Grouping={rec.Art_Grouping}: 獲取 {articles.Count} 篇");
                result.AddRange(articles);
            }

            return result;
        }

        /// <summary>
        /// 獲取推薦分類頁面的連結
        /// </summary>
        public static string GetRecommendationLink(Recommendation rec)
        {
            if (rec.Art_Grouping == "all_article")
            {
                return rec.Art_Odr_Duration == null
                    ? $"/News/all/{rec.Id}/time"
                    : $"/News/all/{rec.Id}/{rec.Art_Odr_Duration}/{rec.Art_Odr_Type}";
            }

            if (rec.Art_Odr_Duration == null)
            {
                var grouping = rec.Art_Grouping ?? "cat";
                var odrType = string.IsNullOrEmpty(rec.Art_Odr_Type) ? "time" : rec.Art_Odr_Type;
                return $"/News/{grouping}/{rec.Id}/{odrType}";
            }

            return $"/News/{rec.Art_Grouping}/{rec.Id}/{rec.Art_Odr_Duration}/{rec.Art_Odr_Type}";
        }
    }

    /// <summary>
    /// 首頁文章顯示用的 ViewModel
    /// </summary>
    public class ArticleViewModel
    {
        public int Id { get; set; }
        public string Title { get; set; } = "";
        public DateTime? DateTime { get; set; }
        public string Author { get; set; } = "";
        public string? Author_Email { get; set; }
        public int? Front_Img_Id { get; set; }
        public int? Member_Img_Id { get; set; }
        public int RecommendationCategoryId { get; set; }

        public string FormattedDateTime => DateTime?.ToString("yyyy/MM/dd") ?? "";
    }
}
