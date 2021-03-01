//
//  ChMeToFindView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/1/24.
//

import SwiftUI

struct ChMeToFindView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var isMessageShow = false
    var body: some View {
        ZStack {
            VStack {
                
                Text("天外天账号密码找回")
                    .font(.title2)
                    .foregroundColor(Color.init(red: 98/255, green: 103/255, blue: 124/255))
                
                
                VStack(){
                
                    NavigationLink(destination: FirstStepView()) {
                        Text("账号已绑定手机号")
                            .foregroundColor(.white)
                            .font(.custom("", size: 20))
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height / 15, alignment: .center)
                    .background(Color.init(red: 79/255, green: 88/255, blue: 107/255))
                    .cornerRadius(UIScreen.main.bounds.height / 30)
                    .padding()
                    
                    ZStack {
                        Color.black
                            .frame(width: UIScreen.main.bounds.width * 0.6 + 2, height: UIScreen.main.bounds.height / 15 + 2, alignment: .center)
                            .cornerRadius(UIScreen.main.bounds.height / 30)
                        Button(action: {
                            isMessageShow = true;
                        }) {
                            Text("账号未绑定手机号")
                                .foregroundColor(.black)
                                .font(.custom("", size: 20))
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height / 15, alignment: .center)
                        .background(Color.white)
                        .cornerRadius(UIScreen.main.bounds.height / 30)
                        .padding()
                        
                    }
                    
                }

            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action : {
                self.mode.wrappedValue.dismiss()
            }){
                Image("back-arrow")
                    .foregroundColor(.black)
                    .font(.title)
            })
            
            Color.black.ignoresSafeArea()
                .opacity(isMessageShow ? 0.5 : 0)
                .animation(.easeIn)
            
            RemindView(remindMessage: "您好！请联系辅导员进行密码重置！若有疑问，请加入天外天用户社区qq群：\n 1群群号：738068756；\n 2群群号：738064793；", isMessageShow: $isMessageShow, type: 1)
        }
    }
}

struct ChMeToFindView_Previews: PreviewProvider {
    static var previews: some View {
        ChMeToFindView()
    }
}


