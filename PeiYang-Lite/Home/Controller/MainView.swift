//
//  MainView.swift
//  PeiYang Lite
//
//  Created by Zr埋 on 2020/10/21.
//

import SwiftUI

//enum Tab {
//    case tab1, tab2, tab3, tab4
//}


struct MainView: View {
    
    //    @State private var currentView: Tab = .tab1
    @State private var showBadge: Bool = false
    @State private var selected: Int = 0
    @State private var badgeConfig = TabBarBadgeConfig()
    
    var body: some View {
        TabView(selection: $selected) {
            HomeView()
                .tabItem{
                    Image(systemName: self.selected == 0 ? "house.fill" : "house")
                    Text("主页")
                }.tag(0)
            
            //            DrawerView()
            //                .tabItem {
            //                    Image(systemName: self.selected == 1 ? "archivebox.fill" : "archivebox")
            //                    Text("抽屉")
            //                }.tag(1)
            
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
        .accentColor(Color(#colorLiteral(red: 0.1960784314, green: 0.2392156863, blue: 0.3882352941, alpha: 1)))
        .navigationBarBackButtonHidden(true)
        .showTabBarBadge(isPresented: $showBadge, config: badgeConfig)
        .onAppear {
            if SchManager.schToken != nil {
                SchMessageManager.getUnreadMessage { (result) in
                    switch result {
                        case .success(let msgs):
                            if !msgs.isEmpty {
                                badgeConfig.count = msgs.count
                                showBadge = true
                            }
                        case .failure(let err):
                            log(err)
                    }
                }
            }
        }
    }
}

struct TabBarBadgeConfig {
    var count: Int = 0
    var pos: Int = 0
    var tabsCount: Int = 0
}

struct TabBarBadgeModifier: ViewModifier {
    @Binding var isPresented: Bool
    var config: TabBarBadgeConfig
    
    func body(content: Content) -> some View {
        GeometryReader { g in
            ZStack(alignment: .bottomLeading) {
                content
                // Badge View
                if isPresented {
                    ZStack {
                        Circle()
                            .foregroundColor(.red)
                        
                        if config.count > 0 {
                            Text("3")
                                .foregroundColor(.white)
                                .font(Font.system(size: 12))
                        }
                    }
                    .frame(width: 15, height: 15)
                    .offset(x: calcBadgePosX(badgePosition: 2, tabsCount: 3, g: g), y: -25)
                    .allowsHitTesting(false)
                }
            }
        }
    }
    
    private func calcBadgePosX(badgePosition: CGFloat, tabsCount: CGFloat, g: GeometryProxy) -> CGFloat {
        return ( ( 2 * badgePosition) - 0.95 ) * ( g.size.width / ( 2 * tabsCount ) ) + 2
    }
}

extension View {
    // only show circle when count equals -1
    func showTabBarBadge(isPresented: Binding<Bool>, config: TabBarBadgeConfig) -> some View {
        self.modifier(TabBarBadgeModifier(isPresented: isPresented, config: config))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
