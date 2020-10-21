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
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    private var isRegular: Bool { sizeClass == .regular }
    
    private var activeWeekStartDate: Date {
        let startDate = courseTable.startDate
        let distance = (activeWeek - 1) * 7 * 24 * 60 * 60
        return startDate.addingTimeInterval(TimeInterval(distance))
    }
    
    private var activeMonth: String { activeWeekStartDate.format(with: "LLL") }
    
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
        HStack {
            Text(activeMonth)
                .font(isRegular ? .body : .footnote)
                .frame(width: width)
            
            ForEach(0...6, id: \.self) {
                Text("\(weekdays[$0])\n\(days[$0])")
                    .font(isRegular ? .subheadline : .system(size: 10))
                    .multilineTextAlignment(.center)
                    .padding(7)//8
                    .foregroundColor(isActiveDate(dates[$0]) ? .white : .primary)
                    .frame(width: width)
                    .frame(minHeight: width)
                    .background(isActiveDate(dates[$0]) ? Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)) : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
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
