using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace piNews
{
  public partial class Tag : System.Web.UI.Page
  {
    public class Opt
    {
      public string name { get; set; }
      public string value { get; set; }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
      List<Opt> tag_list = new List<Opt>();

      if (RouteData.Values["Tag"] != null)
      {
        string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
        string qry = @"SELECT TOP 20 kw.Item AS Tag
FROM Article A OUTER APPLY dbo.SplitString (A.Keyword, ',') kw where kw.Item like @input + '%'
group by kw.Item";
        using (SqlConnection con = new SqlConnection(constr))
        {
          using (SqlCommand cmd = new SqlCommand(qry, con))
          {
            con.Open();
            cmd.Parameters.Clear();

            cmd.Parameters.AddWithValue("@input", RouteData.Values["Tag"]);

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
              if (reader.HasRows)
              {
                while (reader.Read())
                  tag_list.Add(new Opt { name = reader["Tag"].ToString(), value = reader["Tag"].ToString() });
              }
              reader.Close();
            }
            con.Close();
          }
        }
      }
      else
      {
        string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
        string qry = @"SELECT TOP 20 kw.Item AS Tag
FROM Article A OUTER APPLY dbo.SplitString (A.Keyword, ',') kw
group by kw.Item";
        using (SqlConnection con = new SqlConnection(constr))
        {
          using (SqlCommand cmd = new SqlCommand(qry, con))
          {
            con.Open();
            cmd.Parameters.Clear();

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
              if (reader.HasRows)
              {
                while (reader.Read())
                  tag_list.Add(new Opt { name = reader["Tag"].ToString(), value = reader["Tag"].ToString() });
              }
              reader.Close();
            }
            con.Close();
          }
        }
      }
      Response.Clear();
      Response.ContentType = "application/json; charset=utf-8";
      Response.Write("{\"success\": true,\"results\": " + JsonConvert.SerializeObject(tag_list) + "}");
      Response.End();
    }
  }
}