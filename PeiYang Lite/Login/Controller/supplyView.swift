//
//  supplyView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/3.
//

import SwiftUI

struct supplyView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var telephone = ""
    @State private var verifyCode = ""
    @State private var email = ""
    @State private var codeIsEdit = false
    @State private var timer: Timer?
    @State private var countDown = 60
    @State private var isWrong = false
    @State private var phoneNumIsEdit = false
    static var token = ""
    
    @State private var AlertMessage: String = "网络出现问题"
    @State private var isShowAlert: Bool = false
    @State private var alertTimer: Timer?
    @State private var alertTime = 2
    
    @State private var isSupplied = false
    
    var isPhoneNum: Bool {
        if phoneNumIsEdit {
            return telephone.count == 11
        }
        return true
    }
    var isCode: Bool {
        if codeIsEdit {
            return verifyCode.count == 6
        }
        return true
    }
    var body: some View {
        VStack(spacing: 25.0){
            Text("请补全信息后登录")
                .font(.title2)
                .foregroundColor(Color.init(red: 98/255, green: 103/255, blue: 124/255))
            
            TextField("E-mail", text: $email)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
                .background(Color.init(red: 235/255, green: 238/255, blue: 243/255))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
            
            PQTextField(placeholder: "手机号", maxLength: 11,text: telephone, onEditing: { tf in
                    self.phoneNumIsEdit = true
                    self.telephone = tf.text ?? ""
                 }, onCommit:  { tf in
                    self.phoneNumIsEdit = false
                    self.telephone = tf.text ?? ""
                 }).padding()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 15, alignment: .center)
                .background(Color.init(red: 235/255, green: 238/255, blue: 243/255))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
                .keyboardType(.numberPad)
            if !isPhoneNum {
                Text("手机号码应该是11位数字")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            HStack() {
                PQTextField(placeholder: "请输入验证码", maxLength: 6, text: verifyCode, onEditing: { tf in
                   self.codeIsEdit = true
                   self.verifyCode = tf.text ?? ""
                }, onCommit: { tf in
                   self.codeIsEdit = false
                   self.verifyCode = tf.text ?? ""
                }).padding()
                    .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height / 15, alignment: .center)
                    .background(Color.init(red: 235/255, green: 238/255, blue: 243/255))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
                    .keyboardType(.asciiCapable)
                
                
                Spacer()
    
                Button(action: {
                    RegisterManager.CodePost(phone: telephone){ result in
                        switch result{
                        case .success(_):
                            break
                        case .failure(_):
                            break
                        }
                    }
                    
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (t) in
                        if self.countDown < 1 {
                            self.countDown = 61
                            t.invalidate()
                        }
                        self.countDown -= 1
                    })
                }, label: {
                    Text((countDown == 60) ?  "获取验证码" : "请\(countDown)s之后重试")
                        .foregroundColor((telephone.count != 11) ? .gray : .white)
                        .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height / 15, alignment: .center)
                        .background((telephone.count != 11) ? Color.init(red: 235/255, green: 238/255, blue: 243/255) : Color.init(red: 79/255, green: 88/255, blue: 107/255))
                        .cornerRadius(UIScreen.main.bounds.height / 30)
                        
                })
                .disabled(countDown != 60 || telephone.count != 11)
                
                
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height/15, alignment: .center)
            
            Button(action:{
                SupplyPhManager.SupplyPost(telephone: telephone, verifyCode: verifyCode, email: email){ result in
                    switch result{
                    case .success(let data):
                        AlertMessage = data.message
                        isSupplied = true
                    case .failure(_):
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
                
            }) {
                Text("登录")
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height/15, alignment: .center)
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(Color.init(red: 79/255, green: 88/255, blue: 107/255))
                    .cornerRadius(UIScreen.main.bounds.height/30)
            }
            .disabled(telephone == "" || verifyCode == "" || email == "")
            NavigationLink(
                destination: MainView(),
                isActive: $isSupplied,
                label: {})
            Spacer()
            AlertView(alertMessage: AlertMessage, isShow: $isShowAlert)
        }
        .background(
            Color.white
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .onTapGesture(perform: {
                    UIApplication.shared.endEditing()
                })
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            self.mode.wrappedValue.dismiss()
        }){
            Image("back-arrow")
                .foregroundColor(.black)
                .font(.title)
        })
    }
}

struct supplyView_Previews: PreviewProvider {
    static var previews: some View {
        supplyView()
    }
}
