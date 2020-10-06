//
//  CourseTimelineProvider.swift
//  PeiYangLiteWidgetExtension
//
//  Created by 游奕桁 on 2020/9/17.
//

import Foundation
import WidgetKit

struct  CourseTimelineProvider: TimelineProvider {
    var storage = Storage.courseTable
    var courseTable: CourseTable { storage.object }
    
    func placeholder(in context: Context) -> CourseEntry {
        CourseEntry.placeholder
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CourseEntry) -> Void) {
        if context.isPreview {
            completion(CourseEntry.placeholder)
        } else {
//            let courses = getTodayCourse()
            let entry = CourseEntry(date: Date(), courses: [Course()])
            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CourseEntry>) -> Void) {
        var entries: [CourseEntry] = []
        
        let currentDate = Date()
        for hourOffset in 0..<2 {
            let courses = getTodayCourse()
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = CourseEntry(date: entryDate, courses: courses)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func getTodayCourse() -> [Course] {
        let activeWeek = storage.object.currentWeek
        
        var weeddays: [String] {
            var calendar = Calendar.current
            calendar.firstWeekday = 2
            var weekdays = calendar.shortWeekdaySymbols
            weekdays.append(weekdays.remove(at: 0))
            return weekdays
        }
        
        var activeCourseArray: [Course] {
            courseTable.courseArray.filter {
                $0.weekRange.contains(activeWeek)
            }
        }
        
        var currentCourseArray: [Course] {
            activeCourseArray.filter {
                $0.arrangeArray.map(\.weekday).contains(courseTable.currentWeekday)
            }
        }
        
        return currentCourseArray
        
    }
}
    

