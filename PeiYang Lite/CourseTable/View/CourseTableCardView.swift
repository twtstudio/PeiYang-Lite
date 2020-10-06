//
//  CourseTableCardView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/30/20.
//

import SwiftUI

struct CourseTableCardView: View {
    @ObservedObject var store = Storage.courseTable
    private var courseTable: CourseTable { store.object }
    
    @State private var activeWeek = Storage.courseTable.object.currentWeek
    
    private var weekdays: [String] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        var weekdays = calendar.shortWeekdaySymbols
        weekdays.append(weekdays.remove(at: 0))
        return weekdays
    }
    
    private var activeCourseArray: [Course] {
        courseTable.courseArray.filter { $0.weekRange.contains(activeWeek) }
    }
    
    private var currentCourseArray: [Course] {
        activeCourseArray.filter { $0.arrangeArray.map(\.weekday).contains(courseTable.currentWeekday) }
    }
    
    private var colorHelper: ColorHelper { ColorHelper.shared }
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text(Localizable.courseTable.rawValue)
                    .font(.title)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("week \(courseTable.currentWeek.description)")
                    Text(weekdays[courseTable.currentWeekday])
                }
                .foregroundColor(.primary)
                .padding(4)
            }
            
            if currentCourseArray.isEmpty {
                Text(Localizable.emptyCourseMeesage.rawValue)
                    .frame(maxHeight: .infinity)
            } else {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        ForEach(currentCourseArray, id: \.no) { course in
                            VStack {
                                Text(course.name)
                                Text(course.activeArrange(courseTable.currentWeekday).location)
                            }
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                                .padding(8)
                                .foregroundColor(.white)
                                .frame(
                                    width: CGFloat(course.activeArrange(courseTable.currentWeekday).length) * geo.size.width / 12,
                                    height: geo.size.height
                                )
                                .background(colorHelper.color[course.no])
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .offset(x: CGFloat(course.activeArrange(courseTable.currentWeekday).startUnit) * geo.size.width / 12)
                        }
                    }
                }
            }
        }
    }
}

struct CourseTableCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            GeometryReader{ geometry in
                CourseTableCardView()
            }
            .frame(width: 300, height: 180)
            .environment(\.colorScheme, .dark)
        }
    }
}
