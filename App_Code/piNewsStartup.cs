using System;
using System.Threading.Tasks;
using Microsoft.AspNet.SignalR;
using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(piNews.Startup))]
[assembly: OwinStartupAttribute(typeof(piNews.Startup))]

namespace piNews { 
  public class Startup
  {
  public class CustomUserIdProvider : IUserIdProvider
  {
    public string GetUserId(IRequest request)
    {
      return request.User.Identity.Name;
    }
  }
    public void Configuration(IAppBuilder app)
    {
      // 如需如何設定應用程式的詳細資訊，請瀏覽 https://go.microsoft.com/fwlink/?LinkID=316888
      var hubConfiguration = new HubConfiguration();
      hubConfiguration.EnableDetailedErrors = true;
      
      var idProvider = new CustomUserIdProvider();

      GlobalHost.DependencyResolver.Register(typeof(IUserIdProvider), () => idProvider);
      app.MapSignalR(hubConfiguration);
      //app.MapSignalR();
    }
  }
}