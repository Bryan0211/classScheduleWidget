#   APP架構與使用

<-----UserDefault Data----->

key: classInfo
value:
    [
        {day: 1, class: [ClassItem]?},
        {day: 2, class: [ClassItem]?},
        {day: 3, class: [ClassItem]?},
        {day: 4, class: [ClassItem]?},
        {day: 5, class: [ClassItem]?},
        {day: 6, class: [ClassItem]?},
        {day: 7, class: [ClassItem]?},
    ]
    
struct ClassItem: Identifiable {
    var id = UUID()
    var classNumber: Int
    var name: String
    var interval: Int = 50
    var begin: Date
}

key: swtting
