//
//  UpdateView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/3/25.
//

import SwiftUI

struct UpdateView: View {
    var updateTitle: String
    let FontColor = Color.init(red: 79/255, green: 88/255, blue: 107/255)
    var body: some View {
        ZStack {
            Image("UpdateIcon")
                .resizable()
                .scaledToFit()
                .frame(width: screen.width * 0.2)
            
            VStack(spacing: 15){
                Text("版本更新")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(FontColor)
                Text(updateTitle)
                    .font(.body)
                    .foregroundColor(FontColor)
                    .frame(width: screen.width * 0.5)
                Color.init(red: 172/255, green: 174/255, blue: 186/255)
                    .frame(width: screen.width * 0.5, height: 1, alignment: .center)
                Button(action: {}, label: {
                    Text("点击更新")
                        .font(.headline)
                        .foregroundColor(FontColor)
                })
                
            }
            
            VStack{
                HStack{
                    Spacer()
                    Button(action: {}, label: {
                        Image("shut")
                    })
                }
                Spacer()
            }.padding()
            
            
        }
        .frame(width: screen.width * 0.7, height: screen.height * 0.3, alignment: .center)
        .background(Color.white)
        .cornerRadius(30)
    }
}

struct UpdateView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            
            Color.black.ignoresSafeArea()
            UpdateView(updateTitle: "更新内容：\n1.修复已知问题，提升稳定性\n2.提升稳定性\n3.修复已知问题\n版本：V6.13.2→V4.0")
        }
       
    }
}
