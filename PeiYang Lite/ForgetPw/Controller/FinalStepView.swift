//
//  FinalStepView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/1/25.
//

import SwiftUI

struct FinalStepView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        VStack(spacing: 20.0) {
            Text("密码修改完成")
                .font(.title2)
                .foregroundColor(Color.init(red: 98/255, green: 103/255, blue: 124/255))
            
            Button(action:{
                self.appState.leftHome.toggle()
            }) {
                Text("前往登录")
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height / 15, alignment: .center)
                    .background(Color.init(red: 79/255, green: 88/255, blue: 107/255))
                    .cornerRadius(UIScreen.main.bounds.height / 30)
            }
            .navigationBarBackButtonHidden(true)
        }
        
    }
}

struct FinalStepView_Previews: PreviewProvider {
    static var previews: some View {
        FinalStepView()
    }
}
