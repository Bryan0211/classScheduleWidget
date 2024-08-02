import WidgetKit
import SwiftUI

struct ClassScheduleProvider: AppIntentTimelineProvider {
    @AppStorage("weekSchedule", store: UserDefaults(suiteName: "group.com.classScheduleWidget.sharedData")) var weekScheduleData: Data = Data()
    
    func getCurrentAndNextClass(for date: Date) -> (current: ClassItem?, next: ClassItem?, displayText: String) {
        guard let weekSchedule = try? JSONDecoder().decode(WeekSchedule.self, from: weekScheduleData) else {
            return (nil, nil, "無課程資料")
        }
        
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        // day=1為星期一
        let day = (weekday == 1) ? 7 : weekday - 1
        // 索引從0開始
        let dailySchedule = weekSchedule.dailySchedules[day - 1]
        
        // 獲取排序後的課程列表
        let sortedClasses = dailySchedule.classItemsWrapper.getSortedClassItems()
        
        let currentClass = sortedClasses.first { classItem in
            date >= classItem.begin && date < classItem.end
        }
        
        let nextClass = sortedClasses.first { classItem in
            classItem.begin > date
        }
        
        let displayText = getDisplayText(currentClass: currentClass, nextClass: nextClass, date: date)
        
        return (currentClass, nextClass, displayText)
    }
    
    func getDisplayText(currentClass: ClassItem?, nextClass: ClassItem?, date: Date) -> String {
        if let current = currentClass {
            let endTime = current.end
            let minutesUntilEnd = ceil(endTime.timeIntervalSince(date) / 60)
            
            if minutesUntilEnd <= 10 && minutesUntilEnd > 0 {
                // 課程結束前10分鐘內
                return "\(Int(minutesUntilEnd))分鐘下課！"
            } else {
                // 課程進行中
                return "下課:\(formatTime(endTime))"
            }
        } else if let next = nextClass {
            let startTime = next.begin
            let minutesUntilStart = ceil(startTime.timeIntervalSince(date) / 60)
            
            if minutesUntilStart <= 10 && minutesUntilStart > 0 {
                // 課程開始前10分鐘內
                return "\(Int(minutesUntilStart))分鐘上課！"
            } else if minutesUntilStart > 10 {
                // 休息時間，但距離下節課超過10分鐘
                return "休息時間！"
            } else {
                // 正好要上課
                return "上課:\(formatTime(startTime))"
            }
        } else {
            return "今日已無課程"
        }
    }
    
    // 格式化時間為 "HH:mm" 格式
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    func placeholder(in context: Context) -> ClassScheduleEntry {
        ClassScheduleEntry(date: Date(), configuration: WidgetIntent(), currentClass: nil, nextClass: nil, displayText: "載入中...")
    }

    func snapshot(for configuration: WidgetIntent, in context: Context) async -> ClassScheduleEntry {
        let (current, next, displayText) = getCurrentAndNextClass(for: Date())
        return ClassScheduleEntry(date: Date(), configuration: configuration, currentClass: current, nextClass: next, displayText: displayText)
    }
    
