# 課程表Widget 技術架構

## 概述

課程表 Widget App 採用 MVVM (Model-View-ViewModel) 架構模式，使用 SwiftUI 的聲明式 UI 進行界面開發。APP主要由兩個部分組成：主APP和 Widget 擴展。

## 主要組件

### 1. 模型 (Model)

- `WeekSchedule`: 代表整個週課程表的數據模型。
- `DailySchedule`: 表示每日課程安排。
- `ClassItem`: 代表單個課程項目。

這些模型定義在 `extension.swift` 文件中。

### 2. 視圖模型 (ViewModel)

- `ScheduleViewModel`: 管理課程表數據和業務邏輯的核心組件，定義在 `classViewModel.swift` 文件中。主要職責包括：
  - 加載和保存週課程表數據
  - 提供添加、更新、刪除課程的方法
  - 處理數據的持久化
  - 實現數據與 Widget 的同步
  - 提供查找特定時間課程的方法

### 3. 視圖 (View)

- `ContentView`: APP的主視圖，定義在 `ContentView.swift` 文件中。
- `ClassTimetableView`: 顯示整週課程表的視圖，定義在 `ClassTimetableView.swift` 文件中。
- `ClassView`: 顯示每日課程列表的視圖，定義在 `ClassView.swift` 文件中。
- `DailyClassView`: 顯示特定日期課程的詳細視圖，定義在 `DailyClassView.swift` 文件中。
- `ClassItemView`: 用於編輯單個課程項目的視圖，定義在 `ClassItemView.swift` 文件中。

### 4. Widget

Widget 相關組件定義在 `showClassWidget.swift` 文件中：

- `ClassScheduleWidget`: 定義 Widget 的結構和配置。
- `ClassScheduleProvider`: 為 Widget 提供數據的時間線提供者。主要職責包括：
  - 從 UserDefaults 讀取課程數據
  - 計算並提供當前和下一節課程的信息
  - 生成 Widget 顯示所需的時間線條目
- `ClassScheduleEntry`: 定義 Widget 顯示所需的數據結構。
- `ClassScheduleWidgetEntryView`: 定義 Widget 的視圖結構，負責渲染 Widget 的 UI。

## 數據流和狀態管理

1. `ScheduleViewModel` 作為中心數據管理器，負責數據的加載、更新和持久化。

2. 視圖通過 `@EnvironmentObject` 訪問 `ScheduleViewModel`，實現數據的讀取和修改。

3. 數據變更通過 `@Published` 屬性實現自動更新和UI刷新。

4. Combine 框架的使用尚未完全實作。（註：目前僅在 `ClassItemsWrapper` 中有部分使用）

5. `UserDefaults` 用於數據持久化和在主應用與 Widget 之間共享數據。

## App 與 Widget 通信

1. 主應用和 Widget 共享一個 App Group，使用 `UserDefaults` 進行數據交換。App Group 名稱為 "group.com.classScheduleWidget.sharedData"。

2. 當主應用更新課程數據時，會同步更新 `UserDefaults`。示例代碼：
   ```swift
   @AppStorage("weekSchedule", store: UserDefaults(suiteName: "group.com.classScheduleWidget.sharedData")) var weekScheduleData: Data = Data()
