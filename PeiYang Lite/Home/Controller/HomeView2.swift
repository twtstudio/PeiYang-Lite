//
//  HomeView2.swift
//  PeiYang Lite
//
//  Created by Zr埋 on 2020/10/22.
//

import SwiftUI

struct MyCourse {
    var name: String
    var time: String
    var loc: String
}

struct Module {
    var image: Image
    var title: String
}
struct HomeView2: View {
    
    private var safeAreaHeight: CGFloat {
        return (UIApplication.shared.windows.first ?? UIWindow()).safeAreaInsets.top == 44 ? 44 : 0
    }
    
    init() {
        UITableView.appearance().backgroundColor = .white
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            HeaderView()
            
            ModuleScrollView()
            
            Section(header: HStack {
                Text("NO.12 MON")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }) {
                CourseScrollView()
            }
            Section(header: HStack {
                Text("GPA")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }) {
                GPAView()
            }
        }
        .padding([.horizontal])
        .padding(.top, safeAreaHeight)
        .edgesIgnoringSafeArea(.top)
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
    let classTableData: [MyCourse] = [
        MyCourse(name: "Software Engineering", time: "08:30 - 10:30", loc: "45-B331"),
        MyCourse(name: "Software Engineering", time: "08:30 - 10:30", loc: "45-B331"),
        MyCourse(name: "Software Engineering", time: "08:30 - 10:30", loc: "45-B331"),
        MyCourse(name: "Software Engineering", time: "08:30 - 10:30", loc: "45-B331"),
        MyCourse(name: "Software Engineering", time: "08:30 - 10:30", loc: "45-B331"),
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(classTableData, id: \.name) { course in
                    VStack(alignment: .leading) {
                        Group {
                            Text(course.name.replacingOccurrences(of: " ", with: "\n"))
                                .bold()
                                .padding()
                            Text(course.time)
                                .padding()
                            
                            Text(course.loc)
                                .bold()
                                .padding([.bottom, .horizontal])
                        }
                        .foregroundColor(.white)
                    }
                    .contentShape(RoundedRectangle(cornerRadius: 25.0))
                    .background(Color.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .shadow(color: Color.secondary.opacity(0.3), radius: 5, x: 0, y: 5)
                    .padding([.vertical])
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

struct GPAView: View {
    @ObservedObject var store = Storage.gpa
    private var gpa: GPA { store.object }
    
    @State private var activeIndex = 0
    @State private var show = false
    
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
                CurveCardView(
                    data: ChartData(points: gpa.semesterGPAArray.isEmpty ? [0, 0] : gpa.semesterGPAArray.map(\.score)),
                    size: .constant(CGSize(width: geo.size.width, height: geo.size.width * 0.4)),
                    minDataValue: .constant(nil),
                    maxDataValue: .constant(nil),
                    activeIndex: $activeIndex,
                    showIndicator: $show,
                    pathGradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0.9411764706, green: 0.9450980392, blue: 0.9490196078, alpha: 1))]),
                    indicatorColor: Color(#colorLiteral(red: 0.8039215686, green: 0.8078431373, blue: 0.8274509804, alpha: 1))
                )
            }
            .frame(height: screen.width * 0.4)
            
            HStack {
                GPAGrade(title: "Total Weighted", score: "98.231")
                Spacer()
                GPAGrade(title: "Total Grade", score: "3.952")
            }
        }
    }
}

struct ModuleScrollView: View {
    
    let modules: [Module] = [
        Module(image: Image("123"), title: "Schedule"),
        Module(image: Image("123"), title: "Schedule"),
        Module(image: Image("123"), title: "Schedule"),
        Module(image: Image("123"), title: "Schedule"),
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(modules, id: \.title) { module in
                    NavigationLink(
                        destination: Text("Destination"),
                        label: {
                            VStack {
                                GeometryReader { geo in
                                    module.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geo.size.width)
                                }
                                Text(module.title)
                                    .bold()
                                    .foregroundColor(Color(#colorLiteral(red: 0.4156862745, green: 0.4274509804, blue: 0.4901960784, alpha: 1)))
                            }
                            .padding()
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                        })
                }
                .padding([.vertical])
            }
            .frame(height: screen.width * 0.4)
        }
    }
}
