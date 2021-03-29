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
    var body: some View {
        HStack {
            Text(alertMessage)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .foregroundColor(alertMessage == "成功" ? .black : .white)
                .animation(.none)
                .padding()
        }
        .frame(width: screen.width * 0.4, height: screen.height/10, alignment: .center)
        .background(alertMessage == "成功" ? Color.green : Color.black)
        .animation(.none)
        .cornerRadius(screen.height/80)
        .opacity(isShow ? 1 : 0)
        .animation(
            Animation.easeInOut(duration: 0.5)
                .delay(1)
        )
    }
}
