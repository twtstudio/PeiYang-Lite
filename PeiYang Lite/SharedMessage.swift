//
//  SharedMessage.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/12.
//

import SwiftUI
import Combine

class SharedMessage: ObservableObject {
    // 个人界面的数据存储
    static let isShowFullCourseKey: String = "showfullcourse"
    static let isShowGPAKey: String = "showGPA"
    static let usernameKey: String = "usernameKey"
    static let passwordKey: String = "passwordKey"
    static let showCourseNumKey: String = "showCourseNumKey"
    static let studyRoomHistoryKey: String = "studyRoomHistoryKey"
    
    static var isSowFullCourse: Bool { Storage.defaults.bool(forKey: isShowFullCourseKey) }
    static var isShowGPA: Bool { Storage.defaults.bool(forKey: isShowGPAKey) }
    static var username: String {Storage.defaults.string(forKey: usernameKey) ?? ""}
    static var password: String {Storage.defaults.string(forKey: passwordKey) ?? ""}
    static var showCourseNum: Int {Int(Storage.defaults.double(forKey: showCourseNumKey))}
//    static var studyRoomHistory: [String] {Storage.defaults.stringArray(forKey: studyRoomHistoryKey) ?? [""]}
    
    // 个人页面的绑定数据
    @Published var Account: accountResult = accountResult(userNumber: "", nickname: "", telephone: "", email: "", token: "", role: "", realname: "", gender: "", department: "", major: "", stuType: "", avatar: "", campus: "")
    @Published var isBindBs: Bool = false
    @Published var isBindPh: Bool = false
    @Published var isBindEm: Bool = false
    static var schoolDistrictKey: String = "schoolDistrictKey"
    static var schoolDistrict: Int{Storage.defaults.integer(forKey: schoolDistrictKey)}
    
    // 自习室的时间数据和是否获取信息
    @Published var studyRoomSelectDate: Date = Date()
    @Published var studyRoomSelectTime: String = ""
    @Published var isGetStudyRoomBuildingMessage: Bool = false
    

    
    // 清空全部的缓存
    static func remove(_ key: String) { Storage.defaults.removeObject(forKey: key) }
    static func removeAll() {
        remove(isShowFullCourseKey)
        remove(isShowGPAKey)
        remove(usernameKey)
        remove(passwordKey)
        remove(showCourseNumKey)
        remove(schoolDistrictKey)
    }
    

}
