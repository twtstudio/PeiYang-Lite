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
    
    @StateObject private var alertCourse: AlertCourse = .init()
    
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
                            alertCourse: alertCourse,
                            showFullCourse: $showFullCourse
                        )
                        // 单节课高度 * 12
                        .frame(height: screen.width / CGFloat(showCourseNum) * 1.5 * 12, alignment: .top)
                    }
                }
//                NavigationLink(
//                    destination: AcClassesBindingView(),
//                    isActive: $showLogin,
//                    label: { EmptyView() })
            }
            
            if alertCourse.showDetail {
                ZStack {
                    Color.clear
                        
                        .frame(width: screen.width,
                               alignment: .center)
                        .frame(maxHeight: .infinity)
                        .contentShape(Rectangle())
                    
                    CourseDetailView(course: $alertCourse.currentCourse, weekDay: $alertCourse.currentWeekday, isRegular: isRegular)
                        .frame(width: screen.width / 1.5, height: screen.height / 1.8, alignment: .center)
                        .background(
                            Image("emblem")
                                .resizable()
                                .scaledToFit()
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(color: Color.gray.opacity(0.5), radius: 8, x: 5, y: 5)
                }
                .offset(x: 0, y: floatViewOffset)
                .animation(.easeIn)
                .onTapGesture {
                    withAnimation(.easeOut) {
                        floatViewOffset -= 20
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            withAnimation(.easeOut) {
                                self.alertCourse.showDetail = false
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
