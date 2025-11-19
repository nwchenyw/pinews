using System;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.Encodings.Web;
using Microsoft.AspNetCore.Mvc;

namespace PiNewsCore.Controllers
{
    [ApiController]
    [Route("UserAction/MsgCheck")]
    public class MsgCheckController : ControllerBase
    {
        private static string HmacSHA256(string message, string key)
        {
            var encoding = new UTF8Encoding();
            byte[] keyByte = encoding.GetBytes(key);
            byte[] messageBytes = encoding.GetBytes(message);
            using (var hmacsha256 = new HMACSHA256(keyByte))
            {
                byte[] hashmessage = hmacsha256.ComputeHash(messageBytes);
                return BitConverter.ToString(hashmessage).Replace("-", "").ToLower();
            }
        }

        [HttpPost("{hash}/{method}")]
        public IActionResult Post(string hash, string method)
        {
            const string secret = "kb53229980";

            if (string.IsNullOrEmpty(hash) || string.IsNullOrEmpty(method))
            {
                return Content("{\"success\": false, \"results\": \"rowdata?\"}", "application/json; charset=utf-8");
            }

            if (!Request.HasFormContentType)
            {
                return Content("{\"success\": false, \"results\": \"no-form-data\"}", "application/json; charset=utf-8");
            }

            try
            {
                if (string.Equals(method, "SendMsg", StringComparison.OrdinalIgnoreCase))
                {
                    var name = WebUtility.UrlDecode(Request.Form["name"].ToString() ?? "");
                    var msg = WebUtility.UrlDecode(Request.Form["message"].ToString() ?? "");

                    if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(msg))
                    {
                        return Content(string.Format("{{\"success\": false, \"results\": \"data?{0} {1}\"}}", Request.Form["name"], Request.Form["message"]), "application/json; charset=utf-8");
                    }

                    var payloadObj = new { name = name, msg = msg };
                    var options = new JsonSerializerOptions { Encoder = JavaScriptEncoder.UnsafeRelaxedJsonEscaping };
                    string send = JsonSerializer.Serialize(payloadObj, options);
                    string verify = HmacSHA256(send, secret);

                    if (verify == hash)
                    {
                        return Content("{\"success\": true,\"results\": " + send + "}", "application/json; charset=utf-8");
                    }
                    else
                    {
                        return Content("{\"success\": false, \"results\": \"hash?" + send + "\"}", "application/json; charset=utf-8");
                    }
                }
                else if (string.Equals(method, "SendLinkMsg", StringComparison.OrdinalIgnoreCase))
                {
                    var name = WebUtility.UrlDecode(Request.Form["name"].ToString() ?? "");
                    var msg = WebUtility.UrlDecode(Request.Form["message"].ToString() ?? "");
                    var link = WebUtility.UrlDecode(Request.Form["link"].ToString() ?? "");

                    if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(msg) || string.IsNullOrEmpty(link))
                    {
                        return Content(string.Format("{{\"success\": false, \"results\": \"data?{0} {1}\"}}", Request.Form["name"], Request.Form["message"]), "application/json; charset=utf-8");
                    }

                    var payloadObj = new { name = name, msg = msg, link = link };
                    var options = new JsonSerializerOptions { Encoder = JavaScriptEncoder.UnsafeRelaxedJsonEscaping };
                    string send = JsonSerializer.Serialize(payloadObj, options);
                    string verify = HmacSHA256(send, secret);

                    if (verify == hash)
                    {
                        return Content("{\"success\": true,\"results\": " + send + "}", "application/json; charset=utf-8");
                    }
                    else
                    {
                        return Content("{\"success\": false, \"results\": \"hash?" + send + "\"}", "application/json; charset=utf-8");
                    }
                }
                else if (string.Equals(method, "SendUserMsg", StringComparison.OrdinalIgnoreCase))
                {
                    var name = Request.Form["name"].ToString() ?? "";
                    var msg = Request.Form["message"].ToString() ?? "";

                    if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(msg))
                    {
                        return Content("{\"success\": false, \"results\": \"data?\"}", "application/json; charset=utf-8");
                    }

                    var userName = User?.Identity?.Name ?? string.Empty;
                    var payloadObj = new { user = userName, name = name, msg = msg };
                    var options = new JsonSerializerOptions { Encoder = JavaScriptEncoder.UnsafeRelaxedJsonEscaping };
                    string send = JsonSerializer.Serialize(payloadObj, options);
                    string verify = HmacSHA256(send, secret);

                    if (verify == hash)
                    {
                        return Content("{\"success\": true,\"results\": " + send + "}", "application/json; charset=utf-8");
                    }
                    else
                    {
                        return Content("{\"success\": false, \"results\": \"hash?\"}", "application/json; charset=utf-8");
                    }
                }
                else
                {
                    return Content(string.Format("{{\"success\": false, \"results\": \"method?{0}\"}}", method), "application/json; charset=utf-8");
                }
            }
            catch (Exception ex)
            {
                return Content(string.Format("{{\"success\": false, \"results\": \"error:{0}\"}}", WebUtility.HtmlEncode(ex.Message)), "application/json; charset=utf-8");
            }
        }
    }
}
