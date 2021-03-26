//
//  AccountView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/6.
//

import SwiftUI

struct AccountView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var sharedMessage: SharedMessage
    
    //存绑定的东西
    @AppStorage(SharedMessage.usernameKey, store: Storage.defaults) private var storageUserName = ""
    @AppStorage(SharedMessage.passwordKey, store: Storage.defaults) private var storagePassword = ""
    @AppStorage(SharedMessage.isShowFullCourseKey, store: Storage.defaults) private var showFullCourse = true
    @AppStorage(ClassesManager.isGPAStoreKey, store: Storage.defaults) private var isNotShowGPA = false
    @AppStorage(ClassesManager.isLoginKey, store: Storage.defaults) private var isLogin = false
    
    @AppStorage(ClassesManager.usernameKey, store: Storage.defaults) private var username = ""
    @AppStorage(ClassesManager.passwordKey, store: Storage.defaults) private var password = ""
    
   
    
    
    @State var isActive = false
    @State var isShowSignOut = false
    @State var isJumpToTop = false
    @State var isJumpToChange = false
    
    

    let themeColor = Color(red: 102/255, green: 106/255, blue: 125/255)
    let titleColor = Color.init(red: 98/255, green: 103/255, blue: 122/255)
    var body: some View {

        ZStack{
            BackGroundView(themeColor: themeColor)
            
            VStack(spacing: screen.height / 40) {
                HStack{
                    Spacer()
                    NavigationLink(destination: AcSettingView()){
                        Image(systemName: "gearshape")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                }
                .frame(width: screen.width * 0.9)
                .offset(y: screen.height / 10)
                VStack(spacing: screen.height / 50){
                    HStack {//MARK: 加气泡的地方
                        NavigationLink(destination: AcMessageView(), isActive: $isJumpToChange){
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: screen.width * 0.3, height: screen.width * 0.3, alignment: .center)
                                .cornerRadius(screen.width * 0.15)
                        }.padding(.top)
                       
                    }
                   
                    Text(sharedMessage.Account.nickname)
                        .font(.custom("Avenir-Heavy", size: 20))
                    Text(sharedMessage.Account.userNumber)
                }//: VSTACK Top Account head view
                .foregroundColor(.white)
                .padding(.top, screen.height / 13)
                
                HStack{
                   Image("AcExpect")
                    .resizable()
                    .scaledToFit()
                }// Horizontal 3 icons
                .padding(30)
                .frame(width: screen.width * 0.9, height: screen.height * 0.18, alignment: .center)
                .background(Color.white)
                .cornerRadius(30)
                
                
                VStack(spacing: 15.0) {
                    Button(action:{
                        isJumpToChange = true
                    }){
                        HStack {
                            Image("AcChange")
                            Text("个人信息更改")
                                .foregroundColor(titleColor)
                            Spacer()
                            Image("right")
                        }
                        
                    }
                    .padding()
                    .frame(width: screen.width * 0.9, height: screen.height * 0.08, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(15)
                    
                    NavigationLink(destination: AboutTwTView()){
                        HStack {
                            Image("TwT")
                            Text("关于天外天")
                                .foregroundColor(titleColor)
                            Spacer()
                            Image("right")
                        }
                        
                    }
                    .padding()
                    .frame(width: screen.width * 0.9, height: screen.height * 0.08, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(15)
                    
                    Button(action:{
                        print("log out")
                        isShowSignOut = true
                    }){
                        HStack {
                            Image("logOut")
                            Text("登出")
                                .foregroundColor(titleColor)
                            Spacer()
                            Image("right")
                        }
                    }
                    
                    .padding()
                    .frame(width: screen.width * 0.9, height: screen.height * 0.08, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(15)
                    NavigationLink(
                        destination: LgBeginView().environmentObject(AppState()),
                        isActive: $isJumpToTop,
                        label: {EmptyView()})
                }//: VSTACK List
                Spacer()
            }//: VSTACK body
            
            Color.black.ignoresSafeArea()
                .opacity(isShowSignOut ? 0.5 : 0)
                .animation(.easeIn)
//MARK: 退出登录确定
            VStack(spacing: screen.height / 40) {
                Text("您确定要退出登录？")
                    .foregroundColor(themeColor)
                
                HStack(spacing: screen.width * 0.1){
                    Button(action:{
                        if(appState.leftHome) {
                        self.appState.leftHome.toggle()
                        } else {
                           isJumpToTop = true
                        }
                        loadOut()
                        
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
            .frame(width: screen.width * 0.8, height: screen.height / 6, alignment: .center)
            .background(Color.init(red: 242/255, green: 242/255, blue: 242/255))
            .cornerRadius(15)
            .shadow(radius: 10)
            .offset(y: isShowSignOut ? 0 : 1000)
            .animation(.easeInOut)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .addAnalytics(className: "AccountView")
    }
    func loadOut() {
        ClassesManager.removeAll()
        let cookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
                cookieStorage.deleteCookie(cookie)
            }
        }
        SharedMessage.removeAll()
        DataStorage.clear(in: DataStorage.Directory.caches)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(SharedMessage())
            .environmentObject(AppState())
            
    }
}

fileprivate struct BackGroundView: View {
    var themeColor: Color
    var body: some View {
        VStack(spacing: 0.0) {
            Image("user_back")
                .resizable()
                .ignoresSafeArea()
                .frame(width: screen.width, height: screen.height * 0.45)
            Color.init(red: 247/255, green: 247/255, blue: 248/255, opacity: 1)
                .ignoresSafeArea()
                .frame(height: screen.height * 0.55)
        }
    }
}

