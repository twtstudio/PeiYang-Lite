//
//  QuestionCardView.swift
//  PeiYang Lite
//
//  Created by 游奕桁 on 2021/2/26.
//

import SwiftUI

struct QuestionCardView: View {
    var question = QuestionData()
    var width: CGFloat
    var height: CGFloat
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(question.name)
                    .bold()
                    .font(.body)
                    .foregroundColor(Color(#colorLiteral(red: 0.2117647059, green: 0.2352941176, blue: 0.3294117647, alpha: 1)))
                
                Spacer()
                
                Text(question.no_commit == 0 ? "未回复" : "已回复")
                    .font(.footnote)
                    .foregroundColor(Color(#colorLiteral(red: 0.1882352941, green: 0.2352941176, blue: 0.4, alpha: 1)))
            }
            .padding(.top)
            .padding(.horizontal)
            
            HStack {
                ForEach(question.tags, id: \.id) { tag in
                    Text("#\(tag.name)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
            }
            
            Text(question.description)
                .font(.footnote)
                .foregroundColor(Color(#colorLiteral(red: 0.2117647059, green: 0.2352941176, blue: 0.3294117647, alpha: 1)))
                .padding(.horizontal)
            
            Image("Text")                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(width: width-30)
                .padding(.horizontal)
            
            HStack {
                Text(question.created_at.format(with: "yyyy-M-d"))
                    .fontWeight(.light)
                
                Text(question.created_at.format(with: "hh:m"))
                    .fontWeight(.light)
                
                Spacer()
                Group {
                Image(systemName: "bubble.left")
                
                Text("\(question.msgCount)")
                    .fontWeight(.light)
                }
                
                Group {
                Image(systemName: "hand.thumbsup")
                Text("\(question.likes)")
                    .fontWeight(.light)
                }
                
                Image(systemName: "star")
            }
            .font(.footnote)
            .foregroundColor(.gray)
            .padding()
            
        }
        .frame(width: width, height: height, alignment: .top)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct QuestionCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            
            QuestionCardView(width: screen.width-20, height: screen.width-20)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 2, y: 2)
        }
    }
}
