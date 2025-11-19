using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
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
                // 使用 scaffold 出來的 RemoteDbContext 撈最新 10 篇文章
                var latest = await _remoteDb.Articles.OrderByDescending(a => a.DateTime).Take(10).ToListAsync();
                return View(latest);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error querying remote Articles");
                ViewData["DbError"] = ex.Message;
                return View(new List<Article>());
            }
        }
    }
}
