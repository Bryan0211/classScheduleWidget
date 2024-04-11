import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: WidgetIntent())
    }

    func snapshot(for configuration: WidgetIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: WidgetIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for secondOffset in 0 ..< 60 {
            let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: WidgetIntent
}

struct showClassWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(Date.dateToString(entry.date))

            if entry.configuration.showingNowClass {
                Text("yes")
            } else {
                Text("No")
            }
        }
    }
}

struct showClassWidget: Widget {
    let kind: String = "showClassWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: WidgetIntent.self, provider: Provider()) { entry in
            showClassWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

extension WidgetIntent {
    fileprivate static var smiley: WidgetIntent {
        let intent = WidgetIntent()
        //intent.testParameter = .value1
        return intent
    }
    
    fileprivate static var starEyes: WidgetIntent {
        let intent = WidgetIntent()
        //intent.testParameter = .value2
        return intent
    }
}

#Preview(as: .systemSmall) {
    showClassWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
