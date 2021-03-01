//
//  CourseTableCourseDetailView.swift
//  PeiYang Lite
//
//  Created by 游奕桁 on 2020/9/4.
//

import SwiftUI

struct CourseDetailView: View {
    @Binding var course: Course
    @Binding var weekDay: Int
    var isRegular: Bool
//    var bgColor: Color
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
//            VStack {
            Text(course.name)
                .font(isRegular ? .custom("", size: 45) : .title)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
//            padding(.bottom)
            
            Text("location: \(course.activeArrange(weekDay).location)")
                .font(isRegular ? .title :.subheadline)
                .foregroundColor(.white)
//            }
//            .frame(width: 180, height: 80, alignment: .center)
//            .background(Color.gray.opacity(0.5))
//            .background(bgColor)
//            .clipShape(RoundedRectangle(cornerRadius: 8))
            Text("time: \(course.activeArrange(weekDay).unitTimeString)")
                .font(isRegular ? .title : .footnote)
                .foregroundColor(.white)
                        
            Text("credit: \(course.credit)")
                .font(isRegular ? .title : .footnote)
                .foregroundColor(.white)
                        
            Text("teacher: \(course.teacherArray[0])")
                .font(isRegular ? .title : .footnote)
                .foregroundColor(.white)

            Text("serial: \(course.serial)")
                .font(isRegular ? .title : .footnote)
                .foregroundColor(.white)
            
            Text("courseNO: \(course.no)")
                .font(isRegular ? .title : .footnote)
                .foregroundColor(.white)
            
            
        }
        //        .frame(width: 300, height: 500, alignment: .center)
    }
}

//struct CourseDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        CourseDetailView(course: Course.init())
//    }
//}

