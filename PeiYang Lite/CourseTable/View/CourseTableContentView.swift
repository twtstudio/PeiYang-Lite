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
    
    @AppStorage(SharedMessage.showCourseNumKey, store: Storage.defaults) private var showCourseNum = 5
    
    var body: some View {
        HStack(alignment: .top) {
            // MARK: - Unit
//            VStack {
//                ForEach(1...12, id: \.self) {
//                    Text("\($0)")
//                        .frame(width: width*1.1, height: width)
//                }
//            }
            
            // MARK: - Course
            ForEach(0...showCourseNum, id: \.self) { weekday in
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
                        VStack {
                            if !self.isThisWeek(course, activeWeek: activeWeek, weekday: weekday) {
                                VStack {
                                Image(systemName: "lock.fill")
                                    .font(.body)
                                    .padding(.vertical, 1)
                                
                                Text(course.name)
                                    .bold()
                                    .padding(.vertical, 1)
                                
                                Text("非本周")
                                    .fontWeight(.thin)
                                    .padding(.vertical, 1)
                                }
                                
                            } else {
                                VStack {
                                Text(course.name)
                                    .bold()
                                    .padding(.vertical, 1)
                                
                                Text(course.teachers)
                                    .fontWeight(.light)
                                    .padding(.vertical, 1)
//                                    .bold()
                                
                                Text(course.activeArrange(weekday).location)
                                    .fontWeight(.thin)
                                    .padding(.vertical, 1)
                                }
//                                .zIndex(1)
                            }
                        }
                        .font(isRegular ? .footnote : .system(size: 9))
                        .multilineTextAlignment(.center)
                        .padding(7)
                        .foregroundColor(self.isThisWeek(course, activeWeek: activeWeek, weekday: weekday) ? .white : .gray)
                        .frame(
                            width: width*1.1,
                            height: CGFloat(course.activeArrange(weekday).length) * width * 1.5
                        )
                        // to adapt show full week
                        .background(self.isThisWeek(course, activeWeek: activeWeek, weekday: weekday) ?
                                        colorHelper.color[course.no] :
                                        Color(#colorLiteral(red: 0.9246603847, green: 0.9294714928, blue: 0.9379970431, alpha: 1)))
                        .zIndex(self.isThisWeek(course, activeWeek: activeWeek, weekday: weekday) ? 1 : 0)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .offset(y: CGFloat(course.activeArrange(weekday).startUnit) * width * 1.52)
                        .onTapGesture {
                            withAnimation {
                                self.alertCourse.showDetail = true
                                self.alertCourse.currentCourse = course
                                self.alertCourse.currentWeekday = weekday
                            }
                        }
                    }
                    
                }
                .frame(width: width)
//                .frame(maxheight: .infinity)
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
