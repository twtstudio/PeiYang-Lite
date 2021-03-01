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
    
<<<<<<< HEAD
    private var nextDayCourseCount: Int {
        let nextDay = (courseTable.currentWeekday + 1) % 7
        return activeCourseArray.filter { $0.isThisWeek(activeWeek: activeWeek, weekday: nextDay) && $0.arrangeArray.map(\.weekday).contains(nextDay) }.count
    }
    
    
=======
>>>>>>> e4291697b2a03afcf4cfbf314ae8cf47114102d1
    private var colorHelper: ColorHelper { ColorHelper.shared }
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text(Localizable.courseTable.rawValue)
<<<<<<< HEAD
                    .font(.title2)
                
                Spacer()
                
                Text(nextDayCourseCount != 0 ? "\(nextDayCourseCount.description) coursesTomorrow" : Localizable.nextDayEmptyCourse.rawValue)
                    .foregroundColor(.primary)
                
=======
                    .font(.title)
                
                Spacer()
                
>>>>>>> e4291697b2a03afcf4cfbf314ae8cf47114102d1
                VStack(alignment: .trailing) {
                    Text("week \(courseTable.currentWeek.description)")
                    Text(weekdays[courseTable.currentWeekday])
                }
                .foregroundColor(.primary)
<<<<<<< HEAD
                .padding(.horizontal, 5)
=======
                .padding(4)
>>>>>>> e4291697b2a03afcf4cfbf314ae8cf47114102d1
            }
            
            if currentCourseArray.isEmpty {
                Text(Localizable.emptyCourseMeesage.rawValue)
                    .frame(maxHeight: .infinity)
            } else {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        ForEach(currentCourseArray, id: \.no) { course in
<<<<<<< HEAD
                            Text("\(course.name)\n\(course.activeArrange(courseTable.currentWeekday).location)")
=======
                            VStack {
                                Text(course.name)
                                Text(course.activeArrange(courseTable.currentWeekday).location)
                            }
>>>>>>> e4291697b2a03afcf4cfbf314ae8cf47114102d1
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
