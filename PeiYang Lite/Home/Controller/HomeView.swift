//
//  HomeView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/6/20.
//

import SwiftUI

let screen = UIScreen.main.bounds
let presentWidth = max(screen.width, screen.height) / 2

struct HomeView: View {
    @Binding var inBackground: Bool
    @AppStorage(Account.needUnlockKey, store: Storage.defaults) private var needUnlock = false
    @Binding var isUnlocked: Bool
    private var needHide: Bool { (needUnlock && !isUnlocked) || inBackground }
    
    let modules: [Home] = [.courseTable, .gpa, /*.ecard,*/ .wlan]
    
    @ObservedObject var store = Storage.courseTable
    private var courseTable: CourseTable { store.object }
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(\.colorScheme) private var colorScheme
    
    private var isRegular: Bool { sizeClass == .regular }
    
    // MARK: - Card and Detail
    @State private var width: CGFloat = 0
    @State private var activeIndex = -1
    @State private var activeCenter: CGPoint = .zero
    @State private var showDetail = false
    @State private var showFull = false
    @State private var dragAmount: CGFloat = 0
    
    private var safeAreaHeight: CGFloat {
        return (UIApplication.shared.windows.first ?? UIWindow()).safeAreaInsets.top == 44 ? 44 : 0
    }
    
    /// Determine which module is active and should be shown
    /// - Parameter index: module index
    func isActive(_ index: Int) -> Bool { activeIndex == index && showDetail }
    
    /// Reset detail back to card
    func reset() {
        animate(withDuration: 0.5) {
            showFull = false
        } completion: {
            activeIndex = -1
            activeCenter = .zero
            showDetail = false
        }
    }
    
    // MARK: - Alert
    @State private var isError = false
    @State private var errorMessage: LocalizedStringKey = ""
    
    // MARK: - Sheet
    @State private var showSetting = false
    @State private var showLogin = false
    
    var body: some View {
        GeometryReader { full in
            ZStack {
                GridStack(
                    minCellWidth: 300,
                    spacing: 18,
                    numItems: modules.count
                ) {
                    // MARK: - Header
                    HStack {
                        HomeViewHeaderView()
                            .padding(.top)
                        
                        Spacer()
                        
                        Button(action: { showSetting = true }, label: {
                            Image(systemName: "gearshape")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .font(.title)
                                .padding()
                        })
                        // Setting Sheet
                        .sheet(isPresented: $showSetting) {
                            ZStack {
                                HomeSettingView()
                                
                                if needHide {
                                    BlurView()
                                        .edgesIgnoringSafeArea(.all)
                                }
                            }
                        }
                       

                    }
                } content: { index, width in
                    GeometryReader { geo in
                        // MARK: - Card
                        HomeCardView(module: modules[index])
                            .padding()
                            .frame(width: width, height: width * 0.6)
                            .background(Color.background)
                            .cornerRadius(24)
                            .shadow(color: .shadow, radius: 4)
                            .opacity(isActive(index) ? 0 : 1)
                            .onTapGesture {
                                self.width = width
                                activeIndex = index
                                activeCenter = CGPoint(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).midY)
//                                if modules[index].isLogin || courseTable.courseArray.count != 0 && modules[index] == .courseTable {
                                if modules[index].isStore {
                                    showDetail = true
                                    // TODO: fix it
                                    modules[index].checkLogin { result in
                                        switch result {
                                        case .success:
                                            return
                                        case .failure(let error):
                                            if error == .requestFailed {
                                                isError = true
                                                errorMessage = error.localizedStringKey
                                            } else {
                                                modules[index].exitLogin()
//                                                showDetail = false
//                                                showLogin = true
                                            }
                                        }
                                    }
                                } else {
                                    showLogin = true
                                }
                            }
                            // MARK: - Login Sheet
                            .sheet(isPresented: $showLogin) {
                                if modules[activeIndex].isLogin {
                                    showDetail = true
                                } else {
                                    modules[activeIndex].clear()
                                    showFull = false
                                }
                            } content: {
                                ZStack {
                                    HomeLoginView(module: modules[activeIndex])
                                    
                                    if needHide {
                                        BlurView()
                                            .edgesIgnoringSafeArea(.all)
                                    }
                                }
                            }
                    }
                    .frame(width: width, height: width * 0.6)
                }
                
                // MARK: - Blur
                BlurView()
                    .opacity(showFull ? 1 : 0)
                    .statusBar(hidden: showDetail)
                    .edgesIgnoringSafeArea(.all)
                    .animation(.easeInOut)
                    .onTapGesture(perform: reset)
                
                // MARK: - Detail
                if showDetail {
                    HomeDetailView(module: modules[activeIndex])
                        .padding()
                        .frame(
                            width: showFull ? (isRegular ? presentWidth : full.frame(in: .global).width) : width,
                            height: showFull ? full.frame(in: .global).height * 1 : width * 0.6
                        )
                        .background(Color.background)
//                        .cornerRadius(isRegular ? 24 : 240 * dragAmount, corners: [.topLeft, .topRight])
                        .cornerRadius(24)
//                        .cornerRadius(24, corners: [.topLeft, .topRight])
                        .cornerRadius(isRegular ? 0 : 240 * dragAmount, corners: [.bottomLeft, .bottomRight])
                        .shadow(color: .shadow, radius: 4)
                        .opacity(showDetail ? 1 : 0)
                        .offset(
                            x: showFull ? 0 : activeCenter.x - full.frame(in: .global).midX,
                            y: showFull ? safeAreaHeight : activeCenter.y - full.frame(in: .global).midY
                        )
                        .onAppear {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0)) {
                                showFull = true
                            }
                        }
                        .offset(y: isRegular ? dragAmount * 1000 : 0)
                        .scaleEffect(isRegular ? 1 : 1 - dragAmount)
                        .onTapGesture(count: 2, perform: {
                            reset()
                        })
                        .gesture(
                            DragGesture(minimumDistance: 30, coordinateSpace: .local)
                                .onChanged { value in
                                    let height = value.translation.height

                                    if height < 0 { return }
                                    if height > 100 {
                                        reset()
                                        return
                                    }

                                    dragAmount = height / 1000
                                }
                                .onEnded { value in
                                    withAnimation {
                                        dragAmount = 0
                                    }
                                }
                        )
                }
            }
        }
        .edgesIgnoringSafeArea([.top, .bottom])
        // MARK: - Alert
        .alert(isPresented: $isError) {
            Alert(
                title: Text(errorMessage),
                dismissButton: .default(Text(Localizable.ok.rawValue))
            )
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            HomeView(inBackground: .constant(false), isUnlocked: .constant(true))
                .environment(\.colorScheme, .dark)
        }
    }
}

extension CGRect {
    var center: CGPoint {
        CGPoint(x: self.midX, y: self.maxY)
    }
}

func animate(withDuration duration: TimeInterval, body: () -> Void, completion: @escaping () -> Void) {
    withAnimation(Animation.spring(response: 0.5, dampingFraction: 0.7, blendDuration: duration), body)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: completion)
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
