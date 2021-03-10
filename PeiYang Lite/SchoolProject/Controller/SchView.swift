//
//  SchView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/23.
//

import SwiftUI

struct SchView: View {
    @Environment(\.presentationMode) var mode
    @StateObject private var schViewModel: SchViewModel = .init()
    
    var body: some View {
        ZStack {
            VStack {
                // 顶部栏
                HStack {
                    NavigationLink(
                        destination: SchSearchView(),
                        label: {
                            SchSearchBarView()
                        })
                    Spacer()
                    NavigationLink(
                        destination: SchAccountView(),
                        label: {
                            Image("SchAccount")
                        })
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)
                
                SchQuestionScrollView<SchViewModel>()
                    .environmentObject(schViewModel)
                    .padding(.top)
                    .frame(width: screen.width)
            }
            .background(
                Color.init(red: 247/255, green: 247/255, blue: 248/255).ignoresSafeArea().frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
            )
            .navigationBarHidden(true)
            
            // 添加按钮
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(
                        destination: SchNewQuestionView(),
                        label: {
                            Image("SchAdd")
                                .resizable()
                                .frame(width: screen.width * 0.2, height: screen.width * 0.2)
                        })
                }
                .padding()
            }
            .frame(height: UIScreen.main.bounds.height * 0.8)
        }
    }
}

fileprivate class SchViewModel: SchQuestionScrollViewModel, SchQuestionScrollViewAction, SchQuestionScrollViewDataSource {
    @Published var questions: [SchQuestionModel] = []
    
    @Published var isReloading: Bool = false
    
    @Published var isLoadingMore: Bool = false
    
    @Published var page: Int = 0
    
    @Published var maxPage: Int = 0
    
    func reloadData() {
        page = 1
        SchQuestionManager.loadQuestions { (result) in
            switch result {
                case .success(let (questions, maxPage)):
//                    DispatchQueue.main.async {
                    if !self.questions.isEmpty {
                        print(self.questions[0])
                    }
                    if !self.questions.isEmpty && self.questions[0].id! != questions[0].id! {
                        print(self.questions[0], questions[0])
                    }
                    self.questions = questions
                    self.maxPage = maxPage
                    self.isReloading = false
                    print("刷新成功")
//                    }
                case .failure(let err):
                    print("刷新失败", err)
            }
        }
    }
    func loadMore() {
        guard page < maxPage else {
            return
        }
        page += 1
        SchQuestionManager.loadQuestions(page: page) { (result) in
            switch result {
                case .success(let (questions, _)):
                    self.questions += questions
                    self.isLoadingMore = false
                case .failure(let err):
                    print("刷新失败", err)
            }
        }
    }
    
    func loadOnAppear() {
        SchUserManager.login { (result) in
            switch result {
                case .success(_):
                    self.reloadData()
                case .failure(let err):
                    print("刷新失败", err)
            }
        }
    }
    
    var action: SchQuestionScrollViewAction { self }
    private lazy var _dataSource: SchQuestionScrollViewDataSource = { self }()
    var dataSource: SchQuestionScrollViewDataSource {
        get { _dataSource }
        set { _dataSource = newValue }
    }
}

struct SchView_Previews: PreviewProvider {
    static var previews: some View {
        SchView()
    }
}

struct SchSearchBarView: View {
    var body: some View {
        HStack {
            Image("search")
            Text("搜索问题...").foregroundColor(.init(red: 207/255, green: 208/255, blue: 213/255))
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height / 20, alignment: .center)
        .background(Color.init(red: 236/255, green: 237/255, blue: 239/255))
        .cornerRadius(UIScreen.main.bounds.height / 40)
    }
}

