//
//  RegisterThiView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/1/29.
//

import SwiftUI

struct RegisterThiView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var appState: AppState
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 123/255)
    
//the message that I need to post to log in
    @EnvironmentObject var user: User
    
    @State private var password: String = ""
    @State private var cfPassword: String = ""
    @State private var isShowMessage: Bool = false
    @State private var isLogin: Bool = false
    
    @State private var isShowManual: Bool = false
    @State private var isAgree = false
    
    // Alert var
        @State private var AlertMessage: String = "网络出现问题"
        @State private var isShowAlert: Bool = false
        @State private var alertTimer: Timer?
        @State private var alertTime = 2
    
    var body: some View {
        VStack(spacing: 25.0){
            Text("新用户注册")
                .font(.title2)
                .foregroundColor(Color.init(red: 98/255, green: 103/255, blue: 124/255))
            
            SecureField("请输入密码", text: $password).padding()
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
                Text("密码不一致")
                    .font(.headline)
                    .foregroundColor(.red)
                    .frame(alignment: .top)
            }
            
            HStack{
                Button(action:{
                    isAgree.toggle()
                }){
                    if(!isAgree) {
                        Image(systemName: "square")
                            .foregroundColor(.black)
                    } else {
                        Image("check")
                    }
                    
                }
                
                Text("我已阅读")
                Button(action: {isShowManual = true}){
                    Text("微北洋用户需知")
                        .foregroundColor(.blue)
                }
                   
                  
                
                Spacer()
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width * 0.9)
            
            NavigationLink(
                destination: AccountView(),
                isActive: $isLogin,
                label: {
                    // 空
                })
            Spacer()
            
            AlertView(alertMessage: AlertMessage, isShow: $isShowAlert)
            
            HStack{
                Button(action:{
                    self.mode.wrappedValue.dismiss()
                }){
                    Image("left-arrow")
                        
                }
                Spacer()
                Button(action:{
                    RegisterManager.RegisterPost(userNumber: user.userNumber, nickname: user.nickName, phone: user.phone, verifyCode: user.verifyCode, password: password, email: user.email, idNumber: user.idNumber) { result in
                        switch result {
                        case .success(let data):
                            AlertMessage = data.message
                            if(AlertMessage == "成功"){
                                self.appState.rightHome.toggle()
                            }
                        case .failure(_):
                            break
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
                .disabled((password != cfPassword) || isAgree == false)
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
            
        }
        
        .sheet(isPresented: $isShowManual) {
            AccountNeedToKnowView()
        }// MRAK: 用户需知
        
        .background(
            Color.white
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .onTapGesture(perform: {
                    UIApplication.shared.endEditing()
                })
        )
        .navigationBarBackButtonHidden(true)
        
    }
}

struct RegisterThiView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterThiView()
            .environmentObject(User())
    }
}

