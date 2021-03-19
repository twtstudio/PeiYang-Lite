import SwiftUI

struct CourseTableDetailView: View {
    @ObservedObject var store = Storage.courseTable
    private var courseTable: CourseTable { store.object }
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.horizontalSizeClass) private var sizeClass
    private var isRegular: Bool { sizeClass == .regular }
    
    @State private var isLoading = false
    @AppStorage(SharedMessage.isShowFullCourseKey, store: Storage.defaults) private var showFullCourse = true
    @AppStorage(SharedMessage.showCourseNumKey, store: Storage.defaults) private var showCourseNum = 5
    @AppStorage(ClassesManager.isLoginKey, store: Storage.defaults) private var isLogin = true
    @EnvironmentObject var sharedMessage: SharedMessage
    
    @State private var showLogin = false
    
    @State private var activeWeek = Storage.courseTable.object.currentWeek
    private var activeCourseArray: [Course] {
        courseTable.courseArray.filter { $0.weekRange.contains(activeWeek) }
    }
    
    @ObservedObject var alertCourse: AlertCourse
    
    @State private var isError = false
    @State private var errorMessage: LocalizedStringKey = ""
    
    @State private var navBarHeight: CGFloat = 0
    
    var body: some View {
//        GeometryReader { full in
            ZStack {
                VStack {
                    // 头部伪导航栏
//
                    NavigationBar(leading: {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.title)
                                .foregroundColor(Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)))
                        }

                    }, trailing: {
                        RefreshButton(isLoading: $isLoading, action: reload, color: Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)))
                    }).padding(.horizontal)
                    
                    
                    // MARK: - Header
                    CouseTableHeaderView(
                        activeWeek: $activeWeek,
                        showFullCourse: $showFullCourse,
                        totalWeek: courseTable.totalWeek
                    )
                    .frame(width: screen.width, height: screen.height/5, alignment: .leading)
                    
                    CourseTableWeekdaysView(
                        activeWeek: $activeWeek,
                        courseTable: courseTable,
                        width: (screen.width-40-14*CGFloat(showCourseNum)) / CGFloat(showCourseNum),//9
                        showCourseNum: showCourseNum
                    )
                    .frame(width: screen.width, alignment: .center)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        // MARK: - Table
                        VStack {
                            CourseTableContentView(
                                activeWeek: activeWeek,
                                courseArray: courseTable.courseArray,
                                width: (screen.width-40-14*CGFloat(showCourseNum)) / CGFloat(showCourseNum),//9
                                alertCourse: alertCourse,
                                showFullCourse: $showFullCourse
                            )
                            .frame(width: screen.width, height: screen.height*1.2, alignment: .top)
                            
                            if let totalHour = getCourseHour(week: courseTable.totalWeek), let currentHour = getCourseHour(week: activeWeek) {
                                ProgressBarView(current: currentHour, total: totalHour)
                                    .padding(.horizontal)
                                    .frame(width: screen.width, height: 80, alignment: .center)
                            }
                        }
                        .padding(.horizontal, 10)
                    }
//                    .frame(width: full.size.width, height: full.size.height*1.2)
                    .alert(isPresented: $isError) {
                        Alert(title: Text(errorMessage),
                              dismissButton: .default(Text(Localizable.ok.rawValue)))
                    }
                    NavigationLink(
                        destination: AcClassesBindingView(),
                        isActive: $showLogin,
                        label: {EmptyView()})
                }
                
                if alertCourse.showDetail {
                    Group {
                        Color.clear
                            .frame(width: screen.width,
                                   height: screen.height,
                                   alignment: .center)
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
                    .animation(.easeInOut)
                    .onTapGesture {
                        withAnimation(.easeOut) {
                            self.alertCourse.showDetail = false
                        }
                    }
                }
                
            }
        .onAppear(perform: load)
        .edgesIgnoringSafeArea(.bottom)
        .edgesIgnoringSafeArea(.horizontal)
        .navigationBarHidden(true)
        //        .navigationBarBackButtonHidden(true)
        //        .navigationBarItems(
        //            leading: Button(action: {
        //                self.presentationMode.wrappedValue.dismiss()
        //            }){
        //                Image("back-arrow")
        //            },
        //            trailing: RefreshButton(isLoading: $isLoading, action: load, color: Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)))
        //        )
    }
    //MARK: function: LOAD
    func load() {
        isLoading = true
//        ClassesManager.checkLogin { result in
//            switch result {
//            case .success:
//                return
//            case .failure(let error):
//                sharedMessage.isBindBs = false
//                if error == .requestFailed {
//                    isError = true
//                    errorMessage = error.localizedStringKey
//                } else {
//                    showLogin = true
//                }
//            }
//        }
        
        ClassesManager.getCourseTable { result in
            switch result {
            case .success(let courseTable):
                store.object = courseTable
                store.save()
            case .failure(let error):
                print(error)
            }
            isLoading = false
        }
    }
    
    func reload() {
        isLoading = true
        ClassesManager.checkLogin { result in
            switch result {
            case .success:
                return
            case .failure(let error):
                sharedMessage.isBindBs = false
                if error == .requestFailed {
                    isError = true
                    errorMessage = error.localizedStringKey
                } else {
                    sharedMessage.isBindBs = false
                    isLogin = false
                    showLogin = true
                }
            }
        }
        
        ClassesManager.getCourseTable { result in
            switch result {
            case .success(let courseTable):
                store.object = courseTable
                store.save()
            case .failure(let error):
                print(error)
            }
            isLoading = false
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
            CourseTableDetailView(alertCourse: AlertCourse())
                .environment(\.colorScheme, .dark)
        }
    }
}
