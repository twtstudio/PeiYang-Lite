//
//  CourseEntry.swift
//  PeiYangLiteWidgetExtension
//
//  Created by 游奕桁 on 2020/9/17.
//

import Foundation
import WidgetKit

struct CourseEntry: TimelineEntry {
    let date: Date
    let courses: [Course]
    let weathers: [Weather]
    var isPlaceHolder = false
}

extension CourseEntry {
    static var placeholder: CourseEntry {
        CourseEntry(date: Date(), courses: [], weathers: [Weather(), Weather()], isPlaceHolder: true)
    }
}


