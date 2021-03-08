//
//  SearchAnsViews.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/27.
//

import SwiftUI
//MARK: History
struct SchHistorySectionView: View {
    let color = Color.init(red: 98/255, green: 103/255, blue: 124/255)
    @Binding var searchString: String
    @Binding var searchHistory: [String]
    var body: some View {
        VStack {
            HStack{
                Text("历史记录")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(color)
                Spacer()
                Button(action: {
                        searchHistory = []
                    UserDefaults.standard.removeObject(forKey: SharedMessage.studyRoomHistoryKey)
                    
                }, label: {
                    Image("trash")
                })
            }.padding()
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
            .frame(width: UIScreen.main.bounds.width * 0.9)
        }
    }
    private func generateContent(in g: GeometryProxy) -> some View {
            var width = CGFloat.zero
            var height = CGFloat.zero

            return ZStack(alignment: .topLeading) {
                ForEach(self.searchHistory, id: \.self) { platform in
                    self.item(for: platform)
                        .padding([.horizontal, .vertical], 10)
                        .alignmentGuide(.leading, computeValue: { d in
                            if (abs(width - d.width) > g.size.width)
                            {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            if platform == self.searchHistory.last! {
                                width = 0 //last item
                            } else {
                                width -= d.width
                            }
                            return result
                        })
                        .alignmentGuide(.top, computeValue: {d in
                            let result = height
                            if platform == self.searchHistory.last! {
                                height = 0 // last item
                            }
                            return result
                        })
                }
            }
        }

        func item(for text: String) -> some View {
            Button(action: {searchString = text}, label: {
                Text(text)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .font(.subheadline)
                    .background(Color.white)
                    .foregroundColor(color)
                    .cornerRadius(20)
            })
            
        }
}

//MARK: Building + Class
struct SearchBuildingAndClassView: View {
    let color = Color.init(red: 98/255, green: 103/255, blue: 124/255)
    var title: String
    var isFree: Bool
    var body: some View {
        HStack{
            Text(title)
                .fontWeight(.heavy)
                .foregroundColor(color)
            Spacer()
            if(isFree) {
                Color.green
                    .frame(width: UIScreen.main.bounds.width / 50, height: UIScreen.main.bounds.width / 50, alignment: .center)
                    .cornerRadius(UIScreen.main.bounds.width / 100)
            } else {
                Color.red
                    .frame(width: UIScreen.main.bounds.width / 50, height: UIScreen.main.bounds.width / 50, alignment: .center)
                    .cornerRadius(UIScreen.main.bounds.width / 100)
            }
            
            Text(isFree ? "空闲" : "占用")
                .font(.footnote)
                .fontWeight(.heavy)
                .foregroundColor(isFree ? .green : .red)
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 20, alignment: .center)
        .background(Color.white)
        .cornerRadius(15)
    }
}

//MARK: Building
struct SearchBuildingSectionView: View {
    var title: String
    var section: String
    var imageId = Int(arc4random_uniform(3))
    var backImg: Image{
        switch imageId {
        case 0:
            switch section {
            case "A":
                return Image("A-deep")
            case "B":
                return Image("B-deep")
            case "C":
                return Image("C-deep")
            default:
                return Image("A-deep")
            }
        case 1:
            switch section {
            case "A":
                return Image("A-blue")
            case "B":
                return Image("B-blue")
            case "C":
                return Image("C-blue")
            default:
                return Image("A-blue")
            }
        default:
            switch section {
            case "A":
                return Image("A-light")
            case "B":
                return Image("B-light")
            case "C":
                return Image("C-light")
            default:
                return Image("A-light")
            }
        }
        
    }
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.heavy)
            .frame(width: UIScreen.main.bounds.width / 3.5, height: UIScreen.main.bounds.width / 4, alignment: .center)
            .foregroundColor(.white)
            .background(
                backImg
                    .resizable()
                    .scaledToFit()
            )
            .padding(10)
    }
}

struct SearchBuildingView: View {
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 123/255)
    
    var title: String
    var body: some View {
        VStack(spacing: 5) {
            Image("building")
                .resizable()
                .scaledToFit()
                .frame(width:UIScreen.main.bounds.width / 8)
            Text(title)
                .font(.custom("HelveticaNeue-Bold", size: UIScreen.main.bounds.height / 60))
                .foregroundColor(themeColor)
            
        }
        
    }
}
