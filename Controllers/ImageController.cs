using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PiNewsCore.Models.Reverse;

namespace PiNewsCore.Controllers
{
    /// <summary>
    /// 處理圖片請求的控制器，從資料庫讀取圖片並返回
    /// 相容舊版 Image.aspx?id=xxx 的請求格式
    /// </summary>
    public class ImageController : Controller
    {
        private readonly RemoteDbContext _context;
        private readonly ILogger<ImageController> _logger;

        public ImageController(RemoteDbContext context, ILogger<ImageController> logger)
        {
            _context = context;
            _logger = logger;
        }

        /// <summary>
        /// 根據 ID 從資料庫獲取圖片
        /// 路由: /Image.aspx?ID={id} 或 /Image.aspx?id={id} 或 /Image.aspx?Id={id} 或 /Image/{id}
        /// 支援大寫 ID、小寫 id 和混合 Id 的 query string 參數
        /// </summary>
        [HttpGet]
        [Route("Image.aspx")]
        [Route("Image/{id:int}")]
        [ResponseCache(Duration = 3600, Location = ResponseCacheLocation.Client)]
        public async Task<IActionResult> GetImage(int? id, [FromQuery(Name = "ID")] int? ID, [FromQuery(Name = "Id")] int? Id)
        {
            // 支援大寫 ID、小寫 id 和混合 Id 的 query string 參數
            var imageId = id ?? ID ?? Id;

            if (!imageId.HasValue || imageId <= 0)
            {
                return BadRequest("Invalid image ID");
            }

            // 使用 imageId 變數替代 id
            id = imageId;

            try
            {
                var image = await _context.Images
                    .AsNoTracking()
                    .Where(i => i.Id == id.Value)
                    .Select(i => new { i.Data, i.Content_Type, i.File_Name })
                    .FirstOrDefaultAsync();

                if (image == null || image.Data == null)
                {
                    _logger.LogWarning("Image not found: {ImageId}", id);
                    return NotFound("Image not found");
                }

                var contentType = image.Content_Type ?? "image/jpeg";
                var fileName = image.File_Name ?? $"image_{id}.jpg";

                // 設置 Content-Disposition header 為 inline 以便瀏覽器直接顯示
                Response.Headers["Content-Disposition"] = $"inline; filename=\"{fileName}\"";

                return File(image.Data, contentType);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving image: {ImageId}", id);
                return StatusCode(500, "Error retrieving image");
            }
        }

        /// <summary>
        /// 根據 ID 從資料庫獲取圖片 (下載模式)
        /// </summary>
        [HttpGet]
        [Route("Image/Download/{id:int}")]
        public async Task<IActionResult> DownloadImage(int id)
        {
            if (id <= 0)
            {
                return BadRequest("Invalid image ID");
            }

            try
            {
                var image = await _context.Images
                    .AsNoTracking()
                    .Where(i => i.Id == id)
                    .Select(i => new { i.Data, i.Content_Type, i.File_Name })
                    .FirstOrDefaultAsync();

                if (image == null || image.Data == null)
                {
                    return NotFound("Image not found");
                }

                var contentType = image.Content_Type ?? "application/octet-stream";
                var fileName = image.File_Name ?? $"image_{id}.jpg";

                return File(image.Data, contentType, fileName);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error downloading image: {ImageId}", id);
                return StatusCode(500, "Error downloading image");
            }
        }
    }
}
