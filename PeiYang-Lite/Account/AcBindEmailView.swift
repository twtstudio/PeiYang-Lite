//
//  AcBindEmailView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/8.
//

import SwiftUI

struct AcBindEmailView: View {
    let themeColor = Color(red: 102/255, green: 106/255, blue: 125/255)
    let titleColor = Color.init(red: 98/255, green: 103/255, blue: 122/255)
    @AppStorage(SharedMessage.userTokenKey, store: Storage.defaults) private var userToken = ""
    @State private var email = ""
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var AlertMessage: String = "网络问题"
    @State private var isShowAlert: Bool = false
    @State private var alertTimer: Timer?
    @State private var alertTime = 2
    @State var isShowSignOut = false
    
    @EnvironmentObject var sharedMessage: SharedMessage
    var body: some View {
        ZStack {
            VStack(spacing: UIScreen.main.bounds.width / 15){
                NavigationBar()
                HStack{
                    Text("邮箱绑定")
                        .font(.custom("Avenir-Heavy", size: UIScreen.main.bounds.height / 35))
                        .foregroundColor(.init(red: 48/255, green: 60/255, blue: 102/255))
                    Text((sharedMessage.isBindEm) ? "已绑定" : "未绑定")
                        .font(.callout)
                        .foregroundColor(.init(red: 98/255, green: 103/255, blue: 122/255))
                    Spacer()
                }
                .padding(.bottom, 30)
                .frame(width: UIScreen.main.bounds.width * 0.9)
                
                if(sharedMessage.isBindEm) {
                    VStack(spacing: 10) {
                        Text("已绑定邮箱:")
                        Text(sharedMessage.Account.email!)
                    }
                    .padding(.vertical, UIScreen.main.bounds.height / 20)
                    .foregroundColor(.init(red: 79/255, green: 88/255, blue: 107/255))

                    Button(action:{
                        isShowSignOut = true
                    }){
                        Text("解除绑定")
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height / 15, alignment: .center)
                            .background(Color.init(red: 79/255, green: 88/255, blue: 107/255))
                            .cornerRadius(UIScreen.main.bounds.height / 30)
                    }
                    Spacer()
                    
                } else {
                    TextField("邮箱", text: $email)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
                        .background(Color.init(red: 235/255, green: 238/255, blue: 243/255))
                        .cornerRadius(10)
                        .keyboardType(.numberPad)
                    
                    Button(action: {
                        AcBindManager.BindEmPut(email: email, token: userToken){ result in
                            switch result {
                            case .success(let data):
                                AlertMessage = data.message
                                if(AlertMessage == "成功") {
                                    sharedMessage.Account.email = email
                                    sharedMessage.isBindEm = true
                                    self.mode.wrappedValue.dismiss()
                                } else {
                                    isShowAlert = true
                                }
                            case .failure(let error):
                                isShowAlert = true
                                log(error)
                            }
                        }
                        
                        alertTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (time) in
                            if self.alertTime < 1 {
                                self.alertTime = 3
                                time.invalidate()
                                isShowAlert = false
                               
                            }
                            self.alertTime -= 1
                        })
                    }) {
                        Text("绑定")
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
                            .background(Color.init(red: 79/255, green: 88/255, blue: 107/255))
                            .cornerRadius(UIScreen.main.bounds.height / 30)
                    }
                    Spacer()
                    AlertView(alertMessage: AlertMessage, isShow: $isShowAlert)
                }
                
            }
            
            Color.black.ignoresSafeArea()
                .opacity(isShowSignOut ? 0.5 : 0)
                .animation(.easeIn)

            VStack(spacing: UIScreen.main.bounds.height / 40) {
                Text("解除邮箱绑定后无法使用邮箱登录微北洋。若本次登录为邮箱登录则将退出登录，需要您重新进行账号密码登录。您是否确定解除绑定？").padding()
                    .foregroundColor(themeColor)
                    .font(.caption)

                HStack(spacing: UIScreen.main.bounds.width * 0.1){
        
                    Button(action:{
                        isShowSignOut = false
                        sharedMessage.isBindEm = false
                        sharedMessage.Account.email = nil
                    }){
                        Text("确认")
                            .foregroundColor(titleColor)
                            .font(.custom("Avenir-Black", size: 20))
                    }

                    Button(action:{
                        isShowSignOut = false
                    }){
                        Text("取消")
                            .foregroundColor(titleColor)
                            .font(.custom("Avenir-Black", size: 20))
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height / 6, alignment: .center)
            .background(Color.init(red: 242/255, green: 242/255, blue: 242/255))
            .cornerRadius(15)
            .shadow(radius: 10)
            .offset(y: isShowSignOut ? 0 : 1000)
            .animation(.easeInOut)
            
        }
        .navigationBarHidden(true)
        .addAnalytics(className: "EmailBindingView")
    }
}

struct BindEmailView_Previews: PreviewProvider {
    static var previews: some View {
        AcBindEmailView()
            .environmentObject(SharedMessage())
    }
}
