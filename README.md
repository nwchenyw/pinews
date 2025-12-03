PiNewsCore - .NET 8 MVC 範例專案

此資料夾為將原本 WebForms 專案遷移至 ASP.NET Core 8 MVC 的完整實作。包含：

- 使用 Entity Framework Core (SQL Server) 作為 ORM
- 完整的 MVC 架構：Controllers, Views, Models
- 會員系統：登入、註冊、會員中心
- 新聞系統：分類瀏覽、文章詳情、線上投稿
- 聯絡表單
- 基於 Semantic UI 的響應式前端設計

**詳細的遷移說明請參閱 [MIGRATION.md](./MIGRATION.md)**

快速啟動：
1. 請先安裝 .NET 8 SDK。
2. 在此資料夾下執行：
   ```bash
   dotnet restore
   dotnet build
   ```
3. 設定資料庫連線字串（參考 appsettings.json.example）

4. 執行：
   ```bash
   dotnet run
   ```

**重要警告：如果您在使用遠端既有資料庫（Production/Shared DB），請絕對不要執行** `dotnet ef database update` **或任何會變更結構的 migration，除非您已取得 DBA 同意與完整備份。**

本專案使用反向工程（Scaffold-DbContext）從現有資料庫讀取結構，不會修改資料庫。

若需要重新 scaffold 資料庫模型：

```bash
dotnet tool install --global dotnet-ef
dotnet ef dbcontext scaffold "Name=PiNewsConStr" Microsoft.EntityFrameworkCore.SqlServer -o Models/Reverse -c RemoteDbContext --schema dbo --use-database-names --force
```

注意：預設使用遠端 SQL Server（appsettings.json 的 PiNewsConStr），請修改連線字串指向您的資料庫。
