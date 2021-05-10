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
    @ObservedObject var courseConfig: CourseConfig
    @Binding var showFullCourse: Bool
    
    @AppStorage(SharedMessage.showCourseNumKey, store: Storage.defaults) private var showCourseNum = 6
    
    private var dayWidth: CGFloat { width / CGFloat(showCourseNum) }
    private var height: CGFloat { screen.height / 12 }
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            // MARK: - Course
            ForEach(0..<showCourseNum, id: \.self) { weekday -> AnyView in
                var courseTimeArray: [Int] = Array(repeating: 0, count: 12)
                
                var courses: [CoursePair] = []
                var notConflictCourses: [Course] = []
                var conflictCourses: [[Course]] = []
                let thisWeekCourses = courseArray
                    .filter { course in
                        return course.arrangeArray
                            .filter { $0.weekArray.contains(activeWeek) }
                            .map(\.weekday)
                            .contains(weekday)
                    }
                // 提取课程开始结束时间
                for course in thisWeekCourses {
                    let arrange = course.activeArrange(weekday)
                    courses.append((course, (arrange.startUnit, arrange.endUnit)))
                }
                // 按开始时间排序
                courses.sort(by: { $0.1.0 < $1.1.0 })
                // 区分是否重合
                var i = 0
                while i < courses.count {
                    var courseSet: [CoursePair] = [courses[i]]
                    i += 1
                    while i < courses.count && courses[i].1.0 < courses[i-1].1.1 {
                        courseSet.append(courses[i])
                        i += 1
                    }
                    if courseSet.count == 1 {
                        notConflictCourses.append(courseSet[0].0)
                    } else {
                        // 进行优先度排序
                        courseSet
                            .sort { (c1, c2) -> Bool in
                                (c1.1.1 - c1.1.0) > (c2.1.1 - c2.1.0)
                            }
                        conflictCourses.append(courseSet.map { $0.0 })
                    }
                }
                
                return AnyView(
                    ZStack(alignment: .top) {
                        // 先遍历非重复课
                        ForEach(notConflictCourses,
                                id: \.no
                        ) { course -> AnyView in
                            return AnyView(
                                CourseTableSingleCourseView(
                                    isRegular: isRegular,
                                    course: course,
                                    color: colorHelper.color[course.no] ?? Color(#colorLiteral(red: 0.5590268373, green: 0.5717645288, blue: 0.645496428, alpha: 1)),
                                    weekday: weekday,
                                    courseTimeArray: &courseTimeArray)
                            )
                        }
                        // 再遍历重复课
                        ForEach(conflictCourses.indices, id: \.self) { i in
                            ForEach(conflictCourses[i], id: \.no) { course -> AnyView in
                                return AnyView(
                                    CourseTableSingleCourseView(
                                        isRegular: isRegular,
                                        course: course,
                                        color: colorHelper.color[course.no] ?? Color(#colorLiteral(red: 0.5590268373, green: 0.5717645288, blue: 0.645496428, alpha: 1)),
                                        weekday: weekday,
                                        isConflict: true,
                                        courseTimeArray: &courseTimeArray,
                                        conflictCourses: conflictCourses[i])
                                )
                            }
                        }
                        // 如果要显示非本周课
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
                                CourseTableSingleCourseView(
                                    isRegular: isRegular,
                                    course: course,
                                    color: colorHelper.color[course.no] ?? Color(#colorLiteral(red: 0.5590268373, green: 0.5717645288, blue: 0.645496428, alpha: 1)),
                                    weekday: weekday,
                                    isLock: true,
                                    courseTimeArray: &courseTimeArray)
                            }
                        }
                    }
                    .frame(width: dayWidth, alignment: .top)
                )
            }
        }
        //        .padding(.leading)
    }
    
    private func isThisWeek(_ course: Course, activeWeek: Int, weekday: Int) -> Bool {
        return course.arrangeArray
            .filter { $0.weekArray.contains(activeWeek) }
            .map(\.weekday)
            .contains(weekday)
    }
    
    private func CourseTableSingleCourseView(isRegular: Bool,
                                             course: Course,
                                             color: Color,
                                             weekday: Int,
                                             isConflict: Bool = false,
                                             isLock: Bool = false,
                                             courseTimeArray: inout [Int],
                                             conflictCourses: [Course] = []) -> some View {
         
        let view = VStack {
            if isLock {
                Image(systemName: "lock.fill")
                    .font(.body)
                
                Text(course.name)
                    .bold()
                
                Text("非本周")
                    .fontWeight(.thin)
            } else {
                Text(course.name)
                    .bold()
                
                Text(course.teachers)
                    .fontWeight(.light)
                
                Text(course.activeArrange(weekday).location)
                    .fontWeight(.thin)
                if isConflict {
                    Image("ct-warn")
                }
            }
        }
        .foregroundColor(isLock ? .gray : .white)
        .padding(.horizontal, 7)
        .font(isRegular ? .footnote : .system(size: 9))
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .frame(
            height: calcHeight(isLock: isLock, isConflict: isConflict, timeArray: courseTimeArray, course: course, weekday: weekday)
        )
        // to adapt show full week
        .background(
            Group {
                if isLock {
                    Color(#colorLiteral(red: 0.9246603847, green: 0.9294714928, blue: 0.9379970431, alpha: 1))
                        .cornerRadius(10)
                        .padding(2)
                } else {
                    color
                        .cornerRadius(10)
                        .padding(2)
                }
            }
        )
        .zIndex(isLock ? 0 : 1)
        .offset(
            y: calcOffset(isLock: isLock, isConflict: isConflict, timeArray: courseTimeArray, course: course, weekday: weekday)
        )
        .onTapGesture {
            withAnimation {
                self.courseConfig.showDetail = true
                self.courseConfig.isConflict = isConflict
                if isConflict {
                    self.courseConfig.currentCourses = conflictCourses
                } else {
                    self.courseConfig.currentCourses = [course]
                }
                self.courseConfig.currentWeekday = weekday
            }
        }
        
        // 进行填充
        for i in course.activeArrange(weekday).unitArray {
            courseTimeArray[i] = 1
        }
        
        return view
    }
    
    private func calcHeight(isLock: Bool, isConflict: Bool, timeArray: [Int], course: Course, weekday: Int) -> CGFloat {
        var ret: CGFloat = 0
        
        if isLock || isConflict {
            let unitArray = course.activeArrange(weekday).unitArray
            var availableUnit: Int = 0
            for i in unitArray {
                if timeArray[i] == 0 {
                    availableUnit += 1
                }
            }
            ret = CGFloat(availableUnit) * height
        } else {
            ret = CGFloat(course.activeArrange(weekday).length) * height
        }
        
        return ret
    }
    
    private func calcOffset(isLock: Bool, isConflict: Bool, timeArray: [Int], course: Course, weekday: Int) -> CGFloat {
        var ret: CGFloat = 0
        let arrange = course.activeArrange(weekday)
        var startUnit = arrange.startUnit
        if isLock || isConflict {
            while timeArray[startUnit] == 1 && startUnit < arrange.endUnit {
                startUnit += 1
            }
        }
        ret = CGFloat(startUnit) * height
        
        return ret
    }

}

