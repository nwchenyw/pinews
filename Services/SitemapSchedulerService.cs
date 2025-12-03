namespace PiNewsCore.Services
{
    /// <summary>
    /// Background service that generates and submits sitemap daily at midnight
    /// </summary>
    public class SitemapSchedulerService : BackgroundService
    {
        private readonly IServiceProvider _serviceProvider;
        private readonly ILogger<SitemapSchedulerService> _logger;

        public SitemapSchedulerService(
            IServiceProvider serviceProvider,
            ILogger<SitemapSchedulerService> logger)
        {
            _serviceProvider = serviceProvider;
            _logger = logger;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("Sitemap Scheduler Service started");

            while (!stoppingToken.IsCancellationRequested)
            {
                var now = DateTime.UtcNow;
                var nextMidnight = now.Date.AddDays(1); // Next midnight (00:00 UTC)
                var delay = nextMidnight - now;

                _logger.LogInformation($"Next sitemap generation scheduled at {nextMidnight:yyyy-MM-dd HH:mm:ss} UTC");

                try
                {
                    // Wait until midnight
                    await Task.Delay(delay, stoppingToken);

                    if (!stoppingToken.IsCancellationRequested)
                    {
                        await GenerateAndSubmitSitemapAsync();
                    }
                }
                catch (TaskCanceledException)
                {
                    // Service is stopping
                    _logger.LogInformation("Sitemap Scheduler Service is stopping");
                    break;
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error in sitemap scheduler");
                    // Wait a bit before retrying
                    await Task.Delay(TimeSpan.FromMinutes(5), stoppingToken);
                }
            }
        }

        private async Task GenerateAndSubmitSitemapAsync()
        {
            try
            {
                _logger.LogInformation("Starting scheduled sitemap generation at {Time}", DateTime.Now);

                using var scope = _serviceProvider.CreateScope();
                var sitemapService = scope.ServiceProvider.GetRequiredService<ISitemapService>();

                // Generate sitemap
                await sitemapService.GenerateSitemapAsync();

                // Submit to search engines
                await sitemapService.SubmitSitemapAsync();

                _logger.LogInformation("Scheduled sitemap generation completed successfully");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during scheduled sitemap generation");
            }
        }

        public override async Task StopAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("Sitemap Scheduler Service is stopping");
            await base.StopAsync(stoppingToken);
        }
    }
}
