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
    let currentCourseTable: [Course]
    var hour: Int {
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        let hrString = hourFormatter.string(from: Date())
        let hour = Int(hrString) ?? 0

        return hour
    }
    var colorHelper: ColorHelper { ColorHelper.shared }
    var weekday: String {
        let date = Date()
        let dateFormatter = DateFormatter()
        let avaliable = Locale.availableIdentifiers
        print(avaliable)
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
//                        .padding(.leading, -3)
                    
                    Spacer()
                    
                }
                GeometryReader { geo in
                    VStack(alignment: .leading) {
                        HStack {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(colorScheme == .dark ? Color(#colorLiteral(red: 0.2358871102, green: 0.5033512712, blue: 0.9931854606, alpha: 1)) : Color(#colorLiteral(red: 0.3056178987, green: 0.3728546202, blue: 0.4670386314, alpha: 1)))
                                .frame(width: 3, height: 28)
                                .padding(.leading, 6)
                    
                            if currentCourseTable.isEmpty {
                                Text("接下来没有课")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            } else {
                                if let preCourse = self.getPresentationCourse(courseArray: currentCourseTable, courseTable: courseTable, hour: hour) {
                                    if preCourse.isEmpty == false {
                                        VStack(alignment: .leading) {
                                            Text("\(preCourse.course.name)")
                                                .font(.footnote)
                                                .fontWeight(.bold)
                                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                                .lineLimit(1)
                                        
                                            Text("\(preCourse.course.activeArrange(courseTable.currentWeekday).location)")
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                    }
//                                    .padding(8)
                            } else {
                                Text("接下来没有课")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                }
                            }
                        }
                        }
//                        .frame(width: geo.size.width - 12, height: geo.size.height * (2/5), alignment: .leading)
//                        .padding(10)
                        HStack {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(colorScheme == .dark ? Color(#colorLiteral(red: 0.2358871102, green: 0.5033512712, blue: 0.9931854606, alpha: 1)) : Color(#colorLiteral(red: 0.3056178987, green: 0.3728546202, blue: 0.4670386314, alpha: 1)))
                                .frame(width: 3, height: 28)
                                .padding(.leading, 6)
                            
                            Text("无法获取下一节")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .lineLimit(1)
                        }
//                        .frame(width: geo.size.width - 12, height: geo.size.height * (2/5), alignment: .leading)
                        
                    }
                }
            }
            .padding(.top, 15)
        }
    }
}

struct SmallView_Previews: PreviewProvider {
    static var previews: some View {
        SmallView(currentCourseTable: [Course.init()]).previewContext(WidgetPreviewContext(family: WidgetFamily.systemSmall))
    }
}

struct MorningStarModifier: ViewModifier {
    var style: UIFont.TextStyle = .body
    var weight: Font.Weight = .regular
    
//    var textColor: Color {
//        return Color(#colorLiteral(red: 0.6352576613, green: 0.6942307353, blue: 0.8199440837, alpha: 1)).opacity(0.8)
//    }

    func body(content: Content) -> some View {
        content
            .font(Font.custom("MorningStar", size: UIFont.preferredFont(forTextStyle: style).pointSize)
            .weight(weight))
//        .foregroundColor(textColor)
    }
    
}

extension View {
    
    func morningStar(style: UIFont.TextStyle, weight: Font.Weight) -> some View {
        self.modifier(MorningStarModifier(style: style, weight: weight))
    }
}


