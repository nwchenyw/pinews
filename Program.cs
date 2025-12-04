using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.HttpOverrides;
using PiNewsCore.Data;
using PiNewsCore.Models.Reverse;
using PiNewsCore.Services;

var builder = WebApplication.CreateBuilder(args);
// Add services to the container.
builder.Services.AddControllersWithViews().AddRazorRuntimeCompilation();

// Add HttpClient factory for making HTTP requests
builder.Services.AddHttpClient();

// Add session support
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

// Register Sitemap services
builder.Services.AddScoped<ISitemapService, SitemapService>();
builder.Services.AddHostedService<SitemapSchedulerService>();

// Check if we should use demo mode (in-memory database)
var useDemoMode = builder.Configuration.GetValue<bool>("UseDemoMode", true);
var connectionString = builder.Configuration.GetConnectionString("PiNewsConStr");

if (useDemoMode || string.IsNullOrEmpty(connectionString))
{
    // Use in-memory database for demo/testing
    builder.Services.AddDbContext<ApplicationDbContext>(options =>
        options.UseInMemoryDatabase("PiNewsDemo"));

    builder.Services.AddDbContext<RemoteDbContext>(options =>
    {
        options.UseInMemoryDatabase("PiNewsDemo");
        // Disable concurrency detector to allow parallel queries
        options.EnableThreadSafetyChecks(false);
    });
}
else
{
    // Use real SQL Server database
    builder.Services.AddDbContext<ApplicationDbContext>(options =>
        options.UseSqlServer(connectionString)
    );

    builder.Services.AddDbContext<RemoteDbContext>(options =>
    {
        options.UseSqlServer(connectionString);
    });
}

var app = builder.Build();

// Seed demo data if using in-memory database
if (useDemoMode || string.IsNullOrEmpty(connectionString))
{
    using (var scope = app.Services.CreateScope())
    {
        var context = scope.ServiceProvider.GetRequiredService<RemoteDbContext>();
        DemoDataSeeder.SeedDemoData(context);
    }
}

// When running behind IIS or another reverse proxy, accept forwarded headers
// so the app can know the original request's scheme and remote IP.
var forwardedOptions = new ForwardedHeadersOptions
{
    ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto
};
// In non-production scenarios where the proxy may not be in KnownNetworks,
// clear the lists so forwarded headers from the proxy are accepted.
forwardedOptions.KnownNetworks.Clear();
forwardedOptions.KnownProxies.Clear();
app.UseForwardedHeaders(forwardedOptions);
// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseSession();
app.UseAuthorization();

// 相容舊專案的路由格式
app.MapControllerRoute(
    name: "news_info",
    pattern: "News/Info/{id}",
    defaults: new { controller = "News", action = "Detail" });

app.MapControllerRoute(
    name: "news_category",
    pattern: "News/{id}",
    defaults: new { controller = "News", action = "Category" });

app.MapControllerRoute(
    name: "news_all",
    pattern: "News/all/{id}/{duration}/{orderType}",
    defaults: new { controller = "News", action = "All" });

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
