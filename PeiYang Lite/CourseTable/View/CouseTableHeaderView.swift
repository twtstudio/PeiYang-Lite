//
//  CouseTableHeaderView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/31/20.
//

import SwiftUI

struct CouseTableHeaderView: View {
    @Binding var activeWeek: Int
    @Binding var showFullCourse: Bool
    var totalWeek: Int
    
    var body: some View {
        HStack {
            Text(Localizable.courseTable.rawValue)
                .font(.title)
            
            Spacer()
            
            Button(action: {
                self.showFullCourse.toggle()
            }, label: {
                Text(showFullCourse ? "onlyThisWeek" : "fullCourse")
            })
            .cthViewButtonModifier()
            
            Menu("week \(activeWeek.description)") {
                ForEach(1...totalWeek, id: \.self) { week in
                    Button("week \(week.description)") {
                        activeWeek = week
                    }
                }
            }
            .cthViewButtonModifier()
        }
    }
}

struct CouseTableHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            CouseTableHeaderView(activeWeek: .constant(1), showFullCourse: .constant(false), totalWeek: 1)
                .environment(\.colorScheme, .dark)
        }
    }
}
