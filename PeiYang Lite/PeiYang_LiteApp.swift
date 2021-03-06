//
//  PeiYang_LiteApp.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/1/20.
//

import SwiftUI

@main
struct PeiYang_LiteApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(User())
                .environmentObject(AppState())
                .environmentObject(SharedMessage())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
        }
    }
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
