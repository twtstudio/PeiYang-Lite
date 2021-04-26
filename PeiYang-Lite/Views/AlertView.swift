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
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
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
        HStack {
            Text(alertMessage)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .foregroundColor(isRight ? .black : .white)
                .animation(.none)
                .padding()
        }
        .frame(width: screen.width * 0.9, height: screen.height/12, alignment: .center)
        .background(isRight ? Color.green : Color.black)
        .cornerRadius(screen.height/50)
        .animation(.none)
        .opacity(isShow ? 0.85 : 0)
        .animation(
            Animation.easeInOut(duration: 0.4)
                .delay(1)
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                isShow = false
            }
        }
    }
}
