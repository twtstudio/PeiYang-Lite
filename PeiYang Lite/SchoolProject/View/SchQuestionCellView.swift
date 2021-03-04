//
//  SchQuestionCellView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/23.
//

import SwiftUI

struct SchQuestionCellView: View {
    let titleColor = Color.init(red: 54/255, green: 60/255, blue: 84/255)
    let labelColor = Color.init(red: 145/255, green: 145/255, blue: 145/255)
    let bottomColor = Color.init(red: 177/255, green: 178/255, blue: 190/255)
    let settleColor = Color.init(red: 48/255, green: 60/255, blue: 102/255)
    
    var title: String
    var bodyText: String
    var likes: String
    var comments: String
    var date: String
    var imgName: String?
    
    var isSettled: Bool
    @State private var isLiked: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                    .lineLimit(1)
                    .foregroundColor(titleColor)
                    .font(.custom("Avenir-Heavy", size: 20))
                Spacer()
                if(isSettled) {
                    Text("·已解决")
                        .foregroundColor(settleColor)
                        .font(.caption)
                }
            }.padding()
            
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("#天外天")
                            .foregroundColor(labelColor)
                            .font(.caption)
                        Text("#学工部")
                            .foregroundColor(labelColor)
                            .font(.caption)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
                    Text(bodyText)
                        .frame(height: 40)
                        .lineLimit(2)
                        .foregroundColor(titleColor)
                        .font(.subheadline)
                        .padding(.horizontal)
                    Spacer()
                }
                if(imgName != nil){
                    Image("Text")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80, alignment: .center)
                        .cornerRadius(10)
                        .padding(.trailing)
                }
            }
            
            
            
            Spacer()
            
            HStack {
                Button(action: {}, label: {
                    Image("comment")
                })
                
                Text(comments)
                    .foregroundColor(bottomColor)
                    .font(.caption)
                
                Button(action: {isLiked.toggle()}, label: {
                    Image(isLiked ? "liked" : "like")
                })
                
                Text(likes)
                    .foregroundColor(bottomColor)
                    .font(.caption)
                Spacer()
                Text(date)
                    .foregroundColor(bottomColor)
                    .font(.caption)
            }
            .padding()
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 4.5, alignment: .center)
        .background(Color.white)
        .cornerRadius(20)
        
        
    }
}

struct CommentCellView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SchQuestionCellView(title: "微北洋课表是不是出问题了？", bodyText: "同学您好。IOS应用商店、安卓平台华为、小米、应用宝等应用商店均已上线新版微北洋，请更新后使", likes: "123", comments: "123", date: "2019-01-30   23：33", isSettled: true)
        }
        .edgesIgnoringSafeArea(.all)
        .frame(width: screen.width, height: screen.height)
        .background(Color.black)
        
    }
}
