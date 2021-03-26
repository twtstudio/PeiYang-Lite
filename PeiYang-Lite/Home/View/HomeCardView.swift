//
//  HomeCardView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/6/20.
//

import SwiftUI

struct HomeCardView: View {
    let module: Home
    
    var body: some View {
        switch module {
        case .courseTable:
            CourseTableCardView()
        case .gpa:
            GPACardView()
        case .ecard:
            ECardCardView()
        case .wlan:
            WLANCardView()
        }
    }
}
