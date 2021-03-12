//
//  SchQuestionCellView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/23.
//

import SwiftUI
import URLImage

struct SchQuestionCellView: View {
    let titleColor = Color.init(red: 54/255, green: 60/255, blue: 84/255)
    let labelColor = Color.init(red: 145/255, green: 145/255, blue: 145/255)
    let bottomColor = Color.init(red: 177/255, green: 178/255, blue: 190/255)
    let settleColor = Color.init(red: 48/255, green: 60/255, blue: 102/255)
    
    var question: SchQuestionModel
    
    private var questionTime: String {
        get {
            let day = question.createdAt?[0..<10] ?? ""
            let time = question.createdAt?[11..<16] ?? ""
            return day + " " + time
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(question.name ?? "")
                    .lineLimit(1)
                    .foregroundColor(titleColor)
                    .font(.custom("Avenir-Heavy", size: 20))
                Spacer()
                if (question.solved ?? 0) == 1 {
                    Text("·已解决")
                        .foregroundColor(settleColor)
                        .font(.caption)
                }
            }.padding()
            
            GeometryReader { g in
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            ForEach(0..<(question.tags?.count ?? 0), id: \.self) { i in
                                Text("#" + (question.tags?[i].name ?? ""))
                                    .foregroundColor(labelColor)
                                    .font(.caption)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                        
                        Text(question.content ?? "")
                            .frame(height: 40)
                            .lineLimit(2)
                            .foregroundColor(titleColor)
                            .font(.subheadline)
                            .padding(.horizontal)
                    }
                    Spacer()
                    if question.thumbImg != nil {
                        URLImage(url: URL(string: question.thumbImg!)!) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: g.size.width * 0.3, height: g.size.height)
                                .cornerRadius(10)
                        }
                        .padding(.trailing)
                    }
                }
            }
            
            Spacer()
            
            HStack {
                Image("sch-comment")
                Text((question.msgCount ?? 0).description)
                    .foregroundColor(bottomColor)
                    .font(.caption)
                Image((question.isLiked ?? false) ? "sch-liked" : "sch-like")
                Text((question.likes ?? 0).description)
                    .foregroundColor(bottomColor)
                    .font(.caption)
                Spacer()
                Text(questionTime)
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
            SchQuestionCellView(question: SchQuestionModel(id: 0, name: "哈哈蛤", content: "等哈u的哈", userID: nil, solved: 1, noCommit: nil, likes: 1, createdAt: "2021-03-10T12:50:28.000000Z", updatedAt: nil, username: "hahaha", msgCount: 500, urlList: nil, thumbImg: "https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png", tags: [SchTagModel(id: 1, name: "天津大学", description: nil, tagDescription: nil, isSelected: nil, children: nil)], thumbUrlList: nil, isLiked: true, isOwner: true))
        }
        .edgesIgnoringSafeArea(.all)
        .frame(width: screen.width, height: screen.height)
        .background(Color.black)
        
    }
}
