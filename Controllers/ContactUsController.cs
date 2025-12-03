using Microsoft.AspNetCore.Mvc;

namespace PiNewsCore.Controllers
{
    public class ContactUsController : Controller
    {
        private readonly ILogger<ContactUsController> _logger;

        public ContactUsController(ILogger<ContactUsController> logger)
        {
            _logger = logger;
        }

        // GET: /ContactUs
        public IActionResult Index()
        {
            return View();
        }

        // POST: /ContactUs
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Index(string name, string email, string subject, string message)
        {
            try
            {
                // 這裡應該實作發送聯絡信件的邏輯
                _logger.LogInformation("Contact form submitted by {Name} ({Email}): {Subject}", name, email, subject);
                
                ViewData["Success"] = "您的訊息已送出，我們會盡快回覆您。";
                return View();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing contact form");
                ViewData["Error"] = "送出訊息時發生錯誤，請稍後再試。";
                return View();
            }
        }
    }
}
