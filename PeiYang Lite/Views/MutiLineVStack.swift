//
//  MutiLineVStack.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2021/3/7.
//

import SwiftUI

protocol MutiLineVStackDataSource: ObservableObject {
    associatedtype T
    var source: [T] { get set }
    
    func generateView(_ content: T) -> AnyView
}

struct MutiLineVStack<Model: Equatable, Content: View>: View {
    
    @Binding private var source: [Model]
    private let content: (Binding<Model>) -> Content
    
    init (source: Binding<[Model]>, @ViewBuilder content: @escaping (Binding<Model>) -> Content) {
        _source = source
        self.content = content
    }
    
    private var width = CGFloat.zero
    private var height = CGFloat.zero
    
    var body: some View {
        GeometryReader { g in
            ScrollView(.vertical) {
                generateContent(in: g)
            }
        }
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        // 结构体内不允许存在可变量 (主要是body的上下文不可变)
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(source.indices, id: \.self) { i in
                content($source[i])
                    .padding([.horizontal, .vertical], 10)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if source[i] == source.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if source[i] == source.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
    }
}

//struct MutiLineVStack_Previews: PreviewProvider {
//    static var previews: some View {
//        MutiLineVStack(source: ["单纯吐槽", "天外天", "教务处", "学工部", "后勤保障处", "体育部、场馆中心", "信网中心", "保卫处", "国际处", "研究生院", "科研院", "医科办", "人文社科处", "教工部、人事处", "基建处", "校工会", "离退处", "资产处", "校友与基金事务处", "招标办", "宣传部", "组织部", "党办校办", "保密办", "小幼医", "校团委", "档案馆", "图书馆"]) { (s) in
//            Text(s)
//                .padding()
//                .cornerRadius(15)
//                .background(Color.white)
////                .foregroundColor(.white)
//        }
//        .background(Color.black)
//    }
//}
