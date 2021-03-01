//
//  RadarChart.swift
//  PeiYang Lite
//
//  Created by 游奕桁 on 2020/10/16.
//

import SwiftUI

func deg2rad(_ number: CGFloat) -> CGFloat {
    return number * .pi / 180
}

func radAngle_fromFraction(numerator:Int, denominator: Int) -> CGFloat {
    return deg2rad(360 * (CGFloat((numerator))/CGFloat(denominator)))
}

func degAngle_fromFraction(numerator:Int, denominator: Int) -> CGFloat {
    return 360 * (CGFloat((numerator))/CGFloat(denominator))
    
}

struct RadarChartView: View {
    var strokeColor: Color
    var textColor:Color
    var center:CGPoint
    var labelWidth:CGFloat = 55
    var width:CGFloat
    // var dimensions: [SingleGPA]
    @ObservedObject var store = Storage.gpa
    private var gpa: GPA { store.object }
    @Binding var activeIndex: Int
//    let activeSemesterGPA: SemesterGPA
    private var activeGPAArray: [SingleGPA] { gpa.semesterGPAArray[activeIndex].gpaArray.filter({$0.gpa != 0}) }
    
    private func getX(i: Int) -> CGFloat {
        let angle = radAngle_fromFraction(numerator: i, denominator: activeGPAArray.count)
        let x = (self.width - self.labelWidth)/2 * cos(angle)
        return center.x+x
    }
    
    private func getY(i: Int) -> CGFloat {
        let angle = radAngle_fromFraction(numerator: i, denominator: activeGPAArray.count)
        let y = (self.width - self.labelWidth)/2 * sin(angle)
        return center.y+y
    }
    
    var body: some View {
        ZStack {
            //MARK: - Main division
            Path { path in
                for i in 0..<activeGPAArray.count {
                    let angle = radAngle_fromFraction(numerator: i, denominator: activeGPAArray.count)
                    let x = (self.width - (50 + self.labelWidth))/2 * cos(angle)
                    let y = (self.width - (50 + self.labelWidth))/2 * sin(angle)
                    path.move(to: center)
                    path.addLine(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
                }
            }
            .stroke(self.strokeColor, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
            
            //MARK: - Lables
            ForEach(Array(activeGPAArray.enumerated()), id: \.element) { i, gpa in
                Text(gpa.name)
                    .font(.system(size: 10))
                    .foregroundColor(textColor)
                    .frame(width: self.labelWidth, height: 45)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .background(Color.clear)
                    .position(x: getX(i: i), y: getY(i: i))
            }
            
//            MARK: -DataPath
            ZStack { () -> AnyView in
                let path = Path { path in
                    for i in 0..<activeGPAArray.count+1 {
                        let thisDimension = activeGPAArray[i == activeGPAArray.count ? 0 : i]
                        let maxVal = 100
                        let pointVal = thisDimension.score * thisDimension.score / 100
                        let angle = radAngle_fromFraction(numerator: i == activeGPAArray.count ? 0 : i, denominator: activeGPAArray.count)
                        
                        let size = ((self.width - (50 + self.labelWidth))/2) * (CGFloat(pointVal)/CGFloat(maxVal))
                        let x = size * cos(angle)
                        let y = size * sin(angle)
                        if i == 0 {
                            path.move(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
                        } else {
                            path.addLine(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
                        }
                    }
                }
                
                return AnyView (
                    ZStack {
                        path
                            .stroke(self.textColor, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                        path
                            .foregroundColor(self.textColor).opacity(0.2)
                    }
                )
                
            }
            
            
                    
        }
        .frame(width: self.width, height: self.width, alignment: .center)
    }
}

//struct RadarChart_Previews: PreviewProvider {
//    static var previews: some View {
//        RadarChartView()
//    }
//}
