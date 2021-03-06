//
//  HomeCourseSectionView.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2020/12/25.
//

import SwiftUI

struct HomeCourseSectionView: View {
//    let classTableData: [MyCourse] = [
//        MyCourse(name: "Software Engineering", time: "08:30 - 10:30", loc: "45-B331"),
//        MyCourse(name: "Software Engineering", time: "08:30 - 10:30", loc: "45-B331"),
//        MyCourse(name: "Software Engineering", time: "08:30 - 10:30", loc: "45-B331"),
//        MyCourse(name: "Software Engineering", time: "08:30 - 10:30", loc: "45-B331"),
//        MyCourse(name: "Software Engineering", time: "08:30 - 10:30", loc: "45-B331"),
//    ]
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
        NavigationLink(destination: CourseTableDetailView2(alertCourse: AlertCourse())) {
        ScrollView(.horizontal, showsIndicators: false) {
            if currentCourseArray.isEmpty {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: screen.width-40, height: screen.width/2 - 40)
                        .foregroundColor(Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)))
                        .padding()
                        
                    Text(Localizable.emptyCourseMeesage.rawValue)
                        .foregroundColor(.white)
                }
            } else {
                HStack {
                    ForEach(currentCourseArray, id: \.no) { course in
                        VStack(alignment: .leading) {
                            Group {
                            Text(course.name)
                                .bold()
                                .lineLimit(2)
                                .font(.body)
                                .padding()
                            
                            Spacer()
                                .frame(height: 20)
                            
                            Text(course.activeArrange(courseTable.currentWeekday).unitTimeString)
                                .font(.footnote)
                                .padding()
                        
                            Text(course.activeArrange(courseTable.currentWeekday).location)
                                .bold()
                                .padding([.horizontal, .bottom])
                            }
                            .foregroundColor(.white)
                            
                        }
                        .frame(width: screen.width/2.5, height: screen.width/2)
                        .background(colorHelper.color[course.no])
                        .contentShape(RoundedRectangle(cornerRadius: 15))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                        .padding(.leading, 10)
                    }
                }
                .frame(height: screen.width)
                .padding(.leading, 10)
            }
        }
        .frame(height: screen.width/2)
        }
    }
}

struct HomeCourseSectionView_Previews: PreviewProvider {
    static var previews: some View {
        HomeCourseSectionView()
    }
}
