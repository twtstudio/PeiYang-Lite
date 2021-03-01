//
//  HomeDetailView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/6/20.
//

import SwiftUI

struct HomeDetailView: View {
    let module: Home
    
    var body: some View {
        switch module {
        case .courseTable:
<<<<<<< HEAD
            CourseTableDetailView()
=======
            CourseTableDetailView(alertCourse: AlertCourse())
>>>>>>> e4291697b2a03afcf4cfbf314ae8cf47114102d1
        case .gpa:
            GPADetailView()
        case .ecard:
            ECardDetailView()
        case .wlan:
            WLANDetailView()
        }
    }
}
