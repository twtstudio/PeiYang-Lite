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
            CourseTableDetailView()
        case .gpa:
            GPADetailView()
        case .ecard:
            ECardDetailView()
        case .wlan:
            WLANDetailView()
        }
    }
}
