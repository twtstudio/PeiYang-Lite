//
//  CourseTableCourseDetailView.swift
//  PeiYang Lite
//
//  Created by 游奕桁 on 2020/9/4.
//

import SwiftUI

struct infoView: View {
    var title: String
    var info: String
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
            Text(info)
                .bold()
        }
        .font(.footnote)
        .foregroundColor(.white)
    }
}

struct CourseDetailView: View {
    let course: Course
    let weekDay: Int
    let isRegular: Bool
//    var bgColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(course.name)
                .font(.title)
                .bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 5)
            
            Text(course.teacherArray[0])
                .font(.headline)
                .bold()
                .foregroundColor(.white)
            
            Spacer().frame(height: 50)
            
            HStack(spacing: 5) {
                VStack(alignment: .leading, spacing: 5) {
                    infoView(title: "ID", info: course.no)
                    infoView(title: "上课地点", info: course.activeArrange(weekDay).location)
                    infoView(title: "时间", info: course.activeArrange(weekDay).unitTimeString)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    infoView(title: "逻辑班号", info: course.serial)
                    infoView(title: "起始周", info: course.weeks)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    infoView(title: "校区", info: course.campus)
                    infoView(title: "学分", info: course.credit)
                }
            }
            .padding(.vertical, 8)
        }
        .padding()
        .frame(width: screen.width / 1.5, height: screen.width / 1.5 * 1.4)
        .background(
            Image("emblem")
                .resizable()
                .scaledToFit()
        )
        .shadow(color: Color.gray.opacity(0.5), radius: 8, x: 5, y: 5)
    }
}

//struct CourseDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        CourseDetailView(course: Course.init())
//    }
//}

