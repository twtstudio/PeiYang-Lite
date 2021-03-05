//
//  AcMessageView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/6.
//

import SwiftUI

struct AcMessageView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var sharedMessage: SharedMessage
    @AppStorage(ClassesManager.isLoginKey, store: Storage.defaults) private var isLogin = false
    
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 122/255)
    let captionColor = Color.init(red: 205/255, green: 206/255, blue: 212/255)
    
    @State private var isShowChangeName = false
    @State private var chUserName: String = ""
    // Alert var
        @State private var AlertMessage: String = "网络出现问题"
        @State private var isShowAlert: Bool = false
        @State private var alertTimer: Timer?
        @State private var alertTime = 2

    
    var body: some View {
//        NavigationView {
            ZStack {
                VStack {
                        List {
                            
                            Section() {
                                Button(action:{
                                    print("Todo")
                                }){
                                    HStack{
                                        Text("头像")
                                            .foregroundColor(themeColor)
                                        Spacer()
                                        Image("Text")
                                            .resizable()
                                            .frame(width: UIScreen.main.bounds.height / 25, height: UIScreen.main.bounds.height / 25, alignment: .center)
                                            .cornerRadius(UIScreen.main.bounds.height / 50)
                                    }
                                    .frame(height: UIScreen.main.bounds.height / 15, alignment: .center)
                                }
                                
                                Button(action: {
                                    isShowChangeName = true
                                }){
                                    AcListView(title: "用户名", caption: sharedMessage.Account.nickname)
                                }
                                
                                NavigationLink(destination: ClassesBindingView()){
                                    AcListView(title: "办公网", caption: isLogin ? "已绑定" : "未绑定")
                                }
                            }
                            
                            Section() {
                                NavigationLink(destination: BindPhoneView()){
                                    AcListView2(img: "phone", title: "电话", caption: sharedMessage.isBindPh ? "已绑定" : "未绑定")
                                }
                                
                                NavigationLink(destination: BindEmailView()){
                                    AcListView2(img: "email", title: "邮箱", caption: sharedMessage.isBindEm ? "已绑定" : "未绑定")
                                }
                                
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                        .environment(\.horizontalSizeClass, .regular)
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                    HStack{
                        Button(action : {
                            self.mode.wrappedValue.dismiss()
                            }){
                            Image("back-arrow-black")
                        }

                        Text("个人信息更改")
                            .offset(x: UIScreen.main.bounds.width / 3.8)

                    }
                )
                Color.black.ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                    .opacity(isShowChangeName ? 0.4 : 0)
                    .onTapGesture(perform: {
                        if(isShowChangeName){
                            UIApplication.shared.endEditing()
                        }
                    })
                //: CHANGE NAME VIEW
                VStack(spacing: 30){
                    TextField("新用户名", text: $chUserName).padding()
                        .border(themeColor)
                    
                    if(isShowAlert) {
                        Text(AlertMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                        
                    HStack(spacing: 15){
                        Button(action:{
                            BindManager.ChangeName(username: chUserName) { result in
                                switch result{
                                case .success(let data):
                                    AlertMessage = data.message
                                    if(AlertMessage == "成功"){
                                        sharedMessage.Account.nickname = chUserName
                                        isShowChangeName = false
                                    } else {
                                        chUserName = ""
                                        isShowAlert = true
                                    }
                                case .failure(_):
                                    break
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
                            
                        }){
                            Text("确定")
                                .foregroundColor(themeColor)
                        }
                        Button(action:{
                            isShowChangeName = false
                        }) {
                            Text("取消")
                                .foregroundColor(themeColor)
                        }
                    }
                   
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height / 5, alignment: .center)
                .background(Color.white)
                .cornerRadius(10)
                .offset(y: isShowChangeName ? 0 : 500)
                .animation(.easeInOut)
                
            }
        
                
                                    
//        }//: NAVIGATION
        .onAppear(perform: {
            if(sharedMessage.Account.email != nil) {
                sharedMessage.isBindEm = true
            }
            if(sharedMessage.Account.telephone != nil) {
                sharedMessage.isBindPh = true
            }
        })
    }
}

struct AcMessageView_Previews: PreviewProvider {
    static var previews: some View {
        AcMessageView()
            .environmentObject(SharedMessage())
    }
}

struct AcListView: View {
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 122/255)
    let captionColor = Color.init(red: 205/255, green: 206/255, blue: 212/255)
    var title: String
    var caption: String
    var body: some View {
        HStack{
            Text(title)
                .foregroundColor(themeColor)
            Spacer()
            Text(caption)
                .font(.caption)
                .foregroundColor(captionColor)

            
        }
        .frame(height: UIScreen.main.bounds.height / 15, alignment: .center)
    }
}

struct AcListView2: View {
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 122/255)
    let captionColor = Color.init(red: 205/255, green: 206/255, blue: 212/255)
    var img: String
    var title: String
    var caption: String
    var body: some View {
        HStack{
            Image(img)
            Text(title)
                .foregroundColor(themeColor)
            Spacer()
            Text(caption)
                .font(.caption)
                .foregroundColor(captionColor)
  
        }
        .frame(height: UIScreen.main.bounds.height / 15, alignment: .center)
    }
}
