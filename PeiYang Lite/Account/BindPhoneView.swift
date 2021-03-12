//
//  BindPhoneView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/8.
//

import SwiftUI

struct BindPhoneView: View {
    let themeColor = Color(red: 102/255, green: 106/255, blue: 125/255)
    let titleColor = Color.init(red: 98/255, green: 103/255, blue: 122/255)
    
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
    
    @EnvironmentObject var sharedMessage: SharedMessage
    
    @State var isShowSignOut = false
    
    
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
        ZStack {
            VStack(spacing: UIScreen.main.bounds.width / 15){
                HStack(alignment: .bottom){
                    Text("电话号码绑定")
                        .font(.custom("Avenir-Black", size: UIScreen.main.bounds.height / 35))
                        .foregroundColor(.init(red: 48/255, green: 60/255, blue: 102/255))
                    Text(sharedMessage.isBindPh ? "已绑定" : "未绑定")
                        .font(.callout)
                        .foregroundColor(.init(red: 98/255, green: 103/255, blue: 122/255))
                    Spacer()
                }
                .padding(.vertical, 30)
                .frame(width: UIScreen.main.bounds.width * 0.9)
                
                if(sharedMessage.isBindPh) {
                    VStack(spacing: 10){
                        Text("已绑定手机:")
                        Text(sharedMessage.Account.telephone!.prefix(3) + "****" + sharedMessage.Account.telephone!.suffix(4))
                    }
                    .padding(.vertical, UIScreen.main.bounds.height / 20)
                    .foregroundColor(.init(red: 79/255, green: 88/255, blue: 107/255))

                    Button(action:{
                        isShowSignOut = true
                    }){
                        Text("解除绑定")
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height / 15, alignment: .center)
                            .background(Color.init(red: 79/255, green: 88/255, blue: 107/255))
                            .cornerRadius(UIScreen.main.bounds.height / 30)
                    }
                    Spacer()
                } else {
                    PQTextField(placeholder: "手机号码", maxLength: 11,text: phoneNum, onEditing: { tf in
                            self.phoneNumIsEdit = true
                            self.phoneNum = tf.text ?? ""
                         }, onCommit:  { tf in
                            self.phoneNumIsEdit = false
                            self.phoneNum = tf.text ?? ""
                         })
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
                    .background(Color.init(red: 235/255, green: 238/255, blue: 243/255))
                    .cornerRadius(10)
                    .keyboardType(.numberPad)
                    
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
                            .cornerRadius(10)
                            .keyboardType(.numberPad)
                        
                        Spacer()
                        
                        Button(action: {
                            SupplyPhManager.CodePost(phone: phoneNum){ result in
                                switch result{
                                case .success(_):
                                    break
                                case .failure(_):
                                    break
                                }
                            }
                            
                            
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
                    
                    
                    Button(action: {
                        BindManager.BindPhPut(telephone: phoneNum, verifyCode: code) { result in
                            switch result {
                            case .success(let data):
                                AlertMessage = data.message
                                if(AlertMessage == "成功") {
                                    sharedMessage.Account.telephone = phoneNum
                                    sharedMessage.isBindPh = true
                                    self.mode.wrappedValue.dismiss()
                                } else {
                                    isShowAlert = true
                                }
                            case .failure(_):
                                isShowAlert = true
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
                    }) {
                        Text("绑定")
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
                            .background(Color.init(red: 79/255, green: 88/255, blue: 107/255))
                            .cornerRadius(UIScreen.main.bounds.height / 30)
                    }
                    Spacer()
                    AlertView(alertMessage: AlertMessage, isShow: $isShowAlert)
                }
            }
            
            Color.black.ignoresSafeArea()
                .opacity(isShowSignOut ? 0.5 : 0)
                .animation(.easeIn)

            VStack(spacing: UIScreen.main.bounds.height / 40) {
                Text("解除邮箱绑定后无法使用邮箱登陆微北洋。若本次登录为邮箱登陆则将退出登陆，需要您重新进行账号密码登陆。您是否确定解除绑定？").padding()
                    .foregroundColor(themeColor)
                    .font(.caption)

                HStack(spacing: UIScreen.main.bounds.width * 0.1){
        
                    Button(action:{
                        isShowSignOut = false
                        sharedMessage.isBindPh = false
                        sharedMessage.Account.telephone = nil
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
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            self.mode.wrappedValue.dismiss()
        }){
            Image("back-arrow")
                
        })
    }
}

struct BindPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        BindPhoneView()
    }
}
