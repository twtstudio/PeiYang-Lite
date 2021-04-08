//
//  ReddotModifier.swift
//  PeiYang-Lite
//
//  Created by Zrzz on 2021/4/8.
//

import SwiftUI

struct ReddotModifer: ViewModifier {
    var isPresented: Bool
    // -1时不显示
    var count: Int
    let size: CGFloat
    
    func body(content: Content) -> some View {
        ZStack(alignment: .topTrailing, content: {
            content
            
            if isPresented {
                Circle()
                    .fill(Color.red)
                    .frame(width: size, height: size)
                
                if count > 0 {
                    Text(count.description)
                        .foregroundColor(.white)
                        .font(Font.system(size: 12))
                }
            }
        })
    }
}

extension View {
    func addReddot(isPresented: Bool, count: Int = 0, size: CGFloat) -> some View {
        self.modifier(ReddotModifer(isPresented: isPresented, count: count, size: size))
    }
}
