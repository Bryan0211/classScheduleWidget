import SwiftUI
import SwiftData

struct SettingView: View {
    var body: some View {
        VStack {
            Text("test")
            Text("test")
            
            Spacer()
        }
    }
}

#Preview {
    SettingView()
        .modelContainer(for: Item.self, inMemory: true)
}
