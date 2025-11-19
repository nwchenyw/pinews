using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Web.UI.WebControls;

namespace piNews
{
  public partial class Idle_Image : System.Web.UI.Page
  {
    UserClass uc = new UserClass();
    protected void Page_Load(object sender, EventArgs e)
    {
      if (Request.QueryString["id"] != null)
      {
        //string id = Request.QueryString["id"];
        //string query = "Select * from Image where Id = @id";
        //string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
        //using (SqlConnection con = new SqlConnection(constr))
        //{
        //  using (SqlCommand cmd = new SqlCommand(query, con))
        //  {
        //    con.Open();

        //    cmd.Parameters.Clear();
        //    cmd.Parameters.AddWithValue("@id", id);

        //    using (SqlDataReader reader = cmd.ExecuteReader())
        //    {
        //      if (reader.HasRows)
        //      {
        //        reader.Read();
        //        Session["User_Id"] = reader["Id"].ToString();
        //        Session["Email"] = id;
        //        Session["Name"] = reader["Name"].ToString();
        //        Session["IP"] = uc.UserIP();
        //        Session["Certification"] = reader["Certification"].ToString();
        //        Session["IsAdmin"] = reader["IsAdmin"].ToString();

        //        //and something about authority :O

        //        // end authority :D
        //        uc.UserLog("", "", "Login", "登入", Session["User_Id"].ToString(), Session["IP"].ToString());
        //        Response.Redirect("Member.aspx");
        //      }
        //      else
        //      {

        //      }
        //    }
        //    con.Close();
        //  }
        //}
      }

        this.Master.Page.Title = "管理圖片上傳 | " + Application["Site_Name"];
      //ListDirectory();
    }

    protected void ListView1_ItemDeleting(object sender, ListViewDeleteEventArgs e)
    {
      //string fileName = e.Keys["File_Path"].ToString();

      //FtpWebRequest request = (FtpWebRequest)WebRequest.Create("ftp://192.168.1.150/web/pinews/" + fileName);
      //request.Method = WebRequestMethods.Ftp.DeleteFile;
      //request.Credentials = new NetworkCredential("allwebftp", "webftp");

      //using (FtpWebResponse response = (FtpWebResponse)request.GetResponse())
      //{
      //  uc.FrontEndDebug(this, "ftp error", string.Format("console.log(`{0}`);", response.StatusDescription));
      //}
    }

    private void ListDirectory()
    {
      FtpWebRequest request = (FtpWebRequest)WebRequest.Create("ftp://192.168.1.150/web/pinews/img/news/");
      request.Method = WebRequestMethods.Ftp.ListDirectory;
      request.Credentials = new NetworkCredential("allwebftp", "webftp");
      List<string> entries = new List<string>();
      string filesDetail = "";
      using (var response = (FtpWebResponse)request.GetResponse())
      {
        using (var stream = response.GetResponseStream())
        {
          using (StreamReader reader = new StreamReader(response.GetResponseStream()))
          {
            //Read the Response as String and split using New Line character.
            filesDetail = reader.ReadToEnd();
            entries = filesDetail.Split(new string[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries).ToList();
          }
          response.Close();
        }
      }
      //uc.FrontEndDebug(this, "FTP files", string.Format("console.log(`{0}`);", filesDetail));

      //return entries;

      //Bind Repeater.
      //Repeater1.DataSource = entries;
      //Repeater1.DataBind();
    }



    protected void LinkButton1_Click(object sender, EventArgs e)
    {
      string strArr = "";
      foreach (ListViewDataItem item in ListView1.Items)
      {
        if (item.ItemType == ListViewItemType.DataItem)
        {
          CheckBox ImgChk = item.FindControl("CheckBox1") as CheckBox;
          if (ImgChk.Checked)
          {
            strArr += ListView1.DataKeys[item.DataItemIndex].Value.ToString() + ",";
          }
        }
      }
      if (strArr.Length > 0)
      {
        string[] Arr = strArr.Substring(0, strArr.Length - 1).Split(',');
        string sql = string.Format("Delete from Image output deleted.Id Where id in ({0}) and User_id = @uid", strArr.Substring(0, strArr.Length - 1));
        string[] param = { "@uid" };
        string[] value = { Session["User_Id"].ToString() };
        string result = uc.PiNewsSql(sql, param, value);
        uc.UserLog("Image", "", "Delete", string.Format("刪除圖片({0})", strArr.Substring(0, strArr.Length - 1)), Session["User_Id"].ToString(), Session["IP"].ToString());
        uc.FrontEndDebug(this, "checkbox check", string.Format("console.log('{0}')", strArr));
        ListView1.DataBind();
      }
    }
  }
}