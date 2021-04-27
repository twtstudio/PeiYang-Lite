//
//  LoadingView.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2021/3/8.
//

import SwiftUI

struct LoadingView: View {
    @State private var idx = 0
    @State private var timer: Timer?
    
    var body: some View {
        HStack {
            ForEach(0..<3) { i in
                Circle()
                    .fill(idx % 3 == i ? Color(#colorLiteral(red: 0.6196078431, green: 0.6666666667, blue: 0.7137254902, alpha: 1)) : Color(#colorLiteral(red: 0.3411764706, green: 0.3803921569, blue: 0.4235294118, alpha: 1)))
                    .frame(width: 10, height: 10)
            }
        }
        .onAppear {
            timer = Timer(timeInterval: 0.5, repeats: true, block: { (_) in
                withAnimation {
                    idx += 1
                }
            })
            RunLoop.current.add(timer!, forMode: .default)
            timer?.fire()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
}

struct LoadingModifier: ViewModifier {
    @Binding var isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                BlurView()
                LoadingView()
            }
        }
    }
}

extension View {
    func loading(isLoading: Binding<Bool>) -> some View {
        self.modifier(LoadingModifier(isLoading: isLoading))
    }
}


struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello")
        }
        .loading(isLoading: .constant(true))
    }
}
