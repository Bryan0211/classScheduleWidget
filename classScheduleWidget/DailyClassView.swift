import SwiftUI

struct DailyClassView: View {
    let day: Int
    @EnvironmentObject private var viewModel: ScheduleViewModel
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(Array(sortedClassItems), id: \.key) { id, item in
                        NavigationLink(
                            destination: ClassItemView(classId: id, day: day, item: item)
                        ) {
                            ClassItemRow(item: item)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: removeClass)
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
            }
            .navigationTitle("課程")
        }
        .padding()
        .toolbar {
            ToolbarItem {
                Button(action: addNewItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("錯誤"), message: Text(errorMessage), dismissButton: .default(Text("確定")))
        }
    }
    
    private var sortedClassItems: [(key: UUID, value: ClassItem)] {
        let items = viewModel.weekSchedule?.dailySchedules[day-1].classItemsWrapper.classItems ?? [:]
        return items.sorted { $0.value.begin < $1.value.begin }
    }
    
    private func addNewItem() {
        let newItem = ClassItem(day: day)
        do {
            try viewModel.addClassItem(toDay: day, classItem: newItem)
            print("classtime:\(newItem.begin)")
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
    
    private func removeClass(_ indexSet: IndexSet) {
        let classItems = Array(viewModel.weekSchedule?.dailySchedules[day-1].classItemsWrapper.classItems ?? [:])
        for index in indexSet {
            let (id, _) = classItems[index]
            do {
                try viewModel.removeClassItem(classId: id, inDay: day)
            } catch {
                showError = true
                errorMessage = error.localizedDescription
                break
            }
        }
    }
}

struct ClassItemRow: View {
    @ObservedObject var item: ClassItem
    
    var body: some View {
        VStack {
            HStack {
                Text(item.className)
                    .font(.title)
                Text(" \(Date.dateToDisplayString(item.begin))~\(Date.dateToDisplayString(item.end))")
                    .font(.body)
            }
            HStack {
                Group {
                    Text("老師:\(item.teacherName)")
                    Text("教室:\(item.classroom)")
                }
                .font(.body)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(item.classColor.opacity(0.55))
        )
    }
}
