//
//  ContentView.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/1/20.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @State private var inBackground = false
    @AppStorage(Account.needUnlockKey, store: Storage.defaults) private var needUnlock = false
    @State private var isUnlocked = false
    private var neddHide: Bool { (needUnlock && !isUnlocked) || inBackground }
    
    var body: some View {
        ZStack {
//            GPADetailView()
//            HomeView2()
            MainView()
//            HomeView(inBackground: $inBackground, isUnlocked: $isUnlocked)
            if neddHide {
                BlurView()
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            if needUnlock {
                isUnlocked = false
                authenticate()
            } else {
                isUnlocked = true
            }
        }
        .onReceive(notification(for: UIApplication.willEnterForegroundNotification)) { _ in
            inBackground = false
            if needUnlock {
                isUnlocked = false
                authenticate()
            } else {
                isUnlocked = true
            }
        }
        .onReceive(notification(for: UIApplication.didEnterBackgroundNotification)) { _ in
            inBackground = true
            if needUnlock {
                isUnlocked = false
            } else {
                isUnlocked = true
            }
        }
    }
    
    func notification(for name: NSNotification.Name) -> NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: name)
    }
    
    func authenticate() {
        let context = LAContext()
        let policy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        var error: NSError?
        
        if context.canEvaluatePolicy(policy, error: &error) {
            context.evaluatePolicy(policy, localizedReason: "NSFaceIDUsageDescription") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        isUnlocked = true
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ContentView()
                .environment(\.colorScheme, .dark)
        }
    }
}
