using Microsoft.AspNetCore.Mvc;
using PiNewsCore.Models.Reverse;
using PiNewsCore.Services;

namespace PiNewsCore.Controllers
{
    public class OnlinePostController : Controller
    {
        private readonly RemoteDbContext _remoteDb;
        private readonly ILogger<OnlinePostController> _logger;
        private readonly ISitemapService _sitemapService;

        public OnlinePostController(RemoteDbContext remoteDb, ILogger<OnlinePostController> logger, ISitemapService sitemapService)
        {
            _remoteDb = remoteDb;
            _logger = logger;
            _sitemapService = sitemapService;
        }

        // GET: /OnlinePost
        public IActionResult Index()
        {
            var memberIdStr = HttpContext.Session.GetString("MemberId");
            if (string.IsNullOrEmpty(memberIdStr))
            {
                return RedirectToAction("Login", "Account");
            }

            return View();
        }

        // POST: /OnlinePost
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Index(Article article)
        {
            var memberIdStr = HttpContext.Session.GetString("MemberId");
            if (string.IsNullOrEmpty(memberIdStr))
            {
                return RedirectToAction("Login", "Account");
            }

            try
            {
                article.User_Id = int.Parse(memberIdStr);
                article.DateTime = DateTime.UtcNow;
                article.Status = 0; // 待審核
                
                _remoteDb.Articles.Add(article);
                await _remoteDb.SaveChangesAsync();

                // Note: Sitemap will be updated when article status changes to 1 (published)
                // For now, we don't update the sitemap for pending articles (Status = 0)
                _logger.LogInformation($"Article {article.Id} created with pending status");

                ViewData["Success"] = "文章已送出，等待審核。";
                return View();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error posting article");
                ViewData["Error"] = "發表文章時發生錯誤";
                return View();
            }
        }
    }
}
