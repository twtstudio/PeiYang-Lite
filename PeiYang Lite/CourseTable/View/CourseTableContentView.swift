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
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    private var isRegular: Bool { sizeClass == .regular }
    
    private var colorHelper: ColorHelper { ColorHelper.shared }
    
    // use observable class to pass data
    @ObservedObject var alertCourse: AlertCourse
    @Binding var showFullCourse: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            // MARK: - Unit
            VStack {
                ForEach(1...12, id: \.self) {
                    Text("\($0)")
                        .frame(width: width*1.1, height: width)
                }
            }
            
            // MARK: - Course
            ForEach(0...6, id: \.self) { weekday in
                ZStack(alignment: .top) {
                    ForEach(
                        courseArray
                            .filter { course in
                                if !showFullCourse {
                                    return course.arrangeArray
                                        .filter { $0.weekArray.contains(activeWeek) }
                                        .map(\.weekday)
                                        .contains(weekday)
                                } else {
                                    return true
                                }
                            },
                        id: \.no
                    ) { course in
<<<<<<< HEAD
                        Text(course.isThisWeek(activeWeek: activeWeek, weekday: weekday) ?
                            "\(course.name)\n\(course.activeArrange(weekday).location)" :
                            "[notThisWeek] \(course.name)\n\(course.activeArrange(weekday).location)")
                            .font(isRegular ? .footnote : .system(size: 10))
=======
                        VStack {
                            Text(self.isThisWeek(course, activeWeek: activeWeek, weekday: weekday) ?
                                "\(course.name)" :
                                "[notThisWeek] \(course.name)")
                            Text(course.activeArrange(weekday).location)
                        }
                            .font(isRegular ? .footnote : .system(size: 9))
>>>>>>> e4291697b2a03afcf4cfbf314ae8cf47114102d1
                            .multilineTextAlignment(.center)
                            .padding(5)
                            .foregroundColor(.white)
                            .frame(
                                width: width*1.1,
                                height: CGFloat(course.activeArrange(weekday).length) * width
                            )
                            // to adapt show full week
<<<<<<< HEAD
                            .background(course.isThisWeek(activeWeek: activeWeek, weekday: weekday) ?
=======
                            .background(self.isThisWeek(course, activeWeek: activeWeek, weekday: weekday) ?
>>>>>>> e4291697b2a03afcf4cfbf314ae8cf47114102d1
                                            colorHelper.color[course.no] :
                                            .gray)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .offset(y: CGFloat(course.activeArrange(weekday).startUnit) * width)
                            .onTapGesture {
                                withAnimation {
                                    self.alertCourse.showDetail = true
                                    self.alertCourse.currentCourse = course
                                    self.alertCourse.currentWeekday = weekday
<<<<<<< HEAD
                                    self.alertCourse.activeWeek = activeWeek
=======
>>>>>>> e4291697b2a03afcf4cfbf314ae8cf47114102d1
                                }
                            }
                    }
                    
                }
                .frame(width: width)
            }
        }
    }
    
<<<<<<< HEAD
=======
    private func isThisWeek(_ course: Course, activeWeek: Int, weekday: Int) -> Bool {
        return course.arrangeArray
            .filter { $0.weekArray.contains(activeWeek) }
            .map(\.weekday)
            .contains(weekday)
    }
>>>>>>> e4291697b2a03afcf4cfbf314ae8cf47114102d1
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
