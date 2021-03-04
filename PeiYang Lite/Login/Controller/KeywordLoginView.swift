//
//  KeywordLoginView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/1/23.
//

import SwiftUI


struct KeywordLoginView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @AppStorage(LoginManager.isTokenKey, store: Storage.defaults) private var token = ""
    @AppStorage(SharedMessage.usernameKey, store: Storage.defaults) private var storageUserName = ""
    @AppStorage(SharedMessage.passwordKey, store: Storage.defaults) private var storagePassword = ""
    
    @State private var isLogin = false
    @State private var username = ""
    @State  private var password = ""
    @State private var isEnable = true
    
    
    @State var accountMessage: AccountMessage = AccountMessage(errorCode: 0, message:  "网络出现问题", result: AccountResult(userNumber: "无", nickname: "无", telephone: nil, email: "无", token: "无", role: "无", realname: "无", gender: "无", department: "无", major: "无", stuType: "无", avatar: "无", campus: "无"))
    
    @EnvironmentObject var sharedMessage: SharedMessage
    
    @State private var isError = false
    @State private var isHide: Bool = true

// Alert var
    @State private var AlertMessage: String = "网络出现问题"
    @State private var isShowAlert: Bool = false
    @State private var alertTimer: Timer?
    @State private var alertTime = 2
    
    
    
    var body: some View {
        VStack(spacing: 25.0){
            Text("天外天账号密码登陆")
                .font(.title2)
                .foregroundColor(Color.init(red: 98/255, green: 103/255, blue: 124/255))
                
                
            
           
            TextField("学号/手机号/邮箱/用户名", text: $username).padding()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
                .background(Color.init(red: 235/255, green: 238/255, blue: 243/255))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
                .keyboardType(.twitter)
            
        
            
            HStack{
                if(isHide == true) {
                    SecureField("密码", text: $password).padding()
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height / 15, alignment: .center)
                        .background(Color.init(red: 235/255, green: 238/255, blue: 243/255))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
                    
                } else {
                    TextField("密码", text: $password).padding()
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height / 15, alignment: .center)
                        .background(Color.init(red: 235/255, green: 238/255, blue: 243/255))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
                }
                Button(action:{
                    self.isHide.toggle()
                }){
                    Image(systemName: isHide ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(isHide ? Color.secondary : Color.init(red: 79/255, green: 88/255, blue: 107/255))
                }
                .frame(width: UIScreen.main.bounds.width * 0.08, height: UIScreen.main.bounds.height / 15, alignment: .center)
            }
         
            HStack{
                NavigationLink(
                    destination: ChMeToFindView(),
                    label: {
                        Text("忘记密码?")
                            .foregroundColor(Color.init(red: 79/255, green: 88/255, blue: 107/255))
                    })
               Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height/25, alignment: .center)
           
            
            Button(action:{
                //MARK: Login
                LoginManager.LoginPost(account: username, password: password) { result in
                    switch result {
                    case .success(let data):
                        isLogin = true
                        accountMessage = data
                        AlertMessage = accountMessage.message
                        SupplyPhManager.token = accountMessage.result.token
                        token = accountMessage.result.token
                        storagePassword = password
                        storageUserName = username
                    case .failure(let error):
                        isError = true
                        AlertMessage = error.message
                        password = ""
                        isShowAlert = true
                    }
                    isEnable = true
                }
                isEnable = false// 确保只会点击一次
                
                
                
                alertTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (time) in
                    if self.alertTime < 1 {
                        self.alertTime = 3
                        time.invalidate()
                        isShowAlert = false
                    }
                    self.alertTime -= 1
                })
            }) {
                Text("登陆")
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height/15, alignment: .center)
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(Color.init(red: 79/255, green: 88/255, blue: 107/255))
                    .cornerRadius(UIScreen.main.bounds.height/30)
            }
            .disabled(!isEnable || username.isEmpty || password.isEmpty)
            
            if(accountMessage.result.telephone == nil || accountMessage.result.email == nil) {
                NavigationLink(destination: supplyView(), isActive: $isLogin){
                    // 空
                }
            } else {
                NavigationLink(destination: MainView(), isActive: $isLogin){
                    // 空
                }
            }
            
            Spacer()
            
            AlertView(alertMessage: AlertMessage, isShow: $isShowAlert)
        }
        //MARK: 下降键盘
        .background(
            Color.white
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .onTapGesture(perform: {
                    UIApplication.shared.endEditing()
                })
        )
        .onDisappear(perform: {
            sharedMessage.Account = accountMessage.result
        })
        .padding(.bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            self.mode.wrappedValue.dismiss()
        }){
            Image("back-arrow")
                .foregroundColor(.black)
                .font(.title)
        })
    }
    
}





struct KeywordLoginView_Previews: PreviewProvider {
    static var previews: some View {
     
        KeywordLoginView()
            .environment(\.colorScheme, .light)
        
    }
}
