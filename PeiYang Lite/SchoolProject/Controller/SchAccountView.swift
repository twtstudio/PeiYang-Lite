//
//  SchAccountView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/23.
//

import SwiftUI

struct SchAccountView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var sharedMessage: SharedMessage
    
    
    var body: some View {
                    
        ZStack {
            SchBackGround()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: UIScreen.main.bounds.height / 40) {
                    VStack (spacing: UIScreen.main.bounds.height / 55){
                        Image("Text")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.3, alignment: .center)
                            .cornerRadius(UIScreen.main.bounds.width * 0.15)
                        
                        Text(/*sharedMessage.Account.nickname*/"PhoenixDai")
                            .font(.custom("Avenir-Heavy", size: 20))
                        Text(/*sharedMessage.Account.userNumber*/"3019244328")
                    }
                        .padding(.top, UIScreen.main.bounds.height / 15)
                        .foregroundColor(.white)
                    
                    HStack(spacing: UIScreen.main.bounds.width / 5){
                        SchHorizontalView(imgTitle: "ques", title: "我的提问")
                        SchHorizontalView(imgTitle: "favour", title: "我的收藏")
                    }// Horizontal 3 icons
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.18, alignment: .center)
                        .background(Color.white)
                        .cornerRadius(30)
                    
                    SchQuestionCellView(title: "微北洋课表是不是出问题了？", bodyText: "同学您好。IOS应用商店、安卓平台华为、小米、应用宝等应用商店均已上线新版微北洋，请更新后使", likes: "123", comments: "123", date: "2019-01-30   23：33", isSettled: true)
                    SchQuestionCellView(title: "微北洋课表是不是出问题了？", bodyText: "同学您好。IOS应用商店、安卓平台华为、小米、应用宝等应用商店均已上线新版微北洋，请更新后使", likes: "123", comments: "123", date: "2019-01-30   23：33", isSettled: false)
                    SchQuestionCellView(title: "微北洋课表是不是出问题了？", bodyText: "同学您好。IOS应用商店、安卓平台华为、小米、应用宝等应用商店均已上线新版微北洋，请更新后使", likes: "123", comments: "123", date: "2019-01-30   23：33", imgName: "Text", isSettled: true)
                }
                .frame(width: UIScreen.main.bounds.width)
            }
            .padding(.top, 30)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
            
            VStack {
                HStack {
                    Button(action : {
                        self.mode.wrappedValue.dismiss()
                    }){
                        Image("back-arrow-white")
                    }
                    Spacer()
                    Text("个人中心").font(.headline).foregroundColor(.white)
                    Spacer()
                    
                    Image("back-arrow-white").opacity(0)
                }.padding()
                .padding(.top, 30)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 10, alignment: .center)
                .background(Color.init(red: 67/255, green: 70/255, blue: 80/255))
                .shadow(color: Color.init(red: 67/255, green: 70/255, blue: 80/255).opacity(0.5), radius: 10, x: 0, y: 10)
                .ignoresSafeArea()
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
            
        }
        .navigationBarHidden(true)
    }
}

struct SchAccountView_Previews: PreviewProvider {
    static var previews: some View {
        SchAccountView()
    }
}


struct SchBackGround: View {
    var body: some View {
        VStack {
            
            Color.init(red: 67/255, green: 70/255, blue: 80/255)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.45)
            Color.init(red: 247/255, green: 247/255, blue: 248/255)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.55)
        }
        .ignoresSafeArea()
    }
}

struct SchHorizontalView: View {
    var imgTitle: String
    var title: String
    var body: some View {
        VStack {
            Image(imgTitle)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 9)
            Text(title)
                .foregroundColor(.init(red: 105/255, green: 111/255, blue: 133/255))
        }
    }
}
