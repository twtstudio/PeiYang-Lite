//
//  FgFirstStepView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/1/24.
//

import SwiftUI

struct FgFirstStepView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var phoneNum: String = ""
    @State private var code: String = ""
    @State private var phoneNumIsEdit = false
    @State private var codeIsEdit = false
    @State private var waitingTimer: Timer?
    @State private var countDown = 60
    
    @State private var AlertMessage: String = "网络出现问题"
    @State private var isShowAlert: Bool = false
    @State private var alertTimer: Timer?
    @State private var alertTime = 2
    @State private var isVerifyCode = false
    
    var isPhoneNum: Bool {
        if phoneNumIsEdit {
            return phoneNum.count == 11
        }
        return true
    }
    var isCode: Bool {
        if codeIsEdit {
            return code.count == 6
        }
        return true
    }
    
    var body: some View {
        VStack(spacing: 25.0) {
            NavigationBar()

            Text("天外天账号密码找回")
                .font(.title2)
                .foregroundColor(Color.init(red: 98/255, green: 103/255, blue: 124/255))
            
            
            PQTextField(placeholder: "手机号", maxLength: 11,text: phoneNum, onEditing: { tf in
                    self.phoneNumIsEdit = true
                    self.phoneNum = tf.text ?? ""
                 }, onCommit:  { tf in
                    self.phoneNumIsEdit = false
                    self.phoneNum = tf.text ?? ""
                 })
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
                .background(Color.init(red: 235/255, green: 238/255, blue: 243/255))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
            
            if !isPhoneNum {
                Text("手机号码应该是11位数字")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            
            HStack {
                PQTextField(placeholder: "短信验证码", maxLength: 6,text: code, onEditing: { tf in
                        self.codeIsEdit = true
                        self.code = tf.text ?? ""
                     }, onCommit:  { tf in
                        self.codeIsEdit = false
                        self.code = tf.text ?? ""
                     })
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height / 15, alignment: .center)
                    .background(Color.init(red: 235/255, green: 238/255, blue: 243/255))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
                
                Spacer()
                
                Button(action: {
                    ForgetManager.CodePost(phone: phoneNum) { result in
                        switch result {
                        case .success(let data):
                            AlertMessage = data.message
                        case .failure(_): break
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
                    
                    waitingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (time) in
                        if self.countDown < 1 {
                            self.countDown = 61
                            time.invalidate()
                        }
                        self.countDown -= 1
                    })
                }, label: {
                    Text((countDown == 60) ?  "获取验证码" : "请\(countDown)s之后重试")
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height / 15, alignment: .center)
                        .background(Color.init(red: 79/255, green: 88/255, blue: 107/255))
                        .cornerRadius(UIScreen.main.bounds.height / 30)
                        .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 1)
                        
                })
                .disabled(countDown != 60 || phoneNum.count != 11)
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
            if !isCode {
                 Text("请输入正确的验证码(6位数字)")
                     .font(.headline)
                     .foregroundColor(.red)
                     .frame(alignment: .top)
             }
            NavigationLink(
                destination: FgSecondStepView(),
                isActive: $isVerifyCode,
                label: {
                    // 空
                })
            Spacer()
            
            AlertView(alertMessage: AlertMessage, isShow: $isShowAlert)
            
            HStack{
                Spacer()
                Button(action: {
                    ForgetManager.VertifyCodePost(phone: phoneNum, code: code) { result in
                        switch result {
                        case .success(let data):
                            AlertMessage = data.message
                            if (AlertMessage == "成功"){
                                isVerifyCode = true
                            }
                        case .failure(_): break
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
            
    }

}

struct FirstStepView_Previews: PreviewProvider {
    static var previews: some View {
        FgFirstStepView()
    }
}
