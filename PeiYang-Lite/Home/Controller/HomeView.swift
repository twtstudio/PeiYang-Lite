//
//  HomeView.swift
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

struct HomeView: View {
    @AppStorage(SharedMessage.isShowGPAKey, store: Storage.defaults) private var isShowGPA = true
    
    private var safeAreaHeight: CGFloat {
        return (UIApplication.shared.windows.first ?? UIWindow()).safeAreaInsets.top
    }
    
    init() {
        UITableView.appearance().backgroundColor = .white
    }
    @EnvironmentObject var sharedMessage: SharedMessage
    @State private var showUpdateView: Bool = false
    
    var body: some View {
        VStack {
            HomeHeaderView(AccountName: sharedMessage.Account.nickname)
                .padding(.top, safeAreaHeight)
                .padding(.horizontal)

            ScrollView(showsIndicators: false) {
                
            HomeModuleSectionView()
                .padding(.bottom)

            HomeCourseSectionView()
                .padding(.bottom)

            if(isShowGPA) {
                Section(header: HStack {
                    Text(Localizable.gpa.rawValue)
                        .font(.title3)
                        .bold()
                        .foregroundColor(Color(#colorLiteral(red: 0.3803921569, green: 0.3960784314, blue: 0.4862745098, alpha: 1)))
                    Spacer()
                }) {
                    HomeGPASectionView()
                        .padding(.bottom)
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
        .addAnalytics(className: "HomeView")
//        HomeScrollView(model: homeViewModel)
        .onAppear(perform: checkUpdate)
        .showUpdateView($showUpdateView)
    }
    
    private func checkUpdate() {
        struct LookUpResponse: Codable {
            let results: [LookUpResult]?
        }
        struct LookUpResult: Codable {
            let version: String?
        }
        
        let appid = String(1542905353)
        let localVersion:String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        Network.fetch("http://itunes.apple.com/lookup?id=" + appid) { (result) in
            switch result {
            case .success(let (data, _)):
                do {
                    let res = try JSONDecoder().decode(LookUpResponse.self, from: data)
                    guard !(res.results ?? []).isEmpty else { return }
                    let newVersion = res.results![0].version ?? ""
                    let lvArr = localVersion.split(separator: ".").map { s in Int(s) ?? 0 }
                    let nvArr = newVersion.split(separator: ".").map { s in Int(s) ?? 0 }
                    let shouldUpdate = zip(lvArr, nvArr).reduce(false) { (oldResult, tup) in oldResult || (tup.0 < tup.1) }
                    if shouldUpdate {
                        showUpdateView = true
                    }
                } catch {
                    log(error)
                }
            case .failure(let error):
                log(error)
            }
        }
    }
    
    
}

struct HomeView2_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

//fileprivate class HomeViewModel: HomeScrollViewModel, HomeScrollViewAction, HomeScrollViewDataSource {
//
//
//
//    @Published var studyRoomCollections: [CollectionClass] = []
//
//    private var collectionId: [String] = []
//
//    private var allBuilding: [StudyBuilding] = []
//
//    init() {
//        loadOnAppear()
//    }
//
//    func loadOnAppear() {
//        StudyRoomManager.allBuidlingGet(term: "20212", week: "1", day: "7") { result in
//            switch result {
//            case .success(let data):
//                if(data.errorCode == 0) {
//                    DispatchQueue.main.async {
//                        self.allBuilding = data.data
//                        self.collectionIdToClass()
//                    }
//                }
//            case .failure(let error):
//                print("加载教学楼失败", error)
//            }
//
//        }
//    }
//
//    func collectionIdToClass() {
//        StyCollectionManager.getCollections(){ result in
//            switch result {
//            case .success(let data):
//                self.collectionId = data.data.classroomID ?? []
//                for code in self.collectionId {
//                    for building in self.allBuilding {
//                        for area in building.areas {
//                            for room in area.classrooms {
//                                if(room.classroomID == code) {
//                                    self.studyRoomCollections.append(CollectionClass(classMessage: room, buildingName: building.building))
//                                }
//                            }
//                        }
//                    }
//                }
//            case .failure(let error):
//                print("转换失败", error)
//            }
//        }
//    }
//
////    func reloadData() {
////        self.studyRoomCollections = []
////        self.collectionIdToClass()
////    }
//
//    var action: HomeScrollViewAction { self }
//
//    private lazy var _dataSource: HomeScrollViewDataSource = { self }()
//
//    var dataSource: HomeScrollViewDataSource {
//        get { _dataSource }
//        set { _dataSource = newValue }
//    }
//}
//
//
