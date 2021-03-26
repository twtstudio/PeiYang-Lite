//
//  StyChooseClassView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2020/11/15.
//

import SwiftUI

struct StyChooseClassView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var sharedMessage: SharedMessage
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 123/255)
    
    // 定位class
    var buildingID: String
    var sectionName: String
    
    // grid布局
    var columns: [GridItem] = [
        GridItem(.fixed(screen.width / 5.5), spacing: 16),
        GridItem(.fixed(screen.width / 5.5), spacing: 16),
        GridItem(.fixed(screen.width / 5.5), spacing: 16),
        GridItem(.fixed(screen.width / 5.5), spacing: 16)
        ]
    @Binding var week: Int
    
    // 日历及其中数据
    @State private var isShowCalender = false

    
    // 教室存储
     var fullClasses: [Classroom] {
        if let saveBuildings = DataStorage.retreive("studyroom/todaydata.json", from: .caches, as: [StudyBuilding].self){
            for building in saveBuildings {
                if building.buildingID == buildingID {
                    for area in building.areas {
                        if area.areaID == sectionName {
                            return area.classrooms
                        }
                    }
                }
            }
        }
        return []
    }
    var finalFullClasses: [Classroom] {
        return fullClasses.sorted(by: {$0.classroom < $1.classroom})
    }
    @State var classes: [[Classroom]] = [[]]
    @State var totalFloors: Int = 0

    var buildingName: String
    
    // 一周教室存储
    @State var weeksBuildings: [[Classroom]] = [[]]
    @State var weeksClasses: [[[Classroom]]] = [[[]], [[]], [[]], [[]], [[]], [[]], [[]]]
    var availArray: [String] = []
    
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
            
            HStack{
                Image("building-gray")
                    .resizable()
                    .frame(width: screen.width / 15, height: screen.width / 15, alignment: .center)
                Text(buildingName)
                    .foregroundColor(themeColor)
                    .font(.custom("HelveticaNeue-Bold", size: screen.height/40))
                Spacer()
            }// TOP BUILDING NAME
                .padding()
                .frame(width: screen.width * 0.9)
                
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(
                    columns: columns,
                    alignment: .center,
                    spacing: 16,
                    pinnedViews: [.sectionHeaders, .sectionFooters]
                ) {
                   
                    ForEach(0...totalFloors, id: \.self) { floor in
                        if(floor == 0 || classes[floor].count == 0) {
                           // null
                        } else {
                            Section(header: FloorTitleView(floor: String(floor))) {
                                ForEach(classes[floor], id: \.self) { rooms in
                                    
                                    
                                NavigationLink(
                                    destination: StyRoomDetailView(activeWeek: $week, className: buildingName + rooms.classroom, classData: rooms)) {
                                    SelectRoomView(classTitle: rooms.classroom, classData: rooms)
                                    }
                                    
                                }
                            }
                        }
                    }
                    .navigationBarHidden(true)
                }
            }

            Spacer()
            
        }
        .onAppear(perform: {
//            load()
            let getFloorsAndSort = GetFloorsAndSort(fullClasses: finalFullClasses)
            classes = getFloorsAndSort.0
            totalFloors = getFloorsAndSort.1

        })
        .frame(width: screen.width)
        .background(Color(#colorLiteral(red: 0.9352087975, green: 0.9502342343, blue: 0.9600060582, alpha: 1)).ignoresSafeArea())
        .sheet(isPresented: $isShowCalender,
               content: {
                CalendarView(isShowCalender: $isShowCalender)
                    .onDisappear(perform: {
                        let getFloorsAndSort = GetFloorsAndSort(fullClasses: finalFullClasses)
                        classes = getFloorsAndSort.0
                        totalFloors = getFloorsAndSort.1
                    })
        })//: sheet
        .navigationBarHidden(true)
        .addAnalytics(className: "StudyRoomChooseClassView")

  
    }
    
    func load() {
//        DispatchQueue.global().sync {
//            if(theField == 0) {
//                if let saveWeeksBuildings = DataStorage.retreive("studyroom/weekdataWJ.json", from: .caches, as: [[Classroom]].self) {
//                    weeksBuildings = saveWeeksBuildings
//                }
//            } else {
//                if let saveWeeksBuildings = DataStorage.retreive("studyroom/weekdataWJ.json", from: .caches, as: [[Classroom]].self) {
//                    weeksBuildings = saveWeeksBuildings
//                }
//            }
//            for i in 0...6 {
//                let getFloorsAndSort = GetFloorsAndSort(fullClasses: weeksBuildings[i])
//                weeksClasses[i] = getFloorsAndSort.0
//            }
//            
//        }
    }
    
}

