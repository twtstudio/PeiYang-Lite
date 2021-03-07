//
//  SchSelectTagView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/25.
//

import SwiftUI

struct SchSelectTagView: View {
    
    let color = Color.init(red: 48/255, green: 60/255, blue: 102/255)
    
    @State private var tagIntro: String = ""
    
    @Binding var availableTags: [SchTagModel]
    
    var body: some View {
        VStack(spacing: 10) {
            Text("添加标签")
                .padding(.top)
                .font(.title2)
                .foregroundColor(color)
            Text("这一行能添加的小字号的部门介绍的字数上限大概有25~30个字dawdawdawdawdaw")
                .frame(width: screen.width * 0.8)
                .font(.footnote)
                .foregroundColor(color)
            
            MutiLineVStack(source: $availableTags, content: { tag in
                Button(action: {
                    if let idx = self.availableTags.firstIndex(of: tag.wrappedValue) {
                        self.availableTags[idx].isSelected = true
                    }
                }, label: {
                    SchTagView(model: tag)
                })
            })
            .frame(width: UIScreen.main.bounds.width * 0.9)
            Spacer()
        }
    }
}

//struct SchQuestionTagView_Previews: PreviewProvider {
//    static var previews: some View {
//        SchSelectTagView(availableTags: .constant([]))
//    }
//}




struct SchTagView: View {
    @Binding var model: SchTagModel
    private var isSelected: Bool {
        get { return model.isSelected ?? false }
    }
    
    var body: some View {
        Text(model.name ?? "")
            .padding(.all, 10)
            .font(.subheadline)
            .background(isSelected ? Color.init(red: 98/255, green: 103/255, blue: 124/255) : Color.init(red: 238/255, green: 238/255, blue: 238/255) )
            .foregroundColor(isSelected ? .white : Color.init(red: 98/255, green: 103/255, blue: 144/255))
            .cornerRadius(30)
        Text((model.isSelected ?? false) ? "1" : "2" )
    }
    
}
