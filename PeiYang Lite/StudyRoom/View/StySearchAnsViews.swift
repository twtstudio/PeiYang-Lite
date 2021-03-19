//
//  StySearchAnsViews.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/27.
//

import SwiftUI
//MARK: History
struct StyHistorySectionView: View {
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
                    Image("sch-trash")
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
struct StySearchBuildingAndClassView: View {
    @EnvironmentObject var sharedMessage: SharedMessage
    let color = Color.init(red: 98/255, green: 103/255, blue: 124/255)
    let diameter = UIScreen.main.bounds.width / 50
    var title: String
    @State var periodsFree: Bool = true
    @State var indexArray: [Int] = []
    var classData: Classroom
    var body: some View {
        HStack{
            Text(title)
                .fontWeight(.heavy)
                .foregroundColor(color)
            Spacer()
            if indexArray == [] {
                Color.gray
                    .frame(width: diameter, height: diameter, alignment: .center)
                    .cornerRadius(diameter / 2)
                
                Text("未选择时间段")
                    .font(.footnote)
                    .fontWeight(.heavy)
                    .foregroundColor(.gray)
            } else {
                if(periodsFree) {
                    Color.green
                        .frame(width: diameter, height: diameter, alignment: .center)
                        .cornerRadius(diameter / 2)
                } else {
                    Color.red
                        .frame(width: diameter, height: diameter, alignment: .center)
                        .cornerRadius(diameter / 2)
                }
                
                Text(periodsFree ? "空闲" : "占用")
                    .font(.footnote)
                    .fontWeight(.heavy)
                    .foregroundColor(periodsFree ? .green : .red)
            }
           
            
            
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 20, alignment: .center)
        .background(Color.white)
        .cornerRadius(15)
        .onAppear(perform: {
            if(sharedMessage.studyRoomSelectPeriod != []) {
                turnPeriodToIndex()
                for i in indexArray {
                    if classData.status[i] == "1" {
                        periodsFree = false
                        break
                    }
                }
            }
        })
    }
    func turnPeriodToIndex() {
        for period in sharedMessage.studyRoomSelectPeriod {
            switch period {
            case "8:30--10:05":
                indexArray.append(0)
            case "10:25--12:00":
                indexArray.append(2)
            case "13:30--15:05":
                indexArray.append(4)
            case "15:25--17:00":
                indexArray.append(6)
            case "18:30--20:05":
                indexArray.append(8)
            case "20:25--22:00":
                indexArray.append(10)
            default:
                indexArray.append(-1)
            }
        }
    }
}

//MARK: Building
struct StySearchBuildingSectionView: View {
    var title: String
    var section: String
    var backImg: Image{
        switch section {
        case "A":
            return Image("A-deep")
        case "B":
            return Image("B-light")
        case "C":
            return Image("C-blue")
        default:
            return Image("D-deep")
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

struct StySearchBuildingView: View {
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
