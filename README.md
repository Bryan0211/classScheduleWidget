# 課程表Widget

課程表Widget 是一款為學生和教育工作者設計的 iOS 應用程式，旨在幫助用戶輕鬆管理和查看他們的課程安排。

## 主要功能

- 自定義每週課程表
  - 支持週一至週日的課程安排
  - 每天可添加多個課程
  - 每個課程可設置名稱、教師、教室、開始時間、結束時間和顏色
- 支持添加、編輯和刪除課程
- 提供整週和每日課程視圖
- iOS Widget 支持，方便快速查看當前和下一節課程
- Lock Screen Widget 支持（尚未實作）
- 支持自定義課程顏色
- 課程提醒功能（尚未實作）

## 技術棧

- SwiftUI: 用於構建用戶界面
- WidgetKit: 實現 iOS Widget 功能
- UserDefaults: 處理數據持久化和 App 與 Widget 間的數據共享
- Combine: 用於響應式編程，主要用於課程項目的自動排序（尚未完善）
- AppIntents: 實現 Widget 自定義配置

## 快速開始

1. 克隆專案倉庫:
git clone https://github.com/your-username/class-schedule-widget-app.git

2. 使用 Xcode 打開專案

3. 選擇目標設備或模擬器

4. 構建並運行應用程式

## 文檔

- 技術架構 (ARCHITECTURE.md)
- 開發指南 (DEVELOPMENT.md)
- 用戶手冊 (USER_GUIDE.md)
- README.md

## 貢獻

我們歡迎所有形式的貢獻。請查看我們的 [貢獻指南](./CONTRIBUTING.md) 以了解更多資訊。

## 許可證

本專案採用 MIT 許可證。詳情請見 [LICENSE](./LICENSE) 文件。
