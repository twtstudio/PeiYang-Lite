//
//  AcClassesBindingView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/8.
//
import SwiftUI
import URLImage

struct AcClassesBindingView: View {
    @AppStorage(ClassesManager.isLoginKey, store: Storage.defaults) private var isLogin = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    
    var body: some View {

            if isLogin {
                ClassesBindingLoginedView(isLogin: $isLogin)
                    .navigationBarHidden(true)
            } else {
                ClassesBindingLoginView(isLogin: $isLogin)
                    .navigationBarHidden(true)
                    .onTapGesture {
                        hideKeyboard()
                    }
            }
        
    }
    
    
}
//        .navigationBarHidden(true)
//        .background(
//            Color.white
//                .ignoresSafeArea()
//                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        )
        
    }
}

struct BsLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AcClassesBindingView()
    }
}
//MARK: 已绑定页面
fileprivate struct ClassesBindingLoginedView: View {
    @State var isShowSignOut: Bool = false
    @AppStorage(ClassesManager.usernameKey, store: Storage.defaults) private var username = ""
    let themeColor = Color(red: 102/255, green: 106/255, blue: 125/255)
    let titleColor = Color.init(red: 98/255, green: 103/255, blue: 122/255)
    @Binding var isLogin: Bool
    
    var body: some View {
        ZStack {
            VStack{
                NavigationBar()
                HStack{
                    Text("办公网账号绑定")
                        .font(.custom("Avenir-Black", size: UIScreen.main.bounds.height / 35))
                        .foregroundColor(.init(red: 48/255, green: 60/255, blue: 102/255))
                    Text("已绑定")
                        .font(.callout)
                        .foregroundColor(.init(red: 98/255, green: 103/255, blue: 122/255))
                    Spacer()
                }
                .padding(.horizontal, 30)
                .frame(width: UIScreen.main.bounds.width * 0.9)
                
                HStack(spacing: UIScreen.main.bounds.width / 15){
                    Image("business-circle")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width / 8, height: UIScreen.main.bounds.width / 8, alignment: .center)
                    Image("bind")
                    Image("TwT-circle")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width / 8, height: UIScreen.main.bounds.width / 8, alignment: .center)
                }
                .padding(.vertical, UIScreen.main.bounds.width / 20)
                
                Text("绑定账号：\(username)")
                    .foregroundColor(.init(red: 79/255, green: 88/255, blue: 107/255))
                    .padding(.bottom, UIScreen.main.bounds.width / 5)
                Button(action: {
                    isShowSignOut = true
                }) {
                    Text("解除绑定")
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height / 15, alignment: .center)
                        .background(Color.init(red: 79/255, green: 88/255, blue: 107/255))
                        .cornerRadius(UIScreen.main.bounds.height / 30)
                }
                Spacer()
            }
            // 解绑界面
            Color.black
                .ignoresSafeArea()
                .opacity(isShowSignOut ? 0.5 : 0)
                .animation(.easeIn)
            
            VStack(spacing: UIScreen.main.bounds.height / 40) {
                Text("解除办公网绑定后无法正常使用课表、GPA、校务专区功能。您是否确定解除绑定？").padding()
                    .foregroundColor(themeColor)
                    .font(.caption)
                
                HStack(spacing: UIScreen.main.bounds.width * 0.1){
                    
                    Button(action:{
                        isShowSignOut = false
                        ClassesManager.removeAll()
                        isLogin = false
                        /// 删除cookie
                        let cookieStorage = HTTPCookieStorage.shared
                        if let cookies = cookieStorage.cookies {
                            for cookie in cookies {
                                cookieStorage.deleteCookie(cookie)
                            }
                        }
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
    }
}
//MARK: 未绑定页面
fileprivate struct ClassesBindingLoginView: View {
    @State var isEnable: Bool = false
    @State var isError: Bool = false
    @State private var errorMessage: LocalizedStringKey = ""
    
    @Binding var isLogin: Bool
    
    @AppStorage(ClassesManager.usernameKey, store: Storage.defaults) private var username = ""
    @AppStorage(ClassesManager.passwordKey, store: Storage.defaults) private var password = ""
    @State private var captcha = ""
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var sharedMessage: SharedMessage
    
    @State private var captchaURL = "https://sso.tju.edu.cn/cas/images/kaptcha.jpg"
    
    var body: some View {
        VStack{
            NavigationBar()
            HStack{
                Text("办公网账号绑定")
                    .font(.custom("Avenir-Black", size: UIScreen.main.bounds.height / 35))
                    .foregroundColor(.init(red: 48/255, green: 60/255, blue: 102/255))
                Text("未绑定")
                    .font(.callout)
                    .foregroundColor(.init(red: 98/255, green: 103/255, blue: 122/255))
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.9)
            
            HStack(spacing: UIScreen.main.bounds.width / 15){
                Image("business-circle")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width / 8, height: UIScreen.main.bounds.width / 8, alignment: .center)
                Image("bind-gray")
                Image("TwT-circle")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width / 8, height: UIScreen.main.bounds.width / 8, alignment: .center)
            }
            .padding(.top, UIScreen.main.bounds.width / 10)
            
            
            Text("只有绑定了办公网后才能正常使用课表、GPA、校务专区功能。 若忘记密码请前往办公网找回。")
                .foregroundColor(.init(red: 98/255, green: 103/255, blue: 122/255))
                .font(.caption)
                .frame(width: UIScreen.main.bounds.width * 0.7)
                .padding()
            VStack(spacing: 25){
                TextField("学号", text: $username)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
                    .background(Color.init(red: 235/255, green: 238/255, blue: 243/255))
                    .cornerRadius(10)
                    .keyboardType(.numberPad)
                
                SecureField("密码", text: $password)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
                    .background(Color.init(red: 235/255, green: 238/255, blue: 243/255))
                    .cornerRadius(10)
                
                HStack {
                    TextField("验证码", text: $captcha)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height / 15, alignment: .center)
                        .background(Color.init(red: 235/255, green: 238/255, blue: 243/255))
                        .cornerRadius(10)
                        .keyboardType(.asciiCapable)
                    
                    Spacer()
                    
                    URLImage(url: URL(string: captchaURL)!) { (image) in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height / 15, alignment: .center)
                            .cornerRadius(10)
                            .padding(.trailing)
                    }
                    .onTapGesture(perform: refreshCaptcha)
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)
                
                Button(action: {
                    ClassesManager.login(captcha: captcha) { result in
                        switch result {
                            case .success:
                                isLogin = true
                                sharedMessage.isBindBs = true
                                mode.wrappedValue.dismiss()
                            case .failure(let error):
                                isError = true
                                errorMessage = error.localizedStringKey
                                password = ""
                                captcha = ""
                                refreshCaptcha()
                                isLogin = false
                        }
                        isEnable = true
                    }
                    isEnable = false
                }) {
                    Text("绑定")
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
                        .background(Color.init(red: 79/255, green: 88/255, blue: 107/255))
                        .cornerRadius(UIScreen.main.bounds.height / 30)
                }
                .disabled(username.isEmpty || password.isEmpty || captcha.isEmpty)
                
            }
            Spacer()
        }
        .onAppear{
            refreshCaptcha()
        }
        .alert(isPresented: $isError) {
            Alert(title: Text(errorMessage), dismissButton: .cancel())
        }
    }
    
    private func refreshCaptcha() {
        captchaURL = "https://sso.tju.edu.cn/cas/images/kaptcha.jpg?id=\(Double.random(in: 0...1))"
    }
}
