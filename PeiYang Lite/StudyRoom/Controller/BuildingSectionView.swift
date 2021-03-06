//
//  BuildingSectionView.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/26.
//

import SwiftUI

struct BuildingSectionView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var sharedMessage: SharedMessage
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 123/255)
    var buildingName: String
    @State private var isShowCalender = false
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
                HStack(spacing: 20) {
                    NavigationLink(
                        destination: ChooseClassView(buildingName: buildingName + "A区"),
                        label: {
                            SchSection(title: "A区")
                        })
                    NavigationLink(
                        destination: ChooseClassView(buildingName: buildingName + "B区"),
                        label: {
                            SchSection(title: "B区")
                        })
                    NavigationLink(
                        destination: ChooseClassView(buildingName: buildingName + "C区"),
                        label: {
                            SchSection(title: "C区")
                        })
                }
               
                Spacer()
            }
            .padding(.top, UIScreen.main.bounds.height / 10)
            .edgesIgnoringSafeArea(.top)
            
            .sheet(isPresented: $isShowCalender,
                   content: {
                    CalendarView(isShowCalender: $isShowCalender)
            })//: sheet
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
//        }
    }
}

struct BuildingSectionView_Previews: PreviewProvider {
    static var previews: some View {
        BuildingSectionView(buildingName: "16教")
    }
}

struct SchSection: View {
    var title: String
    private var backColor: Color {
        switch title {
        case "A区":
            return Color.init(red: 54/255, green: 60/255, blue: 84/255)
        case "B区":
            return Color.init(red: 116/255, green: 120/255, blue: 138/255)
        case "C区":
            return Color.init(red: 103/255, green: 111/255, blue: 150/255)
        default:
            return .black
        }
    }
    var body: some View {
        Text(title)
            .foregroundColor(.white)
            .font(.title3)
            .fontWeight(.heavy)
            .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4.5, alignment: .center)
            .background(
                backColor
            )
            .cornerRadius(10)
    }
}
