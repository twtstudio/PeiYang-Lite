//
//  HomeStudyRoomSectionView.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2020/12/25.
//

import SwiftUI

struct HomeStudyRoomSectionView: View {
    let formatter = DateFormatter()
    var endDate: Date{
        formatter.dateFormat = "YYYYMMdd"
        return formatter.date(from: "20210301")!
    }
    var totalDays: Int {
        endDate.daysBetweenDate(toDate: Date())
    }
    var todayWeek: Int {
        totalDays / 7 + 1
    }
    var todayDay: Int {
        totalDays % 7 + 1
    }
    var nowTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date())
    }
    
    // 计算现在的时间处于哪个时间段
    var nowPeriod: Int {
        if nowTime.prefix(2) < "10" && nowTime.prefix(2) >= "00" || (nowTime.prefix(2) == "10" && nowTime.suffix(2) < "05"){
            return 0
        }
        else if nowTime.prefix(2) > "10" && nowTime.prefix(2) < "12" || (nowTime.prefix(2) == "10" && nowTime.suffix(2) >= "05"){
            return 2
        }
        else if nowTime.prefix(2) >= "12" && nowTime.prefix(2) < "15" || (nowTime.prefix(2) == "15" && nowTime.suffix(2) <= "05"){
            return 4
        }
        else if nowTime.prefix(2) > "15" && nowTime.prefix(2) < "17" || (nowTime.prefix(2) == "15" && nowTime.suffix(2) > "05") {
            return 6
        }
        else if nowTime.prefix(2) >= "17" && nowTime.prefix(2) < "20" || (nowTime.prefix(2) == "20" && nowTime.suffix(2) <= "05"){
            return 8
        }
        else {return 10}
    }
    
    @State var isGetCollectionData: Bool = false

    
    // 收藏
    @State var getCollectionClassId: [String] = []
    @State var collectionClass: [CollectionClass] = []
    @State var buildings: [StudyBuilding] = []

    
    var body: some View {
        if getCollectionClassId == [] {
            NavigationLink(destination: StudyRoomTopView()) {
                Text("还没有get到您的收藏")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
        }
        
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack(spacing: 20) {
                ForEach(collectionClass, id: \.self) { collectionclass in
                    NavigationLink(
                        destination: StudyRoomTopView(),
                        label: {
                            StudyRoomBuildingCardView(buildingName: collectionclass.buildingName, className: collectionclass.classMessage.classroom, isFree: collectionclass.classMessage.status[nowPeriod] == "0", classData: collectionclass.classMessage)
                        })
                   
                    
                }
            }
        }).padding()

        .onAppear(perform: {
            
            StudyRoomManager.allBuidlingGet(term: "20212", week: String(todayWeek), day: String(todayDay)) { result in
                switch result {
                case .success(let data):
                    buildings = data.data
                    if(data.errorCode == 0) {
                        isGetCollectionData = true
                        requestDataToUseData()
                        break
                    } else{
                        isGetCollectionData = false
                    }
                case .failure(let error):
                    isGetCollectionData = false
                    log(error)
                }
            }
            
        })
    }
    func requestDataToUseData() {
        collectionClass = []
        CollectionManager.getCollections() { result in
            switch result {
            case .success(let data):
                getCollectionClassId = data.data.classroomID ?? []
                DataStorage.store(getCollectionClassId, in: .caches, as: "studyroom/collections.json")
                for code in getCollectionClassId {
                    for building in buildings {
                        for area in building.areas {
                            for room in area.classrooms {
                                if(room.classroomID == code) {
                                    collectionClass.append(CollectionClass(classMessage: room, buildingName: building.building))
                                }
                            }
                        }
                    }
                }
            case .failure(_):
                break
            }
        }
    }

}


struct HomeStudyRoomSectionView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStudyRoomSectionView()
    }
}