    func timeline(for configuration: WidgetIntent, in context: Context) async -> Timeline<ClassScheduleEntry> {
        var entries: [ClassScheduleEntry] = []
        let currentDate = Date()
        let calendar = Calendar.current
        let endOfDay = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: currentDate)!)
        
        var entryDate = currentDate
        while entryDate < endOfDay {
            let (current, next, displayText) = getCurrentAndNextClass(for: entryDate)
            let entry = ClassScheduleEntry(date: entryDate, configuration: configuration, currentClass: current, nextClass: next, displayText: displayText)
            entries.append(entry)
            
            // 確定下一個更新時間
            if displayText.contains("分鐘上課！") || displayText.contains("分鐘下課！") {
                // 在倒計時階段，每分鐘更新一次
                entryDate = calendar.date(byAdding: .minute, value: 1, to: entryDate)!
            } else {
                // 找到下一個需要更新的時間點
                let nextUpdateTime = [current?.end, next?.begin]
                    .compactMap { $0?.addingTimeInterval(-10 * 60) } // 課程開始或結束前10分鐘
                    .filter { $0 > entryDate }
                    .min()
                
                if let nextTime = nextUpdateTime {
                    entryDate = nextTime
                } else {
                    // 如果沒有特定的下一個更新時間點，則結束循環
                    break
                }
            }
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct ClassScheduleEntry: TimelineEntry {
    let date: Date
    let configuration: WidgetIntent
    let currentClass: ClassItem?
    let nextClass: ClassItem?
    let displayText: String
}

struct ClassScheduleWidgetEntryView: View {
    var entry: ClassScheduleProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        Group {
            if family == .systemSmall {
                smallWidgetView
            } else {
                mediumWidgetView
            }
        }
        .padding(8)
    }
    
    var smallWidgetView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(formatTime(entry.date))
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(formatDisplayText(entry.displayText))
                .font(.headline)
                .foregroundColor(entry.currentClass?.classColor ?? entry.nextClass?.classColor ?? .blue)
            
            if let currentClass = entry.currentClass {
                classInfoView(class: currentClass, isCurrentClass: true, compact: true)
            }
            
            if let nextClass = entry.nextClass {
                classInfoView(class: nextClass, isCurrentClass: false, compact: true, showTime: true)
            }
        }
    }
    
    var mediumWidgetView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(formatTime(entry.date))
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(formatDisplayText(entry.displayText))
                .font(.headline)
                .foregroundColor(entry.currentClass?.classColor ?? entry.nextClass?.classColor ?? .blue)
            
            if let currentClass = entry.currentClass {
                classInfoView(class: currentClass, isCurrentClass: true)
                
                if let nextClass = entry.nextClass {
                    classInfoView(class: nextClass, isCurrentClass: false)
                }
            } else if let nextClass = entry.nextClass {
                classInfoView(class: nextClass, isCurrentClass: true)
            } else {
                Text("今日無更多課程")
                    .font(.subheadline)
            }
        }
    }
    
    // 顯示課程信息的視圖
    func classInfoView(class item: ClassItem, isCurrentClass: Bool, compact: Bool = false, showTime: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(item.className)
                    .font(compact ? .caption : (isCurrentClass ? .subheadline : .caption))
                    .fontWeight(.bold)
                Spacer()
                Text(item.classroom)
                    .font(compact ? .caption2 : .caption)
            }
            
            if !compact || showTime {
                Text("時間: \(formatTime(item.begin))-\(formatTime(item.end))")
                    .font(isCurrentClass ? .caption : .caption2)
            }
        }
        .padding(6)
        .background(item.classColor.opacity(isCurrentClass ? 0.2 : 0.1))
        .cornerRadius(8)
    }
    
    // 格式化顯示文本，將時間轉換為24小時制
    func formatDisplayText(_ text: String) -> String {
        let components = text.components(separatedBy: ":")
        guard components.count >= 2 else { return text }
        
        let label = components[0]
        let timeString = components[1...].joined(separator: ":")
        
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "zh_Hant_TW")
        inputFormatter.dateFormat = "ah:mm"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        
        if let date = inputFormatter.date(from: timeString.trimmingCharacters(in: .whitespaces)) {
            let formattedTime = outputFormatter.string(from: date)
            return "\(label):\(formattedTime)"
        }
        
        // 如果無法解析時間，嘗試直接格式化
        let timeDigits = timeString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if timeDigits.count >= 3 {
            let paddedTime = String(timeDigits.prefix(4).padding(toLength: 4, withPad: "0", startingAt: 0))
            if let timeInt = Int(paddedTime), timeInt >= 0 && timeInt < 2400 {
                let hours = timeInt / 100
                let minutes = timeInt % 100
                return String(format: "%@:%02d:%02d", label, hours, minutes)
            }
        }
        
        return text
    }
    
    // 格式化時間為 "HH:mm" 格式
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

struct ClassScheduleWidget: Widget {
    let kind: String = "ClassScheduleWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: WidgetIntent.self, provider: ClassScheduleProvider()) { entry in
            ClassScheduleWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("課程表")
        .description("顯示當前或下一節課程信息")
    }
}

#Preview(as: .systemSmall) {
    ClassScheduleWidget()
} timeline: {
    ClassScheduleEntry(date: .now, configuration: .smiley, currentClass: nil, nextClass: nil, displayText: "Preview")
    ClassScheduleEntry(date: .now, configuration: .starEyes, currentClass: nil, nextClass: nil, displayText: "Preview")
}

// 擴展 WidgetIntent 用於預覽
extension WidgetIntent {
    fileprivate static var smiley: WidgetIntent {
        let intent = WidgetIntent()
        return intent
    }
    
    fileprivate static var starEyes: WidgetIntent {
        let intent = WidgetIntent()
        return intent
    }
}
