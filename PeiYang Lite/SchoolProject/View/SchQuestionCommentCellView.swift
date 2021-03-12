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
            return day + " " + time
        }
    }
    
    var body: some View {
        GeometryReader { g in
            VStack {
                HStack {
                    Image("Text")
                        .resizable()
                    Text(comment.username ?? "")
                    Spacer()
                    Text(commentTime)
                }
                Text(comment.commit ?? "")
                
                HStack {
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Image(comment.isLiked ?? false ? "sch-liked" : "sch-like")
                    })
                }
                Text((comment.likes ?? 0).description)
            }
        }
        .background(Color.white)
        .cornerRadius(15)
    }
}

struct SchQuestionCommentCellView_Previews: PreviewProvider {
    static var previews: some View {
        SchQuestionCommentCellView(comment: SchCommentModel(id: 0, contain: nil, adminID: -1, score: nil, commit: "微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳", userID: 0, likes: 999, createdAt: "2021-03-10T12:50:28.000000Z", updatedAt: nil, username: "微北洋真不戳", isLiked: true, adminName: nil))
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
