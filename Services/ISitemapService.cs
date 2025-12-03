namespace PiNewsCore.Services
{
    public interface ISitemapService
    {
        /// <summary>
        /// Generate complete sitemap for all articles
        /// </summary>
        Task<string> GenerateSitemapAsync();
        
        /// <summary>
        /// Update sitemap for a specific article
        /// </summary>
        Task UpdateArticleSitemapAsync(int articleId);
        
        /// <summary>
        /// Submit sitemap to search engines
        /// </summary>
        Task SubmitSitemapAsync();
        
        /// <summary>
        /// Get the path to the sitemap file
        /// </summary>
        string GetSitemapPath();
    }
}
