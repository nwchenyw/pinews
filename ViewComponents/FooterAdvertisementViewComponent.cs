using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PiNewsCore.Models.Reverse;

namespace PiNewsCore.ViewComponents
{
    /// <summary>
    /// 頁尾廣告 ViewComponent - 從資料庫讀取友站連結
    /// </summary>
    public class FooterAdvertisementViewComponent : ViewComponent
    {
        private readonly RemoteDbContext _context;

        public FooterAdvertisementViewComponent(RemoteDbContext context)
        {
            _context = context;
        }

        public async Task<IViewComponentResult> InvokeAsync()
        {
            var advertisements = await _context.Advertisements
                .Where(a => a.Type == "friend")
                .ToListAsync();

            return View(advertisements);
        }
    }
}
