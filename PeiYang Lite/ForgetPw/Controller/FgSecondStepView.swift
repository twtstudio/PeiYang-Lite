//
//  FgSecondStepView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/1/25.
//

import SwiftUI

struct FgSecondStepView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var password: String = ""
    @State private var cfPassword: String = ""
    
    
    @State private var AlertMessage: String = "网络出现问题"
    @State private var isShowAlert: Bool = false
    @State private var alertTimer: Timer?
    @State private var alertTime = 2
    
    @State private var isChangePs:Bool = false

    var body: some View {
        VStack(spacing: 25.0) {
            NavigationBar()
            
            Text("天外天账号密码找回")
                .font(.title2)
                .foregroundColor(Color.init(red: 98/255, green: 103/255, blue: 124/255))
            SecureField("请输入新密码", text: $password).padding()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
                .background(Color.init(red: 235/255, green: 238/255, blue: 243/255))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
            
            SecureField("再次输入密码", text: $cfPassword).padding()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
                .background(Color.init(red: 235/255, green: 238/255, blue: 243/255))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
            
            if(password != cfPassword) {
                HStack {
                    Text("密码不一致")
                        .font(.headline)
                        .foregroundColor(.red)
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)
            }
            
            NavigationLink(
                destination: FgFinalStepView(),
                isActive: $isChangePs,
                label: {
                    // 空
                })
            
            Spacer()
            
            AlertView(alertMessage: AlertMessage, isShow: $isShowAlert)
                
            
            HStack{
                Spacer()
                Button(action:{
                    ForgetManager.ChangePsPost(password: password){result in
                        switch result {
                        case .success(let data):
                                AlertMessage = data.message
                            if(AlertMessage == "成功"){
                                isChangePs = true
                            } else {
                                isChangePs = false
                            }
                        case .failure(_): break
                        }
                    }
                    isShowAlert = true
                    
                    alertTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (time) in
                        if self.alertTime < 1 {
                            self.alertTime = 3
                            time.invalidate()
                            isShowAlert = false
                        }
                        self.alertTime -= 1
                    })
                }) {
                    Image("right-arrow")
                }
                .disabled(password != cfPassword)
                
                
            
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
            
        }
        .background(
            Color.white
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .onTapGesture(perform: {
                    UIApplication.shared.endEditing()
                })
        )
        .navigationBarHidden(true)
        .addAnalytics(className: "TwTGetPasswordView")
    }
}

struct SecondStepView_Previews: PreviewProvider {
    static var previews: some View {
        FgSecondStepView()
    }
}
