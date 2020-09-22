//
//  ECardLoginView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/26/20.
//

import SwiftUI

struct ECardLoginView: View {
    @Environment(\.presentationMode) private var preMode
    
    @AppStorage(ECardManager.isLoginKey, store: Storage.defaults) private var isLogin = false
    
    @AppStorage(ECardManager.usernameKey, store: Storage.defaults) private var username = ""
    @AppStorage(ECardManager.passwordKey, store: Storage.defaults) private var password = ""
    @State private var captcha = ""
    @State private var captchaURL = "https://ecard.tju.edu.cn/epay/codeimage"
    
    @State private var isEnable = true
    
    @State private var isError = false
    @State private var errorMessage: LocalizedStringKey = ""
    
    var body: some View {
        Form {
            TextField(Localizable.ecardUsername.rawValue, text: $username)
                .keyboardType(.numberPad)
            
            SecureField(Localizable.ecardPassword.rawValue, text: $password)
            
            HStack {
                TextField(Localizable.captcha.rawValue, text: $captcha)
                .keyboardType(.asciiCapable)
                
                URLImage(
                    URL(string: captchaURL)!,
                    expireAfter: Date(timeIntervalSinceNow: 0),
                    placeholder: { _ in
                        LoadingView()
                    },
                    content: { imageProxy in
                        ColorInvertView {
                            imageProxy.image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 32)
                        }
                    }
                )
                .onTapGesture(perform: refreshCaptcha)
            }
            
            Section {
                Button {
                    login()
                    isEnable = false
                } label: {
                    Text(Localizable.login.rawValue)
                        .frame(maxWidth: .infinity)
                        
                }
                .disabled(!isEnable || username.isEmpty || password.isEmpty || captcha.isEmpty)
            }
        }
        .alert(isPresented: $isError) {
            Alert(title: Text(errorMessage), dismissButton: .cancel())
        }
    }
    
    func login() {
        ECardManager.loginPost(captcha: captcha) { result in
            switch result {
            case .success:
                isLogin = true
                preMode.wrappedValue.dismiss()
            case .failure(let error):
                isError = true
                errorMessage = error.localizedStringKey
                password = ""
                captcha = ""
                refreshCaptcha()
            }
            
            isEnable = true
        }
    }
    
    func refreshCaptcha() {
        captchaURL = "https://ecard.tju.edu.cn/epay/codeimage?id=\(Int.random(in: 0..<100))"
    }
}

struct ECardLoginView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ECardLoginView()
                .environment(\.colorScheme, .dark)
        }
    }
}
