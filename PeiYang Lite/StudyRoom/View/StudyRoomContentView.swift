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
                    ForEach(1...6, id:\.self) { i in
                        if status[weekday][2*i-1] == "1" {
                            StudyRoomRoomView(index: i, width: width)
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


struct StudyRoomRoomView: View {
    var index: Int
    let width: CGFloat
    let colorArray = [
        #colorLiteral(red: 0.5590268373, green: 0.5717645288, blue: 0.645496428, alpha: 1), #colorLiteral(red: 0.4453202486, green: 0.4580122828, blue: 0.5316858888, alpha: 1), #colorLiteral(red: 0.5585952401, green: 0.4775523543, blue: 0.5879413486, alpha: 1), #colorLiteral(red: 0.512439549, green: 0.524015069, blue: 0.6323540807, alpha: 1), #colorLiteral(red: 0.3847824335, green: 0.396281302, blue: 0.4800215364, alpha: 1), #colorLiteral(red: 0.6332313418, green: 0.6521518826, blue: 0.7899104953, alpha: 1), #colorLiteral(red: 0.6195089221, green: 0.5867381692, blue: 0.7159363031, alpha: 1), #colorLiteral(red: 0.6934235692, green: 0.6567432284, blue: 0.8013477921, alpha: 1),
        #colorLiteral(red: 0.4496340156, green: 0.3764404655, blue: 0.4869975448, alpha: 1), #colorLiteral(red: 0.6253550649, green: 0.5235865116, blue: 0.6773356795, alpha: 1), #colorLiteral(red: 0.7457726598, green: 0.6244233251, blue: 0.8077706695, alpha: 1), #colorLiteral(red: 0.4722867608, green: 0.5927650928, blue: 0.6177451015, alpha: 1), #colorLiteral(red: 0.4739673138, green: 0.6488676667, blue: 0.6929715872, alpha: 1), #colorLiteral(red: 0.2412205935, green: 0.3298183084, blue: 0.3522273302, alpha: 1), #colorLiteral(red: 0.218701601, green: 0.3526560962, blue: 0.2918043733, alpha: 1), #colorLiteral(red: 0.04705882353, green: 0.2784313725, blue: 0.4039215686, alpha: 1)
    ].shuffled()
    
    var body: some View {
        Text("课程占用")
            .font(.caption2)
            .bold()
            .padding(7)
            .foregroundColor(.white)
            .frame(
                width: width*1.1,
                height: width * 3
            )
            .background(Color(colorArray[index]))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .offset(y: 2 * CGFloat(index-1) * width * 1.52)
    }
}
