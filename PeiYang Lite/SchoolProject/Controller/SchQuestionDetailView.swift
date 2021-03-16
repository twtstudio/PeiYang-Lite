//
//  SchQuestionDetailView.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2021/3/11.
//

import SwiftUI

struct SchQuestionDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var question: SchQuestionModel
    @State var answer: SchCommentModel?
    @State var comments: [SchCommentModel] = []
    
    @State private var msg: String = "发条友善的评论"
    
    @State var inputDidChange: Bool = false
    @State var textHeight: CGFloat = 0
    
    // 删除问题
    @State private var isShowAlert: Bool = false
    
    init(question: Binding<SchQuestionModel>) {
        _question = question
        // 解决TextEditor背景白色的问题
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        let inputMessage = Binding<String> {
            return msg
        } set: {
            guard $0.count <= 200 else { return }
            msg = $0
        }
        VStack {
            // 头部伪导航栏
            NavigationBar(center: {
                Text("问题详情")
            }) {
                if question.isOwner ?? false {
                    Button(action: {
                        isShowAlert = true
                    }, label: {
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)))
                            .padding()
                    })
                }
            }
            .alert(isPresented: $isShowAlert, content: {
                Alert(title: Text("确定要删除此问题吗?"), primaryButton: .destructive(Text("好"), action: {
                    deleteQuestion(questionId: question.id ?? 0)
                }), secondaryButton: .cancel())
            })
            
            ScrollView(showsIndicators: false) {
                SchQuestionDetailHeaderView(question: $question)
                    .frame(width: screen.width * 0.95)
                    .cornerRadius(15)
                
                LazyVStack {
                    ForEach(comments.indices, id: \.self) { i in
                        if (comments[i].adminID ?? -1) == -1 {
                            SchQuestionCommentCellView(comment: comments[i])
                                .frame(width: screen.width * 0.95)
                                .cornerRadius(15)
                        } else {
                            SchQuestionAnswerCellView(comment: comments[i])
                                .frame(width: screen.width * 0.95)
                                .cornerRadius(15)
                        }
                    }
                }
                
                Spacer()
            }
            
            HStack {
                HStack {
                    Text(inputMessage.wrappedValue).foregroundColor(.clear).padding(.all, 4)
                        .frame(maxWidth: .infinity, minHeight: screen.height * 0.045)
                        .overlay(
                            TextEditor(text: inputMessage)
                                .foregroundColor(inputDidChange ? Color.black : .init(red: 207/255, green: 208/255, blue: 213/255))
                                .onTapGesture {
                                    if !inputDidChange {
                                        inputMessage.wrappedValue = ""
                                        inputDidChange = true
                                    }
                                }
                        )
                    
                    Text("\(inputDidChange ? inputMessage.wrappedValue.count : 0)/200")
                        .foregroundColor(.init(red: 207/255, green: 208/255, blue: 213/255))
                }
                .padding(.horizontal)
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .background(Color.init(red: 236/255, green: 237/255, blue: 239/255))
                .cornerRadius(20)
                
                Button(action: {
                    sendComment()
                }, label: {
                    Image("sch-send")
                        .resizable()
                        .frame(height: screen.height * 0.045)
                })
            }
            .padding()
            .background(Color(#colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)))
            .clipped()
            .shadow(color: .black, radius: 1.5, y: 1)
            
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            loadComment()
            if question.solved ?? -1 == 1 {
                loadAnswer()
            }
        }
        .background(
            Color(#colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1))
                .ignoresSafeArea()
                .frame(width: screen.width, height: screen.height)
        )
        .navigationBarHidden(true)
        
    }
    
    private func loadAnswer() {
        SchAnswerManager.answerGet(id: question.id ?? 0) { (result) in
            switch result {
                case .success(let answers):
                    self.comments.insert(answers[0], at: 0)
                case .failure(let err):
                    log(err)
            }
        }
    }
    
    private func loadComment() {
        SchCommentManager.commentGet(id: question.id ?? 0) { (result) in
            switch result {
                case .success(let comments):
                    self.comments += comments
                case .failure(let err):
                    log(err)
            }
        }
    }
    
    private func sendComment() {
        SchCommentManager.addComment(questionId: question.id ?? 0, contain: msg) { (result) in
            switch result {
                case .success(_):
                    log("发送评论成功")
                    loadComment()
                    msg = ""
                case .failure(let err):
                    log(err)
            }
        }
    }
    
    private func deleteQuestion(questionId: Int) {
        SchQuestionManager.deleteMyQuestion(questionId: questionId) { (result) in
            switch result {
                case .success(_):
                    log("删除问题成功")
                    presentationMode.wrappedValue.dismiss()
                case .failure(let err):
                    log(err)
            }
        }
    }
}

struct SchQuestionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SchQuestionDetailView(question: .constant(
            SchQuestionModel(id: 0, name: "微北洋真不戳", content: "微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳微北洋真不戳", userID: nil, solved: 1, noCommit: 0, likes: 999, createdAt: "2021-03-10T12:50:28.000000Z", updatedAt: nil, username: "真不戳", msgCount: 999, urlList: ["https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png","https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png"], thumbImg: nil, tags: [SchTagModel(id: 0, name: "天津大学", description: nil, tagDescription: nil, isSelected: nil, children: nil)], thumbUrlList: ["https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png","https://www.hackingwithswift.com/img/covers-flat/watchos@2x.png"], isLiked: true, isOwner: true)
        ))
    }
}
