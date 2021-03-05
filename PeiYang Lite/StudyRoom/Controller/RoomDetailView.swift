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
    var body: some View {
        
        GeometryReader { full in
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
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .padding(.top, 40)
                
                
                RoomDetailHeaderView(className: className, activeWeek: activeWeek)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        CourseTableWeekdaysView(
                            activeWeek: $activeWeek,
                            courseTable: courseTable,
                            width: full.size.width / 8
                        )
                        .padding(.leading, full.size.width/16 + 7)
                        .frame(width: full.size.width, alignment: .center)
                        
                        StudyRoomContentView(
                            activeWeek: activeWeek,
                            courseArray: courseTable.courseArray,
                            width: full.size.width / 8
                            )
                        .frame(width: full.size.width, height: full.size.height*1.2, alignment: .top)
                    }
                    .padding(.horizontal, 10)
                }
            }
            .frame(width: screen.size.width, height: screen.size.height)
//            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: $isShowCalender,
                   content: {
                    CalendarView(isShowCalender: $isShowCalender)
            })
           
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: Button(action : {
//            self.mode.wrappedValue.dismiss()
//        }) {
//            Image("back-arrow")
//        }, trailing: Button(action : {
//            isShowCalender.toggle()
//        }) {
//            Image("calender")
//        })
    }
}



struct RoomDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RoomDetailView(activeWeek: .constant(16), className: "16教A208")
    }
}

struct RoomDetailHeaderView: View {
    var className: String
    var activeWeek: Int
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
            
            Button(action: {}) {
                Text("收藏")
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)))
            }
        }
        .padding()
    }
}
