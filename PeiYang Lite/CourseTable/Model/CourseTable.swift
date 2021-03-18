//
//  CourseTable.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/30/20.
//

import SwiftUI

struct Arrange: Codable, Storable, Comparable {
    let teacherArray: [String]
    let weekArray: [Int] // 1...
    let weekday: Int // 0...
    let unitArray: [Int] // 0...
    let location: String
    
    // Teacher
    var teachers: String { teacherArray.joined(separator: ", ") }
    
    // Week
    var firstWeek: Int { weekArray.first ?? 1 }
    var lastWeek: Int { weekArray.last ?? 1 }
    var weekString: String { "\(firstWeek)-\(lastWeek)" }
    
    // Unit
    var startUnit: Int { unitArray.first ?? 0 }
    var startTime: (Int, Int) {
        [
            (8, 30), (9, 20), (10, 25), (11, 15),
            (13, 30), (14, 20), (15, 25), (16, 15),
            (18, 30), (19, 20), (20, 10), (21, 0)
        ][startUnit]
    }
    var startTimeString: String { String(format: "%02d:%02d", startTime.0, startTime.1) }
    var length: Int { unitArray.count }
    var endTime: (Int, Int) {
        [
            (9, 15), (10, 5), (11, 10), (12, 0),
            (14, 15), (15, 5), (16, 10), (17, 0),
            (19, 15), (20, 5), (20, 55), (21, 45)
        ][startUnit + length - 1]
    }
    var endTimeString: String { String(format: "%02d:%02d", endTime.0, endTime.1) }
    var unitString: String { "\(startUnit + 1)-\(startUnit + length)" }
    var unitTimeString: String { "\(startTimeString)-\(endTimeString)" }
    
    var uuid: String { teachers + weekString + weekday.description + unitString + location }
    
    init(teacherArray: [String], weekArray: [Int], weekday: Int, unitArray: [Int], location: String) {
        self.teacherArray = teacherArray
        self.weekArray = weekArray
        self.weekday = weekday
        self.unitArray = unitArray
        self.location = location
    }
    
    init() {
        self.teacherArray = []
        self.weekArray = []
        self.weekday = 0
        self.unitArray = []
        self.location = ""
    }
    
    static func < (lhs: Arrange, rhs: Arrange) -> Bool {
        if lhs.firstWeek != rhs.firstWeek {
            return lhs.firstWeek < rhs.firstWeek
        } else if lhs.weekday != rhs.weekday {
            return lhs.weekday < rhs.weekday
        } else if lhs.startUnit != rhs.startUnit {
            return lhs.startUnit < rhs.startUnit
        } else {
            return lhs.teachers < rhs.teachers
        }
    }
}

struct Course: Codable, Storable {
    
    let serial: String
    let no: String
    let name: String
    let credit: String
    let teacherArray: [String]
    let weeks: String
    let campus: String
    let arrangeArray: [Arrange]
    
    var teachers: String { teacherArray.joined(separator: ", ") }
    
    var weekRange: ClosedRange<Int> {
        let weekArray = weeks.split(separator: "-").map { Int($0) ?? 0 }
        return weekArray.count == 2 ? weekArray[0]...weekArray[1] : 1...1
    }
    
    func activeArrange(_ weekday: Int) -> Arrange {
//        arrangeArray.filter { $0.weekday == weekday }[0]
        arrangeArray.first { $0.weekday == weekday } ?? Arrange(teacherArray: [], weekArray: [], weekday: 0, unitArray: [], location: "")
    }
    
//    init(serial: String, no: String, name: String, credit: String, teacherArray: [String], weeks: String, campus: String, arrangeArray: [Arrange]) {
//        self.serial = serial
//        self.no = no
//        self.name = name
//        self.credit = credit
//        self.teacherArray = teacherArray
//        self.weeks = weeks
//        self.campus = campus
//        self.arrangeArray = arrangeArray
//    }
    
    init(fullCourse: [String], arrangePairArray: [(String, Arrange)]) {
        self.serial = fullCourse[1]
        self.no = fullCourse[2]
        self.name = fullCourse[3]
        self.credit = fullCourse[4]
        self.teacherArray = fullCourse[5].split(separator: ",").map { String($0).replacingOccurrences(of: "(", with: " (") }
        self.weeks = fullCourse[6]
        self.campus = fullCourse[9]

        var arrangeArray = [Arrange]()
        for (name, arrange) in arrangePairArray {
            if name == fullCourse[3] {
                arrangeArray.append(arrange)
            }
        }
        self.arrangeArray = arrangeArray
    }
    
    init() {
        self.serial = ""
        self.no = ""
        self.name = ""
        self.credit = ""
        self.teacherArray = [""]
        self.weeks = ""
        self.campus = ""
        self.arrangeArray = []
    }
}

struct CourseTable: Codable, Storable {
    var courseArray: [Course]
    
    var totalWeek: Int {
        courseArray.map { $0.weekRange.max() ?? 1 }.max() ?? 1
    }
    
    var currentCalendar: Calendar {
        var currentCalendar = Calendar.current
        currentCalendar.firstWeekday = 2
        return currentCalendar
    }
    var startDate: Date {
        // TODO: Changed termly
        // 20212
        DateComponents(calendar: currentCalendar, year: 2021, month: 3, day: 1).date ?? Date(timeIntervalSince1970: 0)
        // 20211
//        DateComponents(calendar: currentCalendar, year: 2020, month: 8, day: 31).date ?? Date(timeIntervalSince1970: 0)
        // 19202
//        DateComponents(calendar: currentCalendar, year: 2020, month: 2, day: 17).date ?? Date()
    }
    private var endDate: Date { Date(timeInterval: TimeInterval(totalWeek * 7 * 24 * 60 * 60), since: startDate) }
    var currentDate: Date {
        // TODO: Dynamic calculated
        let currentDate = Date()
        if currentDate < startDate {
            return startDate
        } else if currentDate > endDate {
            return endDate
        } else {
            return currentDate
        }
        // test date
//        DateComponents(calendar: currentCalendar, year: 2020, month: 9, day: 10, hour: 10, minute: 30).date ?? Date()
    }
    
