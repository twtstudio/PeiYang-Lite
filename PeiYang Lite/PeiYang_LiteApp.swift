//
//  PeiYang_LiteApp.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/1/20.
//

import SwiftUI

@main
struct PeiYang_LiteApp: App {
    var body: some Scene {
        WindowGroup {
<<<<<<< HEAD
<<<<<<< HEAD
            MainView()
=======
            ContentView()
>>>>>>> e4291697b2a03afcf4cfbf314ae8cf47114102d1
=======
            SplashView()
                .environmentObject(User())
                .environmentObject(AppState())
                .environmentObject(SharedMessage())
                
>>>>>>> origin/PhoneixBranch
        }
    }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
