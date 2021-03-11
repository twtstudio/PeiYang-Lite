//
//  SchSearchResultView.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2021/3/6.
//

import SwiftUI

struct SchSearchResultView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var tags: [SchTagModel] = []
    
    @Binding var inputMessage: String
    @AppStorage(SchSearchView.historyKey, store: Storage.defaults) var historyArray: [String] = []
    @EnvironmentObject var tagSource: SchTagSource
    
    @Binding var rootIsActive: Bool
    
    var body: some View {
        VStack {
            HStack {
                NavigationLink(
                    destination: SchSearchView(rootIsActive: $rootIsActive),
                    isActive: $rootIsActive,
                    label: {
                        SchSearchBarView()
                })
                    .isDetailLink(false)
                Button(action: {
                    self.rootIsActive = false
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("取消")
                        .foregroundColor(.init(red: 98/255, green: 103/255, blue: 124/255))
                })
            }
            SchQuestionScrollView(model: SchSearchResultViewModel())
                .padding(.top)
                .frame(width: screen.width)
            Spacer()
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
    }
}

struct SchSearchResultView_Preview: PreviewProvider {
    static var previews: some View {
        SchSearchResultView(inputMessage: .constant("hahaha"), rootIsActive: .constant(false))
            .environmentObject(SchSearchResultViewModel())
    }
}

fileprivate class SchSearchResultViewModel: SchQuestionScrollViewModel, SchQuestionScrollViewDataSource, SchQuestionScrollViewAction {
    @Published var questions: [SchQuestionModel] = []
    
    @Published var isReloading: Bool = false
    
    @Published var isLoadingMore: Bool = false
    
    @Published var page: Int = 0
    
    @Published var maxPage: Int = 0
    
    @Published var tags: [SchTagModel] = []
    
    @Published var searchString: String = ""
    
    init() {
        loadOnAppear()
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
    
    func loadOnAppear() {
        self.reloadData()
    }
    
    var action: SchQuestionScrollViewAction { self }
    private lazy var _dataSource: SchQuestionScrollViewDataSource = { self }()
    var dataSource: SchQuestionScrollViewDataSource {
        get { _dataSource }
        set { _dataSource = newValue }
    }
}
