//
//  CurveCardView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/5/20.
//

import SwiftUI

struct CurveCardView: View {
    @ObservedObject var data: ChartData
    @Binding var size: CGSize
    @Binding var minDataValue: Double?
    @Binding var maxDataValue: Double?
    @Binding var activeIndex: Int
    @Binding var showIndicator: Bool
    @State private var showFull = false
    
    let pathGradient: Gradient
    let indicatorColor: Color
    
    let padding: CGFloat = 30
    let duration: Double = 1
    let curvedLines: Bool = true
    
    var stepWidth: CGFloat {
        data.points.count < 2 ? 0 : size.width / CGFloat(data.points.count - 1)
    }
    
    var stepHeight: CGFloat {
        if let min = minDataValue, let max = maxDataValue, min != max {
            return (size.height - padding) / CGFloat(max - min)
        }
        
        let points = data.onlyPoints()
        if let min = points.min(), let max = points.max(), min != max {
            return (size.height - padding) / CGFloat(max - min)
        }
        
        return 0
    }
    
    var path: Path {
        let points = data.onlyPoints()
        return curvedLines
            ? Path.quadCurvedPathWithPoints(points: points, step: CGPoint(x: stepWidth, y: stepHeight), globalOffset: minDataValue)
            : Path.linePathWithPoints(points: points, step: CGPoint(x: stepWidth, y: stepHeight))
    }
    
    var closedPath: Path {
        let points = data.onlyPoints()
        return curvedLines
            ? Path.quadClosedCurvedPathWithPoints(points: points, step: CGPoint(x: stepWidth, y: stepHeight), globalOffset: minDataValue)
            : Path.closedLinePathWithPoints(points: points, step: CGPoint(x: stepWidth, y: stepHeight))
    }
    
    var body: some View {
        ZStack {
            path
                .trim(from: 0, to: showFull ? 1 : 0)
                .stroke(LinearGradient(gradient: pathGradient, startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 3, lineJoin: .round))
                .straighten()
                .animation(.easeOut(duration: duration))
            
            if showIndicator {
                Indicator(color: indicatorColor)
//                    .animation(nil) // avoid animation when change between light and dark
                    .position(position(at: activeIndex))
                    .straighten()
                    .animation(.spring())
            }
        }
        .onAppear {
            showFull = true
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    let x = value.location.x
                    let step = data.points.count - 1
                    var i = 0
                    
                    if x < 0 {
                        i = 0
                    } else if x < CGFloat(step) * stepWidth {
                        i = lround(Double(x / stepWidth))
                    } else {
                        i = step
                    }
                    
                    activeIndex = i
                    showIndicator = true
                }
                .onEnded { value in
                    activeIndex = 0
                    showIndicator = false
                }
        )
    }
    
    func position(at i: Int) -> CGPoint {
        path.point(to: CGFloat(i) * stepWidth)
    }
}

struct CurveCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            GeometryReader{ geometry in
                CurveCardView(
                    data: ChartData(points: [12, -230, 10, 54]),
                    size: .constant(CGSize(width: 320, height: 160)),
                    minDataValue: .constant(nil),
                    maxDataValue: .constant(nil),
                    activeIndex: .constant(0),
                    showIndicator: .constant(true),
                    pathGradient: Gradient(colors: [Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)), Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))]),
                    indicatorColor: Color(#colorLiteral(red: 1, green: 0.3411764706, blue: 0.6509803922, alpha: 1))
                )
            }
            .frame(width: 320, height: 160)
            .environment(\.colorScheme, .dark)
        }
    }
}
