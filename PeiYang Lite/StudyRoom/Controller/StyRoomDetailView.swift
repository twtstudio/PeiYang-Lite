//
//  StyRoomDetailView.swift
//  PeiYang Lite
//
//  Created by 游奕桁 on 2021/2/16.
//

import SwiftUI

struct StyRoomDetailView: View {
    @Binding var activeWeek: Int
    @ObservedObject var store = Storage.courseTable
    private var courseTable: CourseTable { store.object }
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State private var isShowCalender = false
    @State var isFavoured: Bool = false
    var className: String
    // 定位classroom
    var classData: Classroom
    @State var weekData: [String] =  ["", "", "", "", "", "", ""]
    
    var body: some View {
        VStack {
            
            NavigationBar(leading: {
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                  }) {
                    Image("back-arrow")
                }
            }, trailing: {
                Button(action: {
                    isShowCalender.toggle()
                }, label: {
                    Image("calender")
                })
            })
            .frame(width: screen.width * 0.9)
           
            HStack(alignment: .firstTextBaseline) {
                Text(className)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)))
                
                Text("WEEK \(activeWeek.description)")
                    .font(.body)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button(action: {
                    
                    if (isFavoured == false){
                        StyCollectionManager.addFavour(classroomID: classData.classroomID) {result in
                            switch result {
                            case .success(let data):
                                if data.errorCode == 0 {
                                    isFavoured.toggle()
                                }
                            case .failure(let error):
                                log(error)
                            }
                        }
                    }
                    else if (isFavoured == true) {
                        StyCollectionManager.deleteFavour(classroomID: classData.classroomID) { result in
                            switch result {
                            case .success(let data):
                                if data.errorCode == 0 {
                                    isFavoured.toggle()
                                }
                            case .failure(let error):
                               log(error)
                            }
                        }
                        
                    }
                    
                }) {
                    Text(isFavoured ? "已收藏" : "收藏")
                        .font(.headline)
                        .bold()
                        .foregroundColor(Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)))
                }
            }
            .padding()
                .padding(.horizontal)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    CourseTableWeekdaysView(
                        activeWeek: $activeWeek,
                        courseTable: courseTable,
                        width: screen.width / 9.5 ,// 变成七天的手动
                        showCourseNum: 6
                    )
                    .padding(.leading, screen.width/16 + 7)
                    .frame(width: screen.width, alignment: .center)

                    StudyRoomContentView(
                        activeWeek: activeWeek,
                        courseArray: courseTable.courseArray, status: weekData,
                        width: screen.width / 9.5 // 变成七天的手动
                        )
                    .frame(width: screen.width, height: screen.height*1.2, alignment: .top)
                }
                .padding(.horizontal, 10)
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
        .edgesIgnoringSafeArea(.horizontal)
        .sheet(isPresented: $isShowCalender,
               content: {
                CalendarView(isShowCalender: $isShowCalender)
                    .onDisappear(perform: {
                        loadTodayOrNewWeekData()
                    })
        })
        .onAppear(perform: {
            loadTodayOrNewWeekData()
        })
        .addAnalytics(className: "StudyRoomDetailView")
    }
    
    func loadTodayOrNewWeekData() {
        var returnWeekData: [String] = ["", "", "", "", "", "", ""]
        if let saveweekData = DataStorage.retreive("studyroom/weekdata.json", from: .caches, as: [[StudyBuilding]].self) {
            for i in 0...6 {
                for building in saveweekData[i] {
                    for area in building.areas {
                        for room in area.classrooms {
                            if room.classroomID == classData.classroomID {
                                returnWeekData[i] = room.status
                                
                                break
                            }
                        }
                    }
                }
                if returnWeekData[i] == "" {
                    returnWeekData[i] = "111111111111"
                }
            }
        }
        weekData = returnWeekData
        
        if let saveCollectionClassId = DataStorage.retreive("studyroom/collections.json", from: .caches, as: [String].self) {
            for roomID in saveCollectionClassId {
                if roomID == classData.classroomID {
                    isFavoured = true
                }
            }
        }
    }
}



struct RoomDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StyRoomDetailView(activeWeek: .constant(16), className: "16教A208", classData: Classroom(classroomID: "303", classroom: "303", status: "001100110011"))
    }
}


//struct RoomDetailHeaderView: View {
//    var classroomId: String
//    var className: String
//    var activeWeek: Int
//
//
//    @State var isFavoured: Bool = false
//
//    var body: some View {
//        HStack(alignment: .firstTextBaseline) {
//            Text(className)
//                .font(.title)
//                .fontWeight(.bold)
//                .foregroundColor(Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)))
//
//            Text("WEEK \(activeWeek.description)")
//                .font(.body)
//                .fontWeight(.light)
//                .foregroundColor(.gray)
//
//            Spacer()
//
//            Button(action: {
//                if (isFavoured == false){
//                    StyCollectionManager.addFavour(classroomID: classroomId) {result in
//                        switch result {
//                        case .success(let data):
//
//                            if(data.errorCode == 0) {
//                                isFavoured = true
//                            }
//                        case .failure(_):
//                            break
//                        }
//                    }
//                }
//                else if (isFavoured == true) {
//                    CollectionManager.deleteFavour(classroomID: classroomId) { result in
//                        switch result {
//                        case .success(let data):
//                            if(data.errorCode == 0) {
//                                isFavoured = false
//                            }
//                        case .failure(_):
//                           break
//                        }
//                    }
//
//                }
//            }) {
//                Text(isFavoured ? "已收藏" : "收藏")
//                    .font(.headline)
//                    .bold()
//                    .foregroundColor(Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)))
//            }
//        }
//        .padding()
//        .onAppear(perform: {
//            if let saveCollectionClassId = DataStorage.retreive("studyroom/collections.json", from: .caches, as: [String].self) {
//                for roomID in saveCollectionClassId {
//                    if roomID == classroomId {
//                        isFavoured = true
//                    }
//                }
//            }
//        })
//    }
//}
