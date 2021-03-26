//
//  HomeViewHeaderView.swift
//  PeiYang Lite
//
//  Created by Zr埋 on 2020/9/18.
//

import SwiftUI

struct HomeViewHeaderView: View {
    @State private var weatherString = ""
    @State private var weatherIconString1 = ""
    @State private var weatherIconString2 = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.sayHi())
                .font(.title)
            HStack {
                Text(weatherString)
                    .font(.title2)
                Image(systemName: weatherIconString1)
                Image(systemName: weatherIconString2)
            }
        }
        .padding([.leading, .top])
        .onAppear(perform: weatherGet)
    }
    
    private func weatherGet() {
        Network.fetch("http://www.weather.com.cn/weather/101030100.shtml") { (result) in
            switch result {
            case .success(let (data, _)):
                if let html = String(data: data, encoding: .utf8) {
                    let today = html.find("（今天）(.+?)</i>")
                    let wStatus = today.find("wea\">(.+?)<")
                    let wTempH = today.find("span>(.+?)</span>")
                    let wTempL = today.find("i>(.+?)℃")
                    if wTempH.isEmpty || wTempL.isEmpty {
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
            case .failure(let error):
                print(error)
            }
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
    
    private func sayHi() -> LocalizedStringKey {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        let hr = formatter.string(from: Date())
        switch Int(hr) ?? 0 {
        case 0..<4:
            return Localizable.beforeDawn.rawValue
        case 4..<6:
            return Localizable.dawn.rawValue
        case 6..<8:
            return Localizable.morning.rawValue
        case 8..<12:
            return Localizable.beforeNoon.rawValue
        case 12..<13:
            return Localizable.noon.rawValue
        case 13..<14:
            return Localizable.noonSoon.rawValue
        case 14..<17:
            return Localizable.afternoon.rawValue
        case 17..<19:
            return Localizable.dusk.rawValue
        case 19..<22:
            return Localizable.evening.rawValue
        default:
            return Localizable.night.rawValue
        }
    }
}

struct HomeViewHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewHeaderView()
    }
}
