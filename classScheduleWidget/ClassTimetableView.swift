import SwiftUI

struct Event: Identifiable {
    var id = UUID()
    var name: String
    var startTime: Date
    var endTime: Date
    var color: Color
}

struct TimetableView: View {
    var events: [Event]

    var body: some View {
        ScrollView {
            ZStack(alignment: .topLeading) {
                TimeAxisView()
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(events) { event in
                        EventView(event: event)
                    }
                }
                .padding()
                .coordinateSpace(name: "TimeTable")
                .readIntrinsicContentSize(to: $scrollViewContentSize)
                /*.background(GeometryReader { proxy in
                    Color.clear
                        .onChange(of: proxy.size, initial: true) { newSize,arg  in
                            print(arg)
                            print(newSize)
                            print("\(proxy.size)\n")
                            scrollViewContentSize = newSize
                        }
                })*/
            }
            .padding()
            .background(.clear)
            .coordinateSpace(name: "TimeTable")
        }
    }
}

struct TimeAxisView: View {
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<24) { hour in
                HStack(alignment: .center) {
                    Text("\(hour):00")
                        .frame(width: 46, height: 50, alignment: .trailing) // 固定寬度，右對齊
                    VStack {
                        Divider()
                    }
                }
            }
        }
    }
}


struct EventView: View {
    var event: Event

    var body: some View {
        let totalMinutesInDay: CGFloat = 24 * 60
        let startMinutes = minutesSinceMidnight(for: event.startTime)
        let endMinutes = minutesSinceMidnight(for: event.endTime)
        let eventDuration = endMinutes - startMinutes

        NavigationLink(destination: EventDetailView(event: event)) {
            Text(event.name)
                .padding(5)
                .background(event.color)
                .cornerRadius(5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .containerRelativeFrame(
                    .vertical,
                    count: Int(totalMinutesInDay),
                    span: Int(eventDuration),
                    spacing: 0,
                    alignment: .top
                )
                .offset(y: startMinutes / totalMinutesInDay * 1200) // 調整這裡以適應顯示高度
        }
    }

    func minutesSinceMidnight(for date: Date) -> CGFloat {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        return CGFloat(hour * 60 + minute)
    }
}

struct EventDetailView: View {
    var event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Event: \(event.name)")
                .font(.largeTitle)
                .padding(.bottom, 10)
            
            Text("Start Time: \(event.startTime, formatter: DateFormatter.shortTimeFormatter)")
            Text("End Time: \(event.endTime, formatter: DateFormatter.shortTimeFormatter)")
            
            Spacer()
        }
        .padding()
        .navigationTitle("Event Details")
    }
}

extension DateFormatter {
    static var shortTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}





struct ClassTimetableViewa: View {
    var body: some View {
        let calendar = Calendar.current
        let events = [
            Event(name: "Event 1", startTime: calendar.date(bySettingHour: 2, minute: 45, second: 0, of: Date())!, endTime: calendar.date(bySettingHour: 3, minute: 45, second: 0, of: Date())!, color: .purple),
            Event(name: "Event 2", startTime: calendar.date(bySettingHour: 4, minute: 0, second: 0, of: Date())!, endTime: calendar.date(bySettingHour: 5, minute: 0, second: 0, of: Date())!, color: .orange),
            Event(name: "Event 3", startTime: calendar.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!, endTime: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!, color: .black)
        ]
        
        NavigationStack {
            TimetableView(events: events)
                .coordinateSpace(name: "TimeTable")
        }
    }
}
/*
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}*/

#Preview {
    ClassTimetableViewa()
        .modelContainer(for: Item.self, inMemory: true)
}
