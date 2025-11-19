using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using System.Web.Routing;

namespace piNews
{
  public class UserClass
  {

    //string[,] cityCode = new string[,] { {"臺北市", "A"}, {"臺中市", "B"}, {"基隆市", "C"}, {"臺南市", "D"}, {"高雄市", "E"}, {"新北市", "F"},
    //    {"宜蘭縣", "G"}, {"桃園縣", "H"}, {"新竹縣", "J"}, {"苗栗縣", "K"}, {"臺中縣", "L"}, {"南投縣", "M"}, {"彰化縣", "N"}, {"雲林縣", "P"}, 
    //    {"嘉義縣", "Q"}, {"台南縣", "R"}, {"高雄縣", "S"}, {"屏東縣", "T"}, {"花蓮縣", "U"}, {"臺東縣", "V"}, {"澎湖縣", "X"}, {"陽明山", "Y"},
    //    {"金門縣", "W"}, {"連江縣", "Z"}, {"嘉義市", "I"}, {"新竹市", "O"} };

    string[] city = new string[] { "臺北市", "臺中市", "基隆市", "臺南市", "高雄市", "新北市",
                "宜蘭縣", "桃園市", "新竹縣", "苗栗縣", "臺中縣", "南投縣", "彰化縣", "雲林縣",
                "嘉義縣", "臺南縣", "高雄縣", "屏東縣", "花蓮縣", "臺東縣", "澎湖縣", "陽明山",
                "金門縣", "連江縣", "嘉義市", "新竹市"};

    string[] Code = new string[] { "A", "B", "C", "D", "E", "F"
                  , "G", "H", "J", "K", "L", "M", "N", "P"
                  , "Q", "R", "S", "T", "U", "V", "X", "Y"
                  , "W", "Z", "I", "O" };

    public int[] Bonus = { 0, 30, 35, 40 };

    public string CityCode(string c)
    {
      return Code[Array.IndexOf(city, c)];
    }

    public string CodeCity(string c)
    {
      return city[Array.IndexOf(Code, c)];
    }
    //public static string Base64Encode(string plainText)
    //{
    //  var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(plainText);
    //  return System.Convert.ToBase64String(plainTextBytes);
    //}
    //public static string Base64Decode(string base64EncodedData)
    //{
    //  Byte[] base64EncodedBytes = System.Convert.FromBase64String(base64EncodedData);
    //  return BitConverter.ToString(base64EncodedBytes);
    //}

