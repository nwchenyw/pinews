# 拍新聞 (.NET Core 8 MVC 遷移)

本專案已從 ASP.NET WebForms 遷移至 ASP.NET Core 8 MVC。

## 專案結構

### Controllers (控制器)
- **HomeController** - 首頁顯示，包含橫幅、跑馬燈和最新文章
- **NewsController** - 新聞列表（依分類）和文章詳情頁面
- **AccountController** - 會員登入、註冊、登出功能
- **MemberController** - 會員中心，顯示個人資料和文章管理
- **ContactUsController** - 聯絡我們表單
- **OnlinePostController** - 線上投稿功能
- **ArticlesController** - 文章相關功能（保留）
- **MsgCheckController** - API 訊息驗證（保留）

### Views (視圖)
- **Home/Index.cshtml** - 首頁，包含輪播圖和文章卡片
- **News/Index.cshtml** - 新聞列表頁（含分頁功能）
- **News/Detail.cshtml** - 文章詳情頁
- **Account/Login.cshtml** - 登入表單
- **Account/Register.cshtml** - 註冊表單
- **Member/Index.cshtml** - 會員控制台
- **ContactUs/Index.cshtml** - 聯絡表單
- **OnlinePost/Index.cshtml** - 文章提交表單
- **Shared/_Layout.cshtml** - 主要版面配置（基於 Semantic UI）

### Models
- **Models/Reverse/** - 從現有資料庫反向工程產生的實體模型
  - Article, Member, Banner, Marquee, Category 等

### Data
- **ApplicationDbContext.cs** - EF Core 資料庫上下文
- **RemoteDbContext.cs** - 從現有資料庫 scaffold 的上下文

## 技術棧

- **.NET 8.0** - 目標框架
- **ASP.NET Core MVC** - Web 框架
- **Entity Framework Core 8.0** - ORM
- **SQL Server** - 資料庫
- **Semantic UI** - 前端 UI 框架（保留原有設計）
- **jQuery** - JavaScript 框架

## 主要功能

### 前台功能
1. **首頁** - 顯示橫幅廣告、跑馬燈、最新文章
2. **新聞列表** - 依分類瀏覽新聞，支援分頁
3. **文章詳情** - 顯示完整文章內容和相關文章
4. **會員登入/註冊** - 會員驗證系統
5. **會員中心** - 管理個人資料和已發表文章
6. **線上投稿** - 會員可以提交新聞文章
7. **聯絡我們** - 聯絡表單

### 資料庫架構
- 保持原有資料庫結構不變
- 使用 EF Core 作為 ORM
- 支援現有的資料表和關聯

## 設定

### 資料庫連線字串
在 `appsettings.json` 中設定連線字串：

```json
{
  "ConnectionStrings": {
    "PiNewsConStr": "Data Source=SERVER;Initial Catalog=DATABASE;User ID=USERNAME;Password=PASSWORD;TrustServerCertificate=True"
  }
}
```

## 執行專案

```bash
# 還原套件
dotnet restore

# 建置專案
dotnet build

# 執行專案
dotnet run
```

專案將在 `https://localhost:5001` 或 `http://localhost:5000` 上執行。

## 路由

- `/` - 首頁
- `/News/Category/{id}` - 新聞分類列表
- `/News/Detail/{id}` - 文章詳情
- `/Account/Login` - 登入
- `/Account/Register` - 註冊
- `/Member` - 會員中心
- `/OnlinePost` - 線上投稿
- `/ContactUs` - 聯絡我們

## 遷移說明

### 已完成
✅ 建立 .NET Core 8 MVC 專案結構  
✅ 使用 Entity Framework Core 作為 ORM  
✅ 建立所有主要控制器和視圖  
✅ 保留原有 HTML/CSS 設計（基於 Semantic UI）  
✅ 實作會員登入/註冊功能（使用 Session）  
✅ 實作新聞瀏覽和文章投稿功能  
✅ 資料庫連線使用 EF Core，支援現有資料庫結構  

### 保留的舊檔案
- `*.aspx` 和 `*.aspx.cs` - WebForms 檔案（已從編譯中排除）
- `App_Code/` - 舊的程式碼檔案（可供參考）
- `*.html` - 原始靜態 HTML 檔案（已轉換為 Razor 視圖）

### 注意事項
1. 密碼儲存目前未加密，建議實作密碼雜湊
2. 會員驗證使用 Session，建議改用 ASP.NET Core Identity
3. 圖片顯示使用 `/Image.aspx?id={id}` 路由（保留舊 API）
4. 需要設定正確的資料庫連線字串才能執行

## 開發建議

### 安全性改進
- 實作密碼雜湊（例如使用 BCrypt 或 ASP.NET Core Identity）
- 加入 CSRF 保護（已在表單中使用 `@Html.AntiForgeryToken()`）
- 實作郵件驗證功能
- 加入角色管理和權限控制

### 功能擴充
- 加入檔案上傳功能（用於文章圖片）
- 實作評論系統
- 加入文章搜尋功能
- 實作後台管理介面
- 加入即時通知功能

## 授權
版權所有 © 拍新聞
