//
//  Indicator.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/5/20.
//

import SwiftUI

struct Indicator: View {
    let color: Color
    
    var body: some View {
        ZStack{
            Circle()
                .fill(color)
            Circle()
                .stroke(Color.background, style: StrokeStyle(lineWidth: 4))
        }
        .frame(width: 16, height: 16)
        .shadow(color: .shadow, radius: 4, x: 0, y: 4)
    }
}

struct Indicator_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            Indicator(color: Color(#colorLiteral(red: 1, green: 0.3411764706, blue: 0.6509803922, alpha: 1)))
                .environment(\.colorScheme, .dark)
        }
    }
}
