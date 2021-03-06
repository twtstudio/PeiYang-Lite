//
//  SelectedDetailView.swift
//  PeiYang Lite
//
//  Created by 游奕桁 on 2021/2/2.
//

import SwiftUI

struct SelectedDetailView: View {
    let selected: Destination
    var body: some View {
        switch selected {
        case .courseTable:
            CourseTableDetailView2(alertCourse: AlertCourse())
        case .GPA:
            GPADetailView()
        case .yellowPage:
            Text("黄页")
        case .studyRoom:
            StudyRoomTopView()
        }
    }
}

struct SelectedDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedDetailView(selected: .GPA)
    }
}
