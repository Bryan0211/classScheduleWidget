#   APP架構與使用

<-----UserDefault Data----->

key: classInfo
value:
    [
        {day: 1, classItems: [ClassItem]?},
        {day: 2, classItems: [ClassItem]?},
        {day: 3, classItems: [ClassItem]?},
        {day: 4, classItems: [ClassItem]?},
        {day: 5, classItems: [ClassItem]?},
        {day: 6, classItems: [ClassItem]?},
        {day: 7, classItems: [ClassItem]?},
    ]
    
struct ClassItem: Identifiable {
    var id = UUID()
    var classNumber: Int
    var className: String = "國文課"
    var teacherName: String = "王小明"
    var classroom: String = "無"
    var interval: Int = 50
    var begin: Date = .now
    var end: Date {
        return self.begin + TimeInterval(self.interval * 60)
    }
}

key: setting
