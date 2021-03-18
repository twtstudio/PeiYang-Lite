//
//  SchAnswerDetailView.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2021/3/13.
//

import SwiftUI

struct SchAnswerDetailView: View {
    var question: SchQuestionModel
    var answer: SchCommentModel
    
    @State private var rating: CGFloat = 0
    
    var body: some View {
        VStack {
            NavigationBar(center: {
                Text("回复详情")
                    .font(.title2)
            })
            
            Group {
                VStack {
                    Text(question.name ?? "")
                        .bold()
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    Color(#colorLiteral(red: 0.6745098039, green: 0.6823529412, blue: 0.7294117647, alpha: 1))
                        .frame(height: 1)
                    SchQuestionAnswerCellView(comment: answer, webViewHeight: screen.width * 0.5, isScrollEnabled: true)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                
                if question.isOwner ?? false {
                    GeometryReader { g in
                        HStack(alignment: .center) {
                            Text("请评分:")
                                .padding(.trailing)
                            StarRatingView(rating: $rating, type: .half, spacing: 20, fillColor: Color(#colorLiteral(red: 0.3490196078, green: 0.3921568627, blue: 0.5098039216, alpha: 1)), isInteractive: true, maxRating: 5) { (score) in
                                postScore(score: score)
                            }
                            .frame(height: g.size.height * 0.6)
                        }
                        .frame(width: g.size.width, height: g.size.height)
                    }
                    .frame(width: screen.width * 0.9, height: 40)
                    .background(Color.white)
                    .cornerRadius(8)
                }
            }
            .frame(width: screen.width * 0.9)
            
            Spacer()
        }
        .navigationBarHidden(true)
        .background(
            Color(#colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.9725490196, alpha: 1))
                .ignoresSafeArea()
                .frame(width: screen.width, height: screen.height)
        )
    }
    
    private func postScore(score: CGFloat) {
        SchAnswerManager.commentAnswer(answerId: answer.id ?? 0, score: Int(score * 2), commit: "") { (result) in
            switch result {
                case .success(_):
                    log("评价成功")
                case .failure(let err):
                    log(err)
            }
        }
    }
}

struct SchAnswerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SchAnswerDetailView(question: SchQuestionModel(id: 0, name: "微北洋真不戳", content: "微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳", userID: nil, solved: 1, noCommit: 0, likes: 999, createdAt: "2021-03-10T12:50:28.000000Z", updatedAt: nil, username: "真不戳", msgCount: 999, urlList: ["https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png","https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png"], thumbImg: nil, tags: [SchTagModel(id: 0, name: "天津大学", description: nil, tagDescription: nil, isSelected: nil, children: nil)], thumbUrlList: ["https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png","https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png"], isLiked: true, isOwner: true),
                            answer: SchCommentModel(id: 0, contain: "<p>同学你好！学生宿舍淋浴洗浴和盥洗室免费热水都是从一套系统出水，集中用水时段会出现热水水温低的情况，存在盥洗室热水用量较大直接导致淋浴热水供应不足的情况发生！后保部北洋园能源办将根据天气情况等及时调整出水温度，同时也建议同学们能够错峰用水、节约用水。</p>", adminID: -1, score: nil, commit: nil, userID: 0, likes: 999, createdAt: "2021-03-10T12:50:28.000000Z", updatedAt: nil, username: "微北洋真不戳", isLiked: true, adminName: nil))
    }
}
