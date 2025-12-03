using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PiNewsCore.Models.Reverse;

namespace PiNewsCore.Controllers
{
    public class NewsController : Controller
    {
        private readonly RemoteDbContext _remoteDb;
        private readonly ILogger<NewsController> _logger;

        public NewsController(RemoteDbContext remoteDb, ILogger<NewsController> logger)
        {
            _remoteDb = remoteDb;
            _logger = logger;
        }

        // GET: /News/Category/{id}
        public async Task<IActionResult> Category(int id, int page = 1)
        {
            try
            {
                const int pageSize = 20;
                var skip = (page - 1) * pageSize;

                // Get articles by category - use Category field directly
                var articles = await _remoteDb.Articles
                    .Where(a => a.Status == 1 && a.DateTime != null && a.Category == id.ToString())
                    .OrderByDescending(a => a.DateTime)
                    .Skip(skip)
                    .Take(pageSize)
                    .ToListAsync();

                var totalCount = await _remoteDb.Articles
                    .Where(a => a.Status == 1 && a.DateTime != null && a.Category == id.ToString())
                    .CountAsync();

                ViewData["CategoryId"] = id;
                ViewData["CurrentPage"] = page;
                ViewData["TotalPages"] = (int)Math.Ceiling(totalCount / (double)pageSize);
                
                return View("Index", articles);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error querying articles for category {CategoryId}", id);
                ViewData["DbError"] = ex.Message;
                return View("Index", new List<Article>());
            }
        }

        // GET: /News/Detail/{id}
        public async Task<IActionResult> Detail(int id)
        {
            try
            {
                var article = await _remoteDb.Articles
                    .FirstOrDefaultAsync(a => a.Id == id);

                if (article == null)
                {
                    return NotFound();
                }

                // Note: Article_View table structure doesn't support individual article view tracking as expected
                // You may need to modify this based on your actual requirements

                // 取得相關文章
                var relatedArticles = await _remoteDb.Articles
                    .Where(a => a.Id != id && a.Status == 1 && a.DateTime != null)
                    .OrderByDescending(a => a.DateTime)
                    .Take(5)
                    .ToListAsync();

                ViewData["RelatedArticles"] = relatedArticles;

                return View(article);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error querying article {ArticleId}", id);
                return StatusCode(500, "資料庫讀取錯誤");
            }
        }
    }
}
