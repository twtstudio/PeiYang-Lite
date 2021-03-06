//
//  SchSearchResultView.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2021/3/6.
//

import SwiftUI

struct SchSearchResultView: View {
    @State var isEmpty: Bool = false
    @State var tags: [SchTagModel] = []
    @State var searchString: String = ""
    
    var body: some View {
        if isEmpty {
            Text("未检索到相关问题")
        } else {
            SchQuestionScrollView(model: SchSearchResultViewModel())
        }
    }
}

fileprivate class SchSearchResultViewModel: SchQuestionScrollViewModel, SchQuestionScrollViewDataSource, SchQuestionScrollViewAction {
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
    
    @Published var questions: [SchQuestionModel] = []
    
    @Published var isReloading: Bool = false
    
    @Published var isLoadingMore: Bool = false
    
    @Published var page: Int = 0
    
    @Published var maxPage: Int = 0
    
    @Published var tags: [SchTagModel] = []
    @Published var searchString: String = ""
}
