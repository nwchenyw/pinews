PiNewsCore - .NET 8 MVC 範例專案

此資料夾為將原本 WebForms 專案逐步遷移至 ASP.NET Core 8 MVC 的範例骨架。包含：

- 使用 Entity Framework Core (SQL Server) 作為 ORM
- 範例 Model: Article, Category, Member
- 範例 Controller: HomeController, ArticlesController（使用 DbContext 撈取資料）
- 範例 Razor Views

快速啟動：
1. 請先安裝 .NET 8 SDK。
2. 在此資料夾下執行：
   dotnet restore
   dotnet build
3. 建立資料庫與 migration（注意：請勿對遠端生產 DB 執行下列操作，僅在本地或測試環境執行）

   **重要警告：如果您在使用遠端既有資料庫（Production/Shared DB），請絕對不要執行** `dotnet ef database update` **或任何會變更結構的 migration，除非您已取得 DBA 同意與完整備份。**

   在本地測試或開發環境（例如 LocalDB）建立 migration 的示例：

   dotnet ef migrations add InitialCreate -p . -s .
   dotnet ef database update -p . -s .

   若您要對既有遠端資料庫讀取結構而非修改，請使用反向工程（Scaffold-DbContext）：

   dotnet tool install --global dotnet-ef          # 或使用 local tool manifest
   dotnet ef dbcontext scaffold "Name=PiNewsConStr" Microsoft.EntityFrameworkCore.SqlServer -o Models/Reverse -c RemoteDbContext --schema dbo --use-database-names

   這會在本地產生模型與 DbContext，僅用於讀取/查詢；不會變更資料庫結構。
4. 執行：
   dotnet run

注意：預設使用 LocalDB（appsettings.json 的 DefaultConnection），若使用 SQL Server 或其他請修改連線字串。
