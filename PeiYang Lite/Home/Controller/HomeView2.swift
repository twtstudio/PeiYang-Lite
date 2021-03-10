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
    }
    
    init() {
        UITableView.appearance().backgroundColor = .white
    }
    @EnvironmentObject var sharedMessage: SharedMessage
    var body: some View {
        VStack {
                HomeHeaderView(AccountName: sharedMessage.Account.nickname)
                .padding(.top, safeAreaHeight)
                .padding(.horizontal)
                
            ScrollView(showsIndicators: false) {
            HomeModuleSectionView()
            
            HomeCourseSectionView()
                
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
                .padding()
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
            .padding(.vertical, 30)
            
        }
        .navigationBarHidden(true)
        .background(Color(#colorLiteral(red: 0.9352087975, green: 0.9502342343, blue: 0.9600060582, alpha: 1)))
        .edgesIgnoringSafeArea(.all)
        

        
    }
    
    
}

struct HomeView2_Previews: PreviewProvider {
    static var previews: some View {
        HomeView2()
    }
}




