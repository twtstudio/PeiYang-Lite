//
//  SchNewQuestionView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/24.
//

import SwiftUI

struct SchNewQuestionView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    let color = Color.init(red: 48/255, green: 60/255, blue: 102/255)
    let seperator = Color.init(red: 208/255, green: 209/255, blue: 214/255)
    let textColor = Color.init(red: 208/255, green: 209/255, blue: 214/255)
    @ObservedObject var bodyText = TextFieldManager()
    @State var question: String = ""
    
    @State var tags: String = "#天外天 (点击更改标签)"
    @State var isShowTags = false
    
    
    var body: some View {
        ZStack {
            VStack {
                HStack {//MARK: NavigationBar
                    Button(action: {self.mode.wrappedValue.dismiss()}, label: {
                        Image("back-arrow")
                    })
                    
                    Spacer()
                    Text("新建提问")
                        .foregroundColor(color)
                    Spacer()
                    Image("back-arrow")
                        .opacity(0)
                }// NavigationBar
                .frame(width: UIScreen.main.bounds.width * 0.9)
                
                
                
                VStack{
//                    HStack {
//                        Text("下方输入标题")
//                            .font(.title2)
//                            .fontWeight(.bold)
//                            .foregroundColor(textColor)
//                        Spacer()
//                        Text("\(String(bodyText.labelTitle.count))/200")
//                            .font(.footnote)
//                            .foregroundColor(textColor)
//                    }
                    ZStack(alignment: .leading) {
                        TextEditor(text: $bodyText.title)
                            .foregroundColor(color)
                            .font(.title2)
                            .background(Color.clear)
                        if bodyText.title.isEmpty {
                            Text("输入问题")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(textColor)
                                .padding(.leading)
                                .padding(.bottom, 5)
                                .contentShape(Circle())
                                .onTapGesture {
                                    
                                }
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height / 25, alignment: .center)
                    
                    seperator.frame(width: UIScreen.main.bounds.width * 0.85, height: 1, alignment: .center)
                    
                    ZStack(alignment: .leading) {
                        TextEditor(text: $bodyText.detail)
                            .foregroundColor(color)
//                            .padding(.all)
                            .font(.body)
                        if bodyText.detail.isEmpty {
                            VStack {
                                Text("问题详情...")
                                    .padding(.leading)
                                    .foregroundColor(textColor)
                                    .font(.body)
                                Spacer()
                            }
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Text("\(String(bodyText.detail.count))/200")
                            .font(.footnote)
                            .foregroundColor(textColor)
                    }
                    
                    HStack {
                        Text(tags)
                            .foregroundColor(color)
                            .onTapGesture {
                                self.isShowTags.toggle()
                            }
                        Spacer()
                    }
                    
                    Spacer()
                    
                    
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.5, alignment: .center)
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
            Color.black.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                .ignoresSafeArea()
                    .opacity(isShowTags ? 0.3 : 0)
                .animation(.easeInOut)
            
                TagsView(isShowTags: $isShowTags)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                    .offset(y: isShowTags ? 250 : 1000)
                    .animation(.easeInOut)
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
    let characterLimit = 200
    @Published var title: String = "" {
        didSet {
            if title.count > characterLimit {
                title = String(title.prefix(characterLimit))
            }
        }
    }
    @Published var detail: String = "" {
        didSet {
            if detail.count > characterLimit {
                detail = String(detail.prefix(characterLimit))
            }
        }
    }
}
