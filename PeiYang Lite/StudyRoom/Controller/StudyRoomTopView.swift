//
//  StudyRoomTopView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/1/30.
//

import SwiftUI


struct StudyRoomTopView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var sharedMessage: SharedMessage
    @State var isGetStudyRoomBuildingMessage = false
    static var isGet: Bool = false
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 123/255)
    
    let schoolDistricts: [String] = ["卫津路校区", "北洋园校区"]
    @State var schoolDistrict = 0
    @State var isShowSearch = false
//    @State var selectedTimePeriod: String = ""
    
// SHEET data
    @State private var isShowCalender = false
    var selectedDateStr: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: sharedMessage.studyRoomSelectDate)
    }
    
    

    
    @State var buildings: [Datum] = []
    @State var buildingsWJ: [Datum] = []
    @State var buildingsBY: [Datum] = []
    
//    @State var BYIndex: [[Int]] = [[0,1,2,3], [4,5,6,7], [8,9,10,11]]
    
    
    
    var body: some View {
        
        VStack(spacing: 25.0) {
//            Text("AAAA")// MARK: 迷惑bug
//                .opacity(0)
            HStack{
                Image("position")
                
//                    Picker(schoolDistricts[schoolDistrict], selection: $schoolDistrict) {
//                        ForEach(0 ..< schoolDistricts.count) {
//                            Text(schoolDistricts[$0])
//                        }
//                    }.pickerStyle(MenuPickerStyle())
                
                Button(action: {
                    if(schoolDistrict == 0){
                        schoolDistrict = 1
                    } else {
                        schoolDistrict = 0
                    }
                }, label: {
                    Text(schoolDistricts[schoolDistrict])
                        .foregroundColor(themeColor)
                        .font(.custom("HelveticaNeue-Bold", size: UIScreen.main.bounds.height/40))
                })
                
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
//            Text(String(buildings.count))
            
            if(isGetStudyRoomBuildingMessage == false) {
                VStack{
                    Button(action: {
                        StudyRoomManager.allBuidlingGet() {result in
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
                    GridWithoutScrollStack(minCellWidth: UIScreen.main.bounds.width / 8,
                              spacing: 20,
                              numItems: buildingsWJ.count/2) {

                    } content: { index, width in
                        GeometryReader { geo in
                            NavigationLink(
                                destination: BuildingSectionView(buildingName: buildingsWJ[index].building),
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
                        .frame(width: width, height: width) // That's sucked!
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.9,height: UIScreen.main.bounds.height * 0.4, alignment: .center)
                } else{
                    GridWithoutScrollStack(minCellWidth: UIScreen.main.bounds.width / 8,
                    spacing: 20,
                    numItems: buildingsBY.count/2) {} content: { index, width in
              GeometryReader { geo in
                  NavigationLink(
                    destination: BuildingSectionView(buildingName: buildingsBY[index].building),
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
              .frame(width: width, height: width) // That's sucked!
          }
          .padding()
          .frame(width: UIScreen.main.bounds.width * 0.9,height: UIScreen.main.bounds.height * 0.4, alignment: .center)
                }

            }
                                
                HStack {
                    Text("我的收藏")
                        .font(.custom("HelveticaNeue-Bold", size: UIScreen.main.bounds.height/40))
                        .foregroundColor(themeColor)
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)
//                HomeStudyRoomSectionView()
//                    .padding(.horizontal)
            StudyRoomFavourCard()
           
                
                Spacer()
                
                NavigationLink(
                    destination: StudySearchView(),
                    isActive: $isShowSearch,
                    label: {})
            }//: VSTACK
        // MARK: get funciton
            .onAppear {
                if(isGetStudyRoomBuildingMessage == false) {
                    StudyRoomManager.allBuidlingGet() {result in
                        switch result {
                        case .success(let data):
                            buildings = data.data
                            
                            for building in buildings{
                                if(building.campusID == "1"){
                                    buildingsWJ.insert(building, at: 0)
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
                }
                
            }
        
            .padding(.top, UIScreen.main.bounds.height / 10)
            .edgesIgnoringSafeArea(.top)
        
            .background(Color(#colorLiteral(red: 0.9352087975, green: 0.9502342343, blue: 0.9600060582, alpha: 1)).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center).ignoresSafeArea())
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
        

        
    }//: BODY
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
                if(isFree) {
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
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack(spacing: 20) {
                StudyRoomBuildingCardView(buildingName: "23教", className: "A208", isFree: true)
                StudyRoomBuildingCardView(buildingName: "24教", className: "110", isFree: false)
                StudyRoomBuildingCardView(buildingName: "16教", className: "B210", isFree: true)
                StudyRoomBuildingCardView(buildingName: "55教", className: "C228", isFree: false)
            }
        }).padding()
    }
}
