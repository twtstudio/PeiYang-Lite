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
    
    @EnvironmentObject var tagSource: SchTagSource
    private var tagDescription: String {
        for tag in tagSource.tags {
            if tag.isSelected ?? false {
                return tag.description ?? ""
            }
        }
        return ""
    }
    
    
    
    var body: some View {
        VStack(spacing: 10) {
            Text("添加标签")
                .padding(.top)
                .font(.title2)
                .foregroundColor(color)
            Text(tagDescription)
                .frame(width: screen.width * 0.8)
                .font(.footnote)
                .foregroundColor(color)
            
            GeometryReader { g in
                ScrollView {
                    generateView(g)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.9)
            Spacer()
        }
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

struct SchQuestionTagView_Previews: PreviewProvider {
    static var previews: some View {
        SchSelectTagView()
            .environmentObject(SchTagSource())
    }
}




struct SchTagView: View {
    @Binding var model: SchTagModel
    
    var body: some View {
        Text(model.name ?? "")
            .padding(.all, 10)
            .font(.subheadline)
            .background((model.isSelected ?? false) ? Color.init(red: 98/255, green: 103/255, blue: 124/255) : Color.init(red: 238/255, green: 238/255, blue: 238/255) )
            .foregroundColor((model.isSelected ?? false) ? .white : Color.init(red: 98/255, green: 103/255, blue: 144/255))
            .cornerRadius(30)
    }
    
}
