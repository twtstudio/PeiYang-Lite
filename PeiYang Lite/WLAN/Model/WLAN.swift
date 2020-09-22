//
//  WLAN.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 8/7/20.
//

import Foundation

struct WLANOverview: Codable, Storable {
    let state: String
    let balance: String
    let traffic: String
    
    init(state: String, balance: String, traffic: String) {
        self.state = state
        self.balance = balance
        self.traffic = traffic
    }
    
    init() {
        self.state = "******"
        self.balance = "******"
        self.traffic = "******"
    }
}

struct WLANDetail: Codable, Storable {
//    let username: String
    let onlineDate: String
    let offlineDate: String
    let ip: String
    let traffic: String
    let duration: String
    
    init(wlanDetail: [String]) {
//        self.username = wlanDetail[]
        self.onlineDate = wlanDetail[0]
        self.offlineDate = wlanDetail[1]
        self.ip = wlanDetail[2]
        self.traffic = wlanDetail[4]
        self.duration = wlanDetail[6]
    }
    
//    init(username: String, onlineDate: String, offlineDate: String, ip: String, traffic: String, duration: String) {
//        self.username = username
//        self.onlineDate = onlineDate
//        self.offlineDate = offlineDate
//        self.ip = ip
//        self.traffic = traffic
//        self.duration = duration
//    }
    
    init() {
//        self.username = ""
        self.onlineDate = ""
        self.offlineDate = ""
        self.ip = ""
        self.traffic = ""
        self.duration = ""
    }
}

struct WLAN: Codable, Storable {
    let overview: WLANOverview
    let detailArray: [WLANDetail]
    
    init(overview: WLANOverview, detailArray: [WLANDetail]) {
        self.overview = overview
        self.detailArray = detailArray
    }
    
    init() {
        self.overview = WLANOverview()
        self.detailArray = []
    }
}



/// TODO: 
//struct defaultsKeys {
//    static var userName = "unknown"
//}
