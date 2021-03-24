//
//  RegisterFirView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/1/29.
//

import SwiftUI

struct RegisterFirView: View {
    let fieldColor = Color.init(red: 235/255, green: 238/255, blue: 243/255)
    @Environment(\.presentationMode) var mode:
        Binding<PresentationMode>
    // data that we need
    @State private var userNumber = ""
    @State private var username = ""
    @State var isJumpToSec = false
    @EnvironmentObject var user: User
    
    // Alert var
        @State private var AlertMessage: String = "网络出现问题"
        @State private var isShowAlert: Bool = false
        @State private var alertTimer: Timer?
        @State private var alertTime = 2
    
    var body: some View {
        VStack(spacing: 25.0){
            NavigationBar()
            Text("新用户注册")
                .font(.title2)
                .foregroundColor(Color.init(red: 98/255, green: 103/255, blue: 124/255))
            
            TextField("学号", text: $userNumber)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
                .background(fieldColor)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
            
            
            TextField("用户名", text: $username)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
                .background(fieldColor)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
            
            
            
            Spacer()
            AlertView(alertMessage: AlertMessage, isShow: $isShowAlert)
            
            HStack{
                Spacer()
                NavigationLink(
                    destination: RegisterSecView(), isActive: $isJumpToSec) {EmptyView()}
                Button(action:{
                    RgRegisterManager.FirstPost(userNumber: userNumber, username: username) { result in
                        switch result {
                        case .success(let data):
                            AlertMessage = data.message
                            if (AlertMessage == "成功") {
                                isJumpToSec = true
                            } else {
                                isShowAlert = true
                            }
                        case .failure(_):
                            isShowAlert = true
                        }
                        alertTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (time) in
                            if self.alertTime < 1 {
                                self.alertTime = 3
                                time.invalidate()
                                isShowAlert = false
                            }
                            self.alertTime -= 1
                        })
                    }
                }) {
                    Image("right-arrow")
                }
                .disabled(username == "" || userNumber == "")
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
        .onAppear(perform: {
            UMAnalyticsSwift.beginLogPageView(pageName: "RegisterViewNo.1")
        })
        .onDisappear(perform: {
            user.nickName = username
            user.userNumber = userNumber
            UMAnalyticsSwift.endLogPageView(pageName: "RegisterViewNo.1")
        })
    }
}

class User: ObservableObject {
    @Published var userNumber: String = ""
    @Published var nickName: String = ""
    @Published var phone: String = ""
    @Published var verifyCode: String = ""
    @Published var email: String = ""
    @Published var idNumber: String = ""
    @Published var password: String = ""
}


struct RegisterFirView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterFirView()
            .environmentObject(User())
    }
}
