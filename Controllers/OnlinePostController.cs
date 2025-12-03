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

                // Update sitemap when article is created (will be included when status is changed to 1)
                try
                {
                    await _sitemapService.UpdateArticleSitemapAsync(article.Id);
                    _logger.LogInformation($"Sitemap updated for new article {article.Id}");
                }
                catch (Exception sitemapEx)
                {
                    _logger.LogWarning(sitemapEx, $"Failed to update sitemap for article {article.Id}, but article was created successfully");
                }

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
