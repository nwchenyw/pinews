using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PiNewsCore.Models.Reverse;

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
                // 撈取首頁需要的資料
                // 1. 最新文章（頭條新聞）
                var latestArticles = await _remoteDb.Articles
                    .Where(a => a.Status == 1 && a.DateTime != null)
                    .OrderByDescending(a => a.DateTime)
                    .Take(10)
                    .ToListAsync();

                // 2. 橫幅廣告
                var banners = await _remoteDb.Banners
                    .Where(b => b.active == true)
                    .OrderBy(b => b.odr)
                    .ToListAsync();

                // 3. 跑馬燈
                var marquees = await _remoteDb.Marquees
                    .Where(m => m.active == true)
                    .OrderBy(m => m.odr)
                    .ToListAsync();

                ViewData["Articles"] = latestArticles;
                ViewData["Banners"] = banners;
                ViewData["Marquees"] = marquees;

                return View();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error querying data for Index page");
                ViewData["DbError"] = ex.Message;
                ViewData["Articles"] = new List<Article>();
                ViewData["Banners"] = new List<Banner>();
                ViewData["Marquees"] = new List<Marquee>();
                return View();
            }
        }
    }
}
