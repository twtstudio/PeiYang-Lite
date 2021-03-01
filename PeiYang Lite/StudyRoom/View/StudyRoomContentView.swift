//
//  StudyRoomContentView.swift
//  PeiYang Lite
//
//  Created by 游奕桁 on 2021/2/16.
//
import SwiftUI

struct StudyRoomContentView: View {
    let activeWeek: Int
    let courseArray: [Course]
    let width: CGFloat
    private var colorHelper: ColorHelper { ColorHelper.shared }
    
    var body: some View {
        HStack(alignment: .top) {
            // MARK: - Unit
            VStack {
                ForEach(1...12, id: \.self) {
                    Text("\($0)")
                        .font(.footnote)
                        .foregroundColor(Color(#colorLiteral(red: 0.7221838832, green: 0.7243714929, blue: 0.7514262795, alpha: 1)))
                        .frame(width: width/2, height: width*1.5)
                        .background(Color(#colorLiteral(red: 0.9246603847, green: 0.9294714928, blue: 0.9379970431, alpha: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
            
            // MARK: - Course
            ForEach(0...5, id: \.self) { weekday in
                ZStack(alignment: .top) {
                    ForEach(
                        courseArray
                            .filter { course in
                                return course.arrangeArray
                                    .filter { $0.weekArray.contains(activeWeek) }
                                    .map(\.weekday)
                                    .contains(weekday)
                                },
                        id: \.no
                    ) { course in
                            Text("课程占用")
                                .font(.caption2)
                                .bold()
                                .padding(7)
                                .foregroundColor(.white)
                                .frame(
                                    width: width*1.1,
                                    height: CGFloat(course.activeArrange(weekday).length) * width * 1.5
                                )
                                .background(colorHelper.color[course.no])
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .offset(y: CGFloat(course.activeArrange(weekday).startUnit) * width * 1.52)
                        }
                        
                    }
                    
                }
                .frame(width: width)
            }
        }
    }


struct StudyRoomContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            StudyRoomContentView(activeWeek: 11, courseArray: [Course](), width: 40)
                .environment(\.colorScheme, .dark)
        }
    }
}

