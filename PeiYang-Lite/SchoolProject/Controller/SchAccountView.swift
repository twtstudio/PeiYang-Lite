//
//  SchAccountView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/23.
//

import SwiftUI

struct SchAccountView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var sharedMessage: SharedMessage
    
    @State private var isMineSelected: Bool = true
    @State private var isFavSelected: Bool = false
    
    @State private var myQuestions: [SchQuestionModel] = []
    @State private var favQuestions: [SchQuestionModel] = []
    
    // 删除问题
    @State private var isShowAlert: Bool = false
    @State private var questionIdToDelete: Int = -1
    
    // 红点相关
    @State private var questionsHasReddot: [Int] = []
    
    private var isMyQuestionsHasReddot: Bool {
        !myQuestions.reduce(true, { $0 && ($1.readen ?? true) })
    }
    
    private var isFavQuestionsHasReddot: Bool {
        !favQuestions.reduce(true, { $0 && ($1.readen ?? true) })
    }
    
    // 未读消息
    @AppStorage(SchMessageManager.SCH_MESSAGE_CONFIG_KEY, store: Storage.defaults) private var unreadMessageCount: Int = 0
    
    private var questions: [SchQuestionModel] {
        return isMineSelected ? myQuestions : favQuestions
    }
    
    var body: some View {
        VStack {
            NavigationBar(leading: {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                }
            }, center: {
                Text("个人中心")
                    .font(.title2)
                    .foregroundColor(.white)
            }, trailing: {
                NavigationLink(
                    destination: SchRecvMessageView(),
                    label: {
                        Image(systemName: "text.bubble")
                            .font(.title2)
                            .foregroundColor(.white)
                            .addReddot(isPresented: unreadMessageCount != 0, count: unreadMessageCount, size: 15)
                        .padding()
                    })
            })
            VStack {
                Text(sharedMessage.Account.nickname)
                    .font(.title)
                    .padding(4)
                Text(sharedMessage.Account.userNumber)
                    .font(.title2)
            }
            .foregroundColor(.white)
            .frame(height: screen.height * 0.12)
            
            HStack(spacing: screen.width / 5){
                Button(action: {
                    isMineSelected = true
                    isFavSelected = false
                }, label: {
                    SchAccountModeView(img: "sch-ques", title: "我的提问", isSelected: $isMineSelected)
                        .addReddot(isPresented: isMyQuestionsHasReddot, size: 10)
                })
                Button(action: {
                    isMineSelected = false
                    isFavSelected = true
                }, label: {
                    SchAccountModeView(img: "sch-favour", title: "我的收藏", isSelected: $isFavSelected)
                        .addReddot(isPresented: isFavQuestionsHasReddot, size: 10)
                })
            }// Horizontal 3 icons
            .frame(width: screen.width * 0.9, height: screen.height * 0.17, alignment: .center)
            .background(Color.white)
            .cornerRadius(20)
            
            ScrollView(showsIndicators: false) {
                if isMineSelected {
                    if myQuestions.isEmpty {
                        LoadingView()
                    }
                    LazyVStack {
                        ForEach(myQuestions.indices, id: \.self) { i in
                            SchQuestionCellView(question: myQuestions[i], isEditing: isMineSelected, deleteAction: {
                                isShowAlert = true
                                questionIdToDelete = myQuestions[i].id ?? -1
                            }, showReddot: !(myQuestions[i].readen ?? true))
                            .frame(maxWidth: .infinity)
                            .padding(.top, 10)
                        }
                    }
                    .addAnalytics(className: "MyQuestionView")
                } else {
                    if favQuestions.isEmpty {
                        LoadingView()
                    }
                    LazyVStack {
                        ForEach(favQuestions.indices, id: \.self) { i in
                            SchQuestionCellView(question: favQuestions[i], isEditing: isMineSelected, deleteAction: {
                                isShowAlert = true
                                questionIdToDelete = favQuestions[i].id ?? -1
                            }, showReddot: !(favQuestions[i].readen ?? true))
                            .frame(maxWidth: .infinity)
                            .padding(.top, 10)
                        }
                    }
                    .addAnalytics(className: "MyFavView")
                }
            }
            .padding(.top, 6)
            .edgesIgnoringSafeArea(.bottom)
            .alert(isPresented: $isShowAlert, content: {
                Alert(title: Text("确定要删除此问题吗?"), primaryButton: .destructive(Text("好"), action: {
                    deleteQuestion(questionId: questionIdToDelete)
                }), secondaryButton: .cancel())
            })
            
            Spacer()
        }
        .background(SchBackGround())
        .navigationBarHidden(true)
        .addAnalytics(className: "SchoolProjectAccountView")
        .onAppear(perform: loadQuestionData)
        .onAppear {
            if SchManager.schToken != nil {
                SchMessageManager.getUnreadCount { (result) in
                    switch result {
                    case .success(let (totalCount, _)):
                        unreadMessageCount = totalCount
                    case .failure(let err):
                        log(err)
                    }
                }
            }
        }
    }
    
    private func loadQuestionData() {
        SchQuestionManager.getQuestions(type: .fav) { (result) in
            switch result {
            case .success(let questions):
                self.favQuestions = questions
            case .failure(let err):
                log(err)
            }
        }
        SchQuestionManager.getQuestions(type: .my) { (result) in
            switch result {
            case .success(let questions):
                self.myQuestions = questions
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
                loadQuestionData()
            case .failure(let err):
                log(err)
            }
        }
    }
}

struct SchAccountView_Previews: PreviewProvider {
    static var previews: some View {
        SchAccountView()
    }
}


struct SchBackGround: View {
    var body: some View {
        VStack {
            
            Color.init(red: 67/255, green: 70/255, blue: 80/255)
                .frame(width: screen.width, height: screen.height * 0.45)
            Color.init(red: 247/255, green: 247/255, blue: 248/255)
                .frame(width: screen.width, height: screen.height * 0.55)
        }
        .ignoresSafeArea()
    }
}

struct SchAccountModeView: View {
    var img: String
    var title: String
    @Binding var isSelected: Bool
    var body: some View {
        VStack {
            Image(img)
                .resizable()
                .scaledToFit()
                .frame(width: screen.width / 9)
            Text(title)
                .foregroundColor(.init(red: 105/255, green: 111/255, blue: 133/255))
            Circle()
                .frame(width: 6, height: 6)
                .foregroundColor(Color(#colorLiteral(red: 0.262745098, green: 0.2745098039, blue: 0.3137254902, alpha: 1)))
                .opacity(isSelected ? 1 : 0)
        }
    }
}
