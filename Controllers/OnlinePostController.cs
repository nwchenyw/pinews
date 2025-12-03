using Microsoft.AspNetCore.Mvc;
using PiNewsCore.Models.Reverse;

namespace PiNewsCore.Controllers
{
    public class OnlinePostController : Controller
    {
        private readonly RemoteDbContext _remoteDb;
        private readonly ILogger<OnlinePostController> _logger;

        public OnlinePostController(RemoteDbContext remoteDb, ILogger<OnlinePostController> logger)
        {
            _remoteDb = remoteDb;
            _logger = logger;
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
