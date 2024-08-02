import SwiftUI

struct ClassView: View {
    @EnvironmentObject private var viewModel: ScheduleViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if let weekSchedule = viewModel.weekSchedule {
                    ForEach(1..<8) { day in
                        let classItemsWrapper = weekSchedule.dailySchedules[day-1].classItemsWrapper
                        
                        NavigationLink(
                            destination: DailyClassView(day: day)
                                .navigationTitle("星期\(day.chinese)")
                        ) {
                            HStack {
                                Text("星期 \(day.chinese)")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color(red: 100/255, green: 100/255, blue: 100/255))
                                
                                Spacer()
                                
                                Text("課程數: \(classItemsWrapper.classItems.count)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color(red: 80/255, green: 80/255, blue: 80/255))
                            }
                            .padding(.all, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color(red: 235/255, green: 235/255, blue: 235/255), lineWidth: 2)
                            )
                        }
                    }
                } else {
                    Text("Schedule load ERROR...")
                }
            }
            .padding()
            .navigationTitle("每日課表")
        }
    }
}
