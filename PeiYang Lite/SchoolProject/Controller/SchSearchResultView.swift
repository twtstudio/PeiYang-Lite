//
//  SchSearchResultView.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2021/3/6.
//

import SwiftUI

struct SchSearchResultView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State var tags: [SchTagModel] = []
    
    @AppStorage(SchSearchView.historyKey, store: Storage.defaults) var historyArray: [String] = []
    @EnvironmentObject var tagSource: SchTagSource
    @EnvironmentObject var searchModel: SchSearchResultViewModel
    
    var body: some View {
        VStack {
//            SchSearchTopView(inputMessage: $inputMessage, historyArray: $historyArray)
//                .environmentObject(tagSource)
            // 头部伪导航栏
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .foregroundColor(Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)))
                        .padding()
                }
                
                Spacer()

            }
            .padding(.top, 40)
            .padding(.trailing, 20)
            SchQuestionScrollView(model: searchModel)
                .padding(.top)
                .frame(width: screen.width)
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .background(
            Color(#colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1))
                .ignoresSafeArea()
                .frame(width: screen.width, height: screen.height)
        )
    }
}

class SchSearchResultViewModel: SchQuestionScrollViewModel, SchQuestionScrollViewDataSource, SchQuestionScrollViewAction {
    @Published var questions: [SchQuestionModel] = []
    
    @Published var isReloading: Bool = false
    
    @Published var isLoadingMore: Bool = false
    
    @Published var page: Int = 0
    
    @Published var maxPage: Int = 0
    
    @Published var tags: [SchTagModel] = []
    
    @Published var searchString: String = "" {
        didSet {
            self.reloadData()
        }
    }
    
    func reloadData() {
        page = 1
        SchQuestionManager.searchQuestions(tags: tags, string: searchString, page: page) { (result) in
            switch result {
                case .success(let (questions, maxPage)):
                    DispatchQueue.main.async {
                        self.questions = questions
                        self.maxPage = maxPage
                        self.isReloading = false
                        print("刷新成功")
                    }
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
        SchQuestionManager.searchQuestions(tags: tags, string: searchString, page: page) { (result) in
            switch result {
                case .success(let (questions, _)):
                    self.questions += questions
                    self.isLoadingMore = false
                case .failure(let err):
                    print("刷新失败", err)
            }
        }
    }
    
    func loadOnAppear() {}
    
    var action: SchQuestionScrollViewAction { self }
    private lazy var _dataSource: SchQuestionScrollViewDataSource = { self }()
    var dataSource: SchQuestionScrollViewDataSource {
        get { _dataSource }
        set { _dataSource = newValue }
    }
}
