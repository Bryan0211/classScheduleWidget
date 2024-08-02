import Foundation
/*

class ScheduleViewModelController {
    let userDefaults = UserDefaults(suiteName: "group.com.classScheduleWidget.sharedData")
    var weekSchedule: WeekSchedule?
    
    init(weekSchedule: WeekSchedule?) {
        self.weekSchedule = weekSchedule
    }
    
    func loadWeekSchedule() {
        if let data = userDefaults!.data(forKey: "weekSchedule"),
           let loadedWeekSchedule = try? JSONDecoder().decode(WeekSchedule.self, from: data) {
            weekSchedule = loadedWeekSchedule
        }
    }

    // 新增課程
    func addClassItem(toDay day: Int, classItem: ClassItem) {
        let index = day-1
        // 如果該日程已有課程項目，則添加新的課程項目
        // 如果該日程還沒有課程項目，則創建一個新的課程項目陣列
        weekSchedule?.dailySchedules[index].classItems = (weekSchedule?.dailySchedules[index].classItems ?? []) + [classItem]
        
        // 將更新後的 weekSchedule 儲存到 UserDefaults
        saveWeekSchedule()
    }

    // 修改課程
    func updateClassItem(at classIndex: Int, inDay day: Int, with newItem: ClassItem) {
        let dayIndex = day-1
        if weekSchedule?.dailySchedules[dayIndex].classItems?.indices.contains(classIndex) == true {
            weekSchedule?.dailySchedules[dayIndex].classItems?[classIndex] = newItem
            // 將更新後的 weekSchedule 儲存到 UserDefaults
            saveWeekSchedule()
        }
    }

    // 刪除課程
    func removeClassItem(at classIndex: Int, inDay day: Int) {
        let dayIndex = day-1
        if weekSchedule?.dailySchedules[dayIndex].classItems?.indices.contains(classIndex) == true {
            weekSchedule?.dailySchedules[dayIndex].classItems?.remove(at: classIndex)
            // 將更新後的 weekSchedule 儲存到 UserDefaults
            saveWeekSchedule()
        }
    }

    // 儲存 weekSchedule 到 UserDefaults
    func saveWeekSchedule() {
        if let weekSchedule = weekSchedule,
           let weekScheduleJson = try? JSONEncoder().encode(weekSchedule) {
            userDefaults!.set(weekScheduleJson, forKey: "weekSchedule")
        }
    }

}*/
