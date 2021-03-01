//
//  MidView.swift
//  PeiYangLiteWidgetExtension
//
//  Created by 游奕桁 on 2020/9/17.
//

import SwiftUI
import WidgetKit

struct MediumView: View {
    var courseTable: CourseTable = Storage.courseTable.object
    let currentCourseTable: [Course]
    var colorHelper: ColorHelper { ColorHelper.shared }
//    let hour: Int = getHourInt()
    var hour: Int {
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        let hrString = hourFormatter.string(from: Date())
        let hour = Int(hrString) ?? 0

        return hour
    }
    
    var body: some View {
        if currentCourseTable.isEmpty {
            Text(Localizable.emptyCourseMeesage.rawValue)
                .frame(maxHeight: .infinity)
        } else {
            GeometryReader { geo in
                ZStack(alignment: .center) {
                    HStack {
                        if let preCourse = self.getPresentationCourse(courseArray: currentCourseTable, courseTable: courseTable, hour: hour) {
                            if preCourse.isEmpty == false {
                            VStack {
                                HStack {
                                    Text(preCourse.isNext ? "下一节课：" : "当前课程")
                                        .foregroundColor(.white)
                                        .font(.body)
                                        .padding(.leading, 8)
                                }
                                .frame(width: geo.size.width * (2/3), height: geo.size.height/6, alignment: .leading)
                                
                                VStack(alignment: .center) {
                                    Text("\(preCourse.course.name)")
                                        .font(.title)
                                    
                                    Text("\(preCourse.course.activeArrange(courseTable.currentWeekday).location)")
                                        .font(.body)
                                    
                                    Text("\(preCourse.course.activeArrange(courseTable.currentWeekday).unitTimeString)")
                                        .font(.footnote)
                                }
                                .foregroundColor(.white)
                                .padding(8)
                                
                            }
                            .frame(width: geo.size.width * (2/3), height: geo.size.height, alignment: .center)
                            .background(colorHelper.color[preCourse.course.no]?.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            } else {
                                VStack {
                                    Text("接下来没有课")
                                        .font(.title)
                                        .foregroundColor(.secondary)
                                }
                                .frame(width: geo.size.width * (2/3), height: geo.size.height, alignment: .center)
//                                .background(Color(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        
                        VStack {
                            HStack {
                                Text("晴朗")
                                    .font(.body)
                                
                                Image(systemName: "sun.max")
                                    .font(.body)
                            }
                            
                            Text("19 ℃")
                                .font(.title)
                        }
                        .foregroundColor(.secondary)
                    }
                }
            }
            .padding(10)
        }
    }
}



struct MidView_Previews: PreviewProvider {
    static var previews: some View {
        MediumView(currentCourseTable: [])
            .previewContext(WidgetPreviewContext(family: WidgetFamily.systemMedium))
    }
}

struct WidgetCourse {
    var isNext: Bool
    var course: Course
    var isEmpty: Bool
    
    init() {
        isNext = false
        course = Course()
        isEmpty = false
    }
}

extension View {
    func getPresentationCourse(courseArray: [Course], courseTable: CourseTable, hour: Int) -> WidgetCourse {
        var presentationCourse = WidgetCourse()
        for course in courseArray {
            let arrange = course.activeArrange(courseTable.currentWeekday)
            if arrange.startTime.0 <= hour && arrange.endTime.0 > hour {
                presentationCourse.course = course
                presentationCourse.isEmpty = false
                presentationCourse.isNext = false
                break
            } else if arrange.startTime.0 >= hour {
                presentationCourse.course = course
                presentationCourse.isEmpty = false
                presentationCourse.isNext = true
            } else {
                presentationCourse.course = Course()
                presentationCourse.isEmpty = true
            }
        }
        return presentationCourse
    }
}





