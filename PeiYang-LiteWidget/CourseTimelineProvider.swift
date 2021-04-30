//
//  CourseTimelineProvider.swift
//  PeiYangLiteWidgetExtension
//
//  Created by 游奕桁 on 2020/9/17.
//

import Foundation
import WidgetKit

struct CourseTimelineProvider: TimelineProvider {
    var storage = Storage.courseTable
    var courseTable: CourseTable { storage.object }
    let formatter = DateFormatter()
    var endDate: Date{
        formatter.dateFormat = "YYYYMMdd"
        return formatter.date(from: "20210301")!
    }
    var totalDays: Int {
        endDate.daysBetweenDate(toDate: Date())
    }
    var todayWeek: Int {
        totalDays / 7 + 1
    }
    var todayDay: Int {
        totalDays % 7 + 1
    }
    var nowTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date())
    }
    
    func placeholder(in context: Context) -> DataEntry {
        DataEntry.placeholder
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DataEntry) -> Void) {
        if context.isPreview {
            completion(DataEntry.placeholder)
        } else {
//            let courses = getTodayCourse()
            let entry = DataEntry(date: Date(), courses: [Course()], weathers: [Weather()], studyRoom: [])
            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<DataEntry>) -> Void) {
//        var entries: [CourseEntry] = []
        
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
//        for offset in 0..<5 {
        let courses = getTodayCourse()
        let collections = getCollection()
        
        WeatherService().weatherGet { result in
            var weathers: [Weather]
            switch result {
            case .success(let weather):
                weathers = weather
                
            case .failure(let error):
                weathers = [Weather(), Weather()]
                print(error)
            }
            
            let entry = DataEntry(date: currentDate, courses: courses, weathers: weathers, studyRoom: collections)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
//            let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: currentDate)!
            
//            entries.append(entry)
//        }
        
        
    }
    
    func getTodayCourse() -> [Course] {
        let activeWeek = storage.object.currentWeek
        
        var weekdays: [String] {
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
    
    func getCollection() -> [CollectionClass] {
        var buildings: [StudyBuilding] = []
        var collection: [CollectionClass] = []
        StudyRoomManager.allBuidlingGet(term: "20212", week: String(todayWeek), day: String(todayDay)) { result in
            switch result {
            case .success(let data):
                buildings = data.data
                if(data.errorCode == 0) {
                    collection = requestDataToUseData(buildings: buildings)
                    break
                } else{
                }
            case .failure(let error):
                log(error)
            }
        }
        return collection
    }
    
    func requestDataToUseData(buildings: [StudyBuilding]) -> [CollectionClass] {
        var collection: [CollectionClass] = []
        StyCollectionManager.getCollections(buildings: buildings) {result in
            switch result {
            case .success(let data):
                collection = data
            case .failure(let error):
                log(error)
            }
        }
        return collection
    }
    
}

extension Date {
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
}

    

