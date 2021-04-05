//
//  SplashView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/16.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var sharedMessage: SharedMessage
    /// 这两个是天外天的用户名和密码存储
    @AppStorage(SharedMessage.usernameKey, store: Storage.defaults) private var storageUserName = ""
    @AppStorage(SharedMessage.passwordKey, store: Storage.defaults) private var storagePassword = ""
    /// 这两个是办公网的用户名和密码
    @AppStorage(ClassesManager.usernameKey, store: Storage.defaults) private var username = ""
    @AppStorage(ClassesManager.passwordKey, store: Storage.defaults) private var password = ""
    @AppStorage(SharedMessage.userTokenKey, store: Storage.defaults) private var userToken = ""
    
    @AppStorage(AccountSaveMessage.AccountEmailKey, store: Storage.defaults) private var accountEmail = ""
    @AppStorage(AccountSaveMessage.AccountTelephoneKey, store: Storage.defaults) private var accountTelephone = ""
    @AppStorage(AccountSaveMessage.AccountIdKey, store: Storage.defaults) private var accountId = ""
    @AppStorage(AccountSaveMessage.AccountNameKey, store: Storage.defaults) private var accountName = ""
    
    @State private var isStored: Bool = false
    @State private var isJumpToLog: Bool = false
    @State private var isJumpToAccount: Bool = false
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination:MainView(), isActive: $isJumpToAccount){EmptyView()}
                NavigationLink(
                    destination: LgBeginView(),
                    isActive: $isJumpToLog,
                    label: {EmptyView()})
                Image("splash_screen")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            jump()
        })
        
    }
    func jump() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if userToken == "" {
                isJumpToLog = true
            } else {
                sharedMessage.Account = AccountResult(userNumber: accountId, nickname: accountName, telephone: accountTelephone, email: accountEmail, token: userToken, role: "", realname: "", gender: "", department: "", major: "", stuType: "", avatar: "", campus: "")
                isJumpToAccount = true
            }
        }
    }
    
//    func Jump() {
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
//
//            LgLoginManager.LoginPost(account: storageUserName, password: storagePassword) { result in
//                switch result {
//                case .success(let data):
//                    sharedMessage.Account = data.result
//                    // 存储用户本地数据
//                    accountId = sharedMessage.Account.userNumber
//                    accountEmail = sharedMessage.Account.email ?? ""
//                    accountTelephone = sharedMessage.Account.telephone ?? ""
//                    accountName = sharedMessage.Account.nickname
//                    // 更新token
//                    userToken = sharedMessage.Account.token
//                    isJumpToAccount = true
//                case .failure(let error):
//                    isJumpToAccount = true
//                    sharedMessage.Account = AccountResult(userNumber: accountId, nickname: accountName, telephone: accountTelephone, email: accountEmail, token: userToken, role: "", realname: "", gender: "", department: "", major: "", stuType: "", avatar: "", campus: "")
//                    log(error)
//                }
//            }
//
//
//        }
//    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
           
    }
}

