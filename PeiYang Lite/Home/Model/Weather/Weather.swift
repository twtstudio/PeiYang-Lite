//
//  Weather.swift
//  PeiYang Lite
//
//  Created by Zr埋 on 2020/9/22.
//

import Foundation
import Combine

struct Weather: Codable, Storable {
    var wStatus: String = ""
    var wTempH: String = ""
    var wTempL: String = ""
    var weatherString: String = ""
    var weatherIconString1: String = ""
    var weatherIconString2: String = ""
    
    init() {
    }
    
    init(html: String) {
        let today = html.find("（今天）(.+?)</i>")
        self.wStatus = today.find("wea\">(.+?)<")
        self.wTempH = today.find("span>(.+?)</span>")
        self.wTempL = today.find("i>(.+?)℃")
        self.weatherIconString1 = ""
        self.weatherIconString2 = ""
        if self.wTempH.isEmpty || self.wTempL.isEmpty {
            weatherString = wStatus + " " + wTempL + wTempH + "℃"
        } else {
            weatherString =  wStatus + " " + wTempL + "~" + wTempH + "℃"
        }
        if wStatus.contains("转") {
            let wStatusArr = wStatus.components(separatedBy: "转")
            weatherIconString1 = iconString(wStatusArr[0])
            weatherIconString2 = iconString(wStatusArr[1])
        } else {
            weatherIconString1 = iconString(wStatus)
        }
    }
    
    // return Weathericon system name
    private func iconString(_ str: String) -> String {
        switch str {
        case "晴": return "sun.max"
        case "阴": return "cloud"
        case "雨": return "cloud.rain"
        case "雷阵雨": return "cloud.bolt.rain"
        case "多云": return "cloud.sun"
        default: return "sun.max"
        }
    }
}
