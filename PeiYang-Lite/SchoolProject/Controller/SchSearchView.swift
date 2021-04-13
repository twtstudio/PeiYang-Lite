//
//  SchSearchTableView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/23.
//

import SwiftUI
import Introspect

struct SchSearchView: View {
    // 历史记录本地存储
    static let historyKey = "SCH_SEARCH_HISTORY_KEY"
    @AppStorage(SchSearchView.historyKey, store: Storage.defaults) var historyArray: [String] = []

    @StateObject private var searchModel: SchSearchResultViewModel = .init()
    
    @State private var isSearching: Bool = false
    @State private var placeholder: String = "搜索问题..."
    
    var body: some View {
        VStack {
            SchSearchTopView(placeholder: $placeholder, inputMessage: $searchModel.searchString, historyArray: $historyArray, isSearching: $isSearching)
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
                        .frame(width: screen.width * 0.9)
                        
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
                        .frame(width: screen.width * 0.9)
                        
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
                    .frame(width: screen.width * 0.9)
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
        .background(
            Color(#colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1))
                .ignoresSafeArea()
                .frame(width: screen.width, height: screen.height)
        )
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .addAnalytics(className: "SchoolProjectSearchView")
    }
    
    private func generateView(_ g: GeometryProxy) -> some View {
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        return ZStack(alignment: .topLeading) {
            ForEach(searchModel.tags.indices, id: \.self) { i in
                Button(action: {
                    if let idx = Array(searchModel.tags.indices).firstIndex(where: { searchModel.tags[$0].isSelected ?? false }) {
                        if idx != i {
                            searchModel.tags[idx].isSelected?.toggle()
                        }
                    }
                    searchModel.tags[i].isSelected?.toggle()
                    searchModel.reloadData()
                    self.placeholder = "直接搜索可以查看标签相关问题"
                }, label: {
                    SchTagView(model: $searchModel.tags[i])
                })
                .padding([.horizontal, .vertical], 10)
                .alignmentGuide(.leading, computeValue: { d in
                    if (abs(width - d.width) > g.size.width)
                    {
                        width = 0
                        height -= d.height
                    }
                    let result = width
                    if searchModel.tags[i] == searchModel.tags.last! {
                        width = 0 //last item
                    } else {
                        width -= d.width
                    }
                    return result
                })
                .alignmentGuide(.top, computeValue: {d in
                    let result = height
                    if searchModel.tags[i] == searchModel.tags.last! {
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
    @Binding var placeholder: String
    @Binding var inputMessage: String
    @Binding var historyArray: [String]
    @Binding var isSearching: Bool
    @EnvironmentObject var searchModel: SchSearchResultViewModel
    
    @State private var navigateToResult: Bool = false
    
    var body: some View {
        HStack {
            HStack {
                Image("search")
                XTextField(placeholder: $placeholder, inputMessage: $inputMessage, returnKeyType: .done) { (_) in
                    searchQuestion()
                }
                .foregroundColor(inputMessage.isEmpty ? .init(red: 207/255, green: 208/255, blue: 213/255) : Color.black)
                Spacer()
            }
            .padding()
            .frame(width: screen.width * 0.8, height: screen.height / 20, alignment: .center)
            .background(Color.init(red: 236/255, green: 237/255, blue: 239/255))
            .cornerRadius(screen.height / 40)
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
        guard !inputMessage.isEmpty || searchModel.tags.reduce(false, { $0 || $1.isSelected ?? false }) else { return }
        if !historyArray.contains(inputMessage) && !inputMessage.isEmpty {
            historyArray.insert(inputMessage, at: 0)
            if historyArray.count > 4 {
                historyArray.removeLast()
            }
        }
        isSearching = true
        hideKeyboard()
    }
    
    private struct XTextField: UIViewRepresentable {
        @Binding var placeholder: String
        @Binding var inputMessage: String
        var returnKeyType: UIReturnKeyType
        var onCommit: (UITextField) -> Void
        
        func makeUIView(context: Context) -> UITextField {
            let textField = UITextField(frame: .zero)
            textField.placeholder = placeholder
            textField.returnKeyType = self.returnKeyType
            textField.text = inputMessage
            textField.delegate = context.coordinator
            
            return textField
        }
        
        func updateUIView(_ uiView: UITextField, context: Context) {
            uiView.text = inputMessage
            uiView.placeholder = placeholder
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, UITextFieldDelegate {
            var parent: XTextField
            
            init(_ parent: XTextField) {
                self.parent = parent
            }
            
            func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                if let currentValue = textField.text as NSString? {
                    let proposedValue = currentValue.replacingCharacters(in: range, with: string)
                    parent.inputMessage = proposedValue
                }
                return true
            }
            
            func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                parent.onCommit(textField)
                textField.resignFirstResponder()
                return true
            }
        }
    }
}

fileprivate class SchSearchResultViewModel: SchQuestionScrollViewModel, SchQuestionScrollViewDataSource, SchQuestionScrollViewAction {
    @Published var questions: [SchQuestionModel] = []
    
    @Published var isReloading: Bool = false
    
    @Published var isLoadingMore: Bool = false
    
    @Published var page: Int = 0
    
    @Published var maxPage: Int = 0
    
    @Published var tags: [SchTagModel] = []
    
    private var selectedTags: [SchTagModel] {
        if tags.reduce(false, { $0 || ($1.isSelected ?? false) }) {
            return [tags.first(where: { ($0.isSelected ?? false) })!]
        } else {
            return tags
        }
    }
    
    @Published var searchString: String = "" {
        didSet {
            self.reloadData()
        }
    }
    
    init() {
        SchTagManager.tagGet { (result) in
            switch result {
                case .success(let tags):
                    self.tags = tags
                case .failure(let err):
                    log("获取标签失败", err)
            }
        }
    }
    
    func reloadData() {
        page = 1
        SchQuestionManager.searchQuestions(tags: selectedTags, string: searchString, page: page) { (result) in
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
        SchQuestionManager.searchQuestions(tags: selectedTags, string: searchString, page: page) { (result) in
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
