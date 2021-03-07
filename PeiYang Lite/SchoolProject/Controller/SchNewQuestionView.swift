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
    
    @ObservedObject private var bodyText = TextFieldManager()
    @State private var images: [UIImage] = []
    @State private var availableTags: [SchTagModel] = []
    
    @State private var question: String = ""
    
    @State private var tags: String = "#天外天 (点击更改标签)"
    // 状态布尔
    @State private var isShowTags = false
    @State private var titleDidChange = false
    @State private var detailDidChange = false
    
    
    
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
                
                VStack{
                    HStack {
                        TextEditor(text: $bodyText.title)
                            .foregroundColor(titleDidChange ? color : textColor)
                            .font(.title2)
                            .background(Color.clear)
                            .frame(height: UIScreen.main.bounds.height / 25, alignment: .center)
                            .onTapGesture {
                                if !titleDidChange {
                                    bodyText.title = ""
                                    titleDidChange = true
                                }
                        }
                        Text("\(String(titleDidChange ? bodyText.title.count : 0))/20")
                            .font(.footnote)
                            .foregroundColor(textColor)
                    }
                    
                    seperator.frame(width: UIScreen.main.bounds.width * 0.85, height: 1, alignment: .center)
                    
                    TextEditor(text: $bodyText.detail)
                        .foregroundColor(detailDidChange ? color : textColor)
                        //                        .padding(.all)
                        .font(.body)
                        .onTapGesture {
                            if !detailDidChange {
                                detailDidChange = true
                                bodyText.detail = ""
                            }
                        }
                    HStack {
                        Spacer()
                        Text("\(String(detailDidChange ? bodyText.detail.count : 0))/200")
                            .font(.footnote)
                            .foregroundColor(textColor)
                    }
                    
                    PhotoListView(images: $images)
                    
                    HStack {
                        Text(tags)
                            .foregroundColor(color)
                            .onTapGesture {
                                self.isShowTags = true
                            }
                        Spacer()
                    }
                    
                    Spacer()
                    
                    seperator.frame(width: UIScreen.main.bounds.width * 0.85, height: 1, alignment: .center)
                    Button(action: {
                        
                    }, label: {
                        Text("提交")
                            .bold()
                            .foregroundColor(color)
                            .font(.title3)
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
            .sheet(isPresented: $isShowTags, content: {
                SchSelectTagView(availableTags: $availableTags)
            })
        }
        .onAppear {
            SchTagManager.tagGet { (result) in
                switch result {
                    case .success(let tags):
                        availableTags = tags
                    case .failure(let err):
                        print("获取标签错误", err)
                }
            }
        }
        
    }
}

struct SchNewQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        SchNewQuestionView()
    }
}

class TextFieldManager: ObservableObject {
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
