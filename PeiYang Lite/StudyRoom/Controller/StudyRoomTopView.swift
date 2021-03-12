//
//  StudyRoomTopView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/1/30.
//

import SwiftUI
import Foundation

struct StudyRoomTopView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var sharedMessage: SharedMessage
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 123/255)
    
    //是否获取教室信息
    @State var isGetStudyRoomBuildingMessage = false
    
    // 学区选择
    let schoolDistricts: [String] = ["卫津路校区", "北洋园校区"]
    @AppStorage(SharedMessage.schoolDistrictKey, store: Storage.defaults) private var schoolDistrict = 0
    
    // 搜索栏跳转State
    @State var isShowSearch = false

    // 日历有关
    @State private var isShowCalender = false
    var selectedDateStr: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: sharedMessage.studyRoomSelectDate)
    }
    var nowTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date())
    }
    
    
    // 教学楼储存数组
    @State var buildings: [StudyBuilding] = []
    @State var buildingsWJ: [StudyBuilding] = []
    @State var buildingsBY: [StudyBuilding] = []
    
    // 一星期全部教学楼
    @State var weeksBuildings: [[StudyBuilding]] = [[], [], [], [], [], [], []]
    @State var weeksBuildingWJ: [[StudyBuilding]] = [[], [], [], [], [], [], []]
    @State var weeksBuildingBY: [[StudyBuilding]] = [[], [], [], [], [], [], []]
    @State private var isFailGetOneWeek = true
    
    // 提示
    @State var alertMessage = ""
    
    // 收藏
    @State var getCollectionClassId: [String] = []
    @State var collectionClass: [CollectionClass] = []
    
