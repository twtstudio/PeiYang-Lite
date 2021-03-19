//
//  HomeModuleSectionView.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2020/12/25.
//

import SwiftUI

struct HomeModuleSectionView: View {
    
    let modules: [Module] = [
        Module(image: Image("CourseTableIcon"), title: "课程表", destination: .courseTable),
        Module(image: Image("GPAIcon"), title: "GPA", destination: .GPA),
//        Module(image: Image("YelloPageIcon"), title: "黄页", destination: .yellowPage),
        Module(image: Image("StudyRoomIcon"), title: "自习室", destination: .studyRoom),
        
    ]
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(modules, id: \.title) { module in
                    NavigationLink(destination: SelectedDetailView(selected: module.destination)) {
                            VStack(alignment: .center) {
                                module.image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: screen.width/15)
                                
                                Text(module.title)
                                    .font(.body)
                                    .bold()
                                    .foregroundColor(Color(#colorLiteral(red: 0.8071657419, green: 0.8116033673, blue: 0.833268702, alpha: 1)))
                                    .padding(.top, 8)
                                
                            }
                            .frame(width: screen.width/3.5, height: screen.width/6)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                }
                .padding(.leading, 10)
            }
            .frame(height: screen.width * 0.4)
        }
    }
}

struct HomeModuleSectionView_Previews: PreviewProvider {
    static var previews: some View {
        HomeModuleSectionView()
    }
}
