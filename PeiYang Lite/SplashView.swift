//
//  SplashView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/16.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var sharedMessage: SharedMessage
    @AppStorage(SharedMessage.usernameKey, store: Storage.defaults) private var storageUserName = ""
    @AppStorage(SharedMessage.passwordKey, store: Storage.defaults) private var storagePassword = ""
    @AppStorage(ClassesManager.usernameKey, store: Storage.defaults) private var username = ""
    @AppStorage(ClassesManager.passwordKey, store: Storage.defaults) private var password = ""
    @State private var isStored: Bool = false
    @State private var isJumpToLog: Bool = false
    @State private var isJumpToAccount: Bool = false
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination:MainView(), isActive: $isJumpToAccount){}
                NavigationLink(
                    destination: BeginView(),
                    isActive: $isJumpToLog,
                    label: {})
                Image("splash_screen")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
            }
            .navigationBarHidden(true)
        }
        .onAppear(perform: {
            if(storagePassword != "" && storageUserName != "") {
                isStored = true
            } else {
                isStored = false
            }
            if(username == "" || password == "") {
                sharedMessage.isBindBs = false
            }
            Jump(isStored: isStored)
        })
    }
    func Jump(isStored: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if(isStored){
                LoginManager.LoginPost(account: storageUserName, password: storagePassword) { result in
                    switch result {
                    case .success(let data):
                        sharedMessage.Account = data.result
                        SupplyPhManager.token = sharedMessage.Account.token
                        isJumpToAccount = true
                    case .failure(_):
                        isJumpToLog = true
                    }
                }
            } else {
                isJumpToLog = true
            }
           
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
           
    }
}