//struct ClassesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChooseClassView(buildingName: "23教A区")
//    }
//}

func GetFloorsAndSort(fullClasses: [Classroom]) ->([[Classroom]], Int) {
    var totalFloors: Int = 0
    var classes  = [[Classroom]](repeating: [], count: 10)
    for classroom in fullClasses {
        if(Int(classroom.classroom.prefix(1))! > totalFloors) {
            totalFloors = Int(classroom.classroom.prefix(1))!
        }
        classes[Int(classroom.classroom.prefix(1))!].append(classroom)
        
    }
    
    return (classes, totalFloors)
}


fileprivate struct FloorTitleView: View {
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 123/255)
    var floor: String
    var body: some View {
        HStack{
            Text("\(floor)F")
                .foregroundColor(themeColor)
                .font(.custom("HelveticaNeue-Bold", size: screen.height/45))
            
            Spacer()
        }
        .background(Color(#colorLiteral(red: 0.9352087975, green: 0.9502342343, blue: 0.9600060582, alpha: 1))
                        .frame(width:screen.width, height: 60)
                        .ignoresSafeArea())
        .padding([.top, .horizontal])
        .frame(width: screen.width * 0.9)
    }
}


struct SelectRoomView: View {
    let circleDiameter: CGFloat = screen.width / 70
    let subTitleSize: CGFloat = screen.height / 75
    @EnvironmentObject var sharedMessage: SharedMessage
    var id = UUID()
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 123/255)
    var classTitle: String
    var isFree: Bool?
    
    var classData: Classroom
    @State var indexArray: [Int] = []
    @State var periodsFree: Bool = true
    var body: some View {
        VStack(spacing: 3){
            Text(classTitle)
                .foregroundColor(themeColor)
                .font(.custom("HelveticaNeue-Bold", size: screen.height/50))
            if(isFree != nil) {
                HStack(spacing: 3){
                    if(isFree!) {
                        Color.green
                            .frame(width: circleDiameter, height: circleDiameter, alignment: .center)
                            .cornerRadius(circleDiameter / 2)
                    } else {
                        Color.red
                            .frame(width: circleDiameter, height: circleDiameter, alignment: .center)
                            .cornerRadius(circleDiameter / 2)
                    }
                    
                    Text(isFree! ? "空闲" : "占用")
                        .font(.custom("HelveticaNeue-Bold", size: subTitleSize))
                        .foregroundColor(isFree! ? .green : .red)
                }
            } else {
                if(sharedMessage.studyRoomSelectPeriod == []) {
                    Text("未选时间段")
                        .font(.custom("HelveticaNeue-Bold", size: subTitleSize))
                        .foregroundColor(.gray)
                } else {
                    HStack(spacing: 3){
                        if(periodsFree) {
                            Color.green
                                .frame(width: circleDiameter, height: circleDiameter, alignment: .center)
                                .cornerRadius(circleDiameter / 2)
                        } else {
                            Color.red
                                .frame(width: circleDiameter, height: circleDiameter, alignment: .center)
                                .cornerRadius(circleDiameter / 2)
                        }
                        
                        Text(periodsFree ? "空闲" : "占用")
                            .font(.custom("HelveticaNeue-Bold", size: subTitleSize))
                            .foregroundColor(periodsFree ? .green : .red)
                    }
                }
            }
        }
        .frame(width: screen.width / 6, height: screen.width / 7, alignment: .center)
        .background(Color.init(red: 252/255, green: 252/255, blue: 250/255))
        .cornerRadius(10)
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

