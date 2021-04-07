//
//  AcChangePsView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/3/24.
//

import SwiftUI

struct AcChangePsView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @AppStorage(SharedMessage.passwordKey, store: Storage.defaults) private var storedPassword = ""
    @State var oldPassword = ""
    @State var newPassword = ""
    @State var newCheckPassword = ""
    
    @State private var AlertMessage: String = "网络出现问题"
    @State private var isShowAlert: Bool = false
    @State private var alertTimer: Timer?
    @State private var alertTime = 2
    @State private var isEnable: Bool = true
    
    var body: some View {
        VStack(spacing: 20) {
            NavigationBar(center: {Text("密码更改")})
                .background(Color.white.edgesIgnoringSafeArea(.top))
            
            VStack(spacing: 20){
                AcChangePsHeaderView(text: "原密码")
                
                AcChangePsSecureField(title: "请输入原来的密码", inputString: $oldPassword)
                
                AcChangePsHeaderView(text: "新密码")
                
                AcChangePsSecureField(title: "请输入新密码", inputString: $newPassword)
                
                AcChangePsHeaderView(text: "请确认新密码")
                
                AcChangePsSecureField(title: "请再次输入新密码", inputString: $newCheckPassword)
            }
            
            
            HStack{
                Text("忘记原密码").underline()
                    .foregroundColor(.init(red: 98/255, green: 103/255, blue: 124/255))
                    .fontWeight(.bold)
                Spacer()
            }.frame(width: screen.width * 0.9)
            
            Button(action:{
                isEnable = false
                if oldPassword != storedPassword {
                    AlertMessage = "原密码错误"
                    isShowAlert = true
                    countdown()
                } else if newPassword != newCheckPassword {
                    AlertMessage = "两次密码不一致"
                    isShowAlert = true
                    countdown()
                } else {
                    AcBindManager.ChangePs(password: newPassword) {result in
                        switch result {
                        case .success(let data):
                            AlertMessage = data.message
                            isShowAlert = true
                        case .failure(let error):
                            AlertMessage = "请求失败"
                            isShowAlert = true
                            log(error)
                        }
                    }
                    countdown()
                    
                }
            }){
                Text("确认更改")
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
                    .background(Color.init(red: 79/255, green: 88/255, blue: 107/255))
                    .cornerRadius(UIScreen.main.bounds.height / 30)
            }
            .disabled(!isEnable || newPassword == "" || oldPassword == "" || newCheckPassword == "")
            Spacer()
           
            AlertView(alertMessage: AlertMessage, isShow: $isShowAlert)
        }
        .navigationBarHidden(true)
        .background(Color.init(red: 247/255, green: 247/255, blue: 248/255).edgesIgnoringSafeArea(.bottom))
        .addAnalytics(className: "ChangePsView")
    }
    func countdown() {
        alertTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (time) in
            if self.alertTime < 1 {
                self.alertTime = 3
                time.invalidate()
                isShowAlert = false
                isEnable = true
                if AlertMessage == "成功" {
                    self.mode.wrappedValue.dismiss()
                }
            }
            self.alertTime -= 1
        })
    }
}

struct AcChangePsView_Previews: PreviewProvider {
    static var previews: some View {
        AcChangePsView()
    }
}

fileprivate struct AcChangePsHeaderView: View {
    let width = screen.width * 0.9
    var text: String
    var body: some View {
        HStack{
            Text(text)
                .foregroundColor(.init(red: 79/255, green: 88/255, blue: 107/255))
            Spacer()
        }
        .frame(width: width)
    }
}

fileprivate struct AcChangePsSecureField: View {
    let width = screen.width * 0.9
    var title: String
    @Binding var inputString: String
    var body: some View {
        SecureField(title, text: $inputString).padding()
            .frame(width: width, height: screen.height * 0.06)
            .background(Color.init(red: 235/255, green: 238/255, blue: 243/255))
            .cornerRadius(15)
    }
}

