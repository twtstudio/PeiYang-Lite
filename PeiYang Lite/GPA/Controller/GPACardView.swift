//
//  GPACardView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/5/20.
//

import SwiftUI

struct GPACardView: View {
    @ObservedObject var store = Storage.gpa
    private var gpa: GPA { store.object }
    
    @State private var activeIndex = 0
    @State private var show = false
    
    var body: some View {
        VStack {
            HStack {
                Text(Localizable.gpa.rawValue)
<<<<<<< HEAD
                    .font(.title2)
=======
                    .font(.title)
>>>>>>> e4291697b2a03afcf4cfbf314ae8cf47114102d1
                
                Spacer()
                
                if !gpa.semesterGPAArray.isEmpty {
                    VStack(alignment: .leading) {
                        Text("term: \(gpa.semesterGPAArray[activeIndex].semester.fullname)")
                        Text("score: \(gpa.semesterGPAArray[activeIndex].score.decimal)")
                    }
                    .opacity(show ? 1 : 0)
                }
            }
            
            if gpa.semesterGPAArray.isEmpty {
                Text(Localizable.emptyGPAMeesage.rawValue)
                    .frame(maxHeight: .infinity)
            } else {
                GeometryReader { geo in
                    CurveCardView(
                        data: ChartData(points: gpa.semesterGPAArray.map(\.score)),
                        size: .constant(geo.size),
                        minDataValue: .constant(nil),
                        maxDataValue: .constant(nil),
                        activeIndex: $activeIndex,
                        showIndicator: $show,
                        pathGradient: Gradient(colors: [Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)), Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))]),
                        indicatorColor: Color(#colorLiteral(red: 1, green: 0.3411764706, blue: 0.6509803922, alpha: 1))
                    )
                }
            }
        }
    }
}

struct GPACardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            GeometryReader{ geometry in
                GPACardView()
            }
            .frame(width: 300, height: 180)
            .environment(\.colorScheme, .dark)
        }
    }
}

extension Double {
    var decimal: String {
        NumberFormatter.localizedString(from: NSNumber(value: self), number: .decimal)
    }
}