    var currentMonth: String { currentDate.format(with: "LLL") }
    
    var currentDay: Int { currentCalendar.component(.day, from: currentDate) }
    
    private var weekDistance: Double { startDate.distance(to: currentDate) / (7 * 24 * 60 * 60) }
    private var passedWeek: Double { floor(weekDistance) }
    var currentWeek: Int { weekDistance == 0 ? 1 : Int(ceil(weekDistance)) }
    
    var currentWeekStartDay: Int {
        let currentWeekStartDate = startDate.addingTimeInterval(passedWeek * 7 * 24 * 60 * 60)
        return currentCalendar.component(.day, from: currentWeekStartDate)
    }
    
    var currentWeekday: Int {
        let weekdayDistance = weekDistance - passedWeek
        return Int(floor(weekdayDistance * 7))
    }
    
    init(courseArray: [Course]) {
        self.courseArray = courseArray
    }
    
    init() {
        self.courseArray = []
    }
}

extension Date {
    func format(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

struct ColorHelper {
    let color: [String: Color]
    
    static var shared = ColorHelper(Storage.courseTable.object.courseArray)
    
    init(_ courseArray: [Course]) {
        var colorArray = [
            #colorLiteral(red: 0.5590268373, green: 0.5717645288, blue: 0.645496428, alpha: 1), #colorLiteral(red: 0.4453202486, green: 0.4580122828, blue: 0.5316858888, alpha: 1), #colorLiteral(red: 0.5585952401, green: 0.4775523543, blue: 0.5879413486, alpha: 1), #colorLiteral(red: 0.512439549, green: 0.524015069, blue: 0.6323540807, alpha: 1), #colorLiteral(red: 0.3847824335, green: 0.396281302, blue: 0.4800215364, alpha: 1), #colorLiteral(red: 0.6332313418, green: 0.6521518826, blue: 0.7899104953, alpha: 1), #colorLiteral(red: 0.6195089221, green: 0.5867381692, blue: 0.7159363031, alpha: 1), #colorLiteral(red: 0.6934235692, green: 0.6567432284, blue: 0.8013477921, alpha: 1),
            #colorLiteral(red: 0.4496340156, green: 0.3764404655, blue: 0.4869975448, alpha: 1), #colorLiteral(red: 0.6253550649, green: 0.5235865116, blue: 0.6773356795, alpha: 1), #colorLiteral(red: 0.7457726598, green: 0.6244233251, blue: 0.8077706695, alpha: 1), #colorLiteral(red: 0.4722867608, green: 0.5927650928, blue: 0.6177451015, alpha: 1), #colorLiteral(red: 0.4739673138, green: 0.6488676667, blue: 0.6929715872, alpha: 1), #colorLiteral(red: 0.2412205935, green: 0.3298183084, blue: 0.3522273302, alpha: 1), #colorLiteral(red: 0.218701601, green: 0.3526560962, blue: 0.2918043733, alpha: 1), #colorLiteral(red: 0.04705882353, green: 0.2784313725, blue: 0.4039215686, alpha: 1)
        ].map { Color($0) }
        
        var color = [String: Color]()
        for course in courseArray {
            colorArray.shuffle()
            color[course.no] = colorArray.popLast() ?? .orange
        }
        
        self.color = color
    }
}

struct NotificationHelper {
    static func setNotification(for courseTable: CourseTable, failure: @escaping (Error) -> Void) {
        var messagePairArray = [(Date, String)]()
        for week in courseTable.currentWeek...courseTable.totalWeek {
            for course in courseTable.courseArray {
                for arrange in course.arrangeArray {
                    guard arrange.weekday > courseTable.currentWeekday else {
                        continue
                    }
                    
                    let hour = arrange.startTime.0
                    let minute = arrange.startTime.1
                    let offsetMinute = Storage.defaults.integer(forKey: "courseTableOffsetMinute")
                    let second = (
                        (
                            (
                                (week - 1) * 7 + arrange.weekday - 1
                            ) * 24 + hour
                        ) * 60 + minute + offsetMinute
                    ) * 60
                    
                    let date = courseTable.startDate.addingTimeInterval(TimeInterval(second))
                    guard date > courseTable.currentDate else {
                        continue
                    }
                    let body = "Course Name \(course.name) Start Time \(arrange.startTimeString) Location \(arrange.location)"
                    messagePairArray.append((date, body))
                }
            }
        }
        messagePairArray.sort { $0.0 < $1.0 }
        
        let limitation = 64
        if messagePairArray.count > limitation {
            // TODO: Add limitation warning
//            for i in 54..<messagePairArray.count {
//                messagePairArray[i].1 += ""
//            }
            
            messagePairArray = Array(messagePairArray[..<limitation])
        }
        
        for (i, (date, body)) in messagePairArray.enumerated() {
            let current = UNUserNotificationCenter.current()
            let identifier = "courseTableNotifition\(i)"
            
            current.removePendingNotificationRequests(withIdentifiers: [identifier])
            
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "classStart", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: body, arguments: nil)
            content.sound = .default
            
            let dateComponents = courseTable.currentCalendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            current.add(request) { error in
                if let error = error {
                    failure(error)
                }
            }
        }
    }
}

// to pass Detail
class AlertCourse: ObservableObject {
    @Published var showDetail: Bool = false
    @Published var currentCourse = Course()
    @Published var currentWeekday = 0
}

