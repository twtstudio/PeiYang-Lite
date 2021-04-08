//
//  LgKeywordLoginView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/1/23.
//

import SwiftUI


struct LgKeywordLoginView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @AppStorage(SharedMessage.usernameKey, store: Storage.defaults) private var storageUserName = ""
    @AppStorage(SharedMessage.passwordKey, store: Storage.defaults) private var storagePassword = ""
    @AppStorage(SharedMessage.userTokenKey, store: Storage.defaults) private var userToken = ""
    
    @AppStorage(AccountSaveMessage.AccountEmailKey, store: Storage.defaults) private var accountEmail = ""
    @AppStorage(AccountSaveMessage.AccountTelephoneKey, store: Storage.defaults) private var accountTelephone = ""
    @AppStorage(AccountSaveMessage.AccountIdKey, store: Storage.defaults) private var accountId = ""
    @AppStorage(AccountSaveMessage.AccountNameKey, store: Storage.defaults) private var accountName = ""
    @AppStorage(AccountSaveMessage.AccountUpdateTimeKey, store: Storage.defaults) private var accountLoginTime = 0
    
    
    @State private var isLogin = false
    @State private var username = ""
    @State private var password = ""
    @State private var isEnable = true
    
    @State var accountInfo: AccountInfo = AccountInfo(errorCode: 0, message:  "网络出现问题", result: AccountResult(userNumber: "无", nickname: "无", telephone: nil, email: "无", token: "", role: "无", realname: "无", gender: "无", department: "无", major: "无", stuType: "无", avatar: "无", campus: "无"))
    
    @EnvironmentObject var sharedMessage: SharedMessage
    
    @State private var isError = false
    @State private var isHide: Bool = true

// Alert var
    @State private var AlertMessage: String = "网络出现问题"
    @State private var isShowAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 25.0){
            NavigationBar()
            
            Text("微北洋4.0")
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
                    destination: FgChMeToFindView(),
                    label: {
                        Text("忘记密码?")
                            .foregroundColor(Color.init(red: 79/255, green: 88/255, blue: 107/255))
                    })
               Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height/25, alignment: .center)
           
            
            Button(action:{
                //MARK: Login
                LgLoginManager.LoginPost(account: username, password: password) { result in
                    switch result {
                    case .success(let data):
                        	isLogin = true
                        accountInfo = data
                        // 存下基础信息
                        accountId = accountInfo.result.userNumber
                        accountEmail = accountInfo.result.email ?? ""
                        accountTelephone = accountInfo.result.telephone ?? ""
                        accountName = accountInfo.result.nickname
                        AlertMessage = accountInfo.message
                        userToken = accountInfo.result.token
                        storagePassword = password
                        storageUserName = username
                        // 存时间戳
                        let now = Date()
                        let timeInterval: TimeInterval = now.timeIntervalSince1970
                        let timeStamp = Int(timeInterval)
                        accountLoginTime = timeStamp

                    case .failure(let error):
                        isError = true
                        AlertMessage = error.message
                        password = ""
                        isShowAlert = true
                    }
                    isEnable = true
                }
                isEnable = false// 确保只会点击一次

            }) {
                Text("登录")
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height/15, alignment: .center)
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(Color.init(red: 79/255, green: 88/255, blue: 107/255))
                    .cornerRadius(UIScreen.main.bounds.height/30)
            }
            .disabled(!isEnable || username.isEmpty || password.isEmpty)
            
            if(accountInfo.result.telephone == nil || accountInfo.result.email == nil) {
                NavigationLink(destination: LgSupplyView(), isActive: $isLogin){
                    EmptyView()
                }
            } else {
                NavigationLink(destination: MainView(), isActive: $isLogin){
                    EmptyView()
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
                    hideKeyboard()
                })
        )
        .onDisappear(perform: {
            sharedMessage.Account = accountInfo.result
        })
        .padding(.bottom)
        .navigationBarHidden(true)
    }
    
}





struct KeywordLoginView_Previews: PreviewProvider {
    static var previews: some View {
     
        LgKeywordLoginView()
            .environment(\.colorScheme, .light)
        
    }
}
