import Foundation
import Combine
import SwiftUI
import WidgetKit


// <----- UserDefault Data key: weekSchedule 的 value ----->
// 週課程表
class WeekSchedule: Identifiable, Codable, ObservableObject {
    var id = UUID()
    @Published var dailySchedules: [DailySchedule]

    enum CodingKeys: String, CodingKey {
        case id, dailySchedules
    }

    init() {
        self.dailySchedules = (1...7).map { DailySchedule(day: $0) }
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        dailySchedules = try container.decode([DailySchedule].self, forKey: .dailySchedules)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(dailySchedules, forKey: .dailySchedules)
    }
}

// 每日課程表
struct DailySchedule: Identifiable, Codable {
    var id = UUID()
    var day: Int
    var classItemsWrapper: ClassItemsWrapper
    
    init(day: Int = 0) {
        self.day = day
        self.classItemsWrapper = ClassItemsWrapper()
    }
}

// 課程項目包裝器
class ClassItemsWrapper: ObservableObject, Codable {
    @Published var classItems: [UUID: ClassItem]

    init() {
        self.classItems = [:]
    }

    enum CodingKeys: String, CodingKey {
        case classItems
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        classItems = try container.decode([UUID: ClassItem].self, forKey: .classItems)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(classItems, forKey: .classItems)
    }
    
    // 獲取排序後的課程列表
    func getSortedClassItems() -> [ClassItem] {
        return classItems.values.sorted { $0.begin < $1.begin }
    }
}

// 課程項目
class ClassItem: Identifiable, Codable, ObservableObject {
    let id: UUID
    @Published var classNumber: Int?
    @Published var className: String
    @Published var teacherName: String
    @Published var classroom: String
    @Published var interval: Int
    @Published var begin: Date
    @Published var end: Date
    @Published var classColor: Color
    
    var day: Int
    
    enum CodingKeys: String, CodingKey {
        case id, classNumber, className, teacherName, classroom, interval, begin, end, classColor, day
    }
    
    init(id: UUID = UUID(),
         classNumber: Int? = nil,
         className: String = "國文課",
         teacherName: String = "王小明",
         classroom: String = "待定",
         interval: Int = 45,
         begin: Date = Date(),
         end: Date = Date().addingTimeInterval(45*60),
         classColor: Color = .blue,
         day: Int = 1) {
        self.id = id
        self.classNumber = classNumber
        self.className = className
        self.teacherName = teacherName
        self.classroom = classroom
        self.interval = interval
        self.begin = begin
        self.end = end
        self.classColor = classColor
        self.day = day
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        classNumber = try container.decodeIfPresent(Int.self, forKey: .classNumber)
        className = try container.decode(String.self, forKey: .className)
        teacherName = try container.decode(String.self, forKey: .teacherName)
        classroom = try container.decode(String.self, forKey: .classroom)
        interval = try container.decode(Int.self, forKey: .interval)
        begin = try container.decode(Date.self, forKey: .begin)
        end = try container.decode(Date.self, forKey: .end)
        classColor = try container.decode(CodableColor.self, forKey: .classColor).color
        day = try container.decode(Int.self, forKey: .day)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(classNumber, forKey: .classNumber)
        try container.encode(className, forKey: .className)
        try container.encode(teacherName, forKey: .teacherName)
        try container.encode(classroom, forKey: .classroom)
        try container.encode(interval, forKey: .interval)
        try container.encode(begin, forKey: .begin)
        try container.encode(end, forKey: .end)
        try container.encode(CodableColor(color: classColor), forKey: .classColor)
        try container.encode(day, forKey: .day)
    }
}


