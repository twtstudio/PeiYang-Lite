//
//  CourseTableWeekdaysView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/31/20.
//

import SwiftUI

struct CourseTableWeekdaysView: View {
    @Binding var activeWeek: Int
    let courseTable: CourseTable
    let width: CGFloat
    let showCourseNum: Int
//    @AppStorage(SharedMessage.showCourseNumKey, store: Storage.defaults) private var showCourseNum = 6
    @Environment(\.horizontalSizeClass) private var sizeClass
    private var isRegular: Bool { sizeClass == .regular }
    
    private var activeWeekStartDate: Date {
        let startDate = courseTable.startDate
        let distance = (activeWeek - 1) * 7 * 24 * 60 * 60
        return startDate.addingTimeInterval(TimeInterval(distance))
    }
    
    private var activeMonth: String { activeWeekStartDate.format(with: "MM") }
    
    private var weekdays: [String] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        var weekdays = calendar.shortWeekdaySymbols
        weekdays.append(weekdays.remove(at: 0))
        return weekdays
    }
    
    private var dates: [Date] {
        var dates = [Date]()
        for i in 0..<7 {
            let date = activeWeekStartDate.addingTimeInterval(TimeInterval(i * 24 * 60 * 60))
            dates.append(date)
        }
        return dates
    }
    
    private var months: [Int] {
        dates.map { courseTable.currentCalendar.component(.month, from: $0)}
    }
    
    private var days: [Int] {
        dates.map { courseTable.currentCalendar.component(.day, from: $0) }
    }
    
    private func isActiveDate(_ date: Date) -> Bool {
        func approximateDate(_ date: Date) -> (Int, Int, Int) {
            (
                courseTable.currentCalendar.component(.year, from: date),
                courseTable.currentCalendar.component(.month, from: date),
                courseTable.currentCalendar.component(.day, from: date)
            )
        }
        return approximateDate(courseTable.currentDate) == approximateDate(date)
    }
    
    private var dayWidth: CGFloat { width / CGFloat(showCourseNum) }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
//            Text(activeMonth)
//                .font(isRegular ? .body : .footnote)
//                .frame(width: width)
            
            ForEach(0..<showCourseNum, id: \.self) {
                Text("\(activeMonth)\\\(days[$0])")
                    .bold()
                    .lineLimit(1)
                    .font(isRegular ? .subheadline : .system(size: 10))
                    .padding(4)//8
                    .foregroundColor(isActiveDate(dates[$0]) ? .gray : Color(#colorLiteral(red: 0.8110870719, green: 0.8155250549, blue: 0.8371899128, alpha: 1)))
                    .frame(width: dayWidth)
                    .frame(minHeight: dayWidth/1.7)
                    .background(Color(#colorLiteral(red: 0.9246603847, green: 0.9294714928, blue: 0.9379970431, alpha: 1)).cornerRadius(5).padding(2))
            }
        }
        .frame(width: width)
    }
}

struct CourseTableWeekdaysView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            CourseTableWeekdaysView(activeWeek: .constant(1), courseTable: Storage.courseTable.object, width: 36, showCourseNum: 5)
                .environment(\.colorScheme, .dark)
        }
    }
}
