//
//  FgFinalStepView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/1/25.
//

import SwiftUI

struct FgFinalStepView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var isJumpToBack = false
    var body: some View {
        VStack(spacing: 20.0) {
            Text("密码修改完成")
                .font(.title2)
                .foregroundColor(Color.init(red: 98/255, green: 103/255, blue: 124/255))
            
            Button(action:{
                if self.appState.leftHome {
                    self.appState.leftHome.toggle()
                } else {
                    isJumpToBack = true
                }
            }) {
                Text("前往登录")
                    .foregroundColor(.white)
                    .frame(width: screen.width * 0.4, height: screen.height / 15, alignment: .center)
                    .background(Color.init(red: 79/255, green: 88/255, blue: 107/255))
                    .cornerRadius(screen.height / 30)
            }
            .navigationBarBackButtonHidden(true)
            NavigationLink(
                destination: LgKeywordLoginView(),
                isActive: $isJumpToBack,
                label: {
                    EmptyView()
                })
        }
        .addAnalytics(className: "PasswordChangeView")
    }
}

struct FinalStepView_Previews: PreviewProvider {
    static var previews: some View {
        FgFinalStepView()
    }
}
