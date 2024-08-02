import SwiftUI

struct ClassItemView: View {
    let classId: UUID
    let day: Int
    @EnvironmentObject private var viewModel: ScheduleViewModel
    @ObservedObject var item: ClassItem
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            Group {
                // 課程名稱輸入欄位
                createTextField("課程名稱", text: $item.className, keyPath: \ClassItem.className)
                
                // 教師名稱輸入欄位
                createTextField("教師名稱", text: $item.teacherName, keyPath: \ClassItem.teacherName)
                
                // 教室輸入欄位
                createTextField("教室", text: $item.classroom, keyPath: \ClassItem.classroom)
                
                // 課程時長輸入欄位
                LabeledContent("課長時間(分鐘)") {
                    TextField(
                        "課長分鐘",
                        value: Binding(
                            get: { item.interval },
                            set: { newValue in
                                let validValue = max(0, newValue)
                                item.interval = validValue
                                item.end = item.begin.addingTimeInterval(TimeInterval(validValue * 60))
                                updateClassItem(forKey: \.interval, value: validValue)
                                updateClassItem(forKey: \.end, value: item.end)
                            }
                        ),
                        formatter: NumberFormatter()
                    )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                // 上課時間選擇器
                createDatePicker("上課時間", date: $item.begin, isStartTime: true)

                // 下課時間選擇器
                createDatePicker("下課時間", date: $item.end, isStartTime: false)
                
                // 課程顏色選擇器
                ColorPicker(
                    "課程顏色",
                    selection: Binding(
                        get: { item.classColor },
                        set: { newValue in
                            item.classColor = newValue
                            updateClassItem(forKey: \.classColor, value: newValue)
                        }
                    )
                )
            }
            .font(.title)
            .padding()
        }
        .padding()
        .alert(isPresented: $showError) {
            Alert(title: Text("錯誤"), message: Text(errorMessage), dismissButton: .default(Text("確定")))
        }
    }

    private func createTextField(_ label: String, text: Binding<String>, keyPath: ReferenceWritableKeyPath<ClassItem, String>) -> some View {
        LabeledContent(label) {
            TextField(
                label,
                text: Binding(
                    get: { text.wrappedValue },
                    set: { newValue in
                        text.wrappedValue = newValue
                        updateClassItem(forKey: keyPath, value: newValue)
                    }
                )
            )
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }

    private func createDatePicker(_ label: String, date: Binding<Date>, isStartTime: Bool) -> some View {
        DatePicker(
            label,
            selection: Binding(
                get: { date.wrappedValue },
                set: { newValue in
                    if isStartTime {
                        if newValue <= item.end {
                            date.wrappedValue = newValue
                        } else {
                            item.end = newValue
                            item.begin = newValue
                            updateClassItem(forKey: \.end, value: newValue)
                        }
                    } else {
                        if newValue >= item.begin {
                            date.wrappedValue = newValue
                        } else {
                            item.begin = newValue
                            item.end = newValue
                            updateClassItem(forKey: \.begin, value: newValue)
                        }
                    }
                    updateClassDuration()
                    updateClassItem(forKey: isStartTime ? \.begin : \.end, value: date.wrappedValue)
                }
            ),
            displayedComponents: .hourAndMinute
        )
    }

    private func updateClassDuration() {
        item.interval = Int(item.end.timeIntervalSince(item.begin)) / 60
        updateClassItem(forKey: \.interval, value: item.interval)
    }

    private func updateClassItem<T>(forKey keyPath: ReferenceWritableKeyPath<ClassItem, T>, value: T) {
        do {
            try viewModel.updateClassItem(inDay: day, classId: classId, forKey: keyPath, value: value)
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
}



/*
struct ClassItemView: View {
    let classId: UUID  // 使用 UUID 作為唯一標識符
    let day: Int
    @EnvironmentObject private var viewModel: ScheduleViewModel
    @ObservedObject var item: ClassItem  // 使用 @ObservedObject 來觀察 ClassItem 的變化

    var body: some View {
        VStack {
            Group {
                // 課程名稱輸入欄位
                LabeledContent("課程名稱") {
                    TextField(
                        "課名",
                        text: Binding(
                            get: { item.className },
                            set: { newValue in
                                item.className = newValue
                                try viewModel.updateClassItem(inDay: day, classId: classId, forKey: \.className, value: newValue)
                            }
                        )
                    )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                
            }
            .font(.title)
            .padding()
        }
        .padding()
    }
}*/
