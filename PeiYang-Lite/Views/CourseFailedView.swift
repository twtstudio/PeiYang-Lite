//
//  CourseFailedView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/3/24.
//

import SwiftUI
import URLImage

struct CourseFailedView: View {
    @EnvironmentObject var sharedMessage: SharedMessage
    let foreColor = Color.init(red: 79/255, green: 88/255, blue: 107/255)
    @AppStorage(ClassesManager.usernameKey, store: Storage.defaults) private var storageUserName = ""
    @AppStorage(ClassesManager.passwordKey, store: Storage.defaults) private var storagePassword = ""
    @AppStorage(ClassesManager.isLoginKey, store: Storage.defaults) private var isLogin = false
    @State var isEnable: Bool = true
    @State var isError: Bool = false
    @State private var errorMessage: LocalizedStringKey = ""
    @State private var captcha: String = ""
    @State private var captchaURL = "https://sso.tju.edu.cn/cas/images/kaptcha.jpg"
    var body: some View {
        VStack(spacing: 20.0){
            
            HStack{
                Image("warning")
                Text("出错了！")
                    .font(.title3)
                    .fontWeight(.heavy)
                    .foregroundColor(foreColor)
            }
            
            Text("办公网数据已过期，请重新登录")
                .foregroundColor(foreColor)
                .font(.caption)
            
            CourseFailedTextField(inputMessage: $storageUserName, title: "用户名", cellWidth: screen.width * 0.7)
            
            CourseFailedSecureField(inputMessage: $storagePassword, title: "密码", cellWidth: screen.width * 0.7)
            
            HStack {
                CourseFailedTextField(inputMessage: $captcha, title: "验证码", cellWidth: screen.width * 0.4)
                
                Spacer()
                
                URLImage(url: URL(string: captchaURL)!,
                         empty: {
                            LoadingView()
                         },
                         inProgress: { _ in
                            LoadingView()
                         }) { (err, retry) in
                    Button("Retry", action: retry)
                } content: { (image) in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height / 15, alignment: .center)
                        .cornerRadius(10)
                        .padding(.trailing)
                }
                .onTapGesture(perform: refreshCaptcha)
            }
            .frame(width: screen.width * 0.7, height: screen.height * 0.06)
            
            Button(action: {
                isEnable = false
                ClassesManager.ssoPost(captcha: captcha) { result in
                    switch result {
                        case .success:
                            isLogin = true
                            sharedMessage.isBindBs = true
                        case .failure(let error):
                            log(error)
                            isError = true
                            errorMessage = error.localizedStringKey
                            captcha = ""
                            refreshCaptcha()
                            isLogin = false
                    }
                    isEnable = true
                }
            }, label: {
                Text("登录")
                    .foregroundColor(.white)
                    .frame(width: screen.width * 0.5, height: screen.height / 20, alignment: .center)
                    .background(Color.init(red: 79/255, green: 88/255, blue: 107/255))
                    .cornerRadius(UIScreen.main.bounds.height / 30)
            })
            .disabled(storagePassword == "" || storageUserName == "" || captcha == "")
            
        }.padding(30)
        .frame(height: screen.height * 0.5)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0.0, y: 0.0)
        .alert(isPresented: $isError) {
            Alert(title: Text(errorMessage), dismissButton: .cancel())
        }
        .opacity(isLogin ? 0 : 1)
        .animation(.easeInOut(duration: 0.5))
    }
    private func refreshCaptcha() {
        captchaURL = "https://sso.tju.edu.cn/cas/images/kaptcha.jpg?id=\(Double.random(in: 0...1))"
    }
}

struct CourseFailedView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            CourseFailedView()
                .environmentObject(SharedMessage())
        }
       
    }
}

fileprivate struct CourseFailedTextField: View {
    @Binding var inputMessage: String
    var title: String
    var cellWidth: CGFloat
    var body: some View {
        TextField(title, text: $inputMessage).padding().foregroundColor(.black)
            .frame(width: cellWidth, height: screen.height * 0.06, alignment: .center)
            .background(Color.init(red: 235/255, green: 238/255, blue: 243/255))
            .cornerRadius(10)
    }
}

fileprivate struct CourseFailedSecureField: View {
    @Binding var inputMessage: String
    var title: String
    var cellWidth: CGFloat
    var body: some View {
        SecureField(title, text: $inputMessage).padding().foregroundColor(.black)
            .frame(width: cellWidth, height: screen.height * 0.06, alignment: .center)
            .background(Color.init(red: 235/255, green: 238/255, blue: 243/255))
            .cornerRadius(10)
    }
}
