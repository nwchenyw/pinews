# ?? SQL Server SSL 連接問題 - 解決方案

## ?? 問題診斷

您遇到的問題是 **SQL Server SSL 憑證信任** 的問題：

```
此憑證鏈結是由不受信任的授權單位發出的
(Certificate chain is not trusted)
```

## ? 已應用的解決方案

### 1. **連接字符串更新**

? **更新前**:
```
Data Source=192.168.1.111;Initial Catalog=Pi news;User ID=sa;Password=!QAZxsw2;Connection Timeout=30
```

? **更新後**:
```
Data Source=192.168.1.111;Initial Catalog=Pi news;User ID=sa;Password=!QAZxsw2;Connection Timeout=30;TrustServerCertificate=true;Encrypt=true
```

**關鍵參數**:
- `TrustServerCertificate=true` - 信任自簽名憑證
- `Encrypt=true` - 啟用加密連接

### 2. **DbContext 配置改進** (Program.cs)

? **添加了改進的重試機制**:
```csharp
sqlOptions.EnableRetryOnFailure(
    maxRetryCount: 3,
    maxRetryDelay: TimeSpan.FromSeconds(10),
    errorNumbersToAdd: null
);
```

**優勢**:
- 自動重試 3 次 (瞬間故障)
- 每次重試延遲 10 秒
- 防止連接不穩定導致的錯誤

### 3. **錯誤診斷改進** (HomeController.cs)

? **更詳細的錯誤信息**:
```csharp
catch (Exception ex)
{
    _logger.LogError(ex, "Error querying data for Index page");
    
    string errorDetails = ex.Message;
    if (ex.InnerException != null)
    {
        errorDetails += $" | Inner: {ex.InnerException.Message}";
    }
    
    _logger.LogError($"[診斷] 完整錯誤: {errorDetails}");
    
    ViewData["DbError"] = $"資料庫連接錯誤: {errorDetails}";
    // ...
}
```

## ?? 立即測試

### 步驟 1: 清潔構建
```powershell
cd C:\Users\plauv\devstackers\pinews
dotnet clean
dotnet build
```

### 步驟 2: 運行應用
```powershell
dotnet run
```

### 步驟 3: 訪問首頁
打開瀏覽器訪問: `http://localhost:5xxx`

### 預期結果

? **成功**:
- 首頁正常加載
- 顯示所有內容 (Banners, Marquees, Recommendations, Articles, Ads)
- 查看瀏覽器開發者工具確認無錯誤

? **如果仍然失敗**:
- 查看應用日誌中的錯誤信息
- 檢查下面的故障排除部分

## ?? 故障排除

### 問題 1: "TrustServerCertificate 不被識別"

**原因**: SQL Server 版本或配置問題

**解決方案**:
- 確保使用 .NET 8 和最新的 SqlClient
- 嘗試只使用 `Encrypt=true` 不加 `TrustServerCertificate`

### 問題 2: 連接超時

**原因**: 可能是網絡延遲或防火牆

**檢查清單**:
- [ ] 確認 SQL Server 正在運行: `ping 192.168.1.111`
- [ ] 確認 SQL Server 端口 1433 未被阻擋
- [ ] 確認用戶名和密碼正確
- [ ] 增加 `Connection Timeout` 值 (例如 60 秒)

### 問題 3: "SSL 提供者錯誤"

**原因**: SQL Server 強制加密但客戶端配置不同

**解決方案**:
修改連接字符串為:
```
Data Source=192.168.1.111;Initial Catalog=Pi news;User ID=sa;Password=!QAZxsw2;Connection Timeout=60;TrustServerCertificate=true;Encrypt=true;Connection Reset=false
```

添加 `Connection Reset=false` 可以改善連接穩定性。

## ?? 驗證連接

### 方法 1: PowerShell 測試 (推薦)

```powershell
$connectionString = "Data Source=192.168.1.111;Initial Catalog=Pi news;User ID=sa;Password=!QAZxsw2;Connection Timeout=30;TrustServerCertificate=true;Encrypt=true"

try {
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString
    $connection.Open()
    Write-Host "? 連接成功！"
    $connection.Close()
} catch {
    Write-Host "? 連接失敗: $_"
}
```

### 方法 2: SQL Server Management Studio

1. 打開 SSMS
2. 連接到 `192.168.1.111`
3. 確認能連接並訪問 "Pi news" 數據庫

## ?? 應用日誌檢查

運行應用後，查看輸出窗口中的日誌：

? **成功日誌**:
```
info: Microsoft.EntityFrameworkCore.Database.Connection[20000]
      A database connection will be created.

[性能] 並行查詢耗時 (Banners, Marquees, Recommendations, Ads): XXXms
[性能] RecommendationArticles 查詢耗時: XXXms
[性能] Index 頁面總耗時: XXXms
```

? **失敗日誌**:
```
fail: Microsoft.EntityFrameworkCore.Database.Connection[20004]
      An error occurred using the connection to database 'Pi news' on server '192.168.1.111'.
```

如果看到失敗日誌，檢查完整錯誤信息中的具體原因。

## ?? 如果仍然無法連接

### 終極解決方案: 使用 Demo Mode

暫時使用內存數據庫進行測試：

```json
// appsettings.json
{
  "UseDemoMode": true
}
```

這樣應用將使用內存中的演示數據，無需實際數據庫連接。用於驗證應用邏輯是否正確。

### 長期解決方案

如果 SQL Server 連接持續出現問題，建議：

1. **檢查 SQL Server 日誌** (在服務器上)
2. **確認 TCP/IP 協議已啟用** (SQL Server Configuration Manager)
3. **重啟 SQL Server 服務**
4. **考慮禁用強制加密** (在服務器上)

## ? 成功標誌

應用成功連接到資料庫時，您應該看到：

- ? 首頁加載無錯誤
- ? 頁面顯示所有區塊 (橫幅、跑馬燈、推薦分類等)
- ? 應用日誌顯示 `[性能]` 消息
- ? 首頁加載時間在 2-3 秒內

## ?? 技術支持

如果問題持續，請收集以下信息：

1. **完整的錯誤堆棧** (從應用日誌)
2. **應用配置** (appsettings.json 中的相關部分 - 隱藏密碼)
3. **SQL Server 版本** 
4. **網絡配置** (是否在同一網絡或遠程連接)

---

**祝您成功解決連接問題！** ??
