//
//  BeginView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/1/23.
//

import SwiftUI
import Combine

struct BeginView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        NavigationView {
            VStack {
                HStack {// toppest text
                    VStack(alignment: .leading) {
                        Text("Hello,")
                        Text("微北洋 4.0")
                    }
                    .foregroundColor(Color.init(red: 98/255, green: 103/255, blue: 124/255))
                    .font(.custom("PingFangHK-Light", size: UIScreen.main.bounds.height / 20))
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                HStack(){
                    
                    NavigationLink(destination: KeywordLoginView(), isActive: self.$appState.leftHome) {
                        Text("登陆")
                            .foregroundColor(.white)
                            .font(.custom("", size: 20))
                    }
                    .isDetailLink(false)
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height / 15, alignment: .center)
                    .background(Color.init(red: 79/255, green: 88/255, blue: 107/255))
                    .cornerRadius(UIScreen.main.bounds.height / 30)
                    .padding()
                
                    ZStack {// the first button need a margin
                        Color.black
                            .frame(width: UIScreen.main.bounds.width * 0.3 + 2, height: UIScreen.main.bounds.height / 15 + 2, alignment: .center)
                            .cornerRadius(UIScreen.main.bounds.height / 30)
                        NavigationLink(destination: RegisterFirView(), isActive: self.$appState.rightHome) {
                            Text("注册")
                                .foregroundColor(.black)
                                .font(.custom("", size: 20))
                        }
                        .isDetailLink(false)
                        .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height / 15, alignment: .center)
                        .background(Color.white)
                        .cornerRadius(UIScreen.main.bounds.height / 30)
                        .padding()
                        
                    }
                    
                    
                    
                   
                }
                .padding(.bottom)
                
                
                Text("首次登陆微北洋4.0请使用天外天账号密码登陆，在登陆后绑定手机号码即可手机验证登陆。")
                    .font(.custom("", size: 14))
                    .foregroundColor(.gray)
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height / 15, alignment: .center)
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
//        .onDisappear(perform: {
//            let array: [String] = []
//            UserDefaults.standard.set(array, forKey: SharedMessage.studyRoomHistoryKey)
//        })
    }
}

class AppState: ObservableObject {
    @Published var leftHome: Bool = false
    @Published var rightHome: Bool = false
}

struct ChooseMethodView_Previews: PreviewProvider {
    static var previews: some View {
        BeginView()
            .environmentObject(User())
    }
}

