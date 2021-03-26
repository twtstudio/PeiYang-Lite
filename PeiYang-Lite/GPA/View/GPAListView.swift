//
//  GPAListView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 8/2/20.
//

import SwiftUI

struct GPAListView: View {
    let activeSemesterGPA: SemesterGPA
    var titleColor: Color
    var valueColor: Color
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    private var isRegular: Bool { sizeClass == .regular }
    
    var body: some View {
        VStack {
            HStack {
                if isRegular {
                    GPATitleView(value: activeSemesterGPA.semester.fullname, title: .term, titleColor: titleColor, valueColor: valueColor)
                    GPATitleView(value: activeSemesterGPA.score.decimal, title: .score, titleColor: titleColor, valueColor: valueColor)
                    GPATitleView(value: activeSemesterGPA.gpa.decimal, title: .gpa, titleColor: titleColor, valueColor: valueColor)
                    GPATitleView(value: activeSemesterGPA.credit.decimal, title: .credit, titleColor: titleColor, valueColor: valueColor)
                } else {
                    VStack {
                        GPATitleView(value: activeSemesterGPA.semester.fullname, title: .term, titleColor: titleColor, valueColor: valueColor)
                        GPATitleView(value: activeSemesterGPA.score.decimal, title: .score, titleColor: titleColor, valueColor: valueColor)
                    }
                    
                    VStack {
                        GPATitleView(value: activeSemesterGPA.gpa.decimal, title: .gpa, titleColor: titleColor, valueColor: valueColor)
                        GPATitleView(value: activeSemesterGPA.credit.decimal, title: .credit, titleColor: titleColor, valueColor: valueColor)
                    }
                }
            }
            
            List {
                ForEach(activeSemesterGPA.gpaArray, id: \.no) { singleGPA in
                    VStack(alignment: .leading) {
                        Text(singleGPA.name)
                            .padding(.bottom)
                        
                        HStack {
                            Text("score: \(singleGPA.score.decimal)")
                            Text("gpa: \(singleGPA.gpa.decimal)")
                            Text("credit: \(singleGPA.credit.decimal)")
                        }
                        .font(.headline)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .listRowInsets(EdgeInsets())
                }
            }
        }
    }
}

struct GPAListView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            GPAListView(activeSemesterGPA: SemesterGPA(), titleColor: Color.white, valueColor: Color.white)
                .environment(\.colorScheme, .dark)
        }
    }
}
