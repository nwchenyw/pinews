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
  public class Opt
  {
    public string name { get; set; }
    public string value { get; set; }
  }
  public partial class Staff_Id : System.Web.UI.Page
  {
    protected void Page_Load(object sender, EventArgs e)
    {
      List<Opt> Id_list = new List<Opt>();

      Id_list.Add(new Opt { name = "無", value = "無" });
      if (RouteData.Values["Id"] != null)
      {
        string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
        string qry = "select Staff_Id from Staff_Id where Staff_Id like @Id + '%'";
        using (SqlConnection con = new SqlConnection(constr))
        {
          using (SqlCommand cmd = new SqlCommand(qry, con))
          {
            con.Open();
            cmd.Parameters.Clear();

            cmd.Parameters.AddWithValue("@Id", RouteData.Values["Id"]);

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
              if (reader.HasRows)
              {
                while (reader.Read())
                  Id_list.Add(new Opt { name = reader["Staff_Id"].ToString(), value = reader["Staff_Id"].ToString() });
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
        string qry = "select top 500 Staff_Id from Staff_Id";
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
                  Id_list.Add(new Opt { name = reader["Staff_Id"].ToString(), value = reader["Staff_Id"].ToString() });
              }
              reader.Close();
            }
            con.Close();
          }
        }
      }
      Response.Clear();
      Response.ContentType = "application/json; charset=utf-8";
      Response.Write("{\"success\": true,\"results\": " + JsonConvert.SerializeObject(Id_list) + "}");
      Response.End();
    }
  }
}