//
//  RefreshButton.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 8/3/20.
//

import SwiftUI

struct RefreshButton: View {
    @Binding var isLoading: Bool
    let action: () -> Void
    let color: Color
    
    @State private var isAnimating = false
    
    private let symbol = "arrow.triangle.2.circlepath"
    
    var body: some View {
        if isLoading {
            Image(systemName: symbol)
                .font(.title)
                .foregroundColor(color)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    isLoading
                    ? Animation.linear(duration: 2).repeatForever(autoreverses: false)
                    : .default
                )
                .onAppear {
                    isAnimating = true
                }
                .onDisappear {
                    isAnimating = false
                }
        } else {
            Image(systemName: symbol)
                .font(.title)
                .foregroundColor(color)
                .onTapGesture(perform: action)
        }
    }
}

struct RefreshButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            RefreshButton(isLoading: .constant(true), action: {}, color: Color.white)
                .environment(\.colorScheme, .dark)
        }
    }
}
