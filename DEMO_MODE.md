# Demo Mode - Testing Instructions

本專案已新增**Demo模式**，可以在沒有資料庫連線的情況下進行測試和 UI 預覽。

## 如何啟動 Demo 模式

Demo 模式使用記憶體資料庫（In-Memory Database）並自動填充測試資料。

### 方式 1：自動偵測（預設）

如果 `appsettings.json` 中的連線字串包含預設值（如 "SERVER" 或 "DATABASE"），系統會自動啟用 Demo 模式。

### 方式 2：手動啟用

在 `appsettings.json` 中加入：

```json
{
  "UseDemoMode": true,
  "ConnectionStrings": {
    "PiNewsConStr": "可以留空或使用預設值"
  }
}
```

## 執行步驟

1. 確保已安裝 .NET 8 SDK

2. **重要：複製靜態檔案到 wwwroot**
```bash
# 複製 CSS、JS、圖片和 Semantic UI 到 wwwroot 目錄
cp -r css wwwroot/
cp -r img wwwroot/
cp -r semantic wwwroot/
```

3. 執行應用程式：
```bash
dotnet restore
dotnet build
dotnet run
```

4. 開啟瀏覽器訪問 `http://localhost:5000` 或 `https://localhost:5001`

## Demo 資料

系統會自動建立以下測試資料：

### 測試帳號
- **帳號**: A123456789
- **密碼**: test123
- **姓名**: 測試會員

### 文章內容
- 5 篇範例新聞文章
- 2 個橫幅廣告
- 3 則跑馬燈訊息

## 可測試功能

✅ **首頁**
- 橫幅輪播
- 跑馬燈
- 最新文章列表

✅ **新聞列表**
- 分類瀏覽
- 分頁功能

✅ **文章詳情**
- 完整文章內容
- 相關文章推薦

✅ **會員功能**
- 登入（使用測試帳號）
- 會員中心
- 線上投稿

✅ **其他**
- 聯絡表單
- 註冊頁面

## 切換到正式資料庫

若要連接正式資料庫：

1. 修改 `appsettings.json`：

```json
{
  "UseDemoMode": false,
  "ConnectionStrings": {
    "PiNewsConStr": "Data Source=YOUR_SERVER;Initial Catalog=YOUR_DB;User ID=YOUR_USER;Password=YOUR_PASSWORD;TrustServerCertificate=True"
  }
}
```

2. 重新啟動應用程式

## 注意事項

⚠️ **Demo 模式的資料僅存在記憶體中**，重新啟動應用程式後會重置。

⚠️ **靜態檔案設定**：首次執行前，請將靜態檔案複製到 wwwroot 目錄：
```bash
cp -r css wwwroot/
cp -r img wwwroot/
cp -r semantic wwwroot/
```

這些靜態檔案包含：
- `css/` - 樣式表（main.css, animation.css 等）
- `img/` - 圖片資源（Logo、新聞圖片等）
- `semantic/` - Semantic UI 框架檔案

## 螢幕截圖

### 首頁
![首頁](https://github.com/user-attachments/assets/66cfd8a3-654f-40dc-8905-f57521918f9e)

### 文章詳情頁
![文章詳情](https://github.com/user-attachments/assets/5d7f3535-3530-4811-b705-e86f66d1e144)

### 登入頁面
![登入頁面](https://github.com/user-attachments/assets/06f5c0d6-2c44-4621-be28-cfae28e3fe20)
