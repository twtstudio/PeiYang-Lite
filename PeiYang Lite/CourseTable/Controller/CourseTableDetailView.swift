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
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    private var isRegular: Bool { sizeClass == .regular }
    
    @State private var isLoading = false
    @State private var isFirstAppear = true
    
    @State private var showFullCourse = false
    
    @State private var showLogin = false
    
    @State private var showPopup = false
    
    @State private var activeWeek = Storage.courseTable.object.currentWeek
    private var activeCourseArray: [Course] {
        courseTable.courseArray.filter { $0.weekRange.contains(activeWeek) }
    }
    // for popup course
    @ObservedObject var alertCourse: AlertCourse = AlertCourse()
    
    @State private var isError = false
    @State private var errorMessage: LocalizedStringKey = ""
    
    var body: some View {
        
        GeometryReader { full in
            ZStack {
                VStack {
                    // MARK: - Header
                    HStack {
                        CouseTableHeaderView(
                            activeWeek: $activeWeek,
                            showFullCourse: $showFullCourse,
                            totalWeek: courseTable.totalWeek
                        )
                        
                        Spacer()
                        
                        RefreshButton(isLoading: $isLoading) {
                            load(firstLogin: false)
                        }
                        .padding(.leading)
                    }
                    
                    List {
                        // MARK: - Table
                        if isRegular {
                            Section(header:
                                        CourseTableWeekdaysView(
                                            activeWeek: $activeWeek,
                                            courseTable: courseTable,
                                            width: full.size.width / 9.5//9
                                        )
                            ) {
                                CourseTableContentView(
                                    activeWeek: activeWeek,
                                    courseArray: courseTable.courseArray,
                                    width: full.size.width / 9.5,
                                    alertCourse: alertCourse,
                                    showFullCourse: $showFullCourse//9
                                )
                            }
                            .listRowInsets(EdgeInsets())
                            //                        .listRowInsets(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: 0)) // insane!
                        } else {
                            VStack {
                                CourseTableWeekdaysView(
                                    activeWeek: $activeWeek,
                                    courseTable: courseTable,
                                    width: full.size.width / (9.5)//9
                                )
                                
                                CourseTableContentView(
                                    activeWeek: activeWeek,
                                    courseArray: courseTable.courseArray,
                                    width: full.size.width / (9.5),
                                    alertCourse: alertCourse,//9
                                    showFullCourse: $showFullCourse
                                )
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: -8/*-10 */, bottom: 0, trailing: 5)) // insane!
                        }
                        
                        // MARK: - List
                        CourseTableListView(activeCourseArray: activeCourseArray)
                            .listRowInsets(EdgeInsets())
                    }
                    .listIndicatorNone(.vertical)
                    .sheet(isPresented: $showLogin) {
                        HomeLoginView(module: .courseTable)
                    }
                    .alert(isPresented: $isError) {
                        Alert(title: Text(errorMessage),
                              dismissButton: .default(Text(Localizable.ok.rawValue)))
                    }
                }
                
                if alertCourse.showDetail {
                    //                    withAnimation {
                    ZStack {
                        Color.clear
                            .frame(width: full.size.width,
                                   height: full.size.height,
                                   alignment: .center)
                            .contentShape(Rectangle())
                        //                                .animation(.easeInOut)
                        
                        CourseTableCourseDetailView(course: $alertCourse.currentCourse, weekDay: $alertCourse.currentWeekday, isRegular: isRegular)
                            .frame(width: full.size.width / 1.5, height: full.size.height / 1.8, alignment: .center)
                            .background(
                                alertCourse.currentCourse.isThisWeek(activeWeek: alertCourse.activeWeek, weekday: alertCourse.currentWeekday) ?
                                    ColorHelper.shared.color[alertCourse.currentCourse.no]?.opacity(0.8) :
                                    .gray)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: Color.gray.opacity(0.5), radius: 8, x: 5, y: 5)
                        //                                .opacity(alertCourse.showDetail ? 1 : 0)
                        //                                .animation(.easeInOut)
                    }
                    //                        .transition(.opacity)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.easeOut) {
                            self.alertCourse.showDetail = false
                        }
                    }
                    .layoutPriority(1)
                    
                }
                
            }
        }
        .onAppear {
            if !Storage.defaults.bool(forKey: ClassesManager.isCourseStoreKey) {
                load(firstLogin: true)
            }
        }
        
    }
    
    private func load(firstLogin: Bool) {
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
            case .success(_):
                if firstLogin {
                    self.activeWeek = store.object.currentWeek
                }
            //                store.object = courseTable
            //                store.save()
            
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
            CourseTableDetailView()
                .environment(\.colorScheme, .dark)
        }
    }
}