fileprivate struct CourseTableContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            CourseTableContentView(activeWeek: 11, courseArray: [Course](), width: 36, courseConfig: CourseConfig(), showFullCourse: .constant(true))
                .environment(\.colorScheme, .dark)
        }
    }
}


//fileprivate struct CourseTableSingleCourseView: View {
//    let isRegular: Bool
//    let course: Course
//    let color: Color
//    let weekday: Int
//    var isConflict: Bool = true
//    var isLock: Bool = false
//    let courseTimeArray: [Int]
//    var conflictCourses: [Course] = []
//
//    private var height: CGFloat { screen.height / 12 }
//
//    @EnvironmentObject var alertCourse: CourseConfig
//
//    var body: some View {
//        VStack {
//            if isLock {
//                Image(systemName: "lock.fill")
//                    .font(.body)
//
//                Text(course.name)
//                    .bold()
//
//                Text("非本周")
//                    .fontWeight(.thin)
//            } else {
//                Text(course.name)
//                    .bold()
//
//                Text(course.teachers)
//                    .fontWeight(.light)
//
//                Text(course.activeArrange(weekday).location)
//                    .fontWeight(.thin)
//                if isConflict {
//                    Image("ct-warn")
//                }
//            }
//        }
//        .foregroundColor(isLock ? .gray : .white)
//        .padding(.horizontal, 7)
//        .font(isRegular ? .footnote : .system(size: 9))
//        .multilineTextAlignment(.center)
//        .frame(maxWidth: .infinity)
//        .frame(
//            height: calcHeight(isLock: isLock, timeArray: courseTimeArray, course: course, weekday: weekday)
//        )
//        // to adapt show full week
//        .background(
//            Group {
//                if isLock {
//                    Color(#colorLiteral(red: 0.9246603847, green: 0.9294714928, blue: 0.9379970431, alpha: 1))
//                        .cornerRadius(10)
//                        .padding(2)
//                } else {
//                    color
//                        .cornerRadius(10)
//                        .padding(2)
//                }
//            }
//        )
//        .zIndex(isLock ? 0 : 1)
//        .offset(
//            y: calcOffset(isLock: isLock, timeArray: courseTimeArray, course: course, weekday: weekday)
//        )
//
//        .onTapGesture {
//            withAnimation {
//                self.alertCourse.showDetail = true
//                self.alertCourse.currentCourse = course
//                self.alertCourse.currentWeekday = weekday
//            }
//        }
//    }
//
//    private func calcHeight(isLock: Bool, timeArray: [Int], course: Course, weekday: Int) -> CGFloat {
//        var ret: CGFloat = 0
//
//        if isLock {
//            let unitArray = course.activeArrange(weekday).unitArray
//            var availableUnit: Int = 0
//            for i in unitArray {
//                if timeArray[i] == 0 {
//                    availableUnit += 1
//                }
//            }
//            ret = CGFloat(availableUnit) * height
//        } else {
//            ret = CGFloat(course.activeArrange(weekday).length) * height
//        }
//
//        return ret
//    }
//
//    private func calcOffset(isLock: Bool, timeArray: [Int], course: Course, weekday: Int) -> CGFloat {
//        var ret: CGFloat = 0
//
//        var startUnit = course.activeArrange(weekday).startUnit
//        if isLock {
//            while timeArray[startUnit] == 1 && startUnit < 11 {
//                startUnit += 1
//            }
//        }
//        ret = CGFloat(startUnit) * height
//
//        return ret
//    }
//}
fileprivate typealias CoursePair = (Course, (Int, Int))
//fileprivate struct ConflictCourse: Equatable, Hashable {
//    static func == (lhs: ConflictCourse, rhs: ConflictCourse) -> Bool {
//        return lhs.course == rhs.course && lhs.startUnit == rhs.startUnit && lhs.endUnit == rhs.endUnit
//    }
//
//    let course: Course
//    let startUnit: Int
//    let endUnit: Int
//}
