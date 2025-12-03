using Microsoft.AspNetCore.Mvc;
using PiNewsCore.Services;

namespace PiNewsCore.Controllers
{
    public class SitemapController : Controller
    {
        private readonly ISitemapService _sitemapService;
        private readonly ILogger<SitemapController> _logger;

        public SitemapController(ISitemapService sitemapService, ILogger<SitemapController> logger)
        {
            _sitemapService = sitemapService;
            _logger = logger;
        }

        /// <summary>
        /// Returns the sitemap.xml file
        /// </summary>
        [HttpGet("sitemap.xml")]
        public async Task<IActionResult> Index()
        {
            try
            {
                var sitemapPath = _sitemapService.GetSitemapPath();
                
                // If sitemap doesn't exist, generate it
                if (!System.IO.File.Exists(sitemapPath))
                {
                    _logger.LogInformation("Sitemap not found, generating...");
                    await _sitemapService.GenerateSitemapAsync();
                }

                // Read and return the sitemap file
                var xml = await System.IO.File.ReadAllTextAsync(sitemapPath);
                return Content(xml, "application/xml");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error serving sitemap");
                return StatusCode(500);
            }
        }

        /// <summary>
        /// Manual trigger to regenerate sitemap (admin only)
        /// </summary>
        [HttpPost]
        public async Task<IActionResult> Regenerate()
        {
            try
            {
                // TODO: Add authentication check to ensure only admins can trigger this
                // For now, anyone can trigger it
                
                _logger.LogInformation("Manual sitemap regeneration triggered");
                
                await _sitemapService.GenerateSitemapAsync();
                await _sitemapService.SubmitSitemapAsync();

                TempData["SuccessMessage"] = "Sitemap 已重新生成並提交";
                return RedirectToAction("Index", "Home");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error regenerating sitemap");
                TempData["ErrorMessage"] = "Sitemap 生成失敗";
                return RedirectToAction("Index", "Home");
            }
        }
    }
}
