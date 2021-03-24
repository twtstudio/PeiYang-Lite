//
//  MainView.swift
//  PeiYang Lite
//
//  Created by Zr埋 on 2020/10/21.
//

import SwiftUI
import ObjectiveC

//enum Tab {
//    case tab1, tab2, tab3, tab4
//}


struct MainView: View {
    
//    @State private var currentView: Tab = .tab1
    @State private var selected = 0
   
    var body: some View {
        TabView(selection: $selected) {
            HomeView2()
                .tabItem{
                    Image(systemName: self.selected == 0 ? "house.fill" : "house")
                    Text("主页")
                }.tag(0)
            
            DrawerView()
                .tabItem {
                    Image(systemName: self.selected == 1 ? "archivebox.fill" : "archivebox")
                    Text("抽屉")
                }.tag(1)
            
            SchView()
                .tabItem {
                    Image(systemName: self.selected == 2 ? "captions.bubble.fill" : "captions.bubble")
                    Text("校务专区")
                }.tag(2)
            
            AccountView()
                .tabItem {
                    Image(systemName: self.selected == 3 ? "person.fill" : "person")
                    Text("个人中心")
                }.tag(3)
        }
        .onAppear(perform: {
            UMAnalyticsSwift.beginLogPageView(pageName: "HomeView")
        })
        .navigationBarBackButtonHidden(true)
        .onDisappear {
            UMAnalyticsSwift.endLogPageView(pageName: "HomeView")
        }
    
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

//struct CurrentScreen: View {
//    @Binding var currentView: Tab
//
//    var body: some View {
//        VStack {
//            if self.currentView == .tab1 {
//                HomeView2()
//            } else if self.currentView == .tab2 {
////                HomeView(inBackground: .constant(false), isUnlocked: .constant(true))
//                Text("抽屉")
//            } else if self.currentView == .tab3 {
////                HomeView2()
//                Text("校务")
//            } else {
//                Text("个人")
//            }
//        }
////        .ignoresSafeArea()
//    }
//}
//
//struct TabBar: View {
//    @Binding var currentView: Tab
//
//    var body: some View {
//        HStack {
//            TabBarItem(currentView: $currentView, image: Image("HomeIcon"), paddingEdges: .leading, tab: .tab1, lable: "主页")
//            Spacer()
//            TabBarItem(currentView: $currentView, image: Image("DrawerIcon"), paddingEdges: .leading, tab: .tab2, lable: "抽屉")
//            Spacer()
//            TabBarItem(currentView: $currentView, image: Image("IssueIcon"), paddingEdges: .leading, tab: .tab3, lable: "校务专区")
//            Spacer()
//            TabBarItem(currentView: $currentView, image: Image("PersonIcon"), paddingEdges: .leading, tab: .tab4, lable: "个人中心")
//        }
//    }
//}
//
//struct TabBarItem: View {
//    @Binding var currentView: Tab
//    let image: Image
//    let paddingEdges: Edge.Set
//    let tab: Tab
//    let lable: String
//
//    var body: some View {
//        VStack {
//            image
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .padding(5)
//                .frame(width: 40, height: 40, alignment: .center)
//                .background(Color(self.currentView == tab ? .blue : .white).opacity(0.2))
//                .foregroundColor(Color(self.currentView == tab ? .darkGray : .gray))
//                .cornerRadius(6)
//
//            Text(lable)
//                .font(.footnote)
//                .foregroundColor(.gray)
//        }
//        .frame(width: 100, height: 50)
//        .onTapGesture { self.currentView = self.tab }
//        .padding(paddingEdges, 15)
//    }
//
//}
