//
//  PieCellView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/27/20.
//

import SwiftUI

struct PieSlice: Identifiable {
    var id = UUID()
    var startDeg: Double
    var endDeg: Double
    var value: Double
    var normalizedValue: Double
}

struct PieCellView: View {
    @State private var show = false
    
    var rect: CGRect
    var radius: CGFloat { min(rect.width, rect.height) / 2 }
    
    var startDeg: Double
    var endDeg: Double
    var path: Path {
        var path = Path()
        path.addArc(
            center: rect.mid,
            radius: radius,
            startAngle: Angle(degrees: startDeg),
            endAngle: Angle(degrees: endDeg),
            clockwise: false
        )
        path.addLine(to: rect.mid)
        path.closeSubpath()
        return path
    }
    
    var index: Int
    
    var backgroundColor: Color
    var accentColor: Color
    
    var body: some View {
        path
            .fill()
            .foregroundColor(accentColor)
            .overlay(path.stroke(backgroundColor, lineWidth: 2))
            .scaleEffect(show ? 1 : 0)
            .animation(Animation.spring().delay(Double(index) * 0.04))
            .onAppear {
                show = true
            }
    }
}

extension CGRect {
    var mid: CGPoint {
        CGPoint(x:self.midX, y: self.midY)
    }
}

struct PieCellView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                PieCellView(
                    rect: geometry.frame(in: .local),
                    startDeg: 0.0,
                    endDeg: 90.0,
                    index: 0,
                    backgroundColor: .background,
                    accentColor: Color(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1))
                )
            }
            .frame(width: 100, height: 100)
            .environment(\.colorScheme, .dark)
        }
    }
}
