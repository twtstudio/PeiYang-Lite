//
//  WLANLoginView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 8/7/20.
//

import SwiftUI

struct WLANLoginView: View {
    @Environment(\.presentationMode) private var preMode
    
    @AppStorage(WLANManager.isLoginKey, store: Storage.defaults) private var isLogin = false
    
    @AppStorage(WLANManager.usernameKey, store: Storage.defaults) private var username = ""
    @AppStorage(WLANManager.passwordKey, store: Storage.defaults) private var password = ""
    @State private var captcha = ""
    
//    @State private var captchaURL = "http://202.113.4.11:8800/site/captcha"
    @State private var isEnable = true
    
    @State private var isError = false
    @State private var errorMessage: LocalizedStringKey = ""
    
    var body: some View {
        Form {
            TextField(Localizable.wlanUsername.rawValue, text: $username)
                .keyboardType(.numberPad)
            
            SecureField(Localizable.wlanPassword.rawValue, text: $password)
            
//            HStack {
//                TextField(Localizable.captcha.rawValue, text: $captcha)
//                .keyboardType(.asciiCapable)
                
//                URLImage(
//                    URL(string: captchaURL)!,
//                    expireAfter: Date(timeIntervalSinceNow: 0),
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
//            }
            
            Section {
                Button {
                    login()
                    isEnable = false
                } label: {
                    Text(Localizable.login.rawValue)
                        .frame(maxWidth: .infinity)
                        
                }
                .disabled(!isEnable || username.isEmpty || password.isEmpty)
            }
        }
        .alert(isPresented: $isError) {
            Alert(title: Text(errorMessage), dismissButton: .cancel())
        }
    }
    
    func login() {
        WLANManager.loginPost(captcha: captcha) { result in
            switch result {
            case .success:
                isLogin = true
                preMode.wrappedValue.dismiss()
            case .failure(let error):
                isError = true
                errorMessage = error.localizedStringKey
                password = ""
                captcha = ""
//                refreshCaptcha()
            }
            
            isEnable = true
        }
    }
    
//    func refreshCaptcha() {
//        WLANManager.fetch(urlString: "http://202.113.4.11:8800/site/captcha?refresh=1") { result in
//            switch result {
//            case .success:
//                captchaURL = "http://202.113.4.11:8800/site/captcha?v=\(Double.random(in: 0...1))"
//            case .failure(let error):
//                isError = true
//                errorMessage = error.localizedStringKey
//            }
//        }
//    }
}

struct WLANLoginView_Previews: PreviewProvider {
    static var previews: some View {
        WLANLoginView()
    }
}
