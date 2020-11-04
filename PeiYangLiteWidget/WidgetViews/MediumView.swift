//
//  MidView.swift
//  PeiYangLiteWidgetExtension
//
//  Created by 游奕桁 on 2020/9/17.
//

import SwiftUI
import WidgetKit

struct MediumView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State var isNextCourse: Bool
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
        GeometryReader { geo in
            HStack(alignment: .center) {
                ZStack {
                    Image(colorScheme == .dark ? "NOW-1" : "NOW")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width/2, height: geo.size.height*(5/7))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    if currentCourseTable.isEmpty {
                        Text("当前无课")
                            .font(.body)
                            .fontWeight(.bold)
                    } else {
    //                    GeometryReader { geo in
                            if let preCourse = getPresentationCourse(courseArray: currentCourseTable, courseTable: courseTable, hour: hour) {
                                if preCourse.isEmpty == false {
                                    VStack(alignment: .center) {
                                        Text("\(preCourse.course.name)")
                                            .font(.footnote)
                                            .fontWeight(.bold)
                                            .lineLimit(1)
                                        
                                        Text("\(preCourse.course.activeArrange(courseTable.currentWeekday).location)")
                                            .font(.footnote)
                                    }
                                    .frame(width: geo.size.width*(4/5), height: geo.size.height, alignment: .center)
                                    .foregroundColor(.white)
                                    .padding(8)
                                } else {
                                    Text("接下来无课")
                                        .font(.body)
                                        .fontWeight(.bold)
                                }
                            }
    //                    }
                        
                    }
                }
                .frame(width: geo.size.width*(3/5), height: geo.size.height*(4/5))
//                .padding(.trailing, 10)
//                .padding(.leading, geo.size.width/25)
                
                VStack {
                    HStack {
                        Image(colorScheme == .dark ? "晴转阴-1" : "晴转阴")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                        VStack {
                            Text("晴转阴")
                                .font(.footnote)
                            
                            Text("19 ℃")
                                .font(.body)
                        }
                        .foregroundColor(colorScheme == .dark ? .white : Color(#colorLiteral(red: 0.4518171549, green: 0.5009640455, blue: 0.6247268915, alpha: 1)))
                    }
                    
                    HStack {
                        Image(colorScheme == .dark ? "晴转阴-1" : "晴转阴")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                        VStack {
                            Text("晴转阴")
                                .font(.footnote)
                            
                            Text("19 ℃")
                                .font(.body)
                        }
                        .foregroundColor(colorScheme == .dark ? .white : Color(#colorLiteral(red: 0.4518171549, green: 0.5009640455, blue: 0.6247268915, alpha: 1)))
                    }
                }
            }
            .padding(.top, geo.size.height/9)
            
        }
        
        
    }
}
            



struct MidView_Previews: PreviewProvider {
    static var previews: some View {
        MediumView(isNextCourse: false, currentCourseTable: [])
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
                break
            } else {
                presentationCourse.course = Course()
                presentationCourse.isEmpty = true
            }
        }
        print(hour)
        return presentationCourse
    }
}





