//
//  RegisterSecView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/1/29.
//

import SwiftUI

struct RegisterSecView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    let fieldColor = Color.init(red: 235/255, green: 238/255, blue: 243/255)
    
    @State var phoneNumber = ""
    @State var idNumber = ""
    @State var e_mailNum = ""
    @State var code: String = ""
    
    @EnvironmentObject var user: User
    
    @State private var codeIsEdit = false
    @State private var timer: Timer?
    @State private var countDown = 60
    @State private var isWrong = false
    @State private var phoneNumIsEdit = false
    @State private var idIsEdit = false
    @State private var isJumpToThir = false
    
    // Alert var
        @State private var AlertMessage: String = "网络出现问题"
        @State private var isShowAlert: Bool = false
        @State private var alertTimer: Timer?
        @State private var alertTime = 2
    
    var isPhoneNum: Bool {
        if phoneNumIsEdit {
            return phoneNumber.count == 11
        }
        return true
    }
    var isIdNum: Bool {
        if idIsEdit {
            return idNumber.count == 18
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
        VStack(spacing:25 ){
            Text("新用户注册")
                .font(.title2)
                .foregroundColor(Color.init(red: 98/255, green: 103/255, blue: 124/255))
            PQTextField(placeholder: "身份证号", maxLength: 18,text: idNumber, onEditing: { tf in
                    self.idIsEdit = true
                    self.idNumber = tf.text ?? ""
                 }, onCommit:  { tf in
                    self.idIsEdit = false
                    self.idNumber = tf.text ?? ""
                 }).padding()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
                .background(fieldColor)
                .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
            .keyboardType(.numberPad)
            if !isIdNum {
                Text("无效的身份证号")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            
            TextField("E-Mail", text: $e_mailNum)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
                .background(Color.init(red: 235/255, green: 238/255, blue: 243/255))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
                .keyboardType(.emailAddress)
            
            
             PQTextField(placeholder: "电话号码", maxLength: 11,text: phoneNumber, onEditing: { tf in
                     self.phoneNumIsEdit = true
                     self.phoneNumber = tf.text ?? ""
                  }, onCommit:  { tf in
                     self.phoneNumIsEdit = false
                     self.phoneNumber = tf.text ?? ""
                  }).padding()
                 .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
                 .background(fieldColor)
                 .cornerRadius(15)
             .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
                 .keyboardType(.numberPad)
            
            
            
            if !isPhoneNum {
                Text("手机号码应该是11位数字")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            
            VStack{
                HStack() {
                    PQTextField(placeholder: "短信验证码", maxLength: 6, text: code, onEditing: { tf in
                       self.codeIsEdit = true
                       self.code = tf.text ?? ""
                    }, onCommit: { tf in
                       self.codeIsEdit = false
                       self.code = tf.text ?? ""
                    }).padding()
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height / 15, alignment: .center)
                        .background(fieldColor)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
                        .keyboardType(.asciiCapable)
                    
                    
                    Spacer()
        
                    Button(action: {
                        RgRegisterManager.CodePost(phone: phoneNumber) {
                            result in
                            switch result {
                            case .success(let data):
                                AlertMessage = data.message
                            case .failure(_):
                                print("wrong")
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
                        
                        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (t) in
                            if self.countDown < 1 {
                                self.countDown = 61
                                t.invalidate()
                            }
                            self.countDown -= 1
                        })
                    }, label: {
                        Text((countDown == 60) ?  "获取验证码" : "请\(countDown)s之后重试")
                            .foregroundColor((phoneNumber.count != 11) ? .gray : .white)
                            .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height / 15, alignment: .center)
                            .background((phoneNumber.count != 11) ? Color.init(red: 235/255, green: 238/255, blue: 243/255) : Color.init(red: 79/255, green: 88/255, blue: 107/255))
                            .cornerRadius(UIScreen.main.bounds.height / 30)
                            
                    })
                    .disabled(countDown != 60 || phoneNumber.count != 11)
                    
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height/15, alignment: .center)
                
                if !isCode {
                     Text("请输入正确的验证码(6位数字)")
                         .font(.caption)
                         .foregroundColor(.red)
                         .frame(alignment: .top)
                 }
                
                Spacer()
                AlertView(alertMessage: AlertMessage, isShow: $isShowAlert)
                
                HStack{
                    Button(action:{
                        self.mode.wrappedValue.dismiss()
                    }){
                        Image("left-arrow")
                            
                    }
                    Spacer()
                    NavigationLink(
                        destination: RegisterThiView(), isActive: $isJumpToThir) {EmptyView()}
                    Button(action:{
                        RgRegisterManager.SecondPost(idNumber: idNumber, email: e_mailNum, phone: phoneNumber) { result in
                            switch result {
                            case .success(let data):
                                AlertMessage = data.message
                                if (AlertMessage == "成功") {
                                    isJumpToThir = true
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
                    }){
                        Image("right-arrow")
                    }
                    .disabled(phoneNumber == "" || idNumber == "" || e_mailNum == "" || code == "")
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
            }
        }
        .background(
            Color.white
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .onTapGesture(perform: {
                    UIApplication.shared.endEditing()
                })
        )
        .onDisappear{
            user.email = e_mailNum
            user.idNumber = idNumber
            user.phone = phoneNumber
            user.verifyCode = code
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct RegisterSecView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterSecView()
            .environmentObject(User())
    }
}
