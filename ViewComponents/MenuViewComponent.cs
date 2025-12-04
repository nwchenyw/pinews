using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PiNewsCore.Models.Reverse;

namespace PiNewsCore.ViewComponents
{
    /// <summary>
    /// 動態選單 ViewComponent - 從資料庫讀取 Menu 資料
    /// </summary>
    public class MenuViewComponent : ViewComponent
    {
        private readonly RemoteDbContext _context;

        public MenuViewComponent(RemoteDbContext context)
        {
            _context = context;
        }

        public async Task<IViewComponentResult> InvokeAsync(string viewName = "Default")
        {
            var menus = await _context.Menus
                .OrderBy(m => m.odr)
                .ToListAsync();

            return View(viewName, menus);
        }
    }
}
