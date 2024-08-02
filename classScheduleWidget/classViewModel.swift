import Foundation
import SwiftUI
import WidgetKit
import os

// 自定義錯誤類型
enum ScheduleError: Error {
    case decodingFailed
    case encodingFailed
    case invalidClassIndex
    case invalidDayIndex
    case classNotFound
}

// MVVM 架構中的 ViewModel，負責管理課程表數據和業務邏輯
class ScheduleViewModel: ObservableObject {
    // 使用 AppStorage 來存儲週課程表數據，實現 App 和 Widget 之間的數據共享
    @AppStorage("weekSchedule", store: UserDefaults(suiteName: "group.com.classScheduleWidget.sharedData")) var weekScheduleData: Data = Data()
    
    // 發布的週課程表對象，UI 可以直接綁定此屬性
    @Published var weekSchedule: WeekSchedule?

    // 日誌記錄器
    private let logger = Logger(subsystem: "com.yourapp.classSchedule", category: "ScheduleViewModel")

    init() {
        loadWeekSchedule()
    }

    // 從 UserDefaults 加載週課程表數據
    func loadWeekSchedule() {
        logger.info("正在加載週課程表...")
        do {
            guard let loadedWeekSchedule = try? JSONDecoder().decode(WeekSchedule.self, from: weekScheduleData) else {
                throw ScheduleError.decodingFailed
            }

            if loadedWeekSchedule.dailySchedules.count < 7 {
                throw ScheduleError.invalidDayIndex
            }

            weekSchedule = loadedWeekSchedule
            try? syncWeekScheduleData()
        } catch {
            logger.error("加載週課程表失敗: \(error.localizedDescription)")
            initializeNewWeekSchedule()
        }
    }

    // 初始化新的週課程表
    func initializeNewWeekSchedule() {
        logger.info("初始化新週課程表")
        weekSchedule = WeekSchedule()
        try? syncWeekScheduleData()
    }

    // 新增課程
    func addClassItem(toDay day: Int, classItem: ClassItem) throws {
        print("classtime:\(classItem.begin)")
        guard (1...7).contains(day) else {
            throw ScheduleError.invalidDayIndex
        }

        let index = day - 1
        weekSchedule?.dailySchedules[index].classItemsWrapper.classItems[classItem.id] = classItem
        try syncWeekScheduleData()
        WidgetCenter.shared.reloadAllTimelines()
    }

    func updateClassItem<T>(inDay day: Int, classId: UUID, forKey keyPath: ReferenceWritableKeyPath<ClassItem, T>, value: T) throws {
        guard (1...7).contains(day) else {
            throw ScheduleError.invalidDayIndex
        }

        let dayIndex = day - 1
        guard var classItem = weekSchedule?.dailySchedules[dayIndex].classItemsWrapper.classItems[classId] else {
            throw ScheduleError.classNotFound
        }

        classItem[keyPath: keyPath] = value
        weekSchedule?.dailySchedules[dayIndex].classItemsWrapper.classItems[classId] = classItem
        try syncWeekScheduleData()
        WidgetCenter.shared.reloadAllTimelines()
    }

    // 刪除課程
    func removeClassItem(classId: UUID, inDay day: Int) throws {
        guard (1...7).contains(day) else {
            throw ScheduleError.invalidDayIndex
        }

        let dayIndex = day - 1
        guard weekSchedule?.dailySchedules[dayIndex].classItemsWrapper.classItems[classId] != nil else {
            throw ScheduleError.classNotFound
        }

        weekSchedule?.dailySchedules[dayIndex].classItemsWrapper.classItems.removeValue(forKey: classId)
        try syncWeekScheduleData()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    // 對指定日期的課程進行排序
    private func sortClassItems(forDay day: Int) {
        guard let dailySchedule = weekSchedule?.dailySchedules[day - 1] else { return }
        
        let sortedItems = dailySchedule.classItemsWrapper.classItems.values.sorted { $0.begin < $1.begin }
        
        // 使用新的有序字典來存儲排序後的課程
        var newClassItems: [UUID: ClassItem] = [:]
        for item in sortedItems {
            newClassItems[item.id] = item
        }
        
        weekSchedule?.dailySchedules[day - 1].classItemsWrapper.classItems = newClassItems
    }

    // 同步 weekSchedule 和 weekScheduleData
    private func syncWeekScheduleData() throws {
        guard let weekSchedule = weekSchedule else {
            logger.error("週課程表為空，無法同步")
            return
        }

        do {
            let encodedData = try JSONEncoder().encode(weekSchedule)
            weekScheduleData = encodedData
            logger.info("週課程表同步成功")
        } catch {
            logger.error("編碼週課程表失敗: \(error.localizedDescription)")
            throw ScheduleError.encodingFailed
        }
    }

    // 根據時間查找課程
    func findClass(at date: Date, inDay day: Int) throws -> ClassItem? {
        guard (1...7).contains(day) else {
            throw ScheduleError.invalidDayIndex
        }

        let dayIndex = day - 1
        let classes = weekSchedule?.dailySchedules[dayIndex].classItemsWrapper.classItems.values.sorted { $0.begin < $1.begin }
        
        return classes?.first { $0.begin <= date && date < $0.end }
    }
}
