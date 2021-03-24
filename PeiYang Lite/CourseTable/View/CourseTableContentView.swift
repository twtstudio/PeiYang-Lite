//
//  CourseTableContentView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 8/2/20.
//

import SwiftUI

struct CourseTableContentView: View {
    let activeWeek: Int
    let courseArray: [Course]
    let width: CGFloat
    
//    @EnvironmentObject var sharedMessage: SharedMessage
    @Environment(\.horizontalSizeClass) private var sizeClass
    private var isRegular: Bool { sizeClass == .regular }
    
    private var colorHelper: ColorHelper { ColorHelper.shared }
    
    // use observable class to pass data
    @ObservedObject var alertCourse: AlertCourse
    @Binding var showFullCourse: Bool
    
    @AppStorage(SharedMessage.showCourseNumKey, store: Storage.defaults) private var showCourseNum = 6
    
    private var dayWidth: CGFloat { width / CGFloat(showCourseNum) }
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            // MARK: - Course
            ForEach(0..<showCourseNum, id: \.self) { weekday in
                
                var courseTimeArray: [Int] = Array(repeating: 0, count: 12)
                
                ZStack(alignment: .top) {
                    // 先遍历本周课
                    ForEach(
                        courseArray
                            .filter { course in
                                return course.arrangeArray
                                    .filter { $0.weekArray.contains(activeWeek) }
                                    .map(\.weekday)
                                    .contains(weekday)
                            },
                        id: \.no
                    ) { course -> AnyView in
                        for i in course.activeArrange(weekday).unitArray {
                            courseTimeArray[i] = 1
                        }
                        
                        return AnyView(
                            VStack {
                                Text(course.name)
                                    .bold()
                                
                                Text(course.teachers)
                                    .fontWeight(.light)
                                
                                Text(course.activeArrange(weekday).location)
                                    .fontWeight(.thin)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 7)
                            .font(isRegular ? .footnote : .system(size: 9))
                            .multilineTextAlignment(.center)
    //                        .padding(7)
                            .frame(maxWidth: .infinity)
                            .frame(
                                height: CGFloat(course.activeArrange(weekday).length) * dayWidth * 1.5
                            )
                            // to adapt show full week
                            .background(
                                colorHelper.color[course.no]
                                    .cornerRadius(10)
                                    .padding(2)
                            )
                            .zIndex(1)
                            .offset(y: CGFloat(course.activeArrange(weekday).startUnit) * dayWidth * 1.5)
                            .onTapGesture {
                                withAnimation {
                                    self.alertCourse.showDetail = true
                                    self.alertCourse.currentCourse = course
                                    self.alertCourse.currentWeekday = weekday
                                }
                            }
                        )
                    }
                    
                    if showFullCourse {
                        ForEach(
                            courseArray
                                .filter { course in
                                    return course.arrangeArray
                                        .filter { !$0.weekArray.contains(activeWeek) }
                                        .map(\.weekday)
                                        .contains(weekday)
                                },
                            id: \.no
                        ) { course in
                            VStack {
                                Image(systemName: "lock.fill")
                                    .font(.body)
                                
                                Text(course.name)
                                    .bold()
                                
                                Text("非本周")
                                    .fontWeight(.thin)
                                
                            }
                            .foregroundColor(.gray)
                            .padding(.horizontal, 7)
                            .font(isRegular ? .footnote : .system(size: 9))
                            .multilineTextAlignment(.center)
    //                        .padding(7)
                            .frame(maxWidth: .infinity)
                            .frame(height: calcHeight(timeArray: courseTimeArray, course: course, weekday: weekday))
                            // to adapt show full week
                            .background(
                                Color(#colorLiteral(red: 0.9246603847, green: 0.9294714928, blue: 0.9379970431, alpha: 1))
                                    .cornerRadius(10)
                                    .padding(2)
                            )
                            .zIndex(0)
                           
                            .offset(y: calcOffset(timeArray: courseTimeArray, course: course, weekday: weekday))
                            .onTapGesture {
                                withAnimation {
                                    self.alertCourse.showDetail = true
                                    self.alertCourse.currentCourse = course
                                    self.alertCourse.currentWeekday = weekday
                                }
                            }
                        }
                    }
                    
                    
                    
                }
                .frame(width: dayWidth, alignment: .top)
            }
        }
//        .padding(.leading)
    }
    
    private func calcHeight(timeArray: [Int], course: Course, weekday: Int) -> CGFloat {
        let unitArray = course.activeArrange(weekday).unitArray
        var availableUnit: Int = 0
        for i in unitArray {
            if timeArray[i] == 0 {
                availableUnit += 1
            }
        }
        
        return CGFloat(availableUnit) * dayWidth * 1.5
    }
    
    private func calcOffset(timeArray: [Int], course: Course, weekday: Int) -> CGFloat {
        var startUnit = course.activeArrange(weekday).startUnit
        while timeArray[startUnit] == 1 {
            startUnit += 1
        }
        
        return CGFloat(startUnit) * dayWidth * 1.5
    }
    
    private func isThisWeek(_ course: Course, activeWeek: Int, weekday: Int) -> Bool {
        return course.arrangeArray
            .filter { $0.weekArray.contains(activeWeek) }
            .map(\.weekday)
            .contains(weekday)
    }
}

struct CourseTableContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            CourseTableContentView(activeWeek: 11, courseArray: [Course](), width: 36, alertCourse: AlertCourse(), showFullCourse: .constant(true))
                .environment(\.colorScheme, .dark)
        }
    }
}
