//
//  PieChartView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/27/20.
//

import SwiftUI

struct PieChartView : View {
    @Binding var activeIndex: Int
    @Binding var show: Bool
    
    var data: [Double]
    
    var backgroundColor: Color
    var accentColor: Color
    var activeColor: Color
    
    var slices: [PieSlice] {
        var tempSlices = [PieSlice]()
        var lastEndDeg: Double = 0
        let maxValue = data.reduce(0, +)
        for slice in data {
            let normalized = Double(slice) / Double(maxValue)
            let startDeg = lastEndDeg
            let endDeg = lastEndDeg + (normalized * 360)
            lastEndDeg = endDeg
            tempSlices.append(PieSlice(startDeg: startDeg, endDeg: endDeg, value: slice, normalizedValue: normalized))
        }
        return tempSlices
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                ForEach(0..<slices.count) { i in
                    PieCellView(
                        rect: geometry.frame(in: .local),
                        startDeg: slices[i].startDeg,
                        endDeg: slices[i].endDeg,
                        index: i,
                        backgroundColor: backgroundColor,
                        accentColor: activeIndex == i ? activeColor : accentColor
                    )
                    .onTapGesture {
                        if activeIndex == i {
                            activeIndex = -1
                            show = false
                        } else {
                            activeIndex = i
                            show = true
                        }
                    }
                }
            }
        }
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            PieChartView(
                activeIndex: .constant(2),
                show: .constant(true),
                data: [8,23,54,32,12,37,7,23,43],
                backgroundColor: .background,
                accentColor: Color(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)),
                activeColor: Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
            )
            .frame(width: 100, height: 100)
            .environment(\.colorScheme, .dark)
        }
    }
}
