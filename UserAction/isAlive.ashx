<%@ WebHandler Language="C#" Class="piNews.isAlive" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace piNews
{
  /// <summary>
  /// isAlive 的摘要描述
  /// </summary>
  public class isAlive : IHttpHandler, System.Web.SessionState.IRequiresSessionState
  {

    public void ProcessRequest(HttpContext context)
    {
      //context.Response.ContentType = "text/plain";
      //context.Response.Write("Hello World");
      if (context.Session["User_Id"] == null)
      {
      context.Response.ClearHeaders();
      context.Response.ClearContent();
      context.Response.Status = "503 ServiceUnavailable";
      context.Response.StatusCode = 503;
      context.Response.StatusDescription = "An error has occurred";
      context.Response.Flush();
      }else
      {
        context.Response.ContentType = "text/plain";
        context.Response.Write("OK");
      }
    }

    public bool IsReusable
    {
      get
      {
        return false;
      }
    }
  }
}