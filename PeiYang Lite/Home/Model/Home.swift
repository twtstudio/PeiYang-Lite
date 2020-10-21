//
//  Home.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/26/20.
//

import Foundation

enum Home {
    case courseTable, gpa
    case ecard
    case wlan
    
    var isLogin: Bool {
        switch self {
        case .courseTable, .gpa:
            return ClassesManager.isLogin
        case .ecard:
            return ECardManager.isLogin
        case .wlan:
            return WLANManager.isLogin
        }
    }
    
    var isStore: Bool {
        switch self {
        case .courseTable, .gpa:
            return ClassesManager.isGPAStore || ClassesManager.isCourseStore
        case .ecard:
            return ECardManager.isStore
        case .wlan:
            return WLANManager.isStore
        }
    }
    
    private func remove(_ key: String) { Storage.defaults.removeObject(forKey: key) }
    private func disable(_ key: String) { Storage.defaults.setValue(false, forKey: key) }
    
    /// Reset login state, called after login check fail
    func reset() {
        switch self {
        case .courseTable, .gpa:
            disable(ClassesManager.isLoginKey)
            Storage.courseTable.remove()
            Storage.gpa.remove()
        case .ecard:
            disable(ECardManager.isLoginKey)
            Storage.ecard.remove()
        case .wlan:
            disable(WLANManager.isLoginKey)
            Storage.wlan.remove()
        }
    }
    
    func exitLogin() {
        switch self {
        case .courseTable, .gpa:
            disable(ClassesManager.isLoginKey)
        case .ecard:
            disable(ECardManager.isLoginKey)
        case .wlan:
            disable(WLANManager.isLoginKey)
        }
    }
    
    /// Clear login info, called after login view dismiss with no login
    func clear() {
        switch self {
        case .courseTable, .gpa:
            disable(ClassesManager.isLoginKey)
            remove(ClassesManager.usernameKey)
            remove(ClassesManager.passwordKey)
        case .ecard:
            remove(ECardManager.usernameKey)
            remove(ECardManager.passwordKey)
        case .wlan:
            remove(WLANManager.usernameKey)
            remove(WLANManager.passwordKey)
        }
    }
    
    /// Check login state, called after detail view show
    func checkLogin(completion: @escaping (Result<String, Network.Failure>) -> Void) {
        switch self {
        case .courseTable, .gpa:
            ClassesManager.checkLogin(completion: completion)
        case .ecard:
            ECardManager.checkLogin(completion: completion)
        case .wlan:
            WLANManager.checkLogin(completion: completion)
        }
    }
}
