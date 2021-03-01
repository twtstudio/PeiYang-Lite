//
//  ChooseClassView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2020/11/15.
//

import SwiftUI

struct ChooseClassView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 123/255)
    
    @State private var isShowCalender = false

    var buildingName: String
    
    
    var body: some View {
//        NavigationView {
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
                    ScrollView{
                        FloorTitleView(floor: "1", totalRoom: "10", availRoom: "1")
                        
                        GridWithoutScrollStack(minCellWidth: UIScreen.main.bounds.width / 8,
                                  spacing: 30,
                                  numItems: 10) {} content: { index, width in
                            GeometryReader { geo in
                                NavigationLink(
                                    destination: RoomDetailView(activeWeek: .constant(16), className: buildingName + "A101"),
                                    label: {
                                        SelectRoomView(classTitle: "A101", isFree: true)
                                            .frame(width: width)
                                    })
                                
                            }
                            .frame(width: width, height: width * 0.9) // That's sucked!
                        }
                        .padding()
                        .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height * 0.5, alignment: .center)
                        
                       
                    }
                    
                   
                    
                    Spacer()
                }
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
//        }
  
    }
    
}

struct ClassesView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseClassView(buildingName: "23教A区")
    }
}

struct FloorTitleView: View {
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 123/255)
    var floor: String
    var totalRoom: String
    var availRoom: String
    var body: some View {
        HStack{
            Text("\(floor)F")
                .foregroundColor(themeColor)
                .font(.custom("HelveticaNeue-Bold", size: UIScreen.main.bounds.height/45))
            
            Text("共\(totalRoom)可用\(availRoom)")
                .font(.caption)
                .foregroundColor(.init(red: 192/255, green: 192/255, blue: 201/255))
            Spacer()
        }
        .padding([.top, .horizontal])
        .frame(width: UIScreen.main.bounds.width * 0.9)
    }
}

struct SelectRoomView: View {
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 123/255)
    var classTitle: String
    var isFree: Bool
    var body: some View {
        VStack(spacing: 5){
            Text(classTitle)
                .foregroundColor(themeColor)
                .font(.custom("HelveticaNeue-Bold", size: UIScreen.main.bounds.height/50))
            HStack{
                if(isFree) {
                    Color.green
                        .frame(width: UIScreen.main.bounds.width / 45, height: UIScreen.main.bounds.width / 45, alignment: .center)
                        .cornerRadius(UIScreen.main.bounds.width / 80)
                } else {
                    Color.red
                        .frame(width: UIScreen.main.bounds.width / 45, height: UIScreen.main.bounds.width / 45, alignment: .center)
                        .cornerRadius(UIScreen.main.bounds.width / 90)
                }
                
                Text(isFree ? "空闲" : "占用")
                    .font(.custom("HelveticaNeue-Bold", size: UIScreen.main.bounds.height/65))
                    .foregroundColor(isFree ? .green : .red)
            }
        }
        
        .frame(width: UIScreen.main.bounds.width / 5.5, height: UIScreen.main.bounds.width / 6.5, alignment: .center)
        .background(Color.init(red: 252/255, green: 252/255, blue: 250/255))
        .cornerRadius(10)
//        .shadow(color: themeColor.opacity(0.3), radius: 10, x: 0, y: 0)
    }
}
