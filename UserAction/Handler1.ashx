<%@ WebHandler Language="C#" Class="piNews.Handler1" %>
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;

namespace piNews
{
  /// <summary>
  /// Handler1 的摘要描述
  /// </summary>
  public class Handler1 : IHttpHandler, System.Web.SessionState.IRequiresSessionState
  {
    [WebMethod(EnableSession = true)]
    public void ProcessRequest(HttpContext context)
    {
      string jsonData = "-1";
      string state = "no file";
      bool idle_overflow = true;
      float mb = 5;

      string qry = @"select IsNull(sum(i.Size)/1024, 0) as mb from Image i left join Article_Image ai on i.Id = ai.image_id
left join Article a on i.Id = a.Front_Img_Id
left join Advertisement ad on i.Id = ad.Img_Id
left join Member m on i.Id = m.Member_Img_Id left join Banner b on i.Id = b.Image_Id
where i.Image_Type != 2 and i.User_id = @Id and ai.article_id is null and ad.Id is null and m.Id is null and b.Id is null and a.Id is null";

      string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
      using (SqlConnection con = new SqlConnection(constr))
      {
        using (SqlCommand cmd = new SqlCommand(qry, con))
        {
          con.Open();
          cmd.Parameters.Clear();
          cmd.Parameters.AddWithValue("@Id", context.Session["User_Id"].ToString());

          using (SqlDataReader reader = cmd.ExecuteReader())
          {
            if (reader.HasRows)
            {
              reader.Read();
              mb = (float)Convert.ToDouble(reader["mb"].ToString());
              idle_overflow = mb < 5 ? true: false;
            }
            reader.Close();
          }
          con.Close();
        }
      }

      if (idle_overflow)
      {
        if (context.Request.Files.Count > 0)
        {
          if (context.Request.Files[0].ContentLength / 1024 < 5120)
          {
            UserClass uc = new UserClass();
            HttpFileCollection files = context.Request.Files;

            string fileExtension = Path.GetExtension(files[0].FileName);

            string fileName = Guid.NewGuid() + fileExtension;

            string contentType = files[0].ContentType;
            byte[] bytes;

            using (Stream fs = files[0].InputStream)
            {
              using (BinaryReader br = new BinaryReader(fs))
              {
                bytes = br.ReadBytes((Int32)fs.Length);
              }
            }

            Bitmap bmp = new Bitmap(new System.IO.MemoryStream(bytes));
            System.Drawing.Image img = bmp;
            if (img.Width > 800)
            {
              System.Drawing.Bitmap new_bmp = uc.viewMaker(bmp, 800, (img.Height / img.Width) * 800);
              using (MemoryStream ms = new MemoryStream())
              {
                new_bmp.Save(ms, bmp.RawFormat);
                bytes = ms.ToArray();
              }
            }

            string fimgid = uc.PiNewsInsertImg(contentType, fileName, Convert.ToDecimal(bytes.Length / 1024), context.Session["User_Id"].ToString(), bytes);
            uc.UserLog("Image", fimgid, "Insert", "新增內文圖片", context.Session["User_Id"].ToString(), context.Session["IP"].ToString());
            jsonData = fimgid;
            context.Session["new_Img"] += jsonData + ",";
            state = "OK";
          }
          else
          {
            state = "overflow";
          }
        }
      }
      else
      {
        state = "idle_overflow";
      }
      //Send File details in a JSON Response.
      string json = new JavaScriptSerializer().Serialize(
          new
          {
            id = jsonData + ",",
            stat = state,
            file_size = context.Request.Files[0].ContentLength / 1024,
            overflow = mb
          });
      //context.Session["new_Img"] += jsonData + ",";
      context.Response.StatusCode = (int)HttpStatusCode.OK;
      context.Response.ContentType = "text/json";
      context.Response.Write(json);
      context.Response.End();

      //return json;
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