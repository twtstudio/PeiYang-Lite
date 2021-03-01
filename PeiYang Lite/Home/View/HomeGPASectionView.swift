//
//  HomeGPASectionView.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2020/12/25.
//

import SwiftUI

struct GPAGrade: View {
    var title: String
    var score: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.callout)
                .bold()
                .foregroundColor(.secondary)
            Text(score)
                .font(.title)
                .bold()
                .foregroundColor(.gray)
        }
    }
}

struct HomeGPASectionView: View {
    @ObservedObject var store = Storage.gpa
    private var gpa: GPA { store.object }
    
    @State private var activeIndex = 0
    @State private var show = true
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                if !gpa.semesterGPAArray.isEmpty {
                    HStack {
                        Text("term: \(gpa.semesterGPAArray[activeIndex].semester.fullname)")
                        Spacer()
                        Text("score: \(gpa.semesterGPAArray[activeIndex].score.decimal)")
                    }
                    .foregroundColor(.gray)
                    
                    .opacity(show ? 1 : 0)
                    .animation(.easeInOut)
                }
                
                
                CurveDetailView(data: ChartData(points: gpa.semesterGPAArray.filter({$0.gpa != 0}).map(\.score)), size: .constant(CGSize(width: geo.size.width, height: geo.size.width * 0.4)), minDataValue: .constant(nil), maxDataValue: .constant(nil), activeIndex: $activeIndex, showIndicator: $show, pathGradient: Gradient(colors: [Color(#colorLiteral(red: 0.877415359, green: 0.8721999526, blue: 0.8814247251, alpha: 1)), Color(#colorLiteral(red: 0.8789561391, green: 0.8737315536, blue: 0.8829724193, alpha: 1))]), backgroundGradient: Gradient(colors: [Color.clear]), indicatorColor: Color(#colorLiteral(red: 0.4020757079, green: 0.4150305092, blue: 0.4800136089, alpha: 1)))
            }
            .frame(height: screen.width * 0.4)
            
            NavigationLink(destination: GPADetailView()) {
            HStack {
                GPATitleView(value: gpa.score.decimal, title: .totalScore, titleColor: Color(#colorLiteral(red: 0.8040962815, green: 0.8035985827, blue: 0.8253522515, alpha: 1)), valueColor: Color(#colorLiteral(red: 0.4099749923, green: 0.4227921963, blue: 0.4921118617, alpha: 1)))
                    .padding(5)
                GPATitleView(value: gpa.gpa.decimal, title: .totalGPA, titleColor: Color(#colorLiteral(red: 0.8040962815, green: 0.8035985827, blue: 0.8253522515, alpha: 1)), valueColor: Color(#colorLiteral(red: 0.4099749923, green: 0.4227921963, blue: 0.4921118617, alpha: 1)))
                    .padding(5)
                GPATitleView(value: gpa.credit.decimal, title: .totalCredit, titleColor: Color(#colorLiteral(red: 0.8040962815, green: 0.8035985827, blue: 0.8253522515, alpha: 1)), valueColor: Color(#colorLiteral(red: 0.4099749923, green: 0.4227921963, blue: 0.4921118617, alpha: 1)))
                    .padding(5)
            }
            }
        }
    }
}

struct HomeGPASectionView_Previews: PreviewProvider {
    static var previews: some View {
        HomeGPASectionView()
    }
}
