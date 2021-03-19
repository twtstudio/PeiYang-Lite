//
//  StyCalendar.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/1/31.
//

import SwiftUI
import UIKit
import FSCalendar

//MARK: Calendar
struct StyCalendar: UIViewRepresentable {
    let themeColor = UIColor.init(red: 98/255, green: 103/255, blue: 123/255, alpha: 1)
    typealias UIViewType = FSCalendar
    var calendar = FSCalendar()
    @EnvironmentObject var sharedMessage: SharedMessage
    @Binding var isChangeDate: Bool
    
    
    func updateUIView(_ uiView: FSCalendar, context: Context) { }
    func makeUIView(context: Context) -> FSCalendar {
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        calendar.allowsMultipleSelection = false
        // Apperance settings
        
        calendar.appearance.headerTitleColor = themeColor
        calendar.appearance.todayColor = themeColor
        calendar.appearance.selectionColor = .white
        calendar.appearance.titleSelectionColor = themeColor
        calendar.appearance.titleDefaultColor = themeColor
        calendar.appearance.titleWeekendColor = .red
        calendar.appearance.borderSelectionColor = themeColor
        calendar.appearance.weekdayTextColor = themeColor
        
        calendar.appearance.headerDateFormat = "MM月 yyyy"
        
        return calendar
    }//: FUNC makeUI
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: StyCalendar
        
        init(_ parent: StyCalendar){
            self.parent = parent
        }
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            if(parent.sharedMessage.studyRoomSelectDate != date) {
                parent.isChangeDate = true
            }
            parent.sharedMessage.studyRoomSelectDate = date
        }
    }
    
    
}//: CALENDER REPRESENTABLE

struct CalendarView: View {
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 123/255)
    @EnvironmentObject var sharedMessage: SharedMessage
    @State var buildings: [StudyBuilding] = []
    @State var isGetStudyRoomBuildingMessage = false
    @Binding var isShowCalender: Bool
    @State var isChangeDate = false
    
    @State private var isFailGetOneWeek = true
    @State var weeksBuildings: [[StudyBuilding]] = [[], [], [], [], [], [], []]
    var body: some View {
        VStack{
            StyCalendar(isChangeDate: $isChangeDate)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 2, alignment: .center)
            
            // 选择具体时间的view
            VStack(spacing: 25.0) {
                HStack(spacing: 30.0){
                    StyTimeSelectionView(timePeriod: "8:30--10:05")
                    StyTimeSelectionView(timePeriod: "10:25--12:00")
                }
                
                HStack(spacing: 30.0){
                    StyTimeSelectionView(timePeriod: "13:30--15:05")
                    StyTimeSelectionView(timePeriod: "15:25--17:00")
                }
                
                HStack(spacing: 30.0){
                    StyTimeSelectionView(timePeriod: "18:30--20:05")
                    StyTimeSelectionView(timePeriod: "20:25--22:00")
                }
            }
            
            Spacer()
            HStack{
                Spacer()
                Button(action:{
                    reSave()
                    let queue = DispatchQueue.global()
                    queue.async {
                        DataStorage.store(buildings, in: .caches, as: "studyroom/todaydata.json")
                    }
                    isShowCalender = false
                }) {
                    Text("确定")
                        .font(.title2)
                        .foregroundColor(themeColor)
                }
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width * 0.9)
            
            
        }
    }
    func reSave() {
        
        let formatter = DateFormatter()
        var endDate: Date{
            formatter.dateFormat = "YYYYMMdd"
            return formatter.date(from: "20210301")!
        }
        var totalDays: Int {
            endDate.daysBetweenDate(toDate: sharedMessage.studyRoomSelectDate)
        }
        var days: Int {
           totalDays % 7 + 1
        }
        var weeks: Int {
            totalDays / 7 + 1
        }
        
        StudyRoomManager.allBuidlingGet(term: "20212", week: String(weeks), day: String(days)) { result in
            switch result {
            case .success(let data):
                buildings = data.data
                if(data.errorCode != 0) {
                    isGetStudyRoomBuildingMessage = false
                    break
                }
                DataStorage.store(buildings, in: .caches, as: "studyroom/todaydata.json")
                isGetStudyRoomBuildingMessage = true
            case .failure(_):
                isGetStudyRoomBuildingMessage = false
            }
        }
        
       
          
        for i in 0...6 {
            StudyRoomManager.allBuidlingGet(term: "20212", week: String(weeks), day: String(i+1)) { result in
                switch result {
                case .success(let data):
                    weeksBuildings[i] = data.data
                    if(data.errorCode != 0) {
                        isFailGetOneWeek = true
                        break
                    }
                    if(i == 6) {
                        DataStorage.store(weeksBuildings, in: .caches, as: "studyroom/weekdata.json")
                    }
                    isFailGetOneWeek = false
                case .failure(_):
                    isFailGetOneWeek = true
                }
            }
        }
        
            
        
    }
}

