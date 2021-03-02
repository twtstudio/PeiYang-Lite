//
//  TagsView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/25.
//

import SwiftUI

struct TagsView: View {
    @Binding var isShowTags: Bool
    let color = Color.init(red: 48/255, green: 60/255, blue: 102/255)
    
    var labelsArray = ["单纯吐槽", "天外天", "教务处", "学工部", "后勤保障处", "体育部、场馆中心", "信网中心", "保卫处", "国际处", "研究生院", "科研院", "医科办", "人文社科处", "教工部、人事处", "基建处", "校工会", "离退处", "资产处", "校友与基金事务处", "招标办", "宣传部", "组织部", "党办校办", "保密办", "小幼医", "校团委", "档案馆", "图书馆"]
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("确定")
                    .opacity(0)
                Spacer()
                Text("添加标签")
                    .font(.title2)
                    .foregroundColor(color)
                Spacer()
                Button(action: {isShowTags.toggle()}, label: {
                    Text("确定")
                        .foregroundColor(color)
                        .fontWeight(.bold)
                })
            }
            Text("这一行能添加的小字号的部门介绍的字数上限大概有25~30个字")
                .font(.footnote)
                .foregroundColor(color)
            
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    self.generateContent(in: geometry)
                    
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.9)
            Spacer()
        }.padding()
        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height)
        
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
                tagView(text: text)
            })
            
        }

}



struct tagView: View {
    @State var isSelected: Bool = false
    var text: String
    var body: some View {
        Button(action: {isSelected.toggle()}, label: {
            Text(text)
                .padding(.all, 10)
                .font(.subheadline)
                .background(isSelected ? Color.init(red: 98/255, green: 103/255, blue: 124/255) : Color.init(red: 238/255, green: 238/255, blue: 238/255) )
                .foregroundColor(isSelected ? .white : Color.init(red: 98/255, green: 103/255, blue: 144/255))
                .cornerRadius(30)
        })
    }
    
}
