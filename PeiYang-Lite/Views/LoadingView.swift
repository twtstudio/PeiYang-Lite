//
//  LoadingView.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2021/3/8.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
    enum LoadingStyle {
        case large, medium, small
    }
    
    @State var style: LoadingStyle = .medium
    @Binding var isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                BlurView()
                VStack {
                    if style == .small {
                        ProgressView()
                    } else if style == .medium {
                        ProgressView()
                            .scaleEffect(2)
                    } else {
                        ProgressView()
                            .scaleEffect(3)
                    }
                }
                .padding(50)
                .background(Color.background)
                .cornerRadius(20)
                .shadow(color: .black, radius: 2, x: 1, y: 1)
            }
        }
    }
}

extension View {
    func loading(style: LoadingModifier.LoadingStyle, isLoading: Binding<Bool>) -> some View {
        self.modifier(LoadingModifier(style: style, isLoading: isLoading))
    }
}


struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello")
        }
        .loading(style: .medium, isLoading: .constant(true))
    }
}
