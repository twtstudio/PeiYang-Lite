//
//  ProgressBarView.swift
//  PeiYang Lite
//
//  Created by 游奕桁 on 2021/2/16.
//

import SwiftUI

struct ProgressBar: View {
    var value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(#colorLiteral(red: 0.7667996287, green: 0.7703498006, blue: 0.7790222764, alpha: 1)))
                
                Rectangle().frame(width: min(CGFloat(value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)))
                    .animation(.linear)
                
            }.cornerRadius(45.0)
        }
    }
}

struct ProgressBarView: View {
    var current: Double
    var total: Double
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Total Course Hours: \(total.decimal)")
                .font(.footnote)
                .bold()
                .foregroundColor(Color(#colorLiteral(red: 0.8032445312, green: 0.8076816201, blue: 0.8293473721, alpha: 1)))
            
            ProgressBar(value: current/total)
                .frame(height: 15)
        }
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView(current: 250.0, total: 536.0)
    }
}
