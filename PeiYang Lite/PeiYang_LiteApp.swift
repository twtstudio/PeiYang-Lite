//
//  PeiYang_LiteApp.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/1/20.
//

import SwiftUI

@main
struct PeiYang_LiteApp: App {
    @State var images: [UIImage] = []
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(User())
                .environmentObject(AppState())
                .environmentObject(SharedMessage())
        }
    }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
