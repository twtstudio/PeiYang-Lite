//
//  SchQuestionDetailView.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2021/3/11.
//

import SwiftUI

struct SchQuestionDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var question: SchQuestionModel
    @State var answer: SchCommentModel?
    @State var comments: [SchCommentModel] = []
    
    var body: some View {
        VStack {
            // 头部伪导航栏
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                }
                
                Spacer()
                
                if question.isOwner ?? false {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "trash")
                    })
                }
            }
            .font(.title)
            .foregroundColor(Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)))
            .padding()
            
            SchQuestionDetailHeaderView(question: $question)
            
            LazyVStack {
                ForEach(comments.indices, id: \.self) { i in
                    SchQuestionCommentCellView(comment: comments[i])
                }
            }
            Spacer()
            
            HStack {
                
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            SchCommentManager.commentGet(id: question.id ?? 0) { (result) in
                switch result {
                case .success(let comments):
                    self.comments = comments
                case .failure(let err):
                    print("获取评论失败", err)
                }
            }
        }
        .background(
            Color(#colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1))
                .ignoresSafeArea()
                .frame(width: screen.width, height: screen.height)
        )
        .navigationBarHidden(true)
        
    }
}

struct SchQuestionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SchQuestionDetailView(question: .constant(
            SchQuestionModel(id: 0, name: "微北洋真不戳", content: "微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳", userID: nil, solved: 1, noCommit: 0, likes: 999, createdAt: "2021-03-10T12:50:28.000000Z", updatedAt: nil, username: "真不戳", msgCount: 999, urlList: ["https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png","https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png"], thumbImg: nil, tags: [SchTagModel(id: 0, name: "天津大学", description: nil, tagDescription: nil, isSelected: nil, children: nil)], thumbUrlList: ["https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png","https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png"], isLiked: true, isOwner: true)
        ))
    }
}
