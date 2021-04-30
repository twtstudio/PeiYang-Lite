//
//  MainView.swift
//  PeiYang Lite
//
//  Created by Zr埋 on 2020/10/21.
//

import SwiftUI

struct MainView: View {
    @State private var showBadge: Bool = false
    @State private var selected: Int = 0
    @AppStorage(SchMessageManager.SCH_MESSAGE_CONFIG_KEY, store: Storage.defaults) private var unreadMessageCount: Int = 0
    
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
        .showTabBarBadge(isPresented: $showBadge, msgCount: unreadMessageCount, pos: 2, tabsCount: 3)
        .onAppear {
            if SchManager.schToken != nil {
                SchMessageManager.getUnreadCount { (result) in
                    switch result {
                    case .success(let (totalCount, _)):
                        if totalCount != 0 {
                            unreadMessageCount = totalCount
                            showBadge = true
                        } else {
                            unreadMessageCount = 0
                            showBadge = false
                        }
                    case .failure(let err):
                        log(err)
                    }
                }
            }
        }
    }
}

struct TabBarBadgeModifier: ViewModifier {
    @Binding var isPresented: Bool
    var msgCount: Int
    var pos: Int
    var tabsCount: Int
    
    func body(content: Content) -> some View {
        GeometryReader { g in
            ZStack(alignment: .bottomLeading) {
                content
                // Badge View
                if isPresented {
                    ZStack {
                        Circle()
                            .foregroundColor(.red)
                        
                        if msgCount > 0 {
                            Text(msgCount.description)
                                .foregroundColor(.white)
                                .font(Font.system(size: 12))
                        }
                    }
                    .frame(width: 15, height: 15)
                    .offset(x: calcBadgePosX(badgePosition: pos, tabsCount: tabsCount, g: g), y: -25)
                    .allowsHitTesting(false)
                }
            }
        }
    }
    
    private func calcBadgePosX(badgePosition: Int, tabsCount: Int, g: GeometryProxy) -> CGFloat {
        return ( ( 2 * CGFloat(badgePosition)) - 0.95 ) * ( g.size.width / ( 2 * CGFloat(tabsCount) ) ) + 2
    }
}

extension View {
    // only show circle when count equals -1
    func showTabBarBadge(isPresented: Binding<Bool>, msgCount: Int, pos: Int, tabsCount: Int) -> some View {
        self.modifier(TabBarBadgeModifier(isPresented: isPresented, msgCount: msgCount, pos: pos, tabsCount: tabsCount))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
