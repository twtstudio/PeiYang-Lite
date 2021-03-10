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
    let status: [String]
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
            ForEach(0...6, id: \.self) { weekday in
                ZStack(alignment: .top) {
                    ForEach(0...5, id:\.self) { i in
                        if status[weekday][2*i] == "1" {
                            Text("课程占用")
                                .font(.caption2)
                                .bold()
                                .padding(7)
                                .foregroundColor(.white)
                                .frame(
                                    width: width*1.1,
                                    height: width * 3
                                )
                                .background(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .offset(y: 2 * CGFloat(i) * width * 1.52)
                        }
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
            StudyRoomContentView(activeWeek: 11, courseArray: [Course](), status:  ["001100000000","110000000000","000011111111","000011000000","000000001100","111100000000","000000001111"], width: 40)
                .environment(\.colorScheme, .dark)
        }
    }
}

