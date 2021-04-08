//
//  AccountMessageView.swift
//  PeiYang-Lite
//
//  Created by Zr埋 on 2021/4/7.
//

import SwiftUI

struct AccountMessageView: View {
    var body: some View {
        VStack {
            NavigationBar(center: {
                Text("消息")
                    .font(.title2)
                    .foregroundColor(Color(#colorLiteral(red: 0.1411764706, green: 0.168627451, blue: 0.2705882353, alpha: 1)))
            })
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(0..<10, id: \.self) { i in
                        MessageCellView()
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                    }
                }
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
        .background(Color(#colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.9725490196, alpha: 1)).edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.bottom)
        
    }
}

fileprivate struct MessageCellView: View {
//    @State var message: SchMessageModel
    
    var body: some View {
        VStack {
            Text("一个通知")
                .font(.title3)
                .bold()
                .foregroundColor(Color(#colorLiteral(red: 0.2117647059, green: 0.2352941176, blue: 0.3294117647, alpha: 1)))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)
            
            Text("微北洋针不戳微北洋针不戳微北洋针不戳微北洋针不戳微北洋针不戳微北洋针不戳微北洋针不戳微北洋针不戳微北洋针不戳微北洋针不戳微北洋针不戳微北洋针不戳微北洋针不戳微北洋针不戳微北洋针不戳微北洋针不戳微北洋针不戳微北洋针不戳")
                .lineLimit(3)
                .foregroundColor(Color(#colorLiteral(red: 0.2117647059, green: 0.2352941176, blue: 0.3294117647, alpha: 1)))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Image("Text")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .cornerRadius(10)
                
                Text("天外天")
                    .foregroundColor(Color(#colorLiteral(red: 0.262745098, green: 0.2745098039, blue: 0.3137254902, alpha: 1)))
                Spacer()
                Text("2021-2-12    21:28")
                    .foregroundColor(Color(#colorLiteral(red: 0.6941176471, green: 0.6980392157, blue: 0.7450980392, alpha: 1)))
                    .font(.footnote)
            }
        }
        .padding()
        .background(Color.white)
    }
}

struct AccountMessageView_Previews: PreviewProvider {
    static var previews: some View {
        AccountMessageView()
    }
}
