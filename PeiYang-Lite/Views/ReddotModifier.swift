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
                    .overlay(
                        Text(count.description)
                            .foregroundColor(.white)
                            .opacity(count > 0 ? 1 : 0)
                            .font(Font.system(size: size * 0.8))
                    )
                    .frame(width: size, height: size)
                
                
            }
        })
    }
}

extension View {
    func addReddot(isPresented: Bool, count: Int = 0, size: CGFloat) -> some View {
        self.modifier(ReddotModifer(isPresented: isPresented, count: count, size: size))
    }
}
