using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// MemberRepository 的摘要描述
/// </summary>
public class MemberRepository
{
    private string connectionString;


    public MemberRepository()
    {
        connectionString = ConfigurationManager.ConnectionStrings["PiNewsConStr"].ConnectionString;
    }


    public string InsertIntoDatabase(RegisterInsertMemberDto qurey)
    {
        string insertedId = "";
        // 使用 using 保證連線資源會被正確釋放
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            // 資料庫操作命令字串
            //寫入DB的table
            //UserId, Pinews_name, Password, Pinews_pfr, Phone, Addr_county, Pinews_class, IsAdmin, Certification, Register_Time
            string insertQuery = "INSERT INTO Member (UserId, Pinews_name, Password, Pinews_pfr, Phone, Addr_county, Pinews_class,IsAdmin,Certification,Register_Time,[name]) " +
                                                                    "OUTPUT Inserted.Id VALUES (@Acc, @PinwesName, @Pass, @PlatformReferrer, @Tel, @County, @PinewClass,@IsAdmin,@Certification,@RegisterTime,@userName)";

            // 使用 using 保證命令資源會被正確釋放
            using (SqlCommand command = new SqlCommand(insertQuery, connection))
            {
                // 添加參數，防止 SQL 注入攻擊
                command.Parameters.AddWithValue("@Acc", qurey.Acc);
                command.Parameters.AddWithValue("@PinwesName", qurey.PinwesName);
                command.Parameters.AddWithValue("@Pass", qurey.Pass);
                command.Parameters.AddWithValue("@PlatformReferrer", qurey.PlatformReferrer);
                command.Parameters.AddWithValue("@Tel", qurey.Tel);
                command.Parameters.AddWithValue("@County", qurey.County);
                command.Parameters.AddWithValue("@PinewClass", qurey.PinewClass);
                //IsAdmin 0 為未繳費
                command.Parameters.AddWithValue("@IsAdmin", 0);
                //IsAdmin 0 為未完成
                command.Parameters.AddWithValue("@Certification", 0);
                command.Parameters.AddWithValue("@RegisterTime", DateTime.Now.ToString("yyyyMMdd HH:mm:ss"));
                command.Parameters.AddWithValue("@userName", qurey.UserName);

                // 打開資料庫連線
                connection.Open();
                var result = command.ExecuteScalar();
                if (result != null)
                    insertedId = result.ToString();
                else insertedId = "-1";
                command.Clone();

            }

            return insertedId;
        }
    }
    /// <summary>
    /// 關閉會員
    /// </summary>
    /// <param name="id"></param>
    public void UpdateIsAdminToFalse(int id)
    {
        bool isAdmin = false;
        // 使用 using 保證連線資源會被正確釋放
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            // 查询需要更新的数据
            string selectQuery = "SELECT * FROM Member WHERE Id = @Id";

            // 使用 using 保證命令資源會被正確釋放
            using (SqlCommand selectCommand = new SqlCommand(selectQuery, connection))
            {
                selectCommand.Parameters.AddWithValue("@Id", id);
                // 打開資料庫連線
                connection.Open();

                using (SqlDataReader reader = selectCommand.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // 获取查询结果，此处假设需要修改的字段为 IsAdmin
                        isAdmin = reader.GetBoolean(reader.GetOrdinal("IsAdmin"));
                    }
                }
                if (isAdmin)
                {
                    // 更新 IsAdmin 到 false
                    string updateQuery = "UPDATE Member SET IsAdmin = @IsAdmin WHERE Id = @Id";

                    // 使用 using 保證命令資源會被正確釋放
                    using (SqlCommand updateCommand = new SqlCommand(updateQuery, connection))
                    {
                        updateCommand.Parameters.AddWithValue("@IsAdmin", false);
                        updateCommand.Parameters.AddWithValue("@Id", id);
                        updateCommand.ExecuteNonQuery();
                    }
                }
                connection.Close();
            }
        }
    }

    /// <summary>
    /// 開通會員
    /// TODO
    /// </summary>
    /// <param name="id"></param>
    public void UpdateOpenIsAdmin(int id)
    {
        bool isAdmin = false;
        string buyerName = "";
        string buyerMail = "";
        int subscription_count = 0;
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            try
            {
                string selectQuery = "SELECT * FROM Member WHERE Id = @Id";
                connection.Open();
                using (SqlCommand selectCommand = new SqlCommand(selectQuery, connection))
                {
                    selectCommand.Parameters.AddWithValue("@Id", id);

                    using (SqlDataReader reader = selectCommand.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        if (reader.Read())
                        {
                            isAdmin = reader.GetBoolean(reader.GetOrdinal("IsAdmin"));
                            buyerMail = reader.GetString(reader.GetOrdinal("UserId"));
                            buyerName = reader.GetString(reader.GetOrdinal("Pinews_name"));
                            subscription_count = reader.GetInt32(reader.GetOrdinal("subscription_count"));
                        }
                    }
                }
                if (!isAdmin)
                {
                    // 更新 IsAdmin 到 false
                    string updateQuery = "UPDATE Member SET IsAdmin = @IsAdmin  ,subscription_count = @subscription_count ,lsat_subscription_time=@lsat_subscription_time WHERE Id = @Id";
                    connection.Open();
                    using (SqlCommand updateCommand = new SqlCommand(updateQuery, connection))
                    {

                        updateCommand.Parameters.AddWithValue("@IsAdmin", true);
                        updateCommand.Parameters.AddWithValue("@subscription_count", subscription_count + 1);
                        updateCommand.Parameters.AddWithValue("@lsat_subscription_time", DateTime.Now);
                        updateCommand.Parameters.AddWithValue("@Id", id);

                        updateCommand.ExecuteNonQuery();
                        updateCommand.Clone();
                    }
                    connection.Close();
                    // 插入支付記錄到 Member_Payment 表中
                    string insertQuery = "INSERT INTO Member_Payment (User_Id,Order_Id,Buyer_Name,Buyer_Telm,Buyer_Mail,Amount,CarrierType,CarrierId1,CarrierId2,BuyerIdentifier,NPOBAN,IsComplete,Pay_Time,Due_Time,Remark,User_Class) " +
                        "VALUES (@UserId, @OrderId, @BuyerName, @BuyerTelm, @BuyerMail, @Amount, @CarrierType, @CarrierId1, @CarrierId2, @BuyerIdentifier, @NPOBAN, @IsComplete, @PayTime, @DueTime, @Remark, @UserClass)";
                    connection.Open();

                    string formattedDate = DateTime.Now.ToString("yyyyMMddHHmm");
                    using (SqlCommand insertCommand = new SqlCommand(insertQuery, connection))
                    {
                        // 設置插入語句的參數值
                        insertCommand.Parameters.AddWithValue("@UserId", id);
                        insertCommand.Parameters.AddWithValue("@OrderId", "BK" + formattedDate);
                        insertCommand.Parameters.AddWithValue("@BuyerName", buyerName);
                        insertCommand.Parameters.AddWithValue("@BuyerTelm", DBNull.Value);
                        insertCommand.Parameters.AddWithValue("@BuyerMail", buyerMail);
                        insertCommand.Parameters.AddWithValue("@Amount", 16000);
                        insertCommand.Parameters.AddWithValue("@CarrierType", DBNull.Value);
                        insertCommand.Parameters.AddWithValue("@CarrierId1", DBNull.Value);
                        insertCommand.Parameters.AddWithValue("@CarrierId2", DBNull.Value);
                        insertCommand.Parameters.AddWithValue("@BuyerIdentifier", DBNull.Value);
                        insertCommand.Parameters.AddWithValue("@NPOBAN", DBNull.Value);
                        insertCommand.Parameters.AddWithValue("@IsComplete", 1);
                        insertCommand.Parameters.AddWithValue("@PayTime", DateTime.Now);
                        insertCommand.Parameters.AddWithValue("@DueTime", DateTime.Now.AddYears(1));
                        insertCommand.Parameters.AddWithValue("@Remark", "後台開通");
                        insertCommand.Parameters.AddWithValue("@UserClass", 2);

                        // 執行插入語句
                        insertCommand.ExecuteNonQuery();
                        insertCommand.Clone();

                    }

                    ////寫入userUrl
                    //string insertQueryUserUrl = "INSERT INTO [pinew].[dbo].[User_Url] ([User_Id], [Url]) VALUES (@UserId, @Url)";
                    //int userId = id; 
                    //string url = buyerMail.Split('@')[0];

                    //using (SqlCommand insertCommandUserUrl = new SqlCommand(insertQueryUserUrl, connection))
                    //{
                    //    insertCommandUserUrl.Parameters.AddWithValue("@UserId", id);
                    //    insertCommandUserUrl.Parameters.AddWithValue("@Url", url);
                    //    insertCommandUserUrl.ExecuteNonQuery();
                    //    insertCommandUserUrl.Clone();
                    //}
                }
            }

            catch (Exception ex)
            {
                // 發生異常時回滾事務
                Console.WriteLine("An error occurred: " + ex.Message);
                connection.Close();
            }
            finally
            {
                connection.Close();
            }
        }

    }




}




