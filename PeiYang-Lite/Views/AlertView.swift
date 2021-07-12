//
//  AlertView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/4.
//

import SwiftUI

struct AlertView: View {
    var alertMessage: String
    @Binding var isShow: Bool
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var isRight: Bool {
        switch alertMessage {
        case "成功":
            return true
        case "取消收藏成功":
            return true
        case "收藏成功":
            return true
        default:
            return false
        }
    }
    var body: some View {
        Group {
            if isShow {
                HStack {
                    Text(alertMessage)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(isRight ? .black : .white)
                        .animation(.none)
                        .padding()
                }
                .frame(width: screen.width * 0.9, alignment: .center)
                .background(isRight ? Color.green : Color.black)
                .cornerRadius(screen.height/50)
                .animation(.none)
                .opacity(0.85)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            isShow = false
                        }
                    }
                }
            }
        }
    }
}

struct AlertViewModifier: ViewModifier {
    var alertString: String
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                Spacer()
                AlertView(alertMessage: alertString, isShow: $isPresented)
                    .padding(.bottom)
            }
        }
    }
}

extension View {
    func alertView(isPresented: Binding<Bool>, alertString: String) -> some View {
        self.modifier(AlertViewModifier(alertString: alertString, isPresented: isPresented))
    }
}
