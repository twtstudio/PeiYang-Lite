//
//  SchSearchTableView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/23.
//

import SwiftUI

struct SchSearchTableView: View {
    @State private var inputMessage: String = ""
    @State var historyArray: [String] = []
    @State var labelsArray = ["单纯吐槽", "天外天", "教务处", "学工部", "后勤保障处", "体育部、场馆中心", "信网中心", "保卫处", "国际处", "研究生院", "科研院", "医科办", "人文社科处", "教工部、人事处", "基建处", "校工会", "离退处", "资产处", "校友与基金事务处", "招标办", "宣传部", "组织部", "党办校办", "保密办", "小幼医", "校团委", "档案馆", "图书馆"]
    var body: some View {
        VStack {
            SchSearchTopView(inputMessage: $inputMessage, historyArray: $historyArray)
            HStack {
                Text("历史记录")
                    .foregroundColor(.init(red: 98/255, green: 103/255, blue: 124/255))
                    .font(.custom("Avenir-Black", size: 17))
                Spacer()
                Button(action: {self.historyArray = []}, label: {
                    Image("trash")
                })
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width * 0.9)
            VStack(spacing: 20){
                ForEach(historyArray, id: \.self) { item in
                    SchHistoryView(historyName: item)
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
            
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
            .frame(width: UIScreen.main.bounds.width * 0.9)
            Spacer()
        }
        .navigationBarHidden(true)
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
            var width = CGFloat.zero
            var height = CGFloat.zero

            return ZStack(alignment: .topLeading) {
                ForEach(self.labelsArray, id: \.self) { platform in
                    self.item(for: platform)
                        .padding([.horizontal, .vertical], 10)
                        .alignmentGuide(.leading, computeValue: { d in
                            if (abs(width - d.width) > g.size.width)
                            {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            if platform == self.labelsArray.last! {
                                width = 0 //last item
                            } else {
                                width -= d.width
                            }
                            return result
                        })
                        .alignmentGuide(.top, computeValue: {d in
                            let result = height
                            if platform == self.labelsArray.last! {
                                height = 0 // last item
                            }
                            return result
                        })
                }
            }
        }

        func item(for text: String) -> some View {
            Button(action: {}, label: {
                Text(text)
                    .padding(.all, 10)
                    .font(.subheadline)
                    .background(Color.init(red: 238/255, green: 238/255, blue: 238/255))
                    .foregroundColor(Color.init(red: 98/255, green: 103/255, blue: 144/255))
                    .cornerRadius(30)
            })
            
        }
}

struct SchSearchTableView_Previews: PreviewProvider {
    static var previews: some View {
        SchSearchTableView()
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
                if(inputMessage == "") {
                    self.mode.wrappedValue.dismiss()
                } else {
                    if(historyArray.count < 4) {
                        historyArray.insert(inputMessage, at: 0)
                    } else {
                        historyArray.remove(at: 3)
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
    var historyName: String
    var body: some View {
        HStack{
            Text(historyName)
                .font(.subheadline)
                .foregroundColor(.init(red: 48/255, green: 60/255, blue: 102/255))
            Spacer()
            Image("SchArrow")
        }
        .padding(.horizontal)
        .frame(width: UIScreen.main.bounds.width * 0.9)
    }
}