//     StudyRoom共享数据
//    @StateObject private var studyRoomModel: StudyRoomModel = StudyRoomModel()
    
    //计算week和day
    let formatter = DateFormatter()
    var endDate: Date{
        formatter.dateFormat = "YYYYMMdd"
        return formatter.date(from: "20210301")!
    }
    var totalDays: Int {
        endDate.daysBetweenDate(toDate: sharedMessage.studyRoomSelectDate)
    }
    //TODO: 将计算属性弄成State
    var days: Binding<Int> { Binding(
        get: {totalDays % 7 + 1},
        set: {_ in})
    }
    var weeks: Binding<Int> { Binding(
        get: {totalDays / 7 + 1},
        set: {_ in})
    }
    
    // 计算现在的时间处于哪个时间段
    var nowPeriod: String {
        if nowTime.prefix(2) < "10" && nowTime.prefix(2) >= "00" || (nowTime.prefix(2) == "10" && nowTime.suffix(2) < "05"){
            return "8:30--10:05"
        }
        else if nowTime.prefix(2) > "10" && nowTime.prefix(2) < "12" || (nowTime.prefix(2) == "10" && nowTime.suffix(2) >= "05"){
            return "10:25--12:00"
        }
        else if nowTime.prefix(2) >= "12" && nowTime.prefix(2) < "15" || (nowTime.prefix(2) == "15" && nowTime.suffix(2) <= "05"){
            return "13:30--15:05"
        }
        else if nowTime.prefix(2) > "15" && nowTime.prefix(2) < "17" || (nowTime.prefix(2) == "15" && nowTime.suffix(2) > "05") {
            return "15:25--17:00"
        }
        else if nowTime.prefix(2) >= "17" && nowTime.prefix(2) < "20" || (nowTime.prefix(2) == "20" && nowTime.suffix(2) <= "05"){
            return "18:30--20:05"
        }
        else {return "20:25--22:00"}
    }
    
    
    var body: some View {
        
        VStack (spacing: 25){
            HStack {
                Button(action : {
                    self.mode.wrappedValue.dismiss()
                    sharedMessage.studyRoomSelectDate = Date()
                }) {
                    Image("back-arrow")
                }
                
                Spacer()
                
                Button(action : {
                    isShowCalender.toggle()
                }) {
                    Image("calender")
                }
            }.frame(width: screen.width * 0.9)
            .padding(.top, UIScreen.main.bounds.height / 15)
            
           /// Text String
//            Text(nowTime)
//            Text(nowPeriod)
//            Text(String(collectionBuildings.count))
//            Text(alertMessage)
//            Text(String(weeksBuildingWJ[0].count))
//            Text(String(buildings.count))

            HStack{
                Image("position")
                
                Picker(schoolDistricts[schoolDistrict], selection: $schoolDistrict) {
                    ForEach(0 ..< schoolDistricts.count) {
                        Text(schoolDistricts[$0])

                    }
                }.pickerStyle(MenuPickerStyle())
                .foregroundColor(themeColor)
                .font(.custom("HelveticaNeue-Bold", size: UIScreen.main.bounds.height/40))
//                Button(action: {
//                    if(schoolDistrict == 1) {
//                        schoolDistrict = 0
//                    } else {
//                        schoolDistrict = 1
//                    }
//                }, label: {
//                    Text(schoolDistricts[schoolDistrict])
//                    .foregroundColor(themeColor)
//                    .font(.custom("HelveticaNeue-Bold", size: UIScreen.main.bounds.height/40))
//                })
                

                Spacer()
                
                
                Text(selectedDateStr)
                    .foregroundColor(themeColor)
                    
                    //MARK: Sheet
                    .sheet(isPresented: $isShowCalender,
                           content: {
                            CalendarView(isShowCalender: $isShowCalender)
                           })//: sheet
                
            }//: HSTACK
            .frame(width: UIScreen.main.bounds.width * 0.9)
            
            Button(action: {isShowSearch = true}, label: {
                HStack {
                    Image("search")
                        .offset(x: 15)
                    Spacer()
                }
            })
            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 20, alignment: .center)
            .background(Color.init(red: 236/255, green: 237/255, blue: 239/255))
            .cornerRadius(UIScreen.main.bounds.height / 40)
            .shadow(color: Color.gray.opacity(0.3), radius: 10, x: 0, y: 0)
                        
            
            if(isGetStudyRoomBuildingMessage == false) {
                //MARK: if is already get message
                VStack{
                    Button(action: {
                        StudyRoomManager.allBuidlingGet(term: "20212", week: String(weeks.wrappedValue), day: String(days.wrappedValue)) {result in
                            switch result {
                            case .success(let data):
                                buildings = data.data
                                
                                for building in buildings  {
                                    if(building.campusID == "1"){
                                        buildingsWJ.append(building)
                                    }
                                    else if(building.campusID == "2") {
                                        buildingsBY.append(building)
                                    }
                                }
                                isGetStudyRoomBuildingMessage = true
                            case .failure(_):
                                isGetStudyRoomBuildingMessage = false
                            }
                        }
                    }, label: {
                        Text("信号开小差了...")
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.gray)
                    })
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.9,height: UIScreen.main.bounds.height * 0.4, alignment: .center)
                
            } else {
                
                if(schoolDistrict == 0) {
                    //MARK: show the buildings in WJ
                    GridWithoutScrollStack(minCellWidth: UIScreen.main.bounds.width / 8,
                                           spacing: 20,
                                           numItems: buildingsWJ.count) {
                        
                    } content: { index, width in
                        GeometryReader { geo in
                            if(buildingsWJ[index].areas[0].areaID != "-1") {
                                NavigationLink(
                                    destination: BuildingSectionView(buildingName: buildingsWJ[index].building, sections: buildingsWJ[index].areas, weeks: weeks, buildingID: buildingsWJ[index].buildingID),
                                    label: {
                                        VStack(spacing: 5) {
                                            Image("building")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width:UIScreen.main.bounds.width / 8)
                                            Text(buildingsWJ[index].building)
                                                .font(.custom("HelveticaNeue-Bold", size: UIScreen.main.bounds.height / 60))
                                                .foregroundColor(themeColor)
                                            
                                        }
                                        .frame(width: width, height: width)
                                    })

                            } else {
                                NavigationLink(
                                    destination: ChooseClassView(buildingID: buildingsWJ[index].buildingID, sectionName: "-1", week: weeks, buildingName: buildingsWJ[index].building),
                                    label: {
                                        VStack(spacing: 5) {
                                            Image("building")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width:UIScreen.main.bounds.width / 8)
                                            Text(buildingsWJ[index].building)
                                                .font(.custom("HelveticaNeue-Bold", size: UIScreen.main.bounds.height / 60))
                                                .foregroundColor(themeColor)
                                            
                                        }
                                        .frame(width: width, height: width)
                                    })

                            }
                                                        
                        }
                        .frame(width: width, height: width) // That's sucked!
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4, alignment: .center)
                } else{
                    //MARK: show the buildings in BY
                    GridWithoutScrollStack(minCellWidth: UIScreen.main.bounds.width / 8,
                                           spacing: 20,
                                           numItems: buildingsBY.count) {} content: { index, width in
                        GeometryReader { geo in
                            if(buildingsBY[index].areas[0].areaID != "-1") {
                                NavigationLink(
                                    destination: BuildingSectionView(buildingName: buildingsBY[index].building, sections: buildingsBY[index].areas, weeks: weeks, buildingID: buildingsBY[index].buildingID),
                                    label: {
                                        VStack(spacing: 5) {
                                            Image("building")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width:UIScreen.main.bounds.width / 8)
                                            Text(buildingsBY[index].building)
                                                .font(.custom("HelveticaNeue-Bold", size: UIScreen.main.bounds.height / 60))
                                                .foregroundColor(themeColor)
                                            
                                        }
                                        .frame(width: width, height: width)
                                    })

                            } else {
                                NavigationLink(
                                    destination: ChooseClassView(buildingID: buildingsBY[index].buildingID, sectionName: "-1", week: weeks, buildingName: buildingsBY[index].building),
                                    label: {
                                        VStack(spacing: 5) {
                                            Image("building")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width:UIScreen.main.bounds.width / 8)
                                            Text(buildingsBY[index].building)
                                                .font(.custom("HelveticaNeue-Bold", size: UIScreen.main.bounds.height / 60))
                                                .foregroundColor(themeColor)
                                            
                                        }
                                        .frame(width: width, height: width)
                                    })

                            }

                            
                        }
                        .frame(width: width, height: width) // That's sucked!
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4, alignment: .center)
                }
                
            }
            // MARK: Collections
            HStack {
                Text("我的收藏")
                    .font(.custom("HelveticaNeue-Bold", size: UIScreen.main.bounds.height/40))
                    .foregroundColor(themeColor)
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.9)
            StudyRoomFavourCard(collectionClasses: collectionClass)
            Spacer()
            
            NavigationLink(
                destination: StudySearchView(),
                isActive: $isShowSearch,
                label: {})
        }//: VSTACK
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
        // MARK: 请求当天数据
        .onAppear {
            sharedMessage.studyRoomSelectTime = nowPeriod
            if(isGetStudyRoomBuildingMessage == false) {
                StudyRoomManager.allBuidlingGet(term: "20212", week: String(weeks.wrappedValue), day: String(days.wrappedValue)) { result in
                    switch result {
                    case .success(let data):
                        buildings = data.data
                        if(data.errorCode != 0) {
                            isGetStudyRoomBuildingMessage = false
                            break
                        }
                        requestDataToUseData()
                        for building in buildings{
                            if(building.campusID == "1"){
                                buildingsWJ.insert(building, at: 0)
                            }
                            else if(building.campusID == "2") {
                                buildingsBY.insert(building, at: 0)
                            }
                        }
                        isGetStudyRoomBuildingMessage = true
                    case .failure(_):
                        isGetStudyRoomBuildingMessage = false
                    }
                }
                //MARK: 异步请求全部数据
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()) {
                    DispatchQueue.main.async {
                        for i in 0...6 {
                            StudyRoomManager.allBuidlingGet(term: "20212", week: String(weeks.wrappedValue), day: String(i+1)) { result in
                                switch result {
                                case .success(let data):
                                    weeksBuildings[i] = data.data
                                    if(data.errorCode != 0) {
                                        isFailGetOneWeek = true
                                        break
                                    }
//                                    for building in weeksBuildings[i]  {
//                                        if(building.campusID == "1"){
//                                            weeksBuildingWJ[i].append(building)
//                                        }
//                                        else if(building.campusID == "2") {
//                                            weeksBuildingBY[i].append(building)
//                                        }
//                                    }
                                    
                                    isFailGetOneWeek = false
                                case .failure(_):
                                    isFailGetOneWeek = true
                                }
                            }
                        }
                    }
                }
            } else {
                buildingsWJ = []
                buildingsBY = []
                collectionClass = []
                getCollectionClassId = []
                if let saveBuildings = DataStorage.retreive("studyroom/todaydata.json", from: .caches, as: [StudyBuilding].self) {
                    buildings = saveBuildings
                    requestDataToUseData()
                    for building in buildings{
                        if(building.campusID == "1"){
                            buildingsWJ.insert(building, at: 0)
                        }
                        else if(building.campusID == "2") {
                            buildingsBY.insert(building, at: 0)
                        }
                    }
                  
                }
            }
            
        }
        .onDisappear(perform: {
            if(!isFailGetOneWeek) {
                save()
            }
        })
        .background(Color(#colorLiteral(red: 0.9352087975, green: 0.9502342343, blue: 0.9600060582, alpha: 1)).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center).ignoresSafeArea())
       
//
        
        
    }//: BODY
    
    func save() {
        let queue = DispatchQueue.global()
        queue.async {
            DataStorage.store(buildings, in: .caches, as: "studyroom/todaydata.json")
            DataStorage.store(weeksBuildings, in: .caches, as: "studyroom/weekdata.json")
//            DataStorage.store(weeksBuildingWJ, in: .caches, as: "studyroom/weekdataWJ.json")
//            DataStorage.store(weeksBuildingBY, in: .caches, as: "studyroom/weekdataBY.json")
            DataStorage.store(getCollectionClassId, in: .caches, as: "studyroom/collections.json")
        }
    }
    
    //MARK: 收藏的数据整理
    func requestDataToUseData() {
        CollectionManager.getCollections() { result in
            switch result {
            case .success(let data):
                if(data.errorCode != 0){
                    alertMessage = data.message
                } else {
                    alertMessage = data.message
                    getCollectionClassId = data.data.classroomID!
                }
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




struct StudyRoomTopView_Previews: PreviewProvider {
    static var previews: some View {
        StudyRoomTopView()
            .environmentObject(SharedMessage())
    }
}





struct StudyRoomBuildingCardView: View {
    var buildingName: String
    var className: String
    var isFree: Bool
    private var fullName: String {
        return buildingName + " " + className
    }
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 123/255)
    private var imageId = Int(arc4random_uniform(4)) // 0-3随机数
    var ImageName: String {
        switch imageId {
        case 0:
            return "building"
        case 1:
            return "building-gray"
        case 2:
            return "building-lightgray"
        default:
            return "building-yellow"
        }
    }
    var body: some View {
        VStack{
            Image(ImageName)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 9)
            Text(fullName)
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(themeColor)
            HStack{
                if (isFree) {
                    Color.green.frame(width: UIScreen.main.bounds.width / 50, height: UIScreen.main.bounds.width / 50, alignment: .center)
                        .cornerRadius(UIScreen.main.bounds.width / 100)
                } else {
                    Color.red.frame(width: UIScreen.main.bounds.width / 50, height: UIScreen.main.bounds.width / 50, alignment: .center)
                        .cornerRadius(UIScreen.main.bounds.width / 100)
                }
                Text(isFree ? "空闲" : "占用")
                    .font(.headline)
                    .foregroundColor(isFree ? .green : .red)
                    .fontWeight(.heavy)
            
                
                
            }
            .padding(.top, 0)
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, height: UIScreen.main.bounds.width / 2.5, alignment: .center)
        .background(Color.white)
        .cornerRadius(15)
    }
    init(buildingName: String, className: String, isFree: Bool) {
        self.buildingName = buildingName
        self.className = className
        self.isFree = isFree
    }
}

struct StudyRoomFavourCard: View {
    @EnvironmentObject var sharedMessage: SharedMessage
    var collectionClasses: [CollectionClass]
    
    var checkTheClassNum: Int {
        switch sharedMessage.studyRoomSelectTime {
        case "8:30--10:05":
            return 0
        case "10:25--12:00":
            return 2
        case "13:30--15:05":
            return 4
        case "15:25--17:00":
            return 6
        case "18:30--20:05":
            return 8
        case "20:25--22:00":
            return 10
        default:
            return -1
        }
    }
    private var index: Int {
        collectionClasses.count / 4
    }
    
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack(spacing: 20) {
                ForEach(collectionClasses, id: \.self) { collectionclass in
                    StudyRoomBuildingCardView(buildingName: collectionclass.buildingName, className: collectionclass.classMessage.classroom, isFree: collectionclass.classMessage.status[checkTheClassNum] == "0")
                    
                }
            }
        }).padding()
    }
}

extension Date {
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
}

struct CollectionClass: Hashable {
    var id = UUID()
    var classMessage: Classroom
    var buildingName: String
}

class StudyRoomModel: ObservableObject {
    @Published var day: Int = 0
    @Published var weeks: Int = 0
    @Published var studyRoomSelectTime: String = ""
}
