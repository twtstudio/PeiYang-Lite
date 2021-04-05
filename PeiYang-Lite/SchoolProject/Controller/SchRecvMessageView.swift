//
//  SchRecvMessageView.swift
//  PeiYang-Lite
//
//  Created by Zrzz on 2021/4/5.
//

import SwiftUI

struct SchRecvMessageView: View {
    var body: some View {
        VStack {
            NavigationBar(center: {
                Text("校务消息")
                    .font(.title2)
                    .foregroundColor(Color(#colorLiteral(red: 0.1882352941, green: 0.2352941176, blue: 0.4, alpha: 1)))
            })
            
            
            HStack {
                
            }
            Spacer()
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
    }
}

fileprivate struct ThumbedCellView: View {
    var message: SchMessageModel
    
    var body: some View {
        VStack {
            HStack {
                Image("Text")
                    .resizable()
                    .frame(width: 30, height: 30)
                Text("")
            }
        }
    }
}

struct SchRecvMessageView_Previews: PreviewProvider {
    static var previews: some View {
        SchRecvMessageView()
    }
}

struct SchRecvMessageViewCell_Previews: PreviewProvider {
    static let model = SchMessageModel(id: 0, type: 0, visible: 1, createdAt: "2021-03-10T12:50:28.000000Z", updatedAt: nil,
                                       contain: SchMessageContain(id: 0, contain: "牛逼", userID: 0, adminID: 0, likes: 999, createdAt: "2021-03-10T12:50:28.000000Z", updatedAt: nil, username: "这种重中之重", adminName: "哈啊哈哈哈哈", isLiked: true, score: 4, commit: "可以的"),
                                       question: SchQuestionModel(id: 0, name: "微北洋真不戳", content: "微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳", userID: nil, solved: 1, noCommit: 0, likes: 999, createdAt: "2021-03-10T12:50:28.000000Z", updatedAt: nil, username: "真不戳", msgCount: 999, urlList: ["https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png","https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png"], thumbImg: nil, tags: [SchTagModel(id: 0, name: "天津大学", description: nil, tagDescription: nil, isSelected: nil, children: nil)], thumbUrlList: ["https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png","https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png"], isLiked: true, isOwner: true))
    static var previews: some View {
        VStack {
            ThumbedCellView(message: model)
        }
    }
}
