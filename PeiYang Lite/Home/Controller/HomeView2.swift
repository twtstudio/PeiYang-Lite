//
//  HomeView2.swift
//  PeiYang Lite
//
//  Created by Zr埋 on 2020/10/22.
//

import SwiftUI

struct MyCourse {
    var name = ""
    var time = ""
    var loc = ""
}
struct HomeView2: View {
    @ObservedObject var store = Storage.gpa
    private var gpa: GPA { store.object }
    
    @State private var activeIndex = 0
    @State private var show = false
    
    let classTableData: [MyCourse] = [
        MyCourse(name: "Software Engineering", time: "08:30 - 10:30", loc: "45-B331"),
        MyCourse(name: "Software Engineering", time: "08:30 - 10:30", loc: "45-B331"),
        MyCourse(name: "Software Engineering", time: "08:30 - 10:30", loc: "45-B331"),
        MyCourse(name: "Software Engineering", time: "08:30 - 10:30", loc: "45-B331"),
        MyCourse(name: "Software Engineering", time: "08:30 - 10:30", loc: "45-B331"),
    ]
    
    var body: some View {
        GeometryReader { full in
            VStack {
                HeaderView()
                    .padding()
                Form {
                    Section(header: Text("NO.12 MON")) {
                        CourseScrollView(data: classTableData)
                    }
                    Section(header: Text("GPA")) {
                        VStack {
                            GeometryReader { geo in
                                CurveCardView(
                                    data: ChartData(points: gpa.semesterGPAArray.isEmpty ? [0, 0] : gpa.semesterGPAArray.map(\.score)),
                                    size: .constant(geo.size),
                                    minDataValue: .constant(nil),
                                    maxDataValue: .constant(nil),
                                    activeIndex: $activeIndex,
                                    showIndicator: $show,
                                    pathGradient: Gradient(colors: [Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)), Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))]),
                                    indicatorColor: Color(#colorLiteral(red: 1, green: 0.3411764706, blue: 0.6509803922, alpha: 1))
                                )
                                .frame(width: geo.size.width, height: geo.size.width * 0.6)
                            }
                            
                            HStack {
                                GPAGrade(title: "Total Weighted", score: "98.231")
                                Spacer()
                                GPAGrade(title: "Total Grade", score: "3.952")
                            }
                        }
                    }
                }
                
                
            }
        }
//        .ignoresSafeArea(edges: [.top, .bottom])
        .onAppear {
            UITableView.appearance().backgroundColor = .white
        }
        
    }
}

struct HomeView2_Previews: PreviewProvider {
    static var previews: some View {
        HomeView2()
    }
}

fileprivate struct HeaderView: View {
    var body: some View {
        HStack {
            Text("2020.20.20")
                .font(.title)
                .bold()
            Spacer()
            Text("Zrzz")
                .padding()
            Image("123")
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
        }
    }
}

struct CourseScrollView: View {
    var data: [MyCourse]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(data, id: \.name) { course in
                    VStack(alignment: .leading) {
                        Group {
                            Text(course.name.replacingOccurrences(of: " ", with: "\n"))
                                .bold()
                            Text(course.time)
                            
                            Text(course.loc)
                                .bold()
                        }
                        .foregroundColor(.white)
                        .padding()
                    }
                    .background(Color.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                }
            }
        }
    }
}

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
