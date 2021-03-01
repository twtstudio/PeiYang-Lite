//
//  SmallView.swift
//  PeiYangLiteWidgetExtension
//
//  Created by 游奕桁 on 2020/9/18.
//

import SwiftUI
import WidgetKit

struct SmallView: View {
    @ObservedObject var store = Storage.courseTable
    private var courseTable: CourseTable { store.object }
    let currentCourseTable: [Course]
    var hour: Int {
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        let hrString = hourFormatter.string(from: Date())
        let hour = Int(hrString) ?? 0

        return hour
    }
    var colorHelper: ColorHelper { ColorHelper.shared }
    
    var body: some View {
        if currentCourseTable.isEmpty {
            Text(Localizable.emptyCourseMeesage.rawValue)
                .frame(maxHeight: .infinity)
        } else {
            GeometryReader { geo in
                if let preCourse = self.getPresentationCourse(courseArray: currentCourseTable, courseTable: courseTable, hour: hour) {
                    if preCourse.isEmpty == false {
                    VStack {
                        HStack {
                            Text(preCourse.isNext ? "下一节课：" : "当前课程")
                                .foregroundColor(.white)
                                .font(.body)
                                .padding(.leading, 8)
                            
                            Spacer()
                        }
                        .frame(width: geo.size.width, height: geo.size.height/6, alignment: .leading)
                        
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
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .background(colorHelper.color[preCourse.course.no]?.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        VStack(spacing: 10) {
                            Text("接下来没有课")
                                .font(.body)
                                .foregroundColor(.secondary)
                            
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
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
//                        .background(Color(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                }
            }
        }
    }
}

struct SmallView_Previews: PreviewProvider {
    static var previews: some View {
        SmallView(currentCourseTable: [Course.init()]).previewContext(WidgetPreviewContext(family: WidgetFamily.systemSmall))
    }
}


