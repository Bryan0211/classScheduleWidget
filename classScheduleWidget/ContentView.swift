import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selection = 2
    @StateObject var viewModel = ScheduleViewModel()
    
    // 修改UITabBar的底色
    init() {
        UITabBar.appearance().backgroundColor = UIColor(red:248/255, green: 248/255, blue: 248/255, alpha: 1.0)
    }

    var body: some View {
        TabView(selection:$selection) {
            ClassTimetableView()
                .tabItem {
                    Label("整週課表", systemImage: "calendar")
                }
                .tag(1)
                .environmentObject(viewModel)
            
            ClassView()
                .tabItem {
                    Label("自訂課表", systemImage: "calendar.day.timeline.left")
                }
                .tag(2)
                .environmentObject(viewModel)
            
            SettingView()
                .tabItem {
                    Label("設定", systemImage: "gearshape.2")
                }
                .tag(3)
                //.environmentObject(viewModel)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
