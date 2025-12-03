using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.HttpOverrides;
using PiNewsCore.Data;
using PiNewsCore.Models.Reverse;

var builder = WebApplication.CreateBuilder(args);
// Add services to the container.
builder.Services.AddControllersWithViews().AddRazorRuntimeCompilation();

// Add session support
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

// Check if we should use demo mode (in-memory database)
var useDemoMode = builder.Configuration.GetValue<bool>("UseDemoMode", true);
var connectionString = builder.Configuration.GetConnectionString("PiNewsConStr");

if (useDemoMode || string.IsNullOrEmpty(connectionString) || connectionString.Contains("SERVER") || connectionString.Contains("DATABASE"))
{
    // Use in-memory database for demo/testing
    builder.Services.AddDbContext<ApplicationDbContext>(options =>
        options.UseInMemoryDatabase("PiNewsDemo"));
    
    builder.Services.AddDbContext<RemoteDbContext>(options =>
        options.UseInMemoryDatabase("PiNewsDemo"));
}
else
{
    // Use real SQL Server database
    builder.Services.AddDbContext<ApplicationDbContext>(options =>
        options.UseSqlServer(
            connectionString,
            sqlOptions => sqlOptions.EnableRetryOnFailure()
        )
    );
    
    builder.Services.AddDbContext<RemoteDbContext>(options =>
        options.UseSqlServer(
            connectionString,
            sqlOptions => sqlOptions.EnableRetryOnFailure()
        )
    );
}

var app = builder.Build();

// Seed demo data if using in-memory database
if (useDemoMode || string.IsNullOrEmpty(connectionString) || connectionString.Contains("SERVER") || connectionString.Contains("DATABASE"))
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

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
