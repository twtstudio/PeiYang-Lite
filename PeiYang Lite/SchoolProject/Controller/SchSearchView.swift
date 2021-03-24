//
//  SchSearchTableView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/23.
//

import SwiftUI

struct SchSearchView: View {
    // 历史记录本地存储
    static let historyKey = "SCH_SEARCH_HISTORY_KEY"
    @AppStorage(SchSearchView.historyKey, store: Storage.defaults) var historyArray: [String] = []

    @StateObject private var tagSource: SchTagSource = .init()
    @StateObject private var searchModel: SchSearchResultViewModel = .init()
    
    @State private var isSearching: Bool = false
    
    var body: some View {
        VStack {
            SchSearchTopView(inputMessage: $searchModel.searchString, historyArray: $historyArray, isSearching: $isSearching)
                .environmentObject(tagSource)
                .environmentObject(searchModel)

                if !isSearching {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("历史记录")
                                .foregroundColor(.init(red: 98/255, green: 103/255, blue: 124/255))
                                .font(.custom("Avenir-Black", size: 17))
                            Spacer()
                            Button(action: {
                                historyArray = []
                            }, label: {
                                Image("sch-trash")
                            })
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        
                        VStack(spacing: 20){
                            ForEach(historyArray, id: \.self) { s in
                                Button(action: {
                                    searchModel.searchString = s
                                }, label: {
                                    HStack{
                                        Text(s)
                                            .font(.subheadline)
                                            .foregroundColor(.init(red: 48/255, green: 60/255, blue: 102/255))
                                        Spacer()
                                        Image("SchArrow")
                                    }
                                })
                            }
                        }
                        .padding(.top, 10)
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        
                        Text("标签搜索")
                            .foregroundColor(.init(red: 98/255, green: 103/255, blue: 124/255))
                            .font(.custom("Avenir-Black", size: 17))
                    }
                    .padding(.top)
                        
                    GeometryReader { g in
                        ScrollView {
                            generateView(g)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                } else if searchModel.questions.isEmpty {
                    Text("未检索到相关问题")
                        .frame(maxHeight: .infinity)
                } else {
                    SchQuestionScrollView(model: searchModel)
                        .padding(.top)
                        .frame(width: screen.width)
                }
            
            Spacer()
        }
        .onAppear(perform: {
            UMAnalyticsSwift.beginLogPageView(pageName: "SchoolProjectSearchView")
        })
        .background(
            Color(#colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1))
                .ignoresSafeArea()
                .frame(width: screen.width, height: screen.height)
        )
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onDisappear(perform: {
            UMAnalyticsSwift.endLogPageView(pageName: "SchoolProjectSearchView")
        })
    }
    
    private func generateView(_ g: GeometryProxy) -> some View {
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        return ZStack(alignment: .topLeading) {
            ForEach(tagSource.tags.indices, id: \.self) { i in
                Button(action: {
                    for i in tagSource.tags.indices {
                        tagSource.tags[i].isSelected = false
                    }
                    tagSource.tags[i].isSelected?.toggle()
                }, label: {
                    SchTagView(model: $tagSource.tags[i])
                })
                .padding([.horizontal, .vertical], 10)
                .alignmentGuide(.leading, computeValue: { d in
                    if (abs(width - d.width) > g.size.width)
                    {
                        width = 0
                        height -= d.height
                    }
                    let result = width
                    if tagSource.tags[i] == tagSource.tags.last! {
                        width = 0 //last item
                    } else {
                        width -= d.width
                    }
                    return result
                })
                .alignmentGuide(.top, computeValue: {d in
                    let result = height
                    if tagSource.tags[i] == tagSource.tags.last! {
                        height = 0 // last item
                    }
                    return result
                })
            }
        }
    }
}

struct SchSearchTableView_Previews: PreviewProvider {
    static var previews: some View {
        SchSearchView()
    }
}

fileprivate struct SchSearchTopView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Binding var inputMessage: String
    @Binding var historyArray: [String]
    @Binding var isSearching: Bool
    @EnvironmentObject var tagSource: SchTagSource
    @EnvironmentObject var searchModel: SchSearchResultViewModel
    
    @State private var navigateToResult: Bool = false
    
    var body: some View {
        HStack {
            HStack {
                Image("search")
                TextField("搜索问题...", text: $inputMessage, onCommit: {
                    searchQuestion()
                })
                .foregroundColor(inputMessage.isEmpty ? .init(red: 207/255, green: 208/255, blue: 213/255) : Color.black)
                Spacer()
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height / 20, alignment: .center)
            .background(Color.init(red: 236/255, green: 237/255, blue: 239/255))
            .cornerRadius(UIScreen.main.bounds.height / 40)
            .onTapGesture {
                isSearching = false
            }
            
            Button(action: {
                self.mode.wrappedValue.dismiss()
            }, label: {
                Text("取消")
                    .foregroundColor(.init(red: 98/255, green: 103/255, blue: 124/255))
            })
        }
        
    }
    
    private func searchQuestion() {
        guard !inputMessage.isEmpty else { return }
        if !historyArray.contains(inputMessage) {
            historyArray.insert(inputMessage, at: 0)
            if historyArray.count > 4 {
                historyArray.removeLast()
            }
        }
        isSearching = true
        hideKeyboard()
//        navigateToResult = true
    }
}

fileprivate class SchSearchResultViewModel: SchQuestionScrollViewModel, SchQuestionScrollViewDataSource, SchQuestionScrollViewAction {
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
                        log("刷新成功")
                    }
                case .failure(let err):
                    log("刷新失败", err)
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
                    log("刷新失败", err)
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

// 解决AppStorage无法解释数组的问题
extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
