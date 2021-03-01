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
    var isPlaceHolder = false
}

extension CourseEntry {
    static var placeholder: CourseEntry {
        CourseEntry(date: Date(), courses: [], isPlaceHolder: true)
    }
}


