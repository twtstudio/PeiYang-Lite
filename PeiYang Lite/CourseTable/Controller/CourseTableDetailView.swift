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
    
    @StateObject private var alertCourse: AlertCourse = .init()
    
    @State private var isError = false
    @State private var errorMessage: String = ""
    
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
                    width: (screen.width-40-14*CGFloat(showCourseNum)) / CGFloat(showCourseNum),//9
                    showCourseNum: showCourseNum
                )
                .frame(width: screen.width, alignment: .center)
                .padding(.bottom, 5)
                
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
                        .frame(width: screen.width, height: screen.height*1.52, alignment: .top)
                        
                        if let totalHour = getCourseHour(week: courseTable.totalWeek), let currentHour = getCourseHour(week: activeWeek) {
                            ProgressBarView(current: currentHour, total: totalHour)
                                .padding(.horizontal)
                                .frame(width: screen.width, height: 80, alignment: .center)
                        }
                    }
                    NavigationLink(
                        destination: AcClassesBindingView(),
                        isActive: $showLogin,
                        label: {EmptyView()})
                }
                NavigationLink(
                    destination: ClassesBindingView(),
                    isActive: $showLogin,
                    label: { EmptyView() })
                
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
                .animation(.easeInOut)
                .onTapGesture {
                    withAnimation(.easeOut) {
                        self.alertCourse.showDetail = false
                    }
                }
            }
        .onAppear(perform: load)
        .edgesIgnoringSafeArea(.bottom)
        .edgesIgnoringSafeArea(.horizontal)
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
        
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
//                    errorMessage = error.localizedDescription
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
                    errorMessage = error.localizedDescription
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
            CourseTableDetailView()
                .environment(\.colorScheme, .dark)
        }
    }
}
