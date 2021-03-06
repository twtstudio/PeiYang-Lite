//
//  LargeView.swift
//  PeiYangLiteWidgetExtension
//
//  Created by 游奕桁 on 2021/1/23.
//

import SwiftUI
import MapKit

struct LargeView: View {
    @Environment(\.colorScheme) private var colorScheme

    var courseTable: CourseTable = Storage.courseTable.object
    let entry: CourseEntry
    var currentCourseTable: [Course] { entry.courses }
    var weathers: [Weather] { entry.weathers }
    var colorHelper: ColorHelper { ColorHelper.shared }
    var hour: Int {
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        let hrString = hourFormatter.string(from: Date())
        let hour = Int(hrString) ?? 0

        return hour
    }
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM月dd日"
        let date = dateFormatter.string(from: Date())
        return date
    }
    var body: some View {
        GeometryReader { geo in
        VStack {
            HStack {
                Text("天津市")
                    .font(.body)
                    .foregroundColor(colorScheme == .dark ? .white : Color(#colorLiteral(red: 0.1279886365, green: 0.1797681153, blue: 0.2823780477, alpha: 1)))
                Image(systemName: "location.fill")
                    .font(.system(size: 10))
                    .foregroundColor(colorScheme == .dark ? .white : Color(#colorLiteral(red: 0.1279886365, green: 0.1797681153, blue: 0.2823780477, alpha: 1)))
                
                Spacer()
                
                HStack {
                    VStack {
                        Text("\(weathers[0].weatherString)\n\(weathers[0].wStatus)")
                            .font(.footnote)
                    }
                    .foregroundColor(colorScheme == .dark ? .white : Color(#colorLiteral(red: 0.1279886365, green: 0.1797681153, blue: 0.2823780477, alpha: 1)))
                    .multilineTextAlignment(.leading)
                    
                    Image(weathers[0].weatherIconString1)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 35, height: 35)
                }
            }
            .padding(.init(top: 10, leading: 20, bottom: 0, trailing: 20))
            
            Image("line")
            
            HStack {
                Text("Monday")
                    .gilroy(style: .body, weight: .bold)
                    .foregroundColor(colorScheme == .dark ? .white : Color(#colorLiteral(red: 0.1279886365, green: 0.1797681153, blue: 0.2823780477, alpha: 1)))
                
                Spacer()
                
                Text("\(date)  第\(courseTable.currentWeek)周")
                    .font(.footnote)
                    .foregroundColor(colorScheme == .dark ? .white : Color(#colorLiteral(red: 0.1279886365, green: 0.1797681153, blue: 0.2823780477, alpha: 1)))
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            
            if currentCourseTable.isEmpty {
                ZStack {
                    Image("无课背景")
                    
                    Text("今日无课:)做点有意义的事情吧")
                        .font(.body)
                        .foregroundColor(Color(#colorLiteral(red: 0.1279886365, green: 0.1797681153, blue: 0.2823780477, alpha: 1)))
                }
            } else {
                HStack {
                    if let preCourse = getPresentCourse(courseArray: currentCourseTable, courseTable: courseTable, hour: hour) {
                        ZStack {
                            Image("NOW")
                                .resizable()
                                .scaledToFill()
                                .frame(width: (geo.size.width-60)/2, height: geo.size.height-250)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                            if !preCourse.isEmpty && !preCourse.isNext {
                                VStack(alignment: .center) {
                                    Text("\(preCourse.course.name)")
                                        .font(.footnote)
                                        .lineLimit(1)
                                    HStack {
                                        Text("\(preCourse.course.activeArrange(courseTable.currentWeekday).location)")
                                            .font(.system(size: 10))
                                        
                                        Text("\(preCourse.course.activeArrange(courseTable.currentWeekday).startTimeString)-\(preCourse.course.activeArrange(courseTable.currentWeekday).endTimeString)")
                                            .font(.system(size: 10))
                                    }
                                }
                                .foregroundColor(.white)
                                .padding(8)
                                .padding(.top, 8)
                            } else {
                                Text("当前无课\n做点有意义的事情吧")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                }
                            }
                        }
                    
                    ZStack {
                        Image("NEXT")
                            .resizable()
                            .scaledToFill()
                            .frame(width: (geo.size.width-60)/2, height: geo.size.height-250)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        
                        if let nextCourse = self.getNextCourse(courseArray: currentCourseTable, courseTable: courseTable, hour: hour) {
                            if !nextCourse.isEmpty {
                                VStack(alignment: .center) {
                                    Text("\(nextCourse.course.name)")
                                        .font(.footnote)
                                        .lineLimit(1)
                                    HStack {
                                        Text("\(nextCourse.course.activeArrange(courseTable.currentWeekday).location)")
                                            .font(.system(size: 10))
                                        
                                        Text("\(nextCourse.course.activeArrange(courseTable.currentWeekday).startTimeString)-\(nextCourse.course.activeArrange(courseTable.currentWeekday).endTimeString)")
                                            .font(.system(size: 10))
                                    }
                                }
                                .foregroundColor(.white)
                                .padding(8)
                                .padding(.top, 8)
                            } else {
                                Text("接下来无课\n做点有意义的事情吧")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                }

                        }
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text("自习室")
                    .font(.footnote)
                    .foregroundColor(colorScheme == .dark ? .white : Color(#colorLiteral(red: 0.1279886365, green: 0.1797681153, blue: 0.2823780477, alpha: 1)))
                
                HStack(alignment: .center) {
                    RoomCardView()
                    RoomCardView()
                    RoomCardView()
                    RoomCardView()
                }
            }
        }
        }
    }
}

struct LargeView_Previews: PreviewProvider {
    static var previews: some View {
        LargeView(entry: CourseEntry(date: Date(), courses: [Course()], weathers: [Weather()]))
    }
}
