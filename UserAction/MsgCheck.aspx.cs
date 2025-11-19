using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace piNews
{
  public partial class MsgCheck : System.Web.UI.Page
  {
    public class msg_list
    {
      public string name { get; set; }
      public string msg { get; set; }
    }
    public class link_msg_list
    {
      public string name { get; set; }
      public string msg { get; set; }
      public string link { get; set; }
    }

    public class msg_user_list
    {
      public string user { get; set; }
      public string name { get; set; }
      public string msg { get; set; }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
      UserClass uc = new UserClass();
      if (RouteData.Values["Hash"] != null && RouteData.Values["method"] != null)
      {
        string hash = RouteData.Values["Hash"].ToString();
        //string arr = uc.DecryptString(hash, "kb53229980");
        if (RouteData.Values["method"].ToString() == "SendMsg")
        {
          if (Request.Form["name"] != null && Request.Form["message"] != null)
          {
            string name = HttpUtility.UrlDecode(Request.Form["name"].ToString());
            string msg = HttpUtility.UrlDecode(Request.Form["message"].ToString());
            string send = JsonConvert.SerializeObject(new msg_list { name = name, msg = msg });
            string verify = uc.HmacSHA256(send, "kb53229980");

            if (verify == hash)
            {
              Response.Clear();
              Response.ContentType = "application/json; charset=utf-8";
              Response.Write("{\"success\": true,\"results\": " + send + "}");
              Response.End();
            }
            else
            {
              Response.Clear();
              Response.ContentType = "application/json; charset=utf-8";
              Response.Write("{\"success\": false, \"results\": \"hash?" + send + "\"}");
              Response.End();
            }
          }
          else
          {
            Response.Clear();
            Response.ContentType = "application/json; charset=utf-8";
            Response.Write(string.Format("{{\"success\": false, \"results\": \"data?{0} {1}\"}}", Request.Form["name"], Request.Form["message"]));
            Response.End();
          }


        }
        else if (RouteData.Values["method"].ToString() == "SendLinkMsg")
        {
          if (Request.Form["name"] != null && Request.Form["message"] != null && Request.Form["link"] != null)
          {
            string name = HttpUtility.UrlDecode(Request.Form["name"].ToString());
            string msg = HttpUtility.UrlDecode(Request.Form["message"].ToString());
            string link = HttpUtility.UrlDecode(Request.Form["link"].ToString());
            string send = JsonConvert.SerializeObject(new link_msg_list { name = name, msg = msg, link = link });
            string verify = uc.HmacSHA256(send, "kb53229980");

            if (verify == hash)
            {
              Response.Clear();
              Response.ContentType = "application/json; charset=utf-8";
              Response.Write("{\"success\": true,\"results\": " + send + "}");
              Response.End();
            }
            else
            {
              Response.Clear();
              Response.ContentType = "application/json; charset=utf-8";
              Response.Write("{\"success\": false, \"results\": \"hash?" + send + "\"}");
              Response.End();
            }
          }
          else
          {
            Response.Clear();
            Response.ContentType = "application/json; charset=utf-8";
            Response.Write(string.Format("{{\"success\": false, \"results\": \"data?{0} {1}\"}}", Request.Form["name"], Request.Form["message"]));
            Response.End();
          }


        }
        else if (RouteData.Values["method"].ToString() == "SendUserMsg")
        {
          if (Request.Form["name"] != null && Request.Form["message"] != null)
          {
            string name = Request.Form["name"].ToString();
            string msg = Request.Form["message"].ToString();
            string send = JsonConvert.SerializeObject(new msg_user_list { user = this.User.Identity.Name, name = name, msg = msg });
            string verify = uc.HmacSHA256(send, "kb53229980");

            if (verify == hash)
            {
              Response.Clear();
              Response.ContentType = "application/json; charset=utf-8";
              Response.Write("{\"success\": true,\"results\": " + send + "}");
              Response.End();
            }
            else
            {
              Response.Clear();
              Response.ContentType = "application/json; charset=utf-8";
              Response.Write("{\"success\": false, \"results\": \"hash?\"}");
              Response.End();
            }
          }
        }
        else
        {
          Response.Clear();
          Response.ContentType = "application/json; charset=utf-8";
          Response.Write(string.Format("{{\"success\": false, \"results\": \"method?{0}\"}}", RouteData.Values["method"].ToString()));
          Response.End();
        }
      }
      else
      {
        Response.Clear();
        Response.ContentType = "application/json; charset=utf-8";
        Response.Write("{\"success\": false, \"results\": \"rowdata?\"}");
        Response.End();
      }
    }
  }
}