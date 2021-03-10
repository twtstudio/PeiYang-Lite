//
//  SmallView.swift
//  PeiYangLiteWidgetExtension
//
//  Created by 游奕桁 on 2020/9/18.
//

import SwiftUI
import WidgetKit

struct SmallView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var store = Storage.courseTable
    private var courseTable: CourseTable { store.object }
    let entry: CourseEntry
    var currentCourseTable: [Course] { entry.courses }
    var hour: Int {
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        let hrString = hourFormatter.string(from: Date())
        let hour = Int(hrString) ?? 0
//        fontName()
        return hour
    }
    var colorHelper: ColorHelper { ColorHelper.shared }
    var weekday: String {
        let date = Date()
        let dateFormatter = DateFormatter()
//        let avaliable = Locale.availableIdentifiers
//        print(avaliable)
        dateFormatter.locale = Locale(identifier: "en_CH")
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)
        return dayInWeek
    }
    
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(weekday)
                        .morningStar(style: .largeTitle, weight: .bold)
                        .foregroundColor(colorScheme == .dark ? Color(#colorLiteral(red: 0.2358871102, green: 0.5033512712, blue: 0.9931854606, alpha: 1)) : Color(#colorLiteral(red: 0.6872389913, green: 0.7085373998, blue: 0.8254910111, alpha: 1)))
                        .padding(.leading, -3)
                    
                    Spacer()
                    
                }
                GeometryReader { geo in
                    VStack(alignment: .leading) {
                        if !currentCourseTable.isEmpty {
                            if let preCourse = self.getPresentCourse(courseArray: currentCourseTable, courseTable: courseTable, hour: hour) {
                            HStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(colorScheme == .dark ? Color(#colorLiteral(red: 0.2358871102, green: 0.5033512712, blue: 0.9931854606, alpha: 1)) : Color(#colorLiteral(red: 0.3056178987, green: 0.3728546202, blue: 0.4670386314, alpha: 1)))
                                    .frame(width: 3, height: 28)
                                    .padding(.leading, 6)
                                
                                if !preCourse.isEmpty && !preCourse.isNext {
                                    VStack(alignment: .leading) {
                                        Text("\(preCourse.course.name)")
                                            .font(.footnote)
                                            .fontWeight(.bold)
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                            .lineLimit(1)
                                        HStack {
                                            Text("\(preCourse.course.activeArrange(courseTable.currentWeekday).location)")
                                                .font(.system(size: 10))
                                                .foregroundColor(.gray)
                                            
                                            Text("\(preCourse.course.activeArrange(courseTable.currentWeekday).startTimeString)-\(preCourse.course.activeArrange(courseTable.currentWeekday).endTimeString)")
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                else {
                                    Text("当前没有课:)")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                                
                            }
                            }
                                
                        
                        HStack {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(colorScheme == .dark ? Color(#colorLiteral(red: 0.2358871102, green: 0.5033512712, blue: 0.9931854606, alpha: 1)) : Color(#colorLiteral(red: 0.3056178987, green: 0.3728546202, blue: 0.4670386314, alpha: 1)))
                                .frame(width: 3, height: 28)
                                .padding(.leading, 6)
                            if let nextCourse = self.getNextCourse(courseArray: currentCourseTable, courseTable: courseTable, hour: hour) {
                                if !nextCourse.isEmpty {
                                    VStack {
                                        Text("\(nextCourse.course.name)")
                                            .font(.footnote)
                                            .fontWeight(.bold)
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                            .lineLimit(1)
                                        HStack {
                                            Text("\(nextCourse.course.activeArrange(courseTable.currentWeekday).location)")
                                                .font(.system(size: 10))
                                                .foregroundColor(.gray)
                                            
                                            Text("\(nextCourse.course.activeArrange(courseTable.currentWeekday).startTimeString)-\(nextCourse.course.activeArrange(courseTable.currentWeekday).endTimeString)")
                                                .font(.system(size: 10))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                } else {
                                    Text("接下来没有课:)")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            
                            }
                        }
                            
                        } else {
                            Text(hour>21 ? "夜深了\n做个早睡的人吧" : "今日无课:)\n做点有意义的事情吧")
                                .font(.footnote)
                                .bold()
                                .foregroundColor(.black)
                                .padding([.leading, .top])
                        }
                        
                    }
                }
            }
            .padding(.top, 15)
        }
    }
    
    func fontName() {
        for fontFamilyName in UIFont.familyNames {
            for fontName in UIFont.fontNames(forFamilyName: fontFamilyName) {
                print("Available font: \(fontName)")
            }
        }
    }
}

//struct SmallView_Previews: PreviewProvider {
//    static var previews: some View {
//        SmallView(currentCourseTable: [Course.init()], entry: CourseEntry()).previewContext(WidgetPreviewContext(family: WidgetFamily.systemSmall))
//    }
//}
