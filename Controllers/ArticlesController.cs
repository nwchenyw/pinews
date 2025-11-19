using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using PiNewsCore.Models.Reverse;

namespace PiNewsCore.Controllers
{
    public class ArticlesController : Controller
    {
        private readonly RemoteDbContext _remoteDb;
        private readonly ILogger<ArticlesController> _logger;

        public ArticlesController(RemoteDbContext remoteDb, ILogger<ArticlesController> logger)
        {
            _remoteDb = remoteDb;
            _logger = logger;
        }

        // GET: /Articles
        public async Task<IActionResult> Index()
        {
            try
            {
                var articles = await _remoteDb.Articles.OrderByDescending(a => a.DateTime).ToListAsync();
                return View(articles);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error querying remote Articles for Index");
                ViewData["DbError"] = ex.Message;
                return View(new List<Article>());
            }
        }

        // GET: /Articles/Details/5
        public async Task<IActionResult> Details(int id)
        {
            try
            {
                var article = await _remoteDb.Articles.FirstOrDefaultAsync(a => a.Id == id);
                if (article == null) return NotFound();
                return View(article);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error querying remote Articles for Details");
                return StatusCode(500, "資料庫讀取錯誤");
            }
        }
    }
}
