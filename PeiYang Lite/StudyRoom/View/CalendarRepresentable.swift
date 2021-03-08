//
//  CalendarRepresentable.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/1/31.
//

import SwiftUI
import UIKit
import FSCalendar

//MARK: Calendar
struct CalendarRepresentable: UIViewRepresentable {
    let themeColor = UIColor.init(red: 98/255, green: 103/255, blue: 123/255, alpha: 1)
    typealias UIViewType = FSCalendar
    var calendar = FSCalendar()
    @EnvironmentObject var sharedMessage: SharedMessage
//    @Binding var selectedDate: Date
    
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
        var parent: CalendarRepresentable
        
        init(_ parent: CalendarRepresentable){
            self.parent = parent
        }
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.sharedMessage.studyRoomSelectDate = date
        }
    }
    
    
}//: CALENDER REPRESENTABLE

struct CalendarView: View {
    let themeColor = Color.init(red: 98/255, green: 103/255, blue: 123/255)
    @EnvironmentObject var sharedMessage: SharedMessage
//    @Binding var selectedDate: Date
//    @Binding var selectedTimePeriod: String
    @Binding var isShowCalender: Bool
    var body: some View {
        VStack{
            CalendarRepresentable()
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height / 2, alignment: .center)
            
            // 选择具体时间的view
            VStack(spacing: 25.0) {
                HStack(spacing: 30.0){
                    TimeSelectionView(timePeriod: "8:30--10:05")
                    TimeSelectionView(timePeriod: "10:25--12:00")
                }
                
                HStack(spacing: 30.0){
                    TimeSelectionView(timePeriod: "13:30--15:05")
                    TimeSelectionView(timePeriod: "15:25--17:00")
                }
                
                HStack(spacing: 30.0){
                    TimeSelectionView(timePeriod: "18:30--20:05")
                    TimeSelectionView(timePeriod: "20:25--22:00")
                }
            }
            
            Spacer()
            HStack{
                Spacer()
                Button(action:{
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
}

