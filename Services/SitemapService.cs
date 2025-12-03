using System.Xml.Linq;
using System.Text;
using Microsoft.EntityFrameworkCore;
using PiNewsCore.Models.Reverse;

namespace PiNewsCore.Services
{
    public class SitemapService : ISitemapService
    {
        private readonly RemoteDbContext _dbContext;
        private readonly IWebHostEnvironment _environment;
        private readonly IConfiguration _configuration;
        private readonly ILogger<SitemapService> _logger;
        private readonly string _sitemapPath;

        public SitemapService(
            RemoteDbContext dbContext,
            IWebHostEnvironment environment,
            IConfiguration configuration,
            ILogger<SitemapService> logger)
        {
            _dbContext = dbContext;
            _environment = environment;
            _configuration = configuration;
            _logger = logger;
            _sitemapPath = Path.Combine(_environment.WebRootPath, "sitemap.xml");
        }

        public string GetSitemapPath() => _sitemapPath;

        public async Task<string> GenerateSitemapAsync()
        {
            try
            {
                _logger.LogInformation("Starting sitemap generation...");

                // Get base URL from configuration or use default
                var baseUrl = _configuration["SiteBaseUrl"] ?? "https://pinews.com";

                // Create XML namespace for sitemap
                XNamespace ns = "http://www.sitemaps.org/schemas/sitemap/0.9";
                
                var urlset = new XElement(ns + "urlset");

                // Add homepage
                urlset.Add(new XElement(ns + "url",
                    new XElement(ns + "loc", baseUrl),
                    new XElement(ns + "lastmod", DateTime.UtcNow.ToString("yyyy-MM-dd")),
                    new XElement(ns + "changefreq", "daily"),
                    new XElement(ns + "priority", "1.0")
                ));

                // Get all active articles (Status = 1 means active/published)
                var articles = await _dbContext.Articles
                    .Where(a => a.Status == 1)
                    .OrderByDescending(a => a.DateTime)
                    .ToListAsync();

                _logger.LogInformation($"Found {articles.Count} active articles for sitemap");

                // Add each article to sitemap
                foreach (var article in articles)
                {
                    var articleUrl = $"{baseUrl}/News/Info/{article.Id}";
                    var lastMod = article.DateTime ?? DateTime.UtcNow;

                    urlset.Add(new XElement(ns + "url",
                        new XElement(ns + "loc", articleUrl),
                        new XElement(ns + "lastmod", lastMod.ToString("yyyy-MM-dd")),
                        new XElement(ns + "changefreq", "weekly"),
                        new XElement(ns + "priority", "0.8")
                    ));
                }

                // Add other important pages
                var staticPages = new[]
                {
                    new { Url = "/News", Priority = "0.9", ChangeFreq = "daily" },
                    new { Url = "/Articles", Priority = "0.8", ChangeFreq = "daily" },
                    new { Url = "/ContactUs", Priority = "0.6", ChangeFreq = "monthly" },
                    new { Url = "/OnlinePost", Priority = "0.7", ChangeFreq = "weekly" },
                };

                foreach (var page in staticPages)
                {
                    urlset.Add(new XElement(ns + "url",
                        new XElement(ns + "loc", baseUrl + page.Url),
                        new XElement(ns + "lastmod", DateTime.UtcNow.ToString("yyyy-MM-dd")),
                        new XElement(ns + "changefreq", page.ChangeFreq),
                        new XElement(ns + "priority", page.Priority)
                    ));
                }

                // Create XML document
                var doc = new XDocument(
                    new XDeclaration("1.0", "UTF-8", null),
                    urlset
                );

                // Save to file
                await Task.Run(() => doc.Save(_sitemapPath));

                _logger.LogInformation($"Sitemap generated successfully at {_sitemapPath}");
                
                return _sitemapPath;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error generating sitemap");
                throw;
            }
        }

        public async Task UpdateArticleSitemapAsync(int articleId)
        {
            try
            {
                _logger.LogInformation($"Updating sitemap for article {articleId}");
                
                // For now, regenerate entire sitemap
                // In a high-traffic scenario, you might want to implement incremental updates
                await GenerateSitemapAsync();
                
                // Submit sitemap after update
                await SubmitSitemapAsync();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error updating sitemap for article {articleId}");
                throw;
            }
        }

        public async Task SubmitSitemapAsync()
        {
            try
            {
                _logger.LogInformation("Submitting sitemap to search engines...");

                var baseUrl = _configuration["SiteBaseUrl"] ?? "https://pinews.com";
                var sitemapUrl = $"{baseUrl}/sitemap.xml";

                using var httpClient = new HttpClient();
                httpClient.Timeout = TimeSpan.FromSeconds(30);

                // Submit to Google
                var googlePingUrl = $"https://www.google.com/ping?sitemap={Uri.EscapeDataString(sitemapUrl)}";
                try
                {
                    var googleResponse = await httpClient.GetAsync(googlePingUrl);
                    if (googleResponse.IsSuccessStatusCode)
                    {
                        _logger.LogInformation("Sitemap successfully submitted to Google");
                    }
                    else
                    {
                        _logger.LogWarning($"Google sitemap submission returned status: {googleResponse.StatusCode}");
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogWarning(ex, "Failed to submit sitemap to Google");
                }

                // Submit to Bing
                var bingPingUrl = $"https://www.bing.com/ping?sitemap={Uri.EscapeDataString(sitemapUrl)}";
                try
                {
                    var bingResponse = await httpClient.GetAsync(bingPingUrl);
                    if (bingResponse.IsSuccessStatusCode)
                    {
                        _logger.LogInformation("Sitemap successfully submitted to Bing");
                    }
                    else
                    {
                        _logger.LogWarning($"Bing sitemap submission returned status: {bingResponse.StatusCode}");
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogWarning(ex, "Failed to submit sitemap to Bing");
                }

                _logger.LogInformation("Sitemap submission process completed");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error submitting sitemap");
                // Don't throw - this is not critical
            }
        }
    }
}
