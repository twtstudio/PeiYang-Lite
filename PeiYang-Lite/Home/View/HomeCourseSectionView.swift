//
//  HomeCourseSectionView.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2020/12/25.
//

import SwiftUI

struct HomeCourseSectionView: View {
    @ObservedObject var store = Storage.courseTable
    private var courseTable: CourseTable { store.object }
    @AppStorage(ClassesManager.isLoginKey, store: Storage.defaults) private var isLogin = false
    
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
        activeCourseArray
            .filter {
                $0.arrangeArray.map(\.weekday).contains(courseTable.currentWeekday) &&
                    $0.arrangeArray.flatMap(\.weekArray).contains(activeWeek)
            }
            .sorted { (c1, c2) -> Bool in
                let c1arrange = c1.arrangeArray.first { $0.weekday == courseTable.currentWeekday && $0.weekArray.contains(activeWeek) }!
                let c2arrange = c2.arrangeArray.first { $0.weekday == courseTable.currentWeekday && $0.weekArray.contains(activeWeek) }!
                return c1arrange.startUnit < c2arrange.startUnit
            }
    }
    
    private var colorHelper: ColorHelper { ColorHelper.shared }
//    private var destination: View { courseTable.courseArray.isEmpty ? AcClassesBindingView() : CourseTableDetailView() }
    
    var body: some View {
        Section(header: HStack {
            Text(Localizable.courseTable.rawValue)
                .font(.title3)
                .bold()
                .foregroundColor(Color(#colorLiteral(red: 0.3803921569, green: 0.3960784314, blue: 0.4862745098, alpha: 1)))
                .padding(.horizontal)
            
            Spacer()
            
            Text("今日\(currentCourseArray.count)节课")
                .font(.footnote)
                .foregroundColor(Color(#colorLiteral(red: 0.3803921569, green: 0.3960784314, blue: 0.4862745098, alpha: 1)))
                .padding(.horizontal)
        }) {
            NavigationLink(destination:
                            Group {
                                if isLogin {
                                    CourseTableDetailView()
                                } else {
                                    AcClassesBindingView()
                                }
                            }
            ) {
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
                    ScrollView(.horizontal, showsIndicators: false) {
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
                    .frame(height: screen.width/2)
                }
            }
        }
    }
}

struct HomeCourseSectionView_Previews: PreviewProvider {
    static var previews: some View {
        HomeCourseSectionView()
    }
}
