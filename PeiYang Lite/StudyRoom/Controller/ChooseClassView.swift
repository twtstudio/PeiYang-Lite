//
//  ChooseClassView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2020/11/15.
//

import SwiftUI

struct ChooseClassView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var sharedMessage: SharedMessage
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 123/255)
    
    
    // grid布局
    var columns: [GridItem] = [
        GridItem(.fixed(UIScreen.main.bounds.width / 5.5), spacing: 16),
        GridItem(.fixed(UIScreen.main.bounds.width / 5.5), spacing: 16),
        GridItem(.fixed(UIScreen.main.bounds.width / 5.5), spacing: 16),
        GridItem(.fixed(UIScreen.main.bounds.width / 5.5), spacing: 16)
        ]
    
    
    // 日历及其中数据
    @State private var isShowCalender = false
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

    
    // 教室存储
    @State var fullClasses: [Classroom]
    var finalFullClasses: [Classroom] {
        return fullClasses.sorted(by: {$0.classroom < $1.classroom})
    }
    @State var classes: [[Classroom]] = [[]]
    @State var totalFloors: Int = 0

    var buildingName: String
    
    
    
    var body: some View {
        VStack {
            HStack{
                Image("building-gray")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width / 15, height: UIScreen.main.bounds.width / 15, alignment: .center)
                Text(buildingName)
                    .foregroundColor(themeColor)
                    .font(.custom("HelveticaNeue-Bold", size: UIScreen.main.bounds.height/40))
                Spacer()
            }// TOP BUILDING NAME
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.9)
                
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(
                    columns: columns,
                    alignment: .center,
                    spacing: 16,
                    pinnedViews: [.sectionHeaders, .sectionFooters]
                ) {
                   
                    ForEach(0...totalFloors, id: \.self) { floor in
                        if(floor == 0) {
                           // null
                        } else {
                            Section(header: FloorTitleView(floor: String(floor))) {
                                ForEach(classes[floor], id: \.self) { room in
                                    if(checkTheClassNum == -1){
                                        SelectRoomView(classTitle: room.classroom)
                                    } else {
                                        NavigationLink(
                                            destination: RoomDetailView(activeWeek:
                                                                            .constant(2), className: buildingName + room.classroom),
                                            label: {
                                                SelectRoomView(classTitle: room.classroom, isFree: room.status[checkTheClassNum] == "0")
                                            })
                                       
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Spacer()
            
        }
        .onAppear(perform: {
           
            let getFloorsAndSort = GetFloorsAndSort(fullClasses: finalFullClasses)
            classes = getFloorsAndSort.0
            totalFloors = getFloorsAndSort.1
        })
        .padding(.top, UIScreen.main.bounds.height / 10)
        .edgesIgnoringSafeArea(.top)
        .frame(width: UIScreen.main.bounds.width)
        .background(Color(#colorLiteral(red: 0.9352087975, green: 0.9502342343, blue: 0.9600060582, alpha: 1)).ignoresSafeArea())
        .sheet(isPresented: $isShowCalender,
               content: {
                CalendarView(isShowCalender: $isShowCalender)
        })//: sheet
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            self.mode.wrappedValue.dismiss()
        }) {
            Image("back-arrow")
        }, trailing: Button(action : {
            isShowCalender.toggle()
        }) {
            Image("calender")
        })
  
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


struct FloorTitleView: View {
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 123/255)
    var floor: String
    var body: some View {
        HStack{
            Text("\(floor)F")
                .foregroundColor(themeColor)
                .font(.custom("HelveticaNeue-Bold", size: UIScreen.main.bounds.height/45))
            
            Spacer()
        }
        .background(Color(#colorLiteral(red: 0.9352087975, green: 0.9502342343, blue: 0.9600060582, alpha: 1))
                        .frame(width:screen.width, height: 60)
                        .ignoresSafeArea())
        .padding([.top, .horizontal])
        .frame(width: UIScreen.main.bounds.width * 0.9)
    }
}

struct SelectRoomView: View {
    var id = UUID()
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 123/255)
    var classTitle: String
    var isFree: Bool?
    var body: some View {
        VStack(spacing: 3){
            Text(classTitle)
                .foregroundColor(themeColor)
                .font(.custom("HelveticaNeue-Bold", size: UIScreen.main.bounds.height/50))
            if(isFree != nil) {
                HStack(spacing: 3){
                    if(isFree!) {
                        Color.green
                            .frame(width: UIScreen.main.bounds.width / 70, height: UIScreen.main.bounds.width / 70, alignment: .center)
                            .cornerRadius(UIScreen.main.bounds.width / 140)
                    } else {
                        Color.red
                            .frame(width: UIScreen.main.bounds.width / 70, height: UIScreen.main.bounds.width / 70, alignment: .center)
                            .cornerRadius(UIScreen.main.bounds.width / 140)
                    }
                    
                    Text(isFree! ? "空闲" : "占用")
                        .font(.custom("HelveticaNeue-Bold", size: UIScreen.main.bounds.height/75))
                        .foregroundColor(isFree! ? .green : .red)
                }
            } else {
                Text("未选时间段")
                    .font(.custom("HelveticaNeue-Bold", size: UIScreen.main.bounds.height/75))
                    .foregroundColor(.gray)
            }
        }
            
        
        .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 7, alignment: .center)
        .background(Color.init(red: 252/255, green: 252/255, blue: 250/255))
        .cornerRadius(10)
    }
}

