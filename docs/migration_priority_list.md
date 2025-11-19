PiNews — 優先移植 / 保留清單

目的
- 在保留 WebForms（IIS 運行）前提下，列出所有關鍵功能/檔案、其相依性、建議處理方式與優先順序，方便你規劃未來的逐步移植或維運。

說明欄位
- 檔案/功能：專案內的實際檔案或功能模組
- 主要用途：此檔案/功能在系統中的作用
- 依賴：會影響或被其影響的其他檔案/系統（例如 Image.aspx、Session、MasterPage）
- 建議處理方式：Keep（保留於 IIS）、Migrate ASAP（盡速移植到 ASP.NET Core）、Defer（延後）
- 風險/影響：若不處理會造成的後果
- 工作量估計：小 / 中 / 大（相對估算）

優先清單（依優先級由高到低）

1) `Image.aspx` (根目錄)
- 主要用途：動態回傳圖片，整站大量使用 `Image.aspx?ID=` 或 `Image.aspx?Id=`。
- 依賴：多數前端頁面與 Admin、廣告、會員頁面等。
- 建議處理方式：Keep（IIS）或 Migrate ASAP（若要把資源集中在 Core）
- 風險/影響：若改動或移除會導致大量圖片失效，破壞前端顯示。
- 工作量估計：中（若移植需處理存取權限、緩存、Content-Type）

2) `UserAction/MsgCheck.aspx` + `MsgCheck.aspx.cs`
- 主要用途：訊息、推播或留言（重要互動 endpoint），使用 `RouteData`、`Response.Write`、`System.Web`。
- 依賴：前端 AJAX、Session、可能與通知系統整合。
- 建議處理方式：Migrate ASAP（示範移植首選）、同時在 IIS 保留舊版以免中斷服務。
- 風險/影響：互動相關功能中斷會影響用戶體驗與後端流程。
- 工作量估計：中（需重寫為 API Controller、處理 Session/Auth 與輸出 JSON）

3) 金流相關頁面：`Testchoosepaymode.aspx`, `Testpaycheck.aspx`, `urlcallback.aspx`, `Testurlcallback.aspx`, `paycheck.aspx`
- 主要用途：呼叫第三方支付、接收 callback。
- 依賴：外部回調 URL、SSL、驗證邏輯、訂單狀態更新。
- 建議處理方式：Keep（IIS）直到完整測試，長期可移植為 Web API（小心回調 URL 與安全）
- 風險/影響：若移植不當可能導致金流失敗或訂單資料錯誤。
- 工作量估計：大（需完整測試、模擬回調與憑證）

4) 登入/註冊/會員頁面：`Login.aspx`, `Register.aspx`, `Member.aspx`, `User_Profile.aspx`, `TestLogin.aspx`, `testMember.aspx`
- 主要用途：使用者認證、資料顯示與上傳（Session、驗證、圖片顯示）。
- 依賴：Session、MasterPage、Image.aspx、資料庫（RemoteDbContext）
- 建議處理方式：Keep（IIS）短期內維持，分階段移植（先把 API 認證與關鍵流程抽出）
- 風險/影響：會員功能錯誤會直接影響使用者登入與資料完整性。
- 工作量估計：大

5) Admin 系列頁面與 MasterPages：`Admin.aspx`, `Admin_*.aspx`, `AdminPage.Master`, `ClientPage.Master`, `MasterPage.Master`
- 主要用途：後台管理、MasterPage 提供共同 Layout 與權限檢查。
- 依賴：Session、App_Code、Admin helper 函式
- 建議處理方式：Keep（IIS），或逐步把重要 API（文章 CRUD）抽成 Web API 後再移動 UI。
- 風險/影響：後台不可用會影響營運管理。
- 工作量估計：大

6) `*.ashx` 處理器：`UserAction/isAlive.ashx`, `UserAction/Handler1.ashx`
- 主要用途：輕量 API、小工具或心跳檢查。
- 依賴：Session（視實作而定）、JS 呼叫。
- 建議處理方式：Migrate ASAP（轉成 ASP.NET Core minimal API 或 Controller），因為 ashx 較容易轉換且測試簡單。
- 風險/影響：可快速獲得好處（現代化、可在 Core 部署）。
- 工作量估計：小

7) `Global.asax` / `App_Code` 函式庫
- 主要用途：全域事件、共用函式、初始化邏輯。
- 依賴：多個頁面
- 建議處理方式：Keep 在 IIS 或把關鍵邏輯抽成共享 library（.dll）後讓 Core 與 WebForms 共用。
- 風險/影響：若刪除會造成初始化或共用函式缺失。
- 工作量估計：中

8) 其他靜態 / 前端相關：樣式、scripts、Semantic UI 資產
- 主要用途：前端外觀與互動
- 依賴：Views / .aspx
- 建議處理方式：可直接共用（同步或放 CDN/wwwroot），建議把共用靜態檔放在獨立位置供兩個系統存取。
- 風險/影響：外觀不一致
- 工作量估計：小

9) 其他零散頁面（Tag.aspx, Staff_Id.aspx, News_Info.aspx 等）
- 主要用途：特定頁面功能（路由、參數處理）
- 建議處理方式：Defer，只有當需要重構或發現問題時再移植。
- 工作量估計：中到小（視頁面複雜度）


建議的優先行動（短期可執行）
1. 立刻在 IIS 建立一個 WebForms 應用（.NET Framework 4.8），部署整個 WebForms 資料夾（包含 `App_Code`、`Global.asax`、所有 `.aspx`、`.ashx`、`.master`）。確認 `Image.aspx`、支付 callback 與 `MsgCheck.aspx` 在該環境可被外部存取。
2. 在同主機或其他主機上繼續執行 ASP.NET Core 應用（你已完成的 PiNewsCore），把共用靜態檔與 API 逐步抽出，例如把 `isAlive.ashx`、`Handler1.ashx` 先轉成 Core API，測試互通性。
3. 將 `MsgCheck.aspx` 視為第一個移植目標（若你想示範移植，我可立刻把 `MsgCheck.aspx.cs` 轉寫為 `Controllers/MsgCheckController.cs` 並加入測試 route）。

交付物
- 我已新增 `docs/migration_priority_list.md`（本文件）到專案的 `docs/` 資料夾。

下一步
- 若你要我直接「把 `MsgCheck.aspx.cs` 轉成 ASP.NET Core API」，請回覆確認，我會直接修改並建立 controller、並執行本地測試（不會修改遠端 DB）。
- 若你要我產生 IIS 的 `web.config` 與部署步驟，我也可以直接產出範本與指令。

---
最後進度更新：
- `列出關鍵功能並優先順序` 已完成，對應文件已新增為 `docs/migration_priority_list.md`。
- 下一項目在待辦清單：`選擇後續執行策略並實作第一步`（尚未開始）。

