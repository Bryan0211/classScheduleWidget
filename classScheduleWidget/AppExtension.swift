import Foundation
import Combine
import SwiftUI

/*
// binding傳遞classItem給ClassItemView修改值
struct ClassItemBinding {
    let day: Int
    let index: Int
    var viewModel: ScheduleViewModel

    var binding: Binding<ClassItem> {
        Binding<ClassItem>(
            get: { self.viewModel.weekSchedule?.dailySchedules[self.day - 1].classItems?[index] ?? ClassItem(classNumber: 1, className: "國文課", teacherName: "王小明", classroom: "a101", interval: 10, begin: .now, end: .now) },
            set: { newItem in
                self.viewModel.weekSchedule?.dailySchedules[self.day - 1].classItems?[index] = newItem
            }
        )
    }
}*/
