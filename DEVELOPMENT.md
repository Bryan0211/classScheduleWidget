# 開發指南

本文檔提供了開發 課程表Widget 所需的資訊和指導。

## 開發環境要求

- macOS 版本 Sonoma 14 
- Xcode 15.0 或更高版本
- iOS 17.0 SDK 或更高版本
- Swift 5.9 或更高版本

## 專案設置

1. 克隆專案倉庫：
git clone https://github.com/your-username/class-schedule-widget-app.git

2. 打開 Xcode 並選擇 `classScheduleWidgetApp.xcodeproj` 文件。

3. 在 Xcode 中選擇適當的開發團隊和 bundle identifier。

4. 建立並運行專案。

## 代碼結構

專案的主要組件如下：

- `classScheduleWidgetApp.swift`: APP的入口點
- `ContentView.swift`: 主要的內容視圖
- `ClassTimetableView.swift`: 顯示整週課程表的視圖
- `ClassView.swift`: 顯示每日課程列表的視圖
- `DailyClassView.swift`: 顯示特定日期課程的詳細視圖
- `ClassItemView.swift`: 用於編輯單個課程項目的視圖
- `showClassWidget.swift`: Widget 相關的代碼
- `classViewModel.swift`: 包含 ViewModel 邏輯
- `extension.swift`: 包含擴展方法和自定義類型

## 開發流程

1. 創建新功能分支：
git checkout -b feature/your-feature-name

2. 進行代碼更改。

3. 運行測試確保所有功能正常。

4. 提交更改：
git commit -am "Add new feature: description of your changes"

5. 推送到你的分支：
git push origin feature/your-feature-name

6. 創建一個 Pull Request。

## 編碼規範

- 遵循 Swift API Design Guidelines。
- 使用有意義的變量和函數名稱。
- 為公共 API 添加適當的文檔註釋。
- 保持代碼簡潔，避免重複。

## 測試

- 為新功能編寫單元測試。
- 確保所有現有測試在提交前通過。
- 在多個 iOS 版本和設備上測試APP。

## 部署

- 更新版本號和構建號。
- 確保所有必要的圖標和啟動畫面都已更新。
- 使用 Xcode 的歸檔功能創建發佈版本。
- 通過 App Store Connect 提交APP以進行審核。

如有任何問題或需要更多說明，請聯繫專案維護者或查閱專案文檔。
