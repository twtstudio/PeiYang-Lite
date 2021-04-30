//
//  SelectedDetailView.swift
//  PeiYang Lite
//
//  Created by 游奕桁 on 2021/2/2.
//

import SwiftUI

struct SelectedDetailView: View {
    @AppStorage(ClassesManager.isLoginKey, store: Storage.defaults) private var isCourseTableLogin = false
    @AppStorage(ClassesManager.isLoginKey, store: Storage.defaults) private var isGPALogin = false
    let selected: Destination
    var body: some View {
        switch selected {
        case .courseTable:
            Group { if isCourseTableLogin { CourseTableDetailView() } else { AcClassesBindingView() } }
        case .GPA:
            Group { if isGPALogin { GPADetailView() } else { AcClassesBindingView() } }
        case .yellowPage:
            Text("黄页")
        case .studyRoom:
            StyTopView()
        }
    }
}

struct SelectedDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedDetailView(selected: .GPA)
    }
}
