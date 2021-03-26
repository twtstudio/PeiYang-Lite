//
//  PeiYangLiteWidget.swift
//  PeiYangLiteWidget
//
//  Created by 游奕桁 on 2020/9/17.
//

import WidgetKit
import SwiftUI

struct CourseTableWidgetEntryView: View {
    var entry: CourseTimelineProvider.Entry
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemMedium:
            MediumView(entry: entry)
        case .systemLarge:
            LargeView(entry: entry)
        default:
            SmallView(entry: entry)
        }
    }
}

@main
struct PeiYang_LiteWidget: Widget {
    let kind: String = "PeiYangLiteWidget"
    @Environment(\.widgetFamily) var family

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CourseTimelineProvider()) { entry in
            CourseTableWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("PeiYang Lite Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium, .systemSmall, .systemLarge])
    }
}
//struct PeiYangLiteWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        MediumView(currentCourseTable: [Course()], weathers: [Weather()])
//            .previewContext(WidgetPreviewContext(family: .systemMedium))
//    }
//}