    public void SendCertifyEmail(string hash, string id, string name, string email)
    {
      string url = string.Format("https://pinews.asia/Verify/{0}/{1}", HttpUtility.UrlEncode(hash), id);
      string body = String.Format(@"親愛的會員 {0} 您好！<br>
這封驗證信函是由拍新聞的系統發出，請於12小時內點閱先連結到您的會員帳戶，不需要回信。<br><br>
{1}
<br><br>
如果上面的超連結您無法使用，請複製上列網址，並開啓瀏覽器直接貼上網址進行帳號登入。<br>
此連結將於12小時後失效，若超過時間請登入帳號點選重新寄送認證信。造成不便敬請見諒！<br>
在此建議您定期更新密碼，讓您的帳號更安全有保障哦！<br><br>
拍新聞 感謝您", name, url);
      SendEmail("ask.pinews@gmail.com", email, "歡迎加入拍新聞", body);
    }
    public void UserLog(string table, string rowid, string act, string remark, string uid, string ip)
    {
      string query = "Insert Into UserLog (Modify_Table, Modify_Id, Modify_Action, Modify_Detail, Operate_User_Id, Operate_User_IP, Operate_Time) Output Inserted.Id Values(@table, @tid, @act, @dtl, @uid, @uip, GETDATE());";
      string[] paramN = { "@table", "@tid", "@act", "@dtl", "@uid", "@uip" };
      string[] paramVal = { table, rowid, act, remark, uid, ip };

      PiNewsSql(query, paramN, paramVal);
    }

    public void FrontEndDebug(Control ctrl, string tag, string script)
    {
      ScriptManager.RegisterStartupScript(ctrl, ctrl.GetType(), tag, script, true);
    }

    public bool PiNewsHasRow(string query, string[] paramN, string[] paramVal)
    {
      bool result = false;
      string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
      using (SqlConnection con = new SqlConnection(constr))
      {
        using (SqlCommand cmd = new SqlCommand(query, con))
        {
          con.Open();
          cmd.Parameters.Clear();
          for (var i = 0; i < paramN.Length; i++)
          {
            string pVal = paramVal[i];
            if (pVal == "")
              cmd.Parameters.AddWithValue(paramN[i], DBNull.Value);
            else cmd.Parameters.AddWithValue(paramN[i], pVal);
          }
          using (SqlDataReader reader = cmd.ExecuteReader())
          {
            if (reader.HasRows)
            {
              result = true;
            }
          }
          con.Close();
        }
      }
      return result;
    }

    public string PiNewsInsertImg(string contentType, string filename, decimal size, string uid, byte[] data)
    {
      var id = "";
      string query = "Insert Into Image OUTPUT INSERTED.Id values (1,@C_Type,@F_Name,@DATA,@Size,@uid,@dt)";
      string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
      using (SqlConnection con = new SqlConnection(constr))
      {
        using (SqlCommand cmd = new SqlCommand(query, con))
        {
          con.Open();
          cmd.Parameters.Clear();
          cmd.Parameters.AddWithValue("@C_Type", contentType);
          cmd.Parameters.AddWithValue("@F_Name", filename);
          cmd.Parameters.Add("@Size", SqlDbType.Decimal);
          cmd.Parameters["@Size"].Value = size;
          cmd.Parameters.AddWithValue("@uid", uid);
          cmd.Parameters.AddWithValue("@dt", DateTime.Now);
          cmd.Parameters.AddWithValue("@DATA", data);
          id = cmd.ExecuteScalar().ToString();
          con.Close();
        }
      }
      return id;
    }

    public string PiNewsInsertIdImg(string contentType, string filename, decimal size, string uid, byte[] data)
    {
      var id = "";
      string query = "Insert Into Image OUTPUT INSERTED.Id values (2,@C_Type,@F_Name,@DATA,@Size,@uid,@dt)";
      string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
      using (SqlConnection con = new SqlConnection(constr))
      {
        using (SqlCommand cmd = new SqlCommand(query, con))
        {
          con.Open();
          cmd.Parameters.Clear();
          cmd.Parameters.AddWithValue("@C_Type", contentType);
          cmd.Parameters.AddWithValue("@F_Name", filename);
          cmd.Parameters.Add("@Size", SqlDbType.Decimal);
          cmd.Parameters["@Size"].Value = size;
          cmd.Parameters.AddWithValue("@uid", uid);
          cmd.Parameters.AddWithValue("@dt", DateTime.Now);
          cmd.Parameters.AddWithValue("@DATA", data);
          id = cmd.ExecuteScalar().ToString();
          con.Close();
        }
      }
      return id;
    }


    //    public void PiNewsDeleteImg(string[] Arr, string uid, string uip, string state)
    //    {
    //      int[] imgarr = Array.ConvertAll(Arr, int.Parse);
    //      bool isSequence = imgarr.SequenceEqual(Enumerable.Range(imgarr[0], imgarr.Count()));
    //      if (imgarr.Length == 1)
    //      {
    //        string sql = string.Format(@"DELETE FROM Image Output Deleted.Id WHERE Id IN (SELECT i.id 
    //FROM Image i LEFT JOIN (SELECT Front_Img_Id FROM Article a1 UNION 
    //SELECT item FROM Article a OUTER APPLY dbo.SplitString(a.Relate_Img, ',') rc WHERE Item IS NOT NULL) a2 
    //ON a2.Front_Img_Id = i.ID LEFT JOIN member m ON m.Member_Img_Id = i.Id 
    //WHERE a2.Front_Img_Id IS NULL AND m.Member_Img_Id IS NULL 
    //--AND i.User_id = @uid 
    //AND i.id = {0})", imgarr[0].ToString());
    //        string[] param = { "@uid" };
    //        string[] val = { uid };
    //        string id = PiNewsSql(sql, param, val);
    //        if (id != "-1")
    //        UserLog("Image", "", "Delete", string.Format("刪除{1}({0})", string.Join(",", Arr), state), uid, uip);
    //      }
    //      else if (isSequence)
    //      {
    //        string sql = string.Format(@"DELETE FROM Image Output Deleted.Id WHERE Id IN (SELECT i.id 
    //FROM Image i LEFT JOIN (SELECT Front_Img_Id FROM Article a1 UNION 
    //SELECT item FROM Article a OUTER APPLY dbo.SplitString(a.Relate_Img, ',') rc WHERE Item IS NOT NULL) a2 
    //ON a2.Front_Img_Id = i.ID LEFT JOIN member m ON m.Member_Img_Id = i.Id 
    //WHERE a2.Front_Img_Id IS NULL AND m.Member_Img_Id IS NULL 
    //--AND i.User_id = @uid 
    //AND i.id between {0} and {1})", imgarr[0].ToString(), imgarr[imgarr.Length - 1].ToString());
    //        string[] param = { "@uid" };
    //        string[] val = { uid };
    //        string id = PiNewsSql(sql, param, val);
    //        if (id != "-1")
    //          UserLog("Image", "", "Delete", string.Format("刪除{1}({0})", string.Join(",", Arr), state), uid, uip);
    //      }
    //      else if (!isSequence)
    //      {
    //        string sql = string.Format(@"DELETE FROM Image Output Deleted.Id WHERE Id IN (SELECT i.id 
    //FROM Image i LEFT JOIN (SELECT Front_Img_Id FROM Article a1 UNION 
    //SELECT item FROM Article a OUTER APPLY dbo.SplitString(a.Relate_Img, ',') rc WHERE Item IS NOT NULL) a2 
    //ON a2.Front_Img_Id = i.ID LEFT JOIN member m ON m.Member_Img_Id = i.Id 
    //WHERE a2.Front_Img_Id IS NULL AND m.Member_Img_Id IS NULL 
    //--AND i.User_id = @uid 
    //AND i.id IN ({0}))", string.Join(",", Arr));
    //        string[] param = { "@uid" };
    //        string[] val = { uid };
    //        string id = PiNewsSql(sql, param, val);
    //        if (id != "-1")
    //          UserLog("Image", "", "Delete", string.Format("刪除{1}({0})", string.Join(",", Arr), state), uid, uip);
    //      }
    //    }

    public string PiNewsSql(string query, string[] paramN, string[] paramVal) //for insert/update/delete
    {
      var id = "";
      string constr = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
      using (SqlConnection con = new SqlConnection(constr))
      {
        using (SqlCommand cmd = new SqlCommand(query, con))
        {
          con.Open();
          cmd.Parameters.Clear();
          for (var i = 0; i < paramN.Length; i++)
          {
            string pVal = paramVal[i];
            if (pVal == "")
              cmd.Parameters.AddWithValue(paramN[i], DBNull.Value);
            else cmd.Parameters.AddWithValue(paramN[i], pVal);
          }
          var result = cmd.ExecuteScalar();
          if (result != null)
            id = result.ToString();
          else id = "-1";
          con.Close();
        }
      }
      return id;
    }

    public Bitmap viewMaker(Bitmap originImage, int W, int H)
    {
      int width, height;
      if (originImage.Width > originImage.Height)
      {
        width = W;
        height = (int)((originImage.Height / (double)originImage.Width) * W);
      }
      else
      {
        width = (int)((originImage.Width / (double)originImage.Height) * H);
        height = H;
      }

      Bitmap resizedbitmap = new Bitmap(width, height);

      Graphics g = Graphics.FromImage(resizedbitmap);
      g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
      g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
      g.Clear(Color.Transparent);
      g.DrawImage(originImage, new Rectangle(0, 0, resizedbitmap.Width, resizedbitmap.Height), new Rectangle(0, 0, originImage.Width, originImage.Height), GraphicsUnit.Pixel);
      g.Dispose();

      return resizedbitmap;
    }

    public void FTPUpload(string ftppath, HttpPostedFile file, Control ctrl)
    {
      // Copy the contents of the file to the request stream.
      BinaryReader br = new BinaryReader(file.InputStream);
      byte[] bytes = br.ReadBytes((Int32)file.InputStream.Length);

      // Get the object used to communicate with the server.
      FtpWebRequest request = (FtpWebRequest)WebRequest.Create(ftppath);
      request.Method = WebRequestMethods.Ftp.UploadFile;

      // This example assumes the FTP site uses anonymous logon.
      request.Credentials = new NetworkCredential("allwebftp", "webftp");
      request.ContentLength = file.InputStream.Length;


      try
      {
        using (Stream requestStream = request.GetRequestStream())
        {
          requestStream.Write(bytes, 0, bytes.Length);
        }
      }
      catch (WebException ex)
      {
        FtpWebResponse response = (FtpWebResponse)ex.Response;
        // js
        FrontEndDebug(ctrl, "ftp error", string.Format("console.log(`{0}`);", response.StatusDescription));
      }
      using (FtpWebResponse response = (FtpWebResponse)request.GetResponse())
      {
        // js
        FrontEndDebug(ctrl, "ftp error", string.Format("console.log(`{0}`);", response.StatusDescription));
      }
    }

    public string UserIP()
    {
      System.Web.HttpContext context = System.Web.HttpContext.Current;
      string ipAdd = context.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
      if (!string.IsNullOrEmpty(ipAdd))
      {
        string[] addresses = ipAdd.Split(',');
        if (addresses.Length != 0)
        {
          ipAdd = addresses[0];
        }
      }
      else ipAdd = context.Request.ServerVariables["REMOTE_ADDR"];
      if (string.IsNullOrEmpty(ipAdd))
      {
        ipAdd = context.Request.UserHostAddress;
      }

      return ipAdd;
    }

    public string StaffID(string county, DateTime date, int id)
    {
      return county + date.AddYears(-1911).ToString("yyyMM") + id.ToString("0000");
    }

    public string HmacSHA256(string message, string key)
    {
      var encoding = new System.Text.UTF8Encoding();
      byte[] keyByte = encoding.GetBytes(key);
      byte[] messageBytes = encoding.GetBytes(message);
      using (var hmacsha256 = new HMACSHA256(keyByte))
      {
        byte[] hashmessage = hmacsha256.ComputeHash(messageBytes);
        return BitConverter.ToString(hashmessage).Replace("-", "").ToLower();
      }
    }

    public string EncryptString(string Message, string Passphrase)
    {
      byte[] Results;
      System.Text.UTF8Encoding UTF8 = new System.Text.UTF8Encoding();

      MD5CryptoServiceProvider HashProvider = new MD5CryptoServiceProvider();
      byte[] TDESKey = HashProvider.ComputeHash(UTF8.GetBytes(Passphrase));
      TripleDESCryptoServiceProvider TDESAlgorithm = new TripleDESCryptoServiceProvider();
      TDESAlgorithm.Key = TDESKey;
      TDESAlgorithm.Mode = CipherMode.ECB;
      TDESAlgorithm.Padding = PaddingMode.PKCS7;
      byte[] DataToEncrypt = UTF8.GetBytes(Message);
      try
      {
        ICryptoTransform Encryptor = TDESAlgorithm.CreateEncryptor();
        Results = Encryptor.TransformFinalBlock(DataToEncrypt, 0, DataToEncrypt.Length);
      }
      finally
      {
        TDESAlgorithm.Clear();
        HashProvider.Clear();
      }
      return Convert.ToBase64String(Results);
    }

    public string DecryptString(string Message, string Passphrase)
    {
      byte[] Results;
      System.Text.UTF8Encoding UTF8 = new System.Text.UTF8Encoding();

      MD5CryptoServiceProvider HashProvider = new MD5CryptoServiceProvider();
      byte[] TDESKey = HashProvider.ComputeHash(UTF8.GetBytes(Passphrase));

      TripleDESCryptoServiceProvider TDESAlgorithm = new TripleDESCryptoServiceProvider();

      TDESAlgorithm.Key = TDESKey;
      TDESAlgorithm.Mode = CipherMode.ECB;
      TDESAlgorithm.Padding = PaddingMode.PKCS7;

      byte[] DataToDecrypt = Convert.FromBase64String(Message);
      // Step 5. Bat dau giai ma chuoi
      try
      {
        ICryptoTransform Decryptor = TDESAlgorithm.CreateDecryptor();
        Results = Decryptor.TransformFinalBlock(DataToDecrypt, 0, DataToDecrypt.Length);
      }
      catch (Exception) { Results = DataToDecrypt; }
      finally
      {
        TDESAlgorithm.Clear();
        HashProvider.Clear();
      }

      return UTF8.GetString(Results);
    }

    public void SendEmail(string From, string To, string Subject, string Body)
    {
      MailMessage msg = new MailMessage();
      //收件者，以逗號分隔不同收件者 ex "test@gmail.com,test2@gmail.com"
      msg.To.Add(To);
      msg.From = new MailAddress(From, Subject, System.Text.Encoding.UTF8);
      //郵件標題 
      msg.Subject = Subject;
      //郵件標題編碼  
      msg.SubjectEncoding = System.Text.Encoding.UTF8;
      //郵件內容
      msg.Body = Body;
      msg.IsBodyHtml = true;
      msg.BodyEncoding = System.Text.Encoding.UTF8;//郵件內容編碼 
      msg.Priority = MailPriority.Normal;//郵件優先級 
                                         //建立 SmtpClient 物件 並設定 Gmail的smtp主機及Port 
      #region 其它 Host
      /*
       *  outlook.com smtp.live.com port:25
       *  yahoo smtp.mail.yahoo.com.tw port:465
      */
      #endregion
      SmtpClient MySmtp = new SmtpClient("smtp.gmail.com", 587);
      //設定你的帳號密碼
      MySmtp.Credentials = new System.Net.NetworkCredential("ask.pinews@gmail.com", "yosrxfupswiasvda");
      //Gmial 的 smtp 使用 SSL
      MySmtp.EnableSsl = true;
      MySmtp.Send(msg);
    }

    public string GenAuthCode(int count)
    {
      Random rand = new Random();
      string validateCode = null;
      validateCode += rand.Next((int)Math.Pow(10, count - 1), (int)Math.Pow(10, count) - 1).ToString();

      return validateCode;
    }

    public string IDencrypt(long tick)
    {
      string[] alphabet = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" };
      string final = "";

      for (int i = 0; i < tick.ToString().Length; i++)
      {
        int subN = int.Parse(tick.ToString().Substring(i, 1));
        if (subN > 0 && subN <= 2)
        {
          int tmp = int.Parse(tick.ToString().Substring(i, 2));
          if (tmp < 26)
          {
            subN = tmp;
            i++;
          }
        }
        // Console.WriteLine(subN + " " + alphabet[subN]);
        final += alphabet[subN];
      }

      return final;
    }

    public string IDdecrypt(string ID)
    {
      string[] alphabet = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" };
      string final = "";

      for (int i = 0; i < ID.Length; i++)
      {
        string subID = ID.Substring(i, 1);
        final += Array.IndexOf(alphabet, subID).ToString();
      }

      return final;
    }

    public string IDcrypto(int id, DateTime ori)
    {
      long tick = ori.AddDays(-id).AddMilliseconds(id).Ticks;
      string final = IDencrypt(tick);
      return final;
    }

    public string IDval(string ID, DateTime ori)
    {
      long tick = long.Parse(IDdecrypt(ID));
      double diff = (ori - new DateTime(tick)).TotalMilliseconds;

      return (diff / 86399999).ToString();
    }
  }
}