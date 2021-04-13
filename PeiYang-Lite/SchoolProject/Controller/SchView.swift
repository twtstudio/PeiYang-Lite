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
    @AppStorage(SchMessageManager.SCH_MESSAGE_CONFIG_KEY, store: Storage.defaults) private var unreadMessageCount: Int = 0
    
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
                                .padding(2)
                                .addReddot(isPresented: unreadMessageCount != 0, size: 10)
                        })
                }
                .frame(width: screen.width * 0.9)
                
                SchQuestionScrollView(model: schViewModel)
                    .padding(.top)
                    .frame(width: screen.width)
            }
            .background(
                Color(#colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1))
                    .ignoresSafeArea()
                    .frame(width: screen.width, height: screen.height)
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
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: screen.width * 0.15, height: screen.width * 0.15)
                                .background(Color(#colorLiteral(red: 0.1882352941, green: 0.2392156863, blue: 0.3882352941, alpha: 1)))
                                .cornerRadius(screen.width * 0.075)
                                .shadow(radius: 5)
                        })
                }
                .padding()
            }
            .frame(height: screen.height * 0.8)
        }
        .addAnalytics(className: "SchoolProjectHomeView")
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
            // 刷新数据
            schViewModel.loadOnAppear()
        }
    }
}

fileprivate class SchViewModel: SchQuestionScrollViewModel, SchQuestionScrollViewAction, SchQuestionScrollViewDataSource {
    @Published var questions: [SchQuestionModel] = []
    
    @Published var isReloading: Bool = false
    
    @Published var isLoadingMore: Bool = false
    
    @Published var page: Int = 0
    
    @Published var maxPage: Int = 0
    
    private var cnt: Int = 0
    
    init() {
        loadOnAppear()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.page = 1
            SchQuestionManager.loadQuestions { (result) in
                switch result {
                    case .success(let (questions, maxPage)):
                            self.questions = questions
                            self.maxPage = maxPage
                            self.isReloading = false
                            log("刷新成功")
                    case .failure(let err):
                        log(err)
                }
            }
        }
    }
    func loadMore() {
        guard page < maxPage else {
            return
        }
        DispatchQueue.main.async {
            self.page += 1
            SchQuestionManager.loadQuestions(page: self.page) { (result) in
                switch result {
                    case .success(let (questions, _)):
                            self.questions += questions
                            self.isLoadingMore = false
                    case .failure(let err):
                        log(err)
                }
            }
        }
    }
    
    func loadOnAppear() {
        SchUserManager.login { (result) in
            switch result {
                case .success(_):
                    self.reloadData()
                case .failure(let err):
                    log(err)
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
        .frame(width: screen.width * 0.8, height: screen.height / 20, alignment: .center)
        .background(Color.init(red: 236/255, green: 237/255, blue: 239/255))
        .cornerRadius(screen.height / 40)
    }
}

