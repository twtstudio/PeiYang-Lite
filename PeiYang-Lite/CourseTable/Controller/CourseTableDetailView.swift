//
//  CourseTableDetailView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/30/20.
//

import SwiftUI
import SwiftMessages

struct CourseTableDetailView: View {
    @ObservedObject var store = Storage.courseTable
    private var courseTable: CourseTable { store.object }
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.horizontalSizeClass) private var sizeClass
    private var isRegular: Bool { sizeClass == .regular }
    
    @State private var isLoading = false
    @AppStorage(SharedMessage.isShowFullCourseKey, store: Storage.defaults) private var showFullCourse = true
    @AppStorage(SharedMessage.showCourseNumKey, store: Storage.defaults) private var showCourseNum = 6
    @AppStorage(ClassesManager.isLoginKey, store: Storage.defaults) private var isLogin = true
    @EnvironmentObject var sharedMessage: SharedMessage
    
//    @State private var showLogin = false
    
    @State private var activeWeek = Storage.courseTable.object.currentWeek
    
    @StateObject private var courseConfig: CourseConfig = .init()
    
    @State private var isError = false
    @State private var showRelogin = false
    @State private var errorMessage: String = ""
    
    @State private var floatViewOffset: CGFloat = 0
    
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                NavigationBar(trailing: {
                    RefreshButton(isLoading: $isLoading, action: reload, color: Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)))
                        .padding()
                })
                
                // MARK: - Header
                CouseTableHeaderView(
                    activeWeek: $activeWeek,
                    showFullCourse: $showFullCourse,
                    totalWeek: courseTable.totalWeek
                )
                .padding(.horizontal)
                .frame(alignment: .leading)
                
                CourseTableWeekdaysView(
                    activeWeek: $activeWeek,
                    courseTable: courseTable,
                    width: screen.width,
                    showCourseNum: showCourseNum
                )
                .frame(width: screen.width, alignment: .center)
                
                ScrollView(.vertical, showsIndicators: false) {
                    // MARK: - Table
                    VStack {
                        CourseTableContentView(
                            activeWeek: activeWeek,
                            courseArray: courseTable.courseArray,
                            width: screen.width,
                            courseConfig: courseConfig,
                            showFullCourse: $showFullCourse
                        )
                        // 单节课高度 * 12 (screen.height / 12) * 12 = screen.height
                        .frame(height: screen.height, alignment: .top)
                    }
                }
            }
            
            if courseConfig.showDetail {
                ZStack {
                    Color.clear
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        let svWidth = screen.width / 1.5
                        let svHeight = svWidth * 1.4
                        HStack {
                            Spacer(minLength: (screen.width - svWidth) / 2)

                            ForEach(courseConfig.currentCourses, id: \.self) { course in
                                GeometryReader { g in
                                    CourseDetailView(course: course, weekDay: courseConfig.currentWeekday, isRegular: isRegular)
                                        .scaleEffect(1 - (abs((g.frame(in: .global).midX - screen.width / 2))) / (screen.width * 3))
                                        .rotation3DEffect(Angle(degrees:Double(g.frame(in: .global).midX - screen.width / 2) / -20), axis: (x: 0, y: 1, z: 0))

                                }
                                .frame(width: svWidth, height: svHeight)
                            }


                            Spacer(minLength: (screen.width - svWidth) / 2)
                        }
                    }
                }
                .offset(x: 0, y: floatViewOffset)
                .animation(.easeIn)
                .onTapGesture {
                    withAnimation(.easeOut) {
                        floatViewOffset -= 20
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            withAnimation(.easeOut) {
                                self.courseConfig.showDetail = false
                                floatViewOffset = 0
                            }
                        }
                    }
                }
            }
        }
        .onAppear(perform: load)
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
        .addAnalytics(className: "CourseTableDetailView")
        .showReloginView($showRelogin) { (result) in
            switch result {
            case .success:
                showRelogin = false
                self.reload()
            case .failure: break
            }
        }
    }
    
    //MARK: function: LOAD
    func load() {
        if courseTable.courseArray.isEmpty {
            reload()
        }
    }
    
    func reload() {
        isLoading = true
        ClassesManager.checkLogin { result in
            switch result {
            case .success:
                ClassesManager.getCourseTable { result in
                    switch result {
                    case .success(let courseTable):
                        store.object = courseTable
                        store.save()
                        // 刷新HeaderView的周数
                        activeWeek = Storage.courseTable.object.currentWeek
                    case .failure(let error):
                        log(error)
                    }
                    isLoading = false
                }
                return
            case .failure(let error):
                sharedMessage.isBindBs = false
                if error == .requestFailed {
                    isError = true
                    errorMessage = error.localizedDescription
                } else {
                    sharedMessage.isBindBs = false
                    isLogin = false
                    isLoading = false
                    showRelogin = true
                }
            }
        }
    }
    
    private func getCourseHour(week: Int) -> Double {
        var hourCount: Double = 0
        for arrange in courseTable.courseArray.flatMap(\.arrangeArray) {
            for i in 1...week {
                if arrange.weekArray.contains(i) {
                    hourCount += Double(arrange.length)*1.5
                }
            }
        }
        return hourCount
    }
}

struct NavBarAccessor: UIViewControllerRepresentable {
    var callback: (UINavigationBar) -> Void
    private let proxyController = ViewController()
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavBarAccessor>) ->
    UIViewController {
        proxyController.callback = callback
        return proxyController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavBarAccessor>) {
    }
    
    typealias UIViewControllerType = UIViewController
    
    private class ViewController: UIViewController {
        var callback: (UINavigationBar) -> Void = { _ in }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let navBar = self.navigationController {
                self.callback(navBar.navigationBar)
            }
        }
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
    
}

struct CourseTableDetailView2_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
//            Color.black
//                .edgesIgnoringSafeArea(.all)
            CourseTableDetailView()
                .environment(\.colorScheme, .dark)
        }
    }
}
