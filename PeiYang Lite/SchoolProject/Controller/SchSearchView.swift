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
    @State private var inputMessage: String = ""
    
    @State var availableTags: [SchTagModel] = []
    
    var body: some View {
        VStack {
            SchSearchTopView(inputMessage: $inputMessage, historyArray: $historyArray)
            HStack {
                Text("历史记录")
                    .foregroundColor(.init(red: 98/255, green: 103/255, blue: 124/255))
                    .font(.custom("Avenir-Black", size: 17))
                Spacer()
                Button(action: {
                    
                }, label: {
                    Image("trash")
                })
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width * 0.9)
            VStack(spacing: 20){
                ForEach(historyArray, id: \.self) { s in
                    SchHistoryView(historyString: s)
                }
                Spacer()
            }
            .frame(height: UIScreen.main.bounds.height * 0.15)
            
            HStack {
                Text("标签搜索")
                    .foregroundColor(.init(red: 98/255, green: 103/255, blue: 124/255))
                    .font(.custom("Avenir-Black", size: 17))
                Spacer()
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width * 0.9)
            MutiLineVStack(source: $availableTags, content: { tag in
                Button(action: {
//                    self.availableTags.first(where: { t in t == tag }).isSelected?.toggle()
                }, label: {
                    Text("")
                })
            })
            
            .frame(width: UIScreen.main.bounds.width * 0.9)
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct SchSearchTableView_Previews: PreviewProvider {
    static var previews: some View {
        SchSearchView(availableTags: [
//            SchTagModel(id: 1, name: "哈哈哈", description: "这是个测试标签", children: nil),
//            SchTagModel(id: 2, name: "哈哈哈", description: "这是个测试标签", children: nil),
//            SchTagModel(id: 3, name: "哈哈哈", description: "这是个测试标签", children: nil),
//            SchTagModel(id: 4, name: "哈哈哈", description: "这是个测试标签", children: nil),
        ])
    }
}

struct SchSearchTopView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Binding var inputMessage: String
    @Binding var historyArray: [String]
    
    
    var body: some View {
        HStack {
            HStack {
                Image("search")
                TextField("搜索问题...", text: $inputMessage)
                    .foregroundColor(.init(red: 207/255, green: 208/255, blue: 213/255))
                
                Spacer()
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height / 20, alignment: .center)
            .background(Color.init(red: 236/255, green: 237/255, blue: 239/255))
            .cornerRadius(UIScreen.main.bounds.height / 40)
            
            
            Button(action: {
                if inputMessage == "" {
                    self.mode.wrappedValue.dismiss()
                } else {
                    if historyArray.count < 4 {
                        historyArray.insert(inputMessage, at: 0)
                    } else {
                        historyArray.removeLast()
                        historyArray.insert(inputMessage, at: 0)
                    }
                    inputMessage = ""
                }
                
            }, label: {
                Text((inputMessage == "") ? "取消" : "搜索")
                    .foregroundColor(.init(red: 98/255, green: 103/255, blue: 124/255))
            })
        }
    }
}

struct SchHistoryView: View {
    var historyString: String
    var body: some View {
        HStack{
            Text(historyString)
                .font(.subheadline)
                .foregroundColor(.init(red: 48/255, green: 60/255, blue: 102/255))
            Spacer()
            Image("SchArrow")
        }
        .padding(.horizontal)
        .frame(width: UIScreen.main.bounds.width * 0.9)
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
