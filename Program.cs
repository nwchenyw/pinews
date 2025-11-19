using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.HttpOverrides;
using PiNewsCore.Data;
using PiNewsCore.Models.Reverse;

var builder = WebApplication.CreateBuilder(args);
// Add services to the container.
builder.Services.AddControllersWithViews().AddRazorRuntimeCompilation();

// Configure DbContext - 使用你指定的遠端 SQL Server（在 appsettings.json 中 PiNewsConStr）
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("PiNewsConStr"),
        sqlOptions => sqlOptions.EnableRetryOnFailure() // 啟用短暫故障重試
    )
);

// Remote existing DB context (scaffolded)
builder.Services.AddDbContext<RemoteDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("PiNewsConStr"),
        sqlOptions => sqlOptions.EnableRetryOnFailure()
    )
);

var app = builder.Build();
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
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
