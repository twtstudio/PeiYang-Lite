//
//  WeekGridView.swift
//  PeiYang Lite
//
//  Created by 游奕桁 on 2021/2/6.
//

import SwiftUI

struct WeekGridView: View {
    let width: CGFloat
    let height: CGFloat
    let rows: Int
    let cols: Int
    let weekMatrix: [[Bool]]
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<rows) { row in
                HStack(spacing: 6) {
                    ForEach(0..<cols) { col in
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: 8, height: 8)
                            .foregroundColor(weekMatrix[col][row] ? Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)) : Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                    }
                }
            }
        }
    }
    
    
}

struct WeekGridView_Previews: PreviewProvider {
    static var previews: some View {
        WeekGridView(width: 25, height: 22, rows: 5, cols: 6, weekMatrix: [[false]])
    }
}
