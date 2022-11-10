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
        
        ZStack {
            Color(uiColor: UIColor(named: "backgroundWidget")!).edgesIgnoringSafeArea(.all)
            HStack {
                Spacer()
                VStack {
                    Text("Que tal criar um novo roteiro?")
                        .font(.custom("Avenir-Black", size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .colorInvert()
                    Text("Crie ou duplique um roteiro")
                        .font(.custom("Avenir-Book", size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .colorInvert()
                }
                VStack {
                    Image("emptyWidget")
                        .resizable()
                        .frame(width: 150, height: 150)
                }
            }
            
            
//            HStack {
//                Spacer()
//                VStack {
//                    // Text(entry.date, style: .time)
//                    Text("Sua viagem para")
//                        .font(.custom("Avenir-Book", size: 12))
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .multilineTextAlignment(.leading)
//                        .colorInvert()
//                    Text(nextTrip)
//                        .font(.custom("Avenir-Medium", size: 24))
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .multilineTextAlignment(.leading)
//                        .colorInvert()
//                    Text("acontecerá em:")
//                        .font(.custom("Avenir-Book", size: 12))
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .multilineTextAlignment(.leading)
//                        .colorInvert()
//
//                    Text(countdown)
//                        .font(.custom("Avenir-Black", size: 35))
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .multilineTextAlignment(.leading)
//                        .colorInvert()
//
//                }.padding()
//                VStack {
//                    Image("bussolaWidget")
//                        .resizable()
//                        .frame(width: 150, height: 150)
//                }
//            }
//
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
