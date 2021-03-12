//
//  SchNewQuestionView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/24.
//

import SwiftUI

struct SchNewQuestionView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    private let color = Color.init(red: 48/255, green: 60/255, blue: 102/255)
    private let seperator = Color.init(red: 208/255, green: 209/255, blue: 214/255)
    private let textColor = Color.init(red: 208/255, green: 209/255, blue: 214/255)
    
    @ObservedObject private var textManager = TextFieldManager()
    @State private var images: [UIImage] = []
    
    @StateObject private var tagSource: SchTagSource = SchTagSource()
    
    @State private var question: String = ""
    
    private var tags: String {
        get {
            let t = tagSource.tags.reduce("", { $0 + (($1.isSelected ?? false) ? ("#" + ($1.name ?? "") + " ") : "")})
            return t + "(点击更改标签)"
        }
    }
    // 状态布尔
    @State private var isShowTagSelector = false
    @State private var isLoading = false
    @State private var titleDidChange = false
    @State private var detailDidChange = false
    
    // 报错
    @State private var noTagError = false
    @State private var submitError = false
    
    
    var body: some View {
        ZStack {
            VStack {
                // MARK: NavigationBar
                HStack {//MARK: NavigationBar
                    Button(action: {self.mode.wrappedValue.dismiss()}, label: {
                        Image("back-arrow")
                    })
                    
                    Spacer()
                    Text("新建提问")
                        .font(.title2)
                        .foregroundColor(color)
                    Spacer()
                    Image("back-arrow")
                        .opacity(0)
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)
                
                VStack {
                    HStack {
                        TextEditor(text: $textManager.title)
                            .foregroundColor(titleDidChange ? color : textColor)
                            .font(.title2)
                            .background(Color.clear)
                            .frame(height: UIScreen.main.bounds.height / 25, alignment: .center)
                            .onTapGesture {
                                if !titleDidChange {
                                    textManager.title = ""
                                    titleDidChange = true
                                }
                        }
                        Text("\(String(titleDidChange ? textManager.title.count : 0))/20")
                            .font(.footnote)
                            .foregroundColor(textColor)
                    }
                    
                    seperator.frame(width: UIScreen.main.bounds.width * 0.85, height: 1, alignment: .center)
                    
                    TextEditor(text: $textManager.detail)
                        .foregroundColor(detailDidChange ? color : textColor)
                        //                        .padding(.all)
                        .font(.body)
                        .onTapGesture {
                            if !detailDidChange {
                                detailDidChange = true
                                textManager.detail = ""
                            }
                        }
                    HStack {
                        Spacer()
                        Text("\(String(detailDidChange ? textManager.detail.count : 0))/200")
                            .font(.footnote)
                            .foregroundColor(textColor)
                    }
                    
                    // 图片选择
                    PhotoListView(images: $images, mode: .write)
                    
                    // 标签选择
                    HStack {
                        Text(tags)
                            .foregroundColor(color)
                            .onTapGesture {
                                if !tagSource.tags.isEmpty {
                                    isShowTagSelector = true
                                }
                            }
                        Spacer()
                    }
                    // sheet不能添加给全局
                    .sheet(isPresented: $isShowTagSelector, content: {
                        SchSelectTagView()
                            .environmentObject(tagSource)
                    })
                    
                    // 分割线
                    seperator.frame(width: UIScreen.main.bounds.width * 0.85, height: 1, alignment: .center)
                    
                    // 提交
                    Button(action: {
                        submitQuestion()
//                        isLoading = true
                    }, label: {
                        Text("提交")
                            .bold()
                            .foregroundColor(color)
                            .font(.title3)
                    })
                    .alert(isPresented: $noTagError, content: {
                        Alert(title: Text("您还未选择标签"))
                    })
                    
                    Text("")
                        .frame(width: 0, height: 0)
                        // emm 此为下策但是alert之间只能是平级
                        .alert(isPresented: $submitError, content: {
                            Alert(title: Text("问题提交失败"))
                        })
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.6, alignment: .center)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0.0, y: 0.0)
                Spacer()
                
            }
            .padding(.top, 40)
            .ignoresSafeArea(edges: .bottom)
            .background(
                Color.init(red: 247/255, green: 247/255, blue: 248/255)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                    .ignoresSafeArea()
            )
        }
        .onAppear {
            SchTagManager.tagGet { (result) in
                switch result {
                    case .success(let tags):
                        tagSource.tags = tags
                        
                        print("获取标签成功")
                    case .failure(let err):
                        print("获取标签错误", err)
                }
            }
        }
        .loading(style: .medium, isLoading: $isLoading)
    }
    
    func submitQuestion() {
        let tag = tagSource.tags.reduce(0, { $0 + (($1.isSelected ?? false) ? ($1.id ?? 0) : 0) })
        guard tag != 0 else {
            noTagError = true
            return
        }
        // 开始加载
        isLoading = true
        SchQuestionManager.postQuestion(title: textManager.title, content: textManager.detail, tagList: [tag]) { (result) in
            switch result {
                case .success(let questionId):
                    if !images.isEmpty {
                        let group = DispatchGroup()
                        
                        for i in 0..<images.count {
                            group.enter()
                            SchQuestionManager.postImg(img: images[i], question_id: questionId) { (result) in
                                switch result {
                                case .success(let str):
                                    print("上传图片成功", str)
                                    group.leave()
                                case .failure(let err):
                                    print(err)
                                    group.leave()
                                }
                            }
                        }
                        group.notify(queue: .main, work: DispatchWorkItem(block: {
                            isLoading = false
                            mode.wrappedValue.dismiss()
                            print("提交问题成功, id:", questionId)
                        }))
                    } else {
                        isLoading = false
                        mode.wrappedValue.dismiss()
                        print("提交问题成功, id:", questionId)
                    }
                case .failure(let err):
                    isLoading = false
                    submitError = true
                    print("提交问题失败", err)
            }
            
        }
    }
}

struct SchNewQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        SchNewQuestionView()
    }
}

fileprivate class TextFieldManager: ObservableObject {
    //MARK: character limit
    let titleLimit = 20
    let detailLimit = 200
    @Published var title: String = "输入问题" {
        didSet {
            if title.count > titleLimit {
                title = String(title.prefix(titleLimit))
            }
        }
    }
    @Published var detail: String = "问题详情" {
        didSet {
            if detail.count > detailLimit {
                detail = String(detail.prefix(detailLimit))
            }
        }
    }
}
