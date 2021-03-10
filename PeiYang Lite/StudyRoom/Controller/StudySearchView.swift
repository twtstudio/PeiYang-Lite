//
//  StudySearchView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/27.
//

import SwiftUI

struct StudySearchView: View {
    // text
    @State var textNum = 1
    let color = Color.init(red: 98/255, green: 103/255, blue: 124/255)
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var sharedMessage: SharedMessage
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
    
    // 搜索string和搜索历史
    @State var searchString: String = ""
    @State var studyRoomHistory: [String] = []
    
    // 是否是搜索状态
    @State var isSearched: Bool = false
    
    // 搜索模式
    enum method {
        case buildings
        case sections
        case unclearrooms
        case rooms
        case wrong
    }
    @State var selectedMethod = method.wrong
    
    // 截取的字符串
    @State var brokenString: [String] = []
    // 全部数据
    @State var searchData: [StudyBuilding] = []
    
    @State var searchBuilding: [StudyBuilding] = []
    @State var searchSection: [SearchSectionData] = []
    @State var searchRoom: [SearchClassData] = []
    
    // grid布局
    var roomAndBuildingColumns: [GridItem] = [
        GridItem(.fixed(UIScreen.main.bounds.width / 5.5), spacing: 16),
        GridItem(.fixed(UIScreen.main.bounds.width / 5.5), spacing: 16),
        GridItem(.fixed(UIScreen.main.bounds.width / 5.5), spacing: 16),
        GridItem(.fixed(UIScreen.main.bounds.width / 5.5), spacing: 16)
        ]
    
    var sectionColumns: [GridItem] = [
        GridItem(.fixed(UIScreen.main.bounds.width / 4), spacing: 20),
        GridItem(.fixed(UIScreen.main.bounds.width / 4), spacing: 20),
        GridItem(.fixed(UIScreen.main.bounds.width / 4), spacing: 20),
    ]
    
