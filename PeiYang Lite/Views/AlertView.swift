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
                .foregroundColor(.white)
                .animation(.none)
                .padding()
        }
        .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height/10, alignment: .center)
        .background(Color.black)
        .cornerRadius(UIScreen.main.bounds.height/80)
        .opacity(isShow ? 1 : 0)
        .animation(
            Animation.easeInOut(duration: 0.5)
                .delay(1)
        )
    }
}
