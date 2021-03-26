//
//  SchQuestionAnswerCellView.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2021/3/12.
//

import SwiftUI

struct SchQuestionAnswerCellView: View {
    @State var comment: SchCommentModel
    var webViewHeight: CGFloat
    var isScrollEnabled: Bool
    
    private var commentTime: String {
        get {
            let day = comment.createdAt?[0..<10] ?? ""
            let time = comment.createdAt?[11..<16] ?? ""
            return day + "  " + time
        }
    }
    
    var body: some View {
        let unwrapContain = Binding<String> {
            return comment.contain ?? ""
        } set: {_ in }

        VStack {
            GeometryReader { g in
                HStack {
                    Text("官方")
                        .foregroundColor(.white)
                        .frame(width: g.size.width * 0.15, height: g.size.height * 0.7)
                        .background(Color(#colorLiteral(red: 0.3490196078, green: 0.3882352941, blue: 0.5215686275, alpha: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Spacer()
                    Text(commentTime)
                        .foregroundColor(Color(#colorLiteral(red: 0.6941176471, green: 0.6980392157, blue: 0.7450980392, alpha: 1)))
                        .font(.subheadline)
                }
                .frame(height: g.size.height)
            }
            .frame(height: screen.height * 0.05)
            
            WebHtmlView(html: unwrapContain, isScrollEnabled: isScrollEnabled)
                .frame(height: webViewHeight)
            
            HStack {
                if comment.score ?? -1 == -1 {
                    Text("提问者未评分")
                        .foregroundColor(Color(#colorLiteral(red: 0.6941176471, green: 0.6980392157, blue: 0.7450980392, alpha: 1)))
                        .font(.subheadline)
                } else {
                    Text("提问者评分: ")
                        .foregroundColor(Color(#colorLiteral(red: 0.6941176471, green: 0.6980392157, blue: 0.7450980392, alpha: 1)))
                        .font(.subheadline)
                    StarRatingView(rating: .constant(CGFloat(3.5)), type: .half, spacing: 4, maxRating: 5)
                        .frame(height: screen.height * 0.02)
                }
                Spacer()
                Button(action: {
                    SchAnswerManager.likeOrDislikeAnswer(answerId: comment.id ?? 0, like: !(comment.isLiked ?? false)) { (result) in
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
                    .foregroundColor(Color(#colorLiteral(red: 0.6941176471, green: 0.6980392157, blue: 0.7450980392, alpha: 1)))
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
    }
}

struct SchQuestionAnswerCellView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SchQuestionAnswerCellView(comment: SchCommentModel(id: 0, contain: "<p>微北洋真</p>", adminID: -1, score: nil, commit: nil, userID: 0, likes: 999, createdAt: "2021-03-10T12:50:28.000000Z", updatedAt: nil, username: "微北洋真不戳", isLiked: true, adminName: nil), webViewHeight: screen.width * 0.25, isScrollEnabled: false)
            SchQuestionAnswerCellView(comment: SchCommentModel(id: 0, contain: "<p>同学你好！学生宿舍淋浴洗浴和盥洗室免费热水都是从一套系统出水，集中用水时段会出现热水水温低的情况，存在盥洗室热水用量较大直接导致淋浴热水供应不足的情况发生！后保部北洋园能源办将根据天气情况等及时调整出水温度，同时也建议同学们能够错峰用水、节约用水。</p>", adminID: -1, score: 7, commit: nil, userID: 0, likes: 999, createdAt: "2021-03-10T12:50:28.000000Z", updatedAt: nil, username: "微北洋真不戳", isLiked: true, adminName: nil), webViewHeight: screen.width * 0.25, isScrollEnabled: true)
        }
        .frame(width: screen.width, height: screen.height)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
