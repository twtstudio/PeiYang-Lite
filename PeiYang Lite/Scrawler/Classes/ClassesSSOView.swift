//
//  ClassesSSOView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/7/20.
//

import SwiftUI
import URLImage

struct ClassesSSOView: View {
    @Environment(\.presentationMode) private var preMode
    
    @AppStorage(ClassesManager.isLoginKey, store: Storage.defaults) private var isLogin = false
    
    @AppStorage(ClassesManager.usernameKey, store: Storage.defaults) private var username = ""
    @AppStorage(ClassesManager.passwordKey, store: Storage.defaults) private var password = ""
    @State private var captcha = ""
    
    @State private var captchaURL = "https://sso.tju.edu.cn/cas/images/kaptcha.jpg"
    @State private var isEnable = true
    
    @State private var isError = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        Form {
            TextField(Localizable.classesUsername.rawValue, text: $username)
                .keyboardType(.numberPad)
            
            SecureField(Localizable.classesPassword.rawValue, text: $password)
            
            HStack {
                TextField(Localizable.captcha.rawValue, text: $captcha)
                .keyboardType(.asciiCapable)
                
                URLImage(url: URL(string: captchaURL)!) { (image)in
                    ColorInvertView {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 32)
                    }
                }
//                URLImage(
//                    URL(string: captchaURL)!,
//                    placeholder: { _ in
//                        LoadingView()
//                    },
//                    content: { imageProxy in
//                        ColorInvertView {
//                            imageProxy.image
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(height: 32)
//                        }
//                    }
//                )
//                .onTapGesture(perform: refreshCaptcha)
            }
            
            Button(Localizable.login.rawValue) {
                login()
                isEnable = false
            }
            .disabled(!isEnable || username.isEmpty || password.isEmpty || captcha.isEmpty)
        }
        
        .alert(isPresented: $isError) {
            Alert(title: Text(errorMessage), dismissButton: .cancel())
        }
    }
    
    func login() {
        ClassesManager.login(captcha: captcha) { result in
            switch result {
            case .success:
                isLogin = true
                preMode.wrappedValue.dismiss()
            case .failure(let error):
                isError = true
                errorMessage = error.localizedDescription
                password = ""
                captcha = ""
                refreshCaptcha()
            }
            
            isEnable = true
        }
    }
    
    func refreshCaptcha() {
        captchaURL = "https://sso.tju.edu.cn/cas/images/kaptcha.jpg?id=\(Double.random(in: 0...1))"
    }
}

struct ColorInvertView<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    let content: () -> Content

    var body: some View {
        colorScheme == .dark
        ? AnyView(
            content()
                .colorInvert()
        )
        : AnyView(
            content()
        )
    }
}

struct ClassesSSOView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ClassesSSOView()
                .environment(\.colorScheme, .dark)
        }
    }
}
