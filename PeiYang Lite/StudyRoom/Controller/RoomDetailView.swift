//
//  RoomDetailView.swift
//  PeiYang Lite
//
//  Created by 游奕桁 on 2021/2/16.
//

import SwiftUI

struct RoomDetailView: View {
    @Binding var activeWeek: Int
    @ObservedObject var store = Storage.courseTable
    private var courseTable: CourseTable { store.object }
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State private var isShowCalender = false
    var className: String
    // 定位classroom
    var classData: Classroom
    /// 每一个元素会重复两次……
    @State var weekData: [String] = []
    
    /// 手动换算一下
//    var finalWeekData: [String] {
//        var returnFinalClassData: [String] = []
//        for i in stride(from: 0, to: weekData.count, by: 2) {
//            returnFinalClassData.append(weekData[i])
//        }
//        return returnFinalClassData
//    }
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                  }) {
                    Image("back-arrow")
                }

                Spacer()
                Button(action: {
                    isShowCalender.toggle()
                }, label: {
                    Image("calender")
                })
            }
            .frame(width: screen.width * 0.9)
            .padding(.top, 40)
            ForEach(weekData, id: \.self) { data in
                Text(data)
            }
            RoomDetailHeaderView(classroomId: classData.classroomID, className: className, activeWeek: activeWeek)
            /// Text Spacer()
            Spacer()
//            ScrollView(.vertical, showsIndicators: false) {
//                VStack {
//                    CourseTableWeekdaysView(
//                        activeWeek: $activeWeek,
//                        courseTable: courseTable,
//                        width: screen.width / 8
//                    )
//                    .padding(.leading, screen.width/16 + 7)
//                    .frame(width: screen.width, alignment: .center)
//
//                    StudyRoomContentView(
//                        activeWeek: activeWeek,
//                        courseArray: courseTable.courseArray, status: weekData,
//                        width: screen.width / 8
//                        )
//                    .frame(width: screen.width, height: screen.height*1.2, alignment: .top)
//                }
//                .padding(.horizontal, 10)
//            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isShowCalender,
               content: {
                CalendarView(isShowCalender: $isShowCalender)
                    .onDisappear(perform: {
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
                    })
        })
        .onAppear(perform: {
            var returnWeekData: [String] = ["", "", "", "", "", "", ""]
            if let saveweekData = DataStorage.retreive("studyroom/weekdata.json", from: .caches, as: [[StudyBuilding]].self) {
                for i in 0...6 {
                    for building in saveweekData[i]{
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
        })
    }
}



struct RoomDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RoomDetailView(activeWeek: .constant(16), className: "16教A208", classData: Classroom(classroomID: "303", classroom: "303", status: "001100110011"))
    }
}


struct RoomDetailHeaderView: View {
    var classroomId: String
    var className: String
    var activeWeek: Int
    
    @State private var AlertMessage: String = "网络出现问题"
    @State private var isShowAlert: Bool = false
    @State private var alertTimer: Timer?
    @State private var alertTime = 2
    
    enum favourType {
        case unFavour
        case favoured
        case wrong
    }
    @State var showTitle: String = "收藏"
    
    var body: some View {
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
                if (showTitle == "收藏"){
                    CollectionManager.addFavour(classroomID: classroomId) {result in
                        switch result {
                        case .success(let data):
                            AlertMessage = data.message
                            if(data.errorCode == 0) {
                                showTitle = "已收藏"
                            } else {
                                showTitle = "失败"
                                alertTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (time) in
                                    if self.alertTime < 1 {
                                        self.alertTime = 3
                                        time.invalidate()
                                        showTitle = "收藏"
                                    }
                                    self.alertTime -= 1
                                })
                            }
                        case .failure(_):
                            break
                        }
                    }
                    
                   
                    
                }
                else if (showTitle == "已收藏") {
                    CollectionManager.deleteFavour(classroomID: classroomId) { result in
                        switch result {
                        case .success(let data):
                            AlertMessage = data.message
                            if(data.errorCode == 0) {
                                showTitle = "收藏"
                            } else {
                                showTitle = "失败"
                                alertTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (time) in
                                    if self.alertTime < 1 {
                                        self.alertTime = 3
                                        time.invalidate()
                                        showTitle = "已收藏"
                                    }
                                    self.alertTime -= 1
                                })
                            }
                        case .failure(_):
                           break
                        }
                    }
                    
                }
            }) {
                Text(showTitle)
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)))
            }
            .disabled(showTitle == "失败")
        }
        .padding()
        .onAppear(perform: {
            if let saveCollectionClassId = DataStorage.retreive("studyroom/collections.json", from: .caches, as: [String].self) {
                for roomID in saveCollectionClassId {
                    if roomID == classroomId {
                        showTitle = "已收藏"
                    }
                }
            }
        })
    }
}
