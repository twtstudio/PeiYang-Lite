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

<<<<<<< HEAD
struct Module {
    var image: Image
    var title: String
}
struct HomeView2: View {
    
    private var safeAreaHeight: CGFloat {
        return (UIApplication.shared.windows.first ?? UIWindow()).safeAreaInsets.top == 44 ? 44 : 0
=======
enum Destination {
    case courseTable, yellowPage, GPA, studyRoom
}

struct Module {
    var image: Image
    var title: String
    var destination: Destination
}

struct StudyRoom: Identifiable {
    let id: UUID = UUID()
    var image: Image
    var building: String
    var number: String
    var isAvailable: Bool
    
    var description: String {
        building + "教 " + number
    }
}

struct HomeView2: View {
    @AppStorage(ClassesManager.isGPAStoreKey, store: Storage.defaults) private var isNotShowGPA = true
    
    private var safeAreaHeight: CGFloat {
        return (UIApplication.shared.windows.first ?? UIWindow()).safeAreaInsets.top
>>>>>>> origin/PhoneixBranch
    }
    
    init() {
        UITableView.appearance().backgroundColor = .white
    }
<<<<<<< HEAD
    
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
=======
    @EnvironmentObject var sharedMessage: SharedMessage
    var body: some View {

        
            VStack {
                HomeHeaderView(AccountName: sharedMessage.Account.nickname)
                .padding(.top, safeAreaHeight)
                .padding(.horizontal)
                
            ScrollView(showsIndicators: false) {
            HomeModuleSectionView()
//                .padding(.horizontal)
            
            Section(header: HStack {
                Text(Localizable.courseTable.rawValue)
                    .font(.title3)
                    .bold()
                    .foregroundColor(Color(#colorLiteral(red: 0.3803921569, green: 0.3960784314, blue: 0.4862745098, alpha: 1)))
                    .padding(.horizontal)
                Spacer()
            }) {
                HomeCourseSectionView()
            }
            
            if(!isNotShowGPA) {
                Section(header: HStack {
                    Text(Localizable.gpa.rawValue)
                        .font(.title3)
                        .bold()
                        .foregroundColor(Color(#colorLiteral(red: 0.3803921569, green: 0.3960784314, blue: 0.4862745098, alpha: 1)))
                    Spacer()
                }) {
                    HomeGPASectionView()
                }
                .padding(.horizontal)
            }
            
            Section(header: HStack {
                Text("自习室")
                    .font(.title3)
                    .bold()
                    .foregroundColor(Color(#colorLiteral(red: 0.3803921569, green: 0.3960784314, blue: 0.4862745098, alpha: 1)))
                    .padding(.horizontal)
                Spacer()
            }) {
                HomeStudyRoomSectionView()
                    .padding(.bottom, 80)
            }
            }
            
        }
        .navigationBarHidden(true)
        .background(Color(#colorLiteral(red: 0.9352087975, green: 0.9502342343, blue: 0.9600060582, alpha: 1)))
        .edgesIgnoringSafeArea(.all)
        

        
    }
    
    
>>>>>>> origin/PhoneixBranch
}

struct HomeView2_Previews: PreviewProvider {
    static var previews: some View {
        HomeView2()
    }
}

<<<<<<< HEAD
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
=======



>>>>>>> origin/PhoneixBranch
