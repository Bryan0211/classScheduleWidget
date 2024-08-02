import Foundation

// MVVM分離邏輯
class ScheduleViewModel: ObservableObject {
    let userDefaults = UserDefaults(suiteName: "group.com.classScheduleWidget.sharedData")
    @Published var weekSchedule: WeekSchedule?

    init() {
        let dailySchedules = (1...7).map { DailySchedule(day: $0, classItems: nil) }
        let weekSchedule = WeekSchedule(dailySchedules: dailySchedules)
        if let weekScheduleJson = try? JSONEncoder().encode(weekSchedule) {
            userDefaults!.set(weekScheduleJson, forKey: "weekSchedule")
        }
        loadWeekSchedule()
    }
}
