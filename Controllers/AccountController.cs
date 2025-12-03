using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PiNewsCore.Models.Reverse;

namespace PiNewsCore.Controllers
{
    public class AccountController : Controller
    {
        private readonly RemoteDbContext _remoteDb;
        private readonly ILogger<AccountController> _logger;

        public AccountController(RemoteDbContext remoteDb, ILogger<AccountController> logger)
        {
            _remoteDb = remoteDb;
            _logger = logger;
        }

        // GET: /Account/Login
        public IActionResult Login()
        {
            return View();
        }

        // POST: /Account/Login
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(string username, string password)
        {
            try
            {
                // 這裡應該實作密碼驗證邏輯
                var member = await _remoteDb.Members
                    .FirstOrDefaultAsync(m => m.Id_number == username && m.Password == password);

                if (member != null)
                {
                    // 設定 session 或 cookie
                    HttpContext.Session.SetString("MemberId", member.Id.ToString());
                    HttpContext.Session.SetString("MemberName", member.Name ?? "");
                    
                    return RedirectToAction("Index", "Member");
                }
                else
                {
                    ViewData["Error"] = "帳號或密碼錯誤";
                    return View();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Login error");
                ViewData["Error"] = "登入時發生錯誤";
                return View();
            }
        }

        // GET: /Account/Register
        public IActionResult Register()
        {
            return View();
        }

        // POST: /Account/Register
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Register(Member member)
        {
            try
            {
                // 檢查帳號是否已存在
                var exists = await _remoteDb.Members
                    .AnyAsync(m => m.Id_number == member.Id_number);

                if (exists)
                {
                    ViewData["Error"] = "此帳號已被註冊";
                    return View();
                }

                // 新增會員
                member.Register_Time = DateTime.Now;
                member.Certification = false; // 未驗證
                
                _remoteDb.Members.Add(member);
                await _remoteDb.SaveChangesAsync();

                ViewData["Success"] = "註冊成功，請檢查您的電子郵件進行驗證";
                return View();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Register error");
                ViewData["Error"] = "註冊時發生錯誤";
                return View();
            }
        }

        // GET: /Account/Logout
        public IActionResult Logout()
        {
            HttpContext.Session.Clear();
            return RedirectToAction("Index", "Home");
        }
    }
}
