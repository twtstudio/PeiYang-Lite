//
//  AppDelegate.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2021/3/20.
//

import UIKit

fileprivate struct KGTInfo {
    static let kGtAppId = "ceSsLQVkL97pkqdHOIMmh7"
    static let kGtAppKey = "NxW19LR7xb9JKFy5yVNiL8"
    static let kGtAppSecret = "TllZohf7Sr99sd1XNxQ0i4"
}

class AppDelegate: UIResponder, UIApplicationDelegate, GeTuiSdkDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // [ GTSDK ]：使用APPID/APPKEY/APPSECRENT启动个推
        GeTuiSdk.start(withAppId: KGTInfo.kGtAppId, appKey: KGTInfo.kGtAppKey, appSecret: KGTInfo.kGtAppSecret, delegate: self)
        // [ GTSDK ]: 注册远程通知
        GeTuiSdk.registerRemoteNotification([.alert, .badge, .sound])
        // [ GTSDK ]：是否允许APP后台运行
//        GeTuiSdk.runBackgroundEnable(true)
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for byte in deviceToken {
          token += String(format: "%02X", byte)
        }
        log("已注册deviceToken: ", token)
    }
}

extension AppDelegate {
    // [ GTSDK回调 ] 已注册客户端
    func geTuiSdkDidRegisterClient(_ clientId: String) {
        log("[ GTSDK回调 ] 已注册客户端，本机cid: ", clientId)
    }
    
    // [ GTSDK回调 ] 状态通知
    func geTuiSDkDidNotifySdkState(_ status: SdkStatus) {
        log("[ GTSDK回调 ] 状态通知: ", status.description)
    }
    
    // [ GTSDK回调 ] SDK错误反馈
    func geTuiSdkDidOccurError(_ error: Error) {
        log(error)
    }
    
    // [ GTSDK回调 ] 即将展示APNS通知
    func geTuiSdkNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        log("[ GTSDK回调 ] 即将展示APNS通知")
        log(center)
        completionHandler([.badge, .sound, .list, .banner])
    }
    
    // [ GTSDK回调 ] 接收到APNS通知
    func geTuiSdkDidReceiveNotification(_ userInfo: [AnyHashable : Any], notificationCenter center: UNUserNotificationCenter?, response: UNNotificationResponse?, fetchCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)? = nil) {
        log("[ GTSDK回调 ] 接收到APNS通知")
        log(center)
        log(response)
        completionHandler?(.noData)
    }
    
    // [ GTSDK回调 ] APNs的通知
    func geTuiSdkNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        log("[ GTSDK回调 ] APNs的通知", notification?.description ?? "")
    }
    
    // [ GTSDK回调 ] 接收到透传通知
    func geTuiSdkDidReceiveSlience(_ userInfo: [AnyHashable : Any], fromGetui: Bool, offLine: Bool, appId: String?, taskId: String?, msgId: String?, fetchCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)? = nil) {
        log("[ GTSDK回调 ] 接收到透传通知: \(fromGetui ? "个推消息" : "APNs消息") appId:\(appId ?? "") offLine:\(offLine ? "离线" : "在线") taskId:\(taskId ?? "") msgId:\(msgId ?? "") userInfo:\(userInfo)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        log("APNS 回调")
    }
    
}

extension SdkStatus {
    var description: String {
        switch self {
            case .offline: return "离线"
            case .started: return "启动、在线"
            case .starting: return "正在启动"
            case .stoped: return "停止"
            @unknown default: return "unknown"
        }
    }
}
