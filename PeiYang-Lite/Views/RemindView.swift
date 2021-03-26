//
//  RemindView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/4.
//

import SwiftUI

struct RemindView: View {
    var remindMessage: String
    @Binding var isMessageShow: Bool
    var type: Int
    var body: some View {
       if(type == 1) {
            VStack {
                HStack{
                    Spacer()
                    Button(action: {
                        isMessageShow = false;
                    }){
                        Image("shut")
                    }
                }
                .frame(width: screen.width * 0.75)
                Text(remindMessage)
                    .foregroundColor(Color.init(red: 79/255, green: 88/255, blue: 107/255))
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            .frame(width: screen.width * 0.8, height: screen.height / 6, alignment: .center)
            .background(Color.init(red: 242/255, green: 242/255, blue: 242/255))
            .cornerRadius(15)
            .shadow(radius: 10)
            .offset(y: isMessageShow ? 0 : 1000)
            .animation(.easeInOut)
       
       }
    }
}
