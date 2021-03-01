//
//  CourseTableDetailView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/30/20.
//

import SwiftUI

struct CourseTableDetailView: View {
    @ObservedObject var store = Storage.courseTable
    private var courseTable: CourseTable { store.object }
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) private var sizeClass
    private var isRegular: Bool { sizeClass == .regular }
    
    @State private var isLoading = false
    
    @State private var showFullCourse = true
    
    @State private var showLogin = false
    
    @State private var activeWeek = Storage.courseTable.object.currentWeek
    private var activeCourseArray: [Course] {
        courseTable.courseArray.filter { $0.weekRange.contains(activeWeek) }
    }
    
    @ObservedObject var alertCourse: AlertCourse
    
    @State private var isError = false
    @State private var errorMessage: LocalizedStringKey = ""
    
    var body: some View {
//        GeometryReader { full in
        VStack(alignment: .leading) {
            // MARK: - Header
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
//                .padding(.top, 40)
            .padding(.trailing, 20)
            
//            ZStack {
            ScrollView(showsIndicators: false) {
                // MARK: - Header
                CouseTableHeaderView(
                    activeWeek: $activeWeek,
                    showFullCourse: $showFullCourse,
                    totalWeek: courseTable.totalWeek
                ).padding()
                
//                    List {
                    // MARK: - Table
                if isRegular {
                    Section(header:
                        CourseTableWeekdaysView(
                            activeWeek: $activeWeek,
                            courseTable: courseTable,
                            width: screen.width / 6.8//9
                        )
                    ) {
                        CourseTableContentView(
                            activeWeek: activeWeek,
                            courseArray: courseTable.courseArray,
                            width: screen.width / 6.8,
                            alertCourse: alertCourse,
                            showFullCourse: $showFullCourse//9
                        )
                    }.padding(.horizontal, 20)
//                            .listRowInsets(EdgeInsets())
//                        .listRowInsets(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: 0)) // insane!
                } else {
                    VStack(alignment: .leading) {
                        CourseTableWeekdaysView(
                            activeWeek: $activeWeek,
                            courseTable: courseTable,
                            width: screen.width / (7.5)//9
                        )
                        
                        CourseTableContentView(
                            activeWeek: activeWeek,
                            courseArray: courseTable.courseArray,
                            width: screen.width / (7.5),
                            alertCourse: alertCourse,//9
                            showFullCourse: $showFullCourse
                        )
                    }.padding(.horizontal, 20)
//                            .listRowInsets(EdgeInsets(top: 0, leading: 5/*-10 */, bottom: 0, trailing: 5)) // insane!
                }
            }
            .sheet(isPresented: $showLogin) {
            HomeLoginView(module: .courseTable)
            }
            .alert(isPresented: $isError) {
                Alert(title: Text(errorMessage),
                      dismissButton: .default(Text(Localizable.ok.rawValue)))
            }
            .edgesIgnoringSafeArea(.all)
            
//                if alertCourse.showDetail {
////                    withAnimation {
//                        ZStack {
//                            Color.clear
//                                .frame(width: full.size.width,
//                                       height: full.size.height,
//                                       alignment: .center)
//                                .contentShape(Rectangle())
////                                .animation(.easeInOut)
//
//                            CourseDetailView(course: $alertCourse.currentCourse, weekDay: $alertCourse.currentWeekday, isRegular: isRegular)
//                                .frame(width: full.size.width / 1.5, height: full.size.height / 1.8, alignment: .center)
////                                .transition(.asymmetric(insertion: .opacity, removal: .opacity))
//                                .background(ColorHelper.shared.color[alertCourse.currentCourse.no]?.opacity(0.8))
////                                .transition(.opacity)
//                                .clipShape(RoundedRectangle(cornerRadius: 8))
//                                .shadow(color: Color.gray.opacity(0.5), radius: 8, x: 5, y: 5)
////                                .opacity(alertCourse.showDetail ? 1 : 0)
//                                .animation(.easeInOut)
//                        }
////                        .transition(.opacity)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .edgesIgnoringSafeArea(.all)
//                        .onTapGesture {
//                            withAnimation(.easeOut) {
//                                self.alertCourse.showDetail = false
//                            }
//                        }
//                        .layoutPriority(1)
//
//                }
            
//            }
        }
        .padding(.leading)
//        }
        .navigationBarHidden(true)
        .onAppear(perform: load)
        .navigationBarHidden(true)
        
    }
    
    func load() {
        isLoading = true
        ClassesManager.checkLogin { result in
            switch result {
            case .success:
                return
            case .failure(let error):
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
                
//                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
//                    guard granted else {
//                        return
//                    }
//
//                    if let error = error {
//                        print(error)
//                        return
//                    }
//
//                    NotificationHelper.setNotification(for: courseTable) { error in
//                        print(error)
//                    }
//                }
            case .failure(let error):
                print(error)
            }
            isLoading = false
        }
    }
}

struct CourseTableDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            CourseTableDetailView(alertCourse: AlertCourse())
                .environment(\.colorScheme, .dark)
        }
    }
}

