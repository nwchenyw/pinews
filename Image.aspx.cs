using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace piNews
{
  public partial class Image : System.Web.UI.Page
  {
    protected void Page_Load(object sender, EventArgs e)
    {
      if (Request.QueryString["ID"] != null)
      {
        // 驗證 ID 是否為有效的整數
        int imageId;
        if (!int.TryParse(Request.QueryString["ID"], out imageId))
        {
          // 如果不是有效整數，直接返回避免錯誤
          Response.StatusCode = 400; // Bad Request
          Response.End();
          return;
        }

        string strQuery = "select FILE_NAME, CONTENT_TYPE, DATA from Image where Id=@id";
        String strConnString = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
        using (SqlCommand cmd = new SqlCommand(strQuery))
        {
          cmd.Parameters.Add("@id", SqlDbType.Int).Value = imageId;
          using (SqlConnection con = new SqlConnection(strConnString))
          {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
              cmd.CommandType = CommandType.Text;
              DataTable dt = new DataTable();
              cmd.Connection = con;
              try
              {
                con.Open();
                sda.SelectCommand = cmd;
                sda.Fill(dt);
              }
              catch
              {
                dt = null;
              }
              finally
              {
                con.Close();
                sda.Dispose();
                con.Dispose();
              }
              if (dt != null)
              {
                Byte[] bytes = (Byte[])dt.Rows[0]["DATA"];
                Response.Buffer = true;
                Response.Charset = "";
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = dt.Rows[0]["CONTENT_TYPE"].ToString();
                Response.AddHeader("content-disposition", "attachment;filename=" + dt.Rows[0]["FILE_NAME"].ToString());
                Response.BinaryWrite(bytes);
                Response.Flush();
                Response.End();
              };
            };
          };
        }
      }
    }
  }
}