/*class WeekSchedule: Identifiable, Codable, ObservableObject {
    var id = UUID()
    @Published var dailySchedules: [DailySchedule]

    init() {
        self.dailySchedules = (1...7).map { DailySchedule(day: $0) }
    }
    
    // 編碼方法
    enum CodingKeys: String, CodingKey {
        case id, dailySchedules
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(dailySchedules, forKey: .dailySchedules)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        dailySchedules = try container.decode([DailySchedule].self, forKey: .dailySchedules)
    }
}

struct DailySchedule: Identifiable, Codable {
    var id = UUID()
    var day: Int = 0
    var classItemsWrapper: ClassItemsWrapper
        
    init(day: Int = 0) {
        self.day = day
        print("a")
        self.classItemsWrapper = ClassItemsWrapper()
    }
}

class ClassItemsWrapper: ObservableObject, Codable {
    @Published var classItems: [ClassItem] {
        didSet {
            print("didset!!")
            setupSubscribers(for: classItems)
            
            // 避免循環執行
            if !isSorting {
                sortClassItems()
            }
        }
    }
    
    private var isSorting = false
    private var cancellables = Set<AnyCancellable>()

    init() {
        print("b")
        self.classItems = []
        setupSubscribers(for: classItems)
        print("c")
    }
    
    
    // 編碼和解碼的鍵值定義
    enum CodingKeys: String, CodingKey {
        case classItems
    }

    // 從解碼器初始化
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        classItems = try container.decode([ClassItem].self, forKey: .classItems)
    }

    // 編碼方法
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(classItems, forKey: .classItems)
    }
    
    
    private func setupSubscribers(for items: [ClassItem]) {
        cancellables.removeAll()
        for item in items {
            item.objectWillChange.sink { [weak self] _ in
                self?.sortClassItems()
            }.store(in: &cancellables)
        }
    }

    
    //  依據課程開始時間排序課程
    func sortClassItems() {
        print("sort")
        isSorting = true
        classItems.sort {
            Date.dateToCompareString($0.begin) < Date.dateToCompareString($1.begin)
        }
        isSorting = false
    }
}

class ClassItem: Identifiable, Codable, ObservableObject {
    @Published var id = UUID()
    @Published var classNumber: Int?
    @Published var className: String
    @Published var teacherName: String
    @Published var classroom: String
    @Published var interval: Int
    @Published var begin: Date
    @Published var end: Date
    @Published var classColor: Color
    
    weak var viewModel: ScheduleViewModel?
    var day: Int
    var index: Int

    init(classNumber: Int? = 1, className: String = "國文課", teacherName: String = "王小明", classroom: String = "無", interval: Int = 45, begin: Date = .now, end: Date = (.now + TimeInterval(45.minute)), classColor: Color = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2), viewModel: ScheduleViewModel? = nil, day: Int = 0, index: Int = 0) {
        self.classNumber = classNumber
        self.className = className
        self.teacherName = teacherName
        self.classroom = classroom
        self.interval = interval
        self.begin = begin
        self.end = end
        self.viewModel = viewModel
        self.day = day
        self.index = index
        self.classColor = classColor
    }
    
    enum CodingKeys: String, CodingKey {
        case id, classNumber, className, teacherName, classroom, interval, begin, end, classColor, day, index
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        classNumber = try container.decodeIfPresent(Int.self, forKey: .classNumber)
        className = try container.decode(String.self, forKey: .className)
        teacherName = try container.decode(String.self, forKey: .teacherName)
        classroom = try container.decode(String.self, forKey: .classroom)
        interval = try container.decode(Int.self, forKey: .interval)
        begin = try container.decode(Date.self, forKey: .begin)
        end = try container.decode(Date.self, forKey: .end)
        classColor = try container.decode(CodableColor.self, forKey: .classColor).color
        viewModel = nil  // viewModel 和 day, index 需要初始化
        day = try container.decode(Int.self, forKey: .day)
        index = try container.decode(Int.self, forKey: .index)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(classNumber, forKey: .classNumber)
        try container.encode(className, forKey: .className)
        try container.encode(teacherName, forKey: .teacherName)
        try container.encode(classroom, forKey: .classroom)
        try container.encode(interval, forKey: .interval)
        try container.encode(begin, forKey: .begin)
        try container.encode(end, forKey: .end)
        try container.encode(CodableColor(color: classColor), forKey: .classColor)
    }
}*/