    var body: some View {
        VStack{
            HStack {
                Button(action: {
                    if(searchBuilding != [] || searchSection != [] || searchRoom != []) {
                        searchBuilding = []
                        searchRoom = []
                        searchSection = []
                    }
                    studyRoomHistory.insert(searchString, at: 0)
                    chooseMethod()
                    isSearched = true
                    search()
                }, label: {
                    Image("search")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width / 20)
                })
                .disabled(searchString == "")
                TextField("", text: $searchString)
                    .font(.callout)
                    .padding()
                Button(action: {
                    if(searchString == "") {
                        self.mode.wrappedValue.dismiss()
                    } else {
                        searchString = ""
                        isSearched = false
                    }
                }, label: {
                    Text("取消")
                        .fontWeight(.heavy)
                        .foregroundColor(color)
                })
            }
            .frame(height: UIScreen.main.bounds.height / 20)
            Color.gray
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 1, alignment: .center)
                .padding(.top, 0)
            if(!isSearched){
                SchHistorySectionView(searchString: $searchString, searchHistory: $studyRoomHistory)
            } else {
                ScrollView(.vertical, showsIndicators: false){
                    switch selectedMethod {
                    case .buildings:
                        LazyVGrid(
                            columns: roomAndBuildingColumns,
                            alignment: .center,
                            spacing: 16,
                            pinnedViews: [.sectionHeaders, .sectionFooters]
                        ) {
                            ForEach(searchBuilding, id: \.self) { building in
                                if(building.areas[0].areaID != "-1"){
                                    NavigationLink(
                                        destination: BuildingSectionView(buildingName: building.building, sections: building.areas, weeks: $textNum),
                                        label: {
                                            SearchBuildingView(title: building.building)
                                        })
                                }
                                else {
                                    NavigationLink(
                                        destination: ChooseClassView(week: $textNum, fullClasses: building.areas[0].classrooms, buildingName: building.building),
                                        label: {
                                            SearchBuildingView(title: building.building)
                                        })
                                }
                            }
                        }
                        
                    case .sections:
                        LazyVGrid(
                            columns: sectionColumns,
                            alignment: .center,
                            spacing: 16,
                            pinnedViews: [.sectionHeaders, .sectionFooters]
                        ) {
                            ForEach(searchSection, id: \.self){ section in
                                NavigationLink(
                                    destination: ChooseClassView(week: $textNum, fullClasses: section.sectionData.classrooms, buildingName: section.buildingName + section.sectionData.areaID),
                                    label: {
                                        SearchBuildingSectionView(title: section.buildingName, section: section.sectionData.areaID)
                                    })
                            }
                        }
                       
                    case .rooms:
                        LazyVGrid(
                            columns: roomAndBuildingColumns,
                            alignment: .center,
                            spacing: 16,
                            pinnedViews: [.sectionHeaders, .sectionFooters]
                        ) {
                            ForEach(searchRoom, id: \.self) { room in
                                NavigationLink(
                                    destination: RoomDetailView(activeWeek: $textNum, className: room.buildingName + ((room.sectionName == "-1") ? "" : room.sectionName) + room.room.classroom, classData: room.room),
                                    label: {
                                        SelectRoomView(classTitle: room.room.classroom, isFree: room.room.status[checkTheClassNum] == "0")
                                    })
                            }
                        }
                        
                    case .wrong:
                        VStack(alignment: .leading, spacing: 15.0){
                            Text("格式错误").font(.title)
                            Text("请用如下格式：").font(.headline)
                            Text("**, **楼(教)，**A, ** A, A, ** A***, A***")
                        }
                        .foregroundColor(color)
                        
                    case .unclearrooms:
                        ForEach(searchRoom, id: \.self) { room in
                            NavigationLink(
                                destination: RoomDetailView(activeWeek: $textNum, className: room.buildingName + ((room.sectionName == "-1") ? "" : room.sectionName)+room.room.classroom, classData: room.room),
                                label: {
                                    SearchBuildingAndClassView(title: room.buildingName + ((room.sectionName == "-1") ? "" : room.sectionName) + room.room.classroom, isFree: room.room.status[checkTheClassNum] == "0")
                                })
                        }
                    }
                }
                .padding(.top)
            }
            
            
            Spacer()
        }
        .navigationBarHidden(true)
        .frame(width: UIScreen.main.bounds.width * 0.9)
        .background(Color(#colorLiteral(red: 0.9352087975, green: 0.9502342343, blue: 0.9600060582, alpha: 1)).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center).ignoresSafeArea())
        .onDisappear(perform: {
            save()
            
        })
        .onAppear(perform: {
            load()
        })
        
    }
    //MARK: save
    func save() {
        let queue = DispatchQueue.global()
        queue.async {
            DataStorage.store(studyRoomHistory, in: .caches, as: "studyroom/history.json")
        }
    }
    //MARK: load
    func load() {
        DispatchQueue.global().sync {
            if let saveStudyRoomHistory = DataStorage.retreive("studyroom/history.json", from: .caches, as: [String].self) {
                studyRoomHistory = saveStudyRoomHistory
            }
            if let saveBuildings = DataStorage.retreive("studyroom/todaydata.json", from: .caches, as: [StudyBuilding].self) {
                searchData = saveBuildings
            }
        }
    }
    
    // MARK: choose the search method
    func chooseMethod() {
        //先看看是否有空格，教，楼
        if (searchString.findString("教") != -1) {
            brokenString = searchString.components(separatedBy: "教")
        }
        else if searchString.findString("楼") != -1 {
            brokenString = searchString.components(separatedBy: "楼")
        }
        else {
            brokenString = searchString.components(separatedBy: " ")
        }

        ///eg: "13教", "13", "13楼" --> buildings
        if (brokenString.count == 1 &&
            brokenString[0].count == 2 &&
            brokenString[0].findString("A") == -1 &&
            brokenString[0].findString("B") == -1 &&
            brokenString[0].findString("C") == -1) {
            selectedMethod = .buildings
        }
        
        /// eg: "13A", "14B" --> sections 
        else if (brokenString.count == 1 &&
            brokenString[0].count == 3 &&
            (brokenString[0].findString("A") != -1 ||
            brokenString[0].findString("B") != -1 ||
            brokenString[0].findString("C") != -1)) {
            selectedMethod = .sections
        }
        /// eg: "313", "413", "102" --> unclearrooms
        else if brokenString.count == 1 &&
                brokenString[0].count == 3 &&
                brokenString[0].findString("A") == -1 &&
                brokenString[0].findString("B") == -1 &&
                brokenString[0].findString("C") == -1{
            selectedMethod = .unclearrooms
        }
        /// eg: "A312", "B312" --> unclearrooms
        else if brokenString.count == 1 &&
                brokenString[0].count == 4 {
            selectedMethod = .unclearrooms
        }
        /// eg: "36楼A", "36 A" --> sections
        else if brokenString.count != 1 &&
                (brokenString[1] == "A" ||
                brokenString[1] == "B" ||
                brokenString[1] == "C") {
            selectedMethod = .sections
        }
        /// eg: "36 A103", "36 103" --> rooms
        else if brokenString.count != 1 {selectedMethod = .rooms}
        
        /// eg: "A", "B", "C" --> sections
        else if brokenString[0] == "A" || brokenString[0] == "B" || brokenString[0] == "C" {
            selectedMethod = .sections
        }
        
        /// eg: "1", "2" --> buildings
        else if brokenString[0].count == 1 {selectedMethod = .buildings}
        
        else {selectedMethod = .wrong}
    }
    
// MARK: Search function
    func search() {
        switch selectedMethod {
        case .buildings:
            for building in searchData {
                if(building.building.findString(brokenString[0]) != -1) {
                    searchBuilding.append(building)
                }
            }
    
        case .sections:
            /// "A"
            if(brokenString[0] == "A" || brokenString[0] == "B" || brokenString[0] == "C") {
                for building in searchData {
                    for area in building.areas {
                        if brokenString[0] == area.areaID {
                            searchSection.append(SearchSectionData(buildingName: building.building, sectionData: area))
                        }
                    }
                }
            }
            /// "46A"
            else if brokenString.count == 1 {
                for building in searchData {
                    if(building.building.prefix(2) == brokenString[0].prefix(2)) {
                        for area in building.areas {
                            if area.areaID == brokenString[0].suffix(1) {
                                searchSection.append(SearchSectionData(buildingName: building.building, sectionData: area))
                            }
                        }
                    }
                }
            }
            /// "46 A"
            else {
                for building in searchData {
                    if(building.building.prefix(2) == brokenString[0]) {
                        for area in building.areas {
                            if area.areaID == brokenString[1] {
                                searchSection.append(SearchSectionData(buildingName: building.building, sectionData: area))
                            }
                        }
                    }
                }
            }
            
        case .unclearrooms:
            /// A312
            if(brokenString[0].prefix(1) == "A" || brokenString[0].prefix(1) == "B") {
                for building in searchData {
                    for area in building.areas {
                        if area.areaID == brokenString[0].prefix(1) {
                            for room in area.classrooms {
                                if(room.classroom == brokenString[0].suffix(3)) {
                                    searchRoom.append(SearchClassData(buildingName: building.building, sectionName: area.areaID, room: room))
                                }
                            }
                        }
                    }
                }
            }
            /// 312
            else {
                for building in searchData {
                    for area in building.areas {
                        for room in area.classrooms {
                            if room.classroom == brokenString[0] {
                                searchRoom.append(SearchClassData(buildingName: building.building, sectionName: area.areaID, room: room))
                            }
                        }
                    }
                }
            }
            
        case .rooms:
            /// 36 A103
            if brokenString[1].prefix(1) == "A" || brokenString[1].prefix(1) == "B" {
                for building in searchData {
                    if building.building.prefix(2) == brokenString[0] {
                        for area in building.areas {
                            if(area.areaID == brokenString[1].prefix(1)) {
                                for room in area.classrooms {
                                    if(room.classroom == brokenString[1].suffix(3)) {
                                        searchRoom.append(SearchClassData(buildingName: building.building, sectionName: area.areaID, room: room))
                                    }
                                }
                            }
                        }
                    }
                }
            }
            /// 36 103
            else {
                for building in searchData {
                    if building.building.prefix(2) == brokenString[0] {
                        for area in building.areas {
                            for room in area.classrooms {
                                if(room.classroom == brokenString[1].suffix(3)) {
                                    searchRoom.append(SearchClassData(buildingName: building.building, sectionName: area.areaID, room: room))
                                }
                            }
                        }
                    }
                }
            }
            
        case .wrong:
            break
        }
    }
}

struct StudySearchView_Previews: PreviewProvider {
    static var previews: some View {
        StudySearchView()
    }
}

struct SearchSectionData: Identifiable, Hashable {
    var id = UUID()
    var buildingName: String
    var sectionData: Area
}

struct SearchClassData: Identifiable, Hashable {
    var id = UUID()
    var buildingName: String
    var sectionName: String
    var room: Classroom
}



