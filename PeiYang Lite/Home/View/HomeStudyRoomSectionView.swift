//
//  HomeStudyRoomSectionView.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2020/12/25.
//

import SwiftUI

struct HomeStudyRoomSectionView: View {
    let studyRooms = [
        StudyRoom(image: Image("StudyRoomIcon"),building: "47", number: "a201", isAvailable: true),
        StudyRoom(image: Image("StudyRoomIcon"),building: "47", number: "a201", isAvailable: false),
        StudyRoom(image: Image("StudyRoomIcon"),building: "47", number: "a201", isAvailable: true),
        StudyRoom(image: Image("StudyRoomIcon"),building: "47", number: "a201", isAvailable: false),
        StudyRoom(image: Image("StudyRoomIcon"),building: "47", number: "a201", isAvailable: true),
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack {
                ForEach(studyRooms) { room in
                    NavigationLink(
                        destination: StudyRoomTopView(),
                        label: {
                            VStack {
                                room.image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: screen.width/15)
                                
                                Text(room.description)
                                    .font(.body)
                                    .bold()
                                    .foregroundColor(Color(#colorLiteral(red: 0.4156862745, green: 0.4274509804, blue: 0.4901960784, alpha: 1)))
                                    .padding(.vertical)
//                                    .fitToWidth(1.2)
                                HStack {
                                    Circle()
                                        .fill()
                                        .frame(width: 10, height: 10)
                                    Text(room.isAvailable ? "空闲" : "占用")
                                }
                                .foregroundColor(room.isAvailable ? .green : .red)
                            }
                            .padding()
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        })
                        .frame(width: screen.width * 0.3)
                }
                .padding(10)
            }
            .frame(height: screen.width * 0.45)
        })
    }
}


struct HomeStudyRoomSectionView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStudyRoomSectionView()
    }
}
