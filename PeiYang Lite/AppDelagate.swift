//
//  AppDelagate.swift
//  PeiYang Lite
//
//  Created by 游奕桁 on 2021/3/21.
//

import Foundation

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UMCommonLogSwift.setUpUMCommonLogManager()
        UMCommonSwift.setLogEnabled(bFlag: true)
        UMCommonSwift.initWithAppkey(appKey: "605440876ee47d382b8b74c3", channel: "App Store")
        return true
    }
}