// <----- 增加@AppStorage和UserDefaults可使用類型 ----->

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else { return nil }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

extension Date: RawRepresentable{
    public typealias RawValue = String
    public init?(rawValue: RawValue) {
        guard let data = rawValue.data(using: .utf8),
              let date = try? JSONDecoder().decode(Date.self, from: data) else {
            return nil
        }
        self = date
    }

    public var rawValue: RawValue{
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data:data,encoding: .utf8) else {
            return ""
        }
       return result
    }
}

extension UserDefaults {
    func set<T: Codable>(_ value: T, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(value) {
            self.set(encoded, forKey: key)
        }
    }

    func codableObject<T: Codable>(forKey key: String) -> T? {
        if let data = self.data(forKey: key),
           let decoded = try? JSONDecoder().decode(T.self, from: data) {
            return decoded
        }
        return nil
    }
}



// <----- 實用方法 ----->

// 使Color能夠被decode/encode成json儲存起來
struct CodableColor: Codable {
    let color: Color

    enum CodingKeys: String, CodingKey {
        case red, green, blue, opacity
    }

    init(color: Color) {
        self.color = color
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let red = try container.decode(Double.self, forKey: .red)
        let green = try container.decode(Double.self, forKey: .green)
        let blue = try container.decode(Double.self, forKey: .blue)
        let opacity = try container.decode(Double.self, forKey: .opacity)
        self.color = Color(red: red, green: green, blue: blue, opacity: opacity)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let components = UIColor(self.color).cgColor.components ?? [0, 0, 0, 1]
        try container.encode(Double(components[0]), forKey: .red)
        try container.encode(Double(components[1]), forKey: .green)
        try container.encode(Double(components[2]), forKey: .blue)
        try container.encode(Double(components[3]), forKey: .opacity)
    }
}

extension Int {
    public var minute: Int {
        // 數字分鐘的秒數
        return self*60
    }
    
    public var hour: Int {
        // 數字小時的秒數
        return self*60*60
    }
    
    public var day: Int {
        // 數字天的秒數
        return self*60*60*24
    }
    
    public var month: Int {
        // 數字月的秒數(平均)
        return self*(60*60*24)*30
    }
    
    public var year: Int {
        // 數字年的秒數(平均)
        return self*((60*60*24)*30)*365
    }
}

// 阿拉伯數字轉中文
extension BinaryInteger {
    var chinese: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.numberStyle = .spellOut
        return formatter.string(from: NSDecimalNumber(string: "\(self)")) ?? ""
    }
}

extension Date {    
    static func dateToCompareString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.dateFormat = "HH:mm"
        let string = formatter.string(from: date)
        
        return string
    }
    
    static func dateToDisplayString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.dateFormat = "ah:mm"
        return formatter.string(from: date)
    }
}

extension DateFormatter {
    static var shortTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}


// 為了取得ScrollView的實際大小
extension View {
    func readIntrinsicContentSize(to size: Binding<CGSize>) -> some View {
        background(GeometryReader { proxy in
            Color.clear
                .onChange(of: proxy.size, initial: true) { newSize,arg  in
                    print(arg)
                    print(newSize)
                    print("GeometryReader sizeaaaaaa: \(newSize)\n")
                    size.wrappedValue = newSize
                }
            /*
            .preference(
                key: IntrinsicContentSizePreferenceKey.self,
                value: proxy.size
            )*/
        })/*
        .onPreferenceChange(IntrinsicContentSizePreferenceKey.self) {
            print("PreferenceKey size: \($0)")
            size.wrappedValue = $0
        }*/
    }
}

/*struct IntrinsicContentSizePreferenceKey: PreferenceKey {
    static let defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}*/

