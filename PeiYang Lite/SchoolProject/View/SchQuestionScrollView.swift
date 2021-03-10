//
//  SchQuestionScrollView.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2021/3/6.
//

import SwiftUI

protocol SchQuestionScrollViewDataSource {
    var questions: [SchQuestionModel] { get set }
    
    var isReloading: Bool { get set }
    var isLoadingMore: Bool { get set }
    var page: Int { get set }
    var maxPage: Int { get set }
}

protocol SchQuestionScrollViewAction {
    func reloadData()
    func loadMore()
    func loadOnAppear()
}

protocol SchQuestionScrollViewModel: ObservableObject {
    var action: SchQuestionScrollViewAction { get }
    var dataSource: SchQuestionScrollViewDataSource { get set }
}

struct SchQuestionScrollView<Model>: View where Model: SchQuestionScrollViewModel {
    @ObservedObject var model: Model
    
    var body: some View {
        ScrollViewWithRefresh(refreshing: $model.dataSource.isReloading,
                              loadAction: {
                                model.action.reloadData()
                              },
                              content: {
            LazyVStack(spacing: 10) {
//                ForEach(model.dataSource.questions.indices, id: \.self) { i in
//                    SchQuestionCellView(question: model.dataSource.questions[i])
//                }
                if model.dataSource.questions.count > 4 {
                    SchQuestionCellView(question: model.dataSource.questions[0])
                    SchQuestionCellView(question: model.dataSource.questions[0])
                    SchQuestionCellView(question: model.dataSource.questions[0])
                    SchQuestionCellView(question: model.dataSource.questions[0])
                }
                if model.dataSource.questions.count > 0{
                    Text(model.dataSource.page < model.dataSource.maxPage ? "加载中..." : "已经到底了...")
                    .onAppear {
                        model.action.loadMore()
                    }
                }
            }
        })
    }
}

//struct SchQuestionScrollView_Previews: PreviewProvider {
//    static var previews: some View {
//        SchQuestionScrollView(model: SchViewModel())
//    }
//}
