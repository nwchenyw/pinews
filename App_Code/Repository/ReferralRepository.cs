using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// ReferralRepository 的摘要描述
/// </summary>
public class ReferralRepository
{
    private string connectionString;
    public ReferralRepository()
    {
        connectionString = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
    }

    public DataTable GetReferralData(string staffId) 
    {
        DataTable resultTable = new DataTable();
        string query = "SELECT * FROM Staff_Id AS S LEFT JOIN Member AS M ON M.Id = S.User_Id WHERE Staff_Id = @staffId";

        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            using (SqlDataAdapter adapter = new SqlDataAdapter(query, connection))
            {
                adapter.SelectCommand.Parameters.AddWithValue("@staffId", staffId);
                adapter.Fill(resultTable);
                return resultTable;
            }
        }
    }

    public string InsertReferralData(InsertReferralDto query)
    {
        string insertedId = "";
        string queryString = @"INSERT INTO Referral(User_Id, User_Class, Introducer_Id, Introducer_Class,Referral_Time) "+"" +
                                             "OUTPUT Inserted.Id VALUES(@User_Id, @User_Class, @Introducer_Id,@Introducer_Class, @Register_Time)";

        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            using (SqlCommand command = new SqlCommand(queryString, connection))
            {
                // 添加參數，防止 SQL 注入攻擊
                command.Parameters.AddWithValue("@User_Id", query.PinwesId);
                command.Parameters.AddWithValue("@User_Class", query.PinwesUserClass);
                command.Parameters.AddWithValue("@Introducer_Id", query.IntroducerId);
                command.Parameters.AddWithValue("@Introducer_Class", query.IntroducerClass);
                command.Parameters.AddWithValue("@Register_Time", DateTime.Now.ToString("yyyyMMdd HH:mm:ss"));

                // 打開資料庫連線
                connection.Open();

                // 執行 SQL 命令並取得插入的 ID
                var result = command.ExecuteScalar();
                if (result != null)
                    insertedId = result.ToString();
                else insertedId = "-1";
                command.Clone();
                return insertedId;
            }
        }
    }


}