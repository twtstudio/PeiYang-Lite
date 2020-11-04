//
//  CurveDetailView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/21/20.
//

import SwiftUI

struct CurveDetailView: View {
    @ObservedObject var data: ChartData
    @Binding var size: CGSize
    @Binding var minDataValue: Double?
    @Binding var maxDataValue: Double?
    @Binding var activeIndex: Int
    @Binding var showIndicator: Bool
    @State private var showFull: Bool = false
    @State var showBackground: Bool = true
    
    let pathGradient: Gradient
    let backgroundGradient: Gradient
    let indicatorColor: Color
    
    let padding: CGFloat = 30
    let duration: Double = 1
    let curvedLines: Bool = true
    
    var stepWidth: CGFloat {
        if data.points.count < 2 {
            return 0
        }
        return size.width / CGFloat(data.points.count - 1)
    }
    
    var stepHeight: CGFloat {
        if let min = minDataValue, let max = maxDataValue, min != max {
            return (size.height - padding) / CGFloat(max - min)
        }
        
        let points = self.data.onlyPoints()
        if let min = points.min(), let max = points.max(), min != max {
            return (size.height - padding) / CGFloat(max - min)
        }
        
        return 0
    }
    
    var stepTime: Double {
        duration / Double(data.points.count - 1)
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
            if showBackground {
                closedPath
                    .fill(LinearGradient(gradient: backgroundGradient, startPoint: .bottom, endPoint: .top))
                    .straighten()
                    .opacity(showFull ? 1 : 0)
                    .animation(.easeOut(duration: duration))
            }
            
            path
//                .trim(from: 0, to: showFull ? 1 : 0)
                .stroke(LinearGradient(gradient: pathGradient, startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 3, lineJoin: .round))
                .straighten()
            
            if showIndicator {
                ForEach(Array(data.onlyPoints().enumerated()), id: \.element) { i, point in // using `id` to ensure independent animation
                    Indicator(color: indicatorColor)
                        .animation(nil) // avoid animation when change between light and dark
                        .scaleEffect(showFull ? (isActive(i) ? 1.5 : 1) : 0)
                        .position(position(at: i))
                        .straighten()
                        .animation(
                            Animation
                                .easeOut(duration: stepTime)
//                                .easeIn(duration: s)
                                .delay(activeIndex == -1 ? Double(i) * stepTime : 0)
                        )
                        .onTapGesture {
                            if activeIndex == i {
                                activeIndex = 0
                            } else {
                                activeIndex = i
                            }
                        }
                }
            }
        }
        .onAppear {
            showFull = true
        }
    }
    
    func isActive(_ index: Int) -> Bool {
        activeIndex == index && showIndicator
    }
    
    func position(at i: Int) -> CGPoint {
        path.point(to: CGFloat(i) * stepWidth)
    }
}

struct CurveDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            GeometryReader{ geometry in
                CurveDetailView(
                    data: ChartData(points: [12, -230, 10, 54]),
                    size: .constant(CGSize(width: 320, height: 160)),
                    minDataValue: .constant(nil),
                    maxDataValue: .constant(nil),
                    activeIndex: .constant(0),
                    showIndicator: .constant(true),
                    pathGradient: Gradient(colors: [Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)), Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))]),
                    backgroundGradient: Gradient(colors: [Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)), .background]),
                    indicatorColor: Color(#colorLiteral(red: 1, green: 0.3411764706, blue: 0.6509803922, alpha: 1))
                )
            }
            .frame(width: 320, height: 160)
            .environment(\.colorScheme, .dark)
        }
    }
}
