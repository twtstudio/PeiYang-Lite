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
    var courseTable: CourseTable = Storage.courseTable.object
    let entry: CourseEntry
    var currentCourseTable: [Course] { entry.courses }
    var weathers: [Weather] { entry.weathers }
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
                    if !currentCourseTable.isEmpty {
                    if let preCourse = getPresentCourse(courseArray: currentCourseTable, courseTable: courseTable, hour: hour) {
                        if preCourse.isNext == false {
                            Image("NOW")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.width/2, height: geo.size.height*(5/7))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            Image("NEXT")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.width/2, height: geo.size.height*(5/7))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }

                        if preCourse.isEmpty == false {
                            VStack(alignment: .center) {
                                Text("\(preCourse.course.name)")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                HStack {
                                    Text("\(preCourse.course.activeArrange(courseTable.currentWeekday).location)")
                                        .font(.footnote)
                                    
                                    Text("\(preCourse.course.activeArrange(courseTable.currentWeekday).startTimeString)-\(preCourse.course.activeArrange(courseTable.currentWeekday).endTimeString)")
                                        .font(.footnote)
                                }
                            }
                            .frame(width: geo.size.width*(4/5), height: geo.size.height, alignment: .center)
                            .foregroundColor(.white)
                            .padding(8)
                            .padding(.top, 8)
                        } else {
                            Text("接下来无课")
                                .font(.footnote)
                                .foregroundColor(.white)
                            }
                        }
                    }
        
                    else {
                        Image("无课2*4")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width/2, height: geo.size.height*(5/7))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Text("今日无课:)\n做点有意义的事情吧")
                            .font(.footnote)
                            .foregroundColor(.white)
                    }
                }
                .frame(width: geo.size.width*(3/5), height: geo.size.height*(4/5))
//                .padding(.trailing, 10)
//                .padding(.leading, geo.size.width/25)
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(weathers[0].weatherIconString1)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading) {
                            Text("今：\(weathers[0].wStatus)")
                                .font(.footnote)
                                .bold()
                            
                            Text("\(weathers[0].weatherString)")
                                .font(.footnote)
                                .bold()
                        }
                        .foregroundColor(colorScheme == .dark ? .white : Color(#colorLiteral(red: 0.1279886365, green: 0.1797681153, blue: 0.2823780477, alpha: 1)))
                    }
                    
                    HStack {
                        Image(weathers[1].weatherIconString1)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading) {
                            Text("明：\(weathers[1].wStatus)")
                                .font(.footnote)
                                .bold()
                            
                            Text("\(weathers[1].weatherString)")
                                .font(.footnote)
                                .bold()
                        }
                        .foregroundColor(colorScheme == .dark ? .white : Color(#colorLiteral(red: 0.1279886365, green: 0.1797681153, blue: 0.2823780477, alpha: 1)))
                    }
                }
            }
            .padding(.top, geo.size.height/9)
            
        }
        
        
    }
}
            



//struct MidView_Previews: PreviewProvider {
//    static var previews: some View {
//        MediumView(currentCourseTable: [], weathers: [])
//            .previewContext(WidgetPreviewContext(family: WidgetFamily.systemMedium))
//    }
//}

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
    func getPresentCourse(courseArray: [Course], courseTable: CourseTable, hour: Int) -> WidgetCourse {
        var presentCourse = WidgetCourse()
        for course in courseArray {
            let arrange = course.activeArrange(courseTable.currentWeekday)
            if arrange.startTime.0 <= hour && arrange.endTime.0 > hour {
                presentCourse.course = course
                presentCourse.isEmpty = false
                presentCourse.isNext = false
                break
            } else if arrange.startTime.0 >= hour {
                presentCourse.course = course
                presentCourse.isNext = true
                presentCourse.isEmpty = false
                break
            } else {
                presentCourse.course = Course()
                presentCourse.isEmpty = true
            }
        }
        return presentCourse
    }
    
    func getNextCourse(courseArray: [Course], courseTable: CourseTable, hour: Int) -> WidgetCourse {
        var nextCourse = WidgetCourse()
        for course in courseArray {
            let arrange = course.activeArrange(courseTable.currentWeekday)
            if arrange.startTime.0 >= hour {
                nextCourse.course = course
                nextCourse.isEmpty = false
                nextCourse.isNext = true
                break
            } else {
                nextCourse.course = Course()
                nextCourse.isEmpty = true
            }
        }
        return nextCourse
    }
}



   


