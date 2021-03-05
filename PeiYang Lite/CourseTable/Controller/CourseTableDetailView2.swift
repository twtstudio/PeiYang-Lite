import SwiftUI

struct CourseTableDetailView2: View {
    @ObservedObject var store = Storage.courseTable
    private var courseTable: CourseTable { store.object }
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) private var sizeClass
    private var isRegular: Bool { sizeClass == .regular }
    
    @State private var isLoading = false
    @AppStorage(SharedMessage.isShowFullCourseKey, store: Storage.defaults) private var showFullCourse = true
    @AppStorage(SharedMessage.showCourseNumKey, store: Storage.defaults) private var showCourseNum = 5
    
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
        GeometryReader { full in
            ZStack {
                VStack {
                    // 头部伪导航栏
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.title)
                                .foregroundColor(Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)))
                                .padding()
                        }
                        
                        Spacer()
                        
                        RefreshButton(isLoading: $isLoading, action: load, color: Color(#colorLiteral(red: 0.3856853843, green: 0.403162986, blue: 0.4810273647, alpha: 1)))
                    }
                    .padding(.top, 40)
                    .padding(.trailing, 20)
                    
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        // MARK: - Header
                        CouseTableHeaderView(
                            activeWeek: $activeWeek,
                            showFullCourse: $showFullCourse,
                            totalWeek: courseTable.totalWeek
                        )
                        //                    .padding()
                        .frame(width: screen.width, height: full.size.height/5, alignment: .leading)
                        
                        // MARK: - Table
                        if isRegular {
                            Section(header:
                                        CourseTableWeekdaysView(
                                            activeWeek: $activeWeek,
                                            courseTable: courseTable,
                                            width: full.size.width / CGFloat(showCourseNum+2)//9
                                        ).frame(width: full.size.width)
                            ) {
                                CourseTableContentView(
                                    activeWeek: activeWeek,
                                    courseArray: courseTable.courseArray,
                                    width: full.size.width / CGFloat(showCourseNum+2),
                                    alertCourse: alertCourse,
                                    showFullCourse: $showFullCourse//9
                                )
                                .frame(width: full.size.width, height: full.size.height*2)
                            }
                            .padding(.horizontal, 20)
                        } else {
                            VStack {
                                CourseTableWeekdaysView(
                                    activeWeek: $activeWeek,
                                    courseTable: courseTable,
                                    width: full.size.width / CGFloat(showCourseNum+2)//9
                                )
                                .frame(width: full.size.width, alignment: .center)
                                
                                CourseTableContentView(
                                    activeWeek: activeWeek,
                                    courseArray: courseTable.courseArray,
                                    width: full.size.width / CGFloat(showCourseNum+2),//9
                                    alertCourse: alertCourse,
                                    showFullCourse: $showFullCourse
                                )
                                .frame(width: full.size.width, height: full.size.height, alignment: .top)
                                
                                if let totalHour = getCourseHour(week: courseTable.totalWeek), let currentHour = getCourseHour(week: activeWeek) {
                                    ProgressBarView(current: currentHour, total: totalHour)
                                        .padding(.horizontal)
                                        .frame(width: full.size.width, height: full.size.width, alignment: .center)
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                    
                    .frame(width: full.size.width, height: full.size.height)
                    .alert(isPresented: $isError) {
                        Alert(title: Text(errorMessage),
                              dismissButton: .default(Text(Localizable.ok.rawValue)))
                    }
                    NavigationLink(
                        destination: ClassesBindingView(),
                        isActive: $showLogin,
                        label: {})
                }
                
                if alertCourse.showDetail {
                    Group {
                        Color.clear
                            .frame(width: full.size.width,
                                   height: full.size.height,
                                   alignment: .center)
                            .contentShape(Rectangle())
                        
                        CourseDetailView(course: $alertCourse.currentCourse, weekDay: $alertCourse.currentWeekday, isRegular: isRegular)
                            .frame(width: full.size.width / 1.5, height: full.size.height / 1.8, alignment: .center)
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
        }
        .onAppear(perform: load)
        .edgesIgnoringSafeArea(.all)
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
                    showLogin = true
                }
            }
        }
        
        ClassesManager.courseTablePost { result in
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
            Color.black
                .edgesIgnoringSafeArea(.all)
            CourseTableDetailView2(alertCourse: AlertCourse())
                .environment(\.colorScheme, .dark)
        }
    }
}
