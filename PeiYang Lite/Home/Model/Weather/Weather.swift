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
    
}
