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
    
    @AppStorage(SharedMessage.showCourseNumKey, store: Storage.defaults) private var showCourseNum = 5
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
        for i in 0...6 {
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
    
    var body: some View {
        HStack(alignment: .center) {
//            Text(activeMonth)
//                .font(isRegular ? .body : .footnote)
//                .frame(width: width)
            
            ForEach(0...showCourseNum, id: \.self) {
                Text("\(activeMonth)\\\(days[$0])")
                    .bold()
                    .lineLimit(1)
                    .font(isRegular ? .subheadline : .system(size: 10))
                    .padding(4)//8
                    .foregroundColor(isActiveDate(dates[$0]) ? .gray : Color(#colorLiteral(red: 0.8110870719, green: 0.8155250549, blue: 0.8371899128, alpha: 1)))
//                    .foregroundColor(Color(#colorLiteral(red: 0.8110870719, green: 0.8155250549, blue: 0.8371899128, alpha: 1)))
                    .frame(width: width)
                    .frame(minHeight: width/1.7)
//                    .background(isActiveDate(dates[$0]) ? Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)) : Color.clear)
                    .background(Color(#colorLiteral(red: 0.9246603847, green: 0.9294714928, blue: 0.9379970431, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
    }
}

struct CourseTableWeekdaysView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            CourseTableWeekdaysView(activeWeek: .constant(1), courseTable: Storage.courseTable.object, width: 36)
                .environment(\.colorScheme, .dark)
        }
    }
}
