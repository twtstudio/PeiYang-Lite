//
//  SchQuestionDetailHeaderView.swift
//  PeiYang Lite
//
//  Created by 游奕桁 on 2021/2/26.
//

import SwiftUI

struct SchQuestionDetailHeaderView: View {
    @Binding var question: SchQuestionModel
    
    private var questionTime: String {
        get {
            let day = question.createdAt?[0..<10] ?? ""
            let time = question.createdAt?[11..<16] ?? ""
            return day + " " + time
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(question.name ?? "")
                    .bold()
                    .font(.body)
                    .foregroundColor(Color(#colorLiteral(red: 0.2117647059, green: 0.2352941176, blue: 0.3294117647, alpha: 1)))
                
                Spacer()
                
                Text((question.noCommit ?? 0) == 0 ? "未回复" : "已回复")
                    .font(.footnote)
                    .foregroundColor(Color(#colorLiteral(red: 0.1882352941, green: 0.2352941176, blue: 0.4, alpha: 1)))
            }
            .padding(.top)
            .padding(.horizontal)
            
            HStack {
                ForEach(question.tags ?? [], id: \.id) { tag in
                    Text("#\(tag.name ?? "")")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
            }
            
            Text(question.content ?? "")
                .font(.footnote)
                .foregroundColor(Color(#colorLiteral(red: 0.2117647059, green: 0.2352941176, blue: 0.3294117647, alpha: 1)))
                .padding(.horizontal)
            
            PhotoListView(imageURLs: question.thumbUrlList ?? [])
            
            HStack {
                Text(questionTime)
                    .fontWeight(.light)
                
                Spacer()
                
                Image("sch-conmment")
                
                Text("\(question.msgCount ?? 0)")
                    .fontWeight(.light)
                
                
                Button(action: {
                    likeQuestion()
                }, label: {
                    Image(question.isLiked ?? false ? "sch-like-fill" : "liked")
                })
                Text("\(question.likes ?? 0)")
                    .fontWeight(.light)
                Button(action: {
                    
                }, label: {
                    Image(systemName: "star")
                })
                
            }
            .font(.footnote)
            .foregroundColor(.gray)
            .padding()
            
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private func likeQuestion() {
        
    }
}

struct SchQuestionCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            
            SchQuestionDetailHeaderView(question: .constant(SchQuestionModel(id: 0, name: "微北洋真不戳", content: "微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳", userID: nil, solved: 1, noCommit: 0, likes: 999, createdAt: "2021-03-10T12:50:28.000000Z", updatedAt: nil, username: "真不戳", msgCount: 999, urlList: ["https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png","https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png"], thumbImg: nil, tags: [SchTagModel(id: 0, name: "天津大学", description: nil, tagDescription: nil, isSelected: nil, children: nil)], thumbUrlList: ["https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png","https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png"], isLiked: true, isOwner: true)))
                .frame(width: screen.width - 20, height: screen.width - 20)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 2, y: 2)
        }
    }
}
