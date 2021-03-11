//
//  AcChangeNameView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/3/10.
//

import SwiftUI

struct AcChangeNameView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var changeName: String = ""
    @EnvironmentObject var sharedMessage: SharedMessage
    // Alert var
        @State private var AlertMessage: String = "网络出现问题"
        @State private var isShowAlert: Bool = false
        @State private var alertTimer: Timer?
        @State private var alertTime = 2
    var body: some View {
        VStack{
            HStack {
                TextField("", text: $changeName)
                    .foregroundColor(.init(red: 98/255, green: 103/255, blue: 124/255))
                Button(action: {
                    BindManager.ChangeName(username: changeName) { result in
                        switch result{
                        case .success(let data):
                            AlertMessage = data.message
                            if(AlertMessage == "成功"){
                                sharedMessage.Account.nickname = changeName
                                isShowAlert = true
                            } else {
                                changeName = ""
                                isShowAlert = true
                            }
                        case .failure(_):
                            break
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
                }, label: {
                    Text("保存")
                        .foregroundColor(.init(red: 98/255, green: 103/255, blue: 124/255))
                        .fontWeight(.heavy)
                })
            }
            .padding(.top)
            .frame(width: screen.width * 0.9, height: screen.height / 23, alignment: .center)
            Color.init(red: 48/255, green: 60/255, blue: 102/255)
                .frame(width: screen.width * 0.9, height: 1, alignment: .center)
            Spacer()
            AlertView(alertMessage: AlertMessage, isShow: $isShowAlert)
        }
        .navigationBarTitle("更改名字", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action:{
            self.mode.wrappedValue.dismiss()
        }){
            Image("back-arrow-black")
        })
    }
}

struct AcChangeNameView_Previews: PreviewProvider {
    static var previews: some View {
        AcChangeNameView()
    }
}

