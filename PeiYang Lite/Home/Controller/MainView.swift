//
//  MainView.swift
//  PeiYang Lite
//
//  Created by Zr埋 on 2020/10/21.
//

import SwiftUI

enum Tab {
    case tab1, tab2, tab3
}


struct MainView: View {
    
    @State private var currentView: Tab = .tab1
   
    var body: some View {
        VStack {
            NavigationView {
                CurrentScreen(currentView: self.$currentView)
                    .background(Color.white)
                    .navigationViewStyle(StackNavigationViewStyle())
            }
            TabBar(currentView: self.$currentView)
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct CurrentScreen: View {
    @Binding var currentView: Tab
    
    var body: some View {
        VStack {
            if self.currentView == .tab1 {
                HomeView2()
            } else if self.currentView == .tab2 {
                HomeView(inBackground: .constant(false), isUnlocked: .constant(true))
            } else {
                HomeView2()
            }
        }
//        .ignoresSafeArea()
    }
}

struct TabBar: View {
    @Binding var currentView: Tab
    
    var body: some View {
        HStack {
            TabBarItem(currentView: $currentView, image: Image(systemName: "star"), paddingEdges: .leading, tab: .tab1)
            Spacer()
            TabBarItem(currentView: $currentView, image: Image(systemName: "star"), paddingEdges: .leading, tab: .tab2)
            Spacer()
            TabBarItem(currentView: $currentView, image: Image(systemName: "star"), paddingEdges: .leading, tab: .tab3)
        }
    }
}

struct TabBarItem: View {
    @Binding var currentView: Tab
    let image: Image
    let paddingEdges: Edge.Set
    let tab: Tab
    
    var body: some View {
        VStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(5)
                .frame(width: 40, height: 40, alignment: .center)
                .background(Color(self.currentView == tab ? .blue : .white).opacity(0.2))
                .foregroundColor(Color(self.currentView == tab ? .blue : .black))
                .cornerRadius(6)
        }
        .frame(width: 100, height: 50)
        .onTapGesture { self.currentView = self.tab }
        .padding(paddingEdges, 15)
    }
    
}
