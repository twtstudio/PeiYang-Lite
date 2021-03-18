//
//  SchQuestionCommentCellView.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2021/3/12.
//

import SwiftUI

struct SchQuestionCommentCellView: View {
    @State var comment: SchCommentModel
    
    private var commentTime: String {
        get {
            let day = comment.createdAt?[0..<10] ?? ""
            let time = comment.createdAt?[11..<16] ?? ""
            return day + "  " + time
        }
    }
    
    var body: some View {
        VStack {
            GeometryReader { g in
                HStack {
                    Image("Text")
                        .resizable()
                        .frame(width: g.size.height, height: g.size.height)
                        .cornerRadius(g.size.height / 2)
                    Text(comment.username ?? "")
                    Spacer()
                    Text(commentTime)
                }
                .frame(height: g.size.height)
            }
            .frame(height: screen.height * 0.05)
            
            Text(comment.contain ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            HStack {
                Spacer()
                Button(action: {
                    SchCommentManager.likeOrDislikeComment(commentId: comment.id ?? 0, like: !(comment.isLiked ?? false)) { (result) in
                        switch result {
                        case .success(_):
                            comment.isLiked?.toggle()
                            if comment.isLiked ?? false {
                                comment.likes = (comment.likes ?? 0) + 1
                            } else {
                                comment.likes = (comment.likes ?? 0) - 1
                            }
                        case .failure(let err):
                            log("评论点赞失败", err)
                        }
                    }
                }, label: {
                    Image(comment.isLiked ?? false ? "sch-like-fill" : "sch-like")
                })
                Text((comment.likes ?? 0).description)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
    }
}

struct SchQuestionCommentCellView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SchQuestionCommentCellView(comment: SchCommentModel(id: 0, contain: "微北洋真", adminID: -1, score: nil, commit: "微北洋真", userID: 0, likes: 999, createdAt: "2021-03-10T12:50:28.000000Z", updatedAt: nil, username: "微北洋真不戳", isLiked: true, adminName: nil))
            SchQuestionCommentCellView(comment: SchCommentModel(id: 0, contain: "微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳", adminID: -1, score: nil, commit: "微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳", userID: 0, likes: 999, createdAt: "2021-03-10T12:50:28.000000Z", updatedAt: nil, username: "微北洋真不戳", isLiked: true, adminName: nil))
        }
        .frame(width: screen.width, height: screen.height)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
