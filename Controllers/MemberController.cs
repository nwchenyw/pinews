using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PiNewsCore.Models.Reverse;

namespace PiNewsCore.Controllers
{
    public class MemberController : Controller
    {
        private readonly RemoteDbContext _remoteDb;
        private readonly ILogger<MemberController> _logger;

        public MemberController(RemoteDbContext remoteDb, ILogger<MemberController> logger)
        {
            _remoteDb = remoteDb;
            _logger = logger;
        }

        // GET: /Member
        public async Task<IActionResult> Index()
        {
            var memberIdStr = HttpContext.Session.GetString("MemberId");
            if (string.IsNullOrEmpty(memberIdStr))
            {
                return RedirectToAction("Login", "Account");
            }

            try
            {
                var memberId = int.Parse(memberIdStr);
                var member = await _remoteDb.Members
                    .FirstOrDefaultAsync(m => m.Id == memberId);

                if (member == null)
                {
                    HttpContext.Session.Clear();
                    return RedirectToAction("Login", "Account");
                }

                // 取得會員的文章
                var articles = await _remoteDb.Articles
                    .Where(a => a.User_Id == memberId)
                    .OrderByDescending(a => a.DateTime)
                    .Take(10)
                    .ToListAsync();

                ViewData["Articles"] = articles;
                return View(member);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading member profile");
                return RedirectToAction("Login", "Account");
            }
        }
    }
}
