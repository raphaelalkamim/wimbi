//
//  wimbWidget.swift
//  wimbWidget
//
//  Created by Beatriz Duque on 10/11/22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),
                    nextTrip: "",
                    countdown: "")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),
                                nextTrip: "",
                                countdown: "")
        completion(entry)
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let nextTrip = UserDefaultsManager.shared.nextTrip
        let countdown = UserDefaultsManager.shared.countdown
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate,
                                    nextTrip: nextTrip ?? "",
                                    countdown: countdown ?? "")
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let nextTrip: String
    let countdown: String
}

struct WimbWidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        let countdown = entry.countdown
        let nextTrip = entry.nextTrip
        if countdown == "" {
            EmptyWidgetView()
        } else {
            CountdownWidgetView(countdown: countdown,
                                nextTrip: nextTrip)
        }
    }
    
    @main
    struct WimbWidget: Widget {
        let kind: String = "WimbWidget"
        
        var body: some WidgetConfiguration {
            StaticConfiguration(kind: kind, provider: Provider()) { entry in
                WimbWidgetEntryView(entry: entry)
            }
            .configurationDisplayName("My Widget")
            .description("This is an example widget.")
            .supportedFamilies([.systemMedium])
        }
    }
    
}

struct WimbWidget_Previews: PreviewProvider {
    static var previews: some View {
        WimbWidgetEntryView(entry: SimpleEntry(date: Date(),
                                               nextTrip: "",
                                               countdown: ""))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
