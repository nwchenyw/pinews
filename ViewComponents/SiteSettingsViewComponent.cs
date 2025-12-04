using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PiNewsCore.Models.Reverse;

namespace PiNewsCore.ViewComponents
{
    /// <summary>
    /// 網站設定 ViewComponent - 從資料庫讀取社群連結等設定
    /// </summary>
    public class SiteSettingsViewComponent : ViewComponent
    {
        private readonly RemoteDbContext _context;

        public SiteSettingsViewComponent(RemoteDbContext context)
        {
            _context = context;
        }

        public async Task<IViewComponentResult> InvokeAsync()
        {
            var settings = await _context.WebSite_Data.ToListAsync();

            var settingsDict = new Dictionary<string, string>();
            foreach (var setting in settings)
            {
                if (!string.IsNullOrEmpty(setting.Option) && setting.Setting != null)
                {
                    settingsDict[setting.Option] = setting.Setting;
                }
            }

            return View(settingsDict);
        }
    }
}
