//
//  WeatherManager.swift
//  PeiYang Lite
//
//  Created by 游奕桁 on 2021/1/26.
//

import Foundation

struct WeatherManager {
    static func fetch(
        _ method: Network.Method = .get,
        urlString: String,
        query: [String: String] = [:],
        body: [String: String] = [:],
        async: Bool = true,
        completion: @escaping (Result<String, Network.Failure>) -> Void
    ) {
        Network.fetch(urlString, query: query, method: method, body: body, async: async) { result in
            switch result {
            case .success(let (data, response)):
                guard let html = String(data: data, encoding: .utf8) else {
                    completion(.failure(.requestFailed))
                    return
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func batch(
        _ method: Network.Method = .get,
        urlString: String,
        query: [String: String] = [:],
        body: [String: String] = [:],
        completion: @escaping (Result<String, Network.Failure>) -> Void
    ) {
        fetch(method, urlString: urlString, query: query, body: body, async: false, completion: completion)
    }
    
    static func weatherGet(completion: @escaping (Result<WLAN, Network.Failure>) -> Void) {
        DispatchQueue.global().async {
            let semaphore = DispatchSemaphore(value: 0)
            
            var todayWeather = Weather()
            batch(urlString: "http://www.weather.com.cn/weather/101030100.shtml") { result in
                switch result {
                case .success(let (data, _)):
                    if let html = String(data: data, encoding: .utf8) {
                        let today = html.find("（今天）(.+?)</i>")
                        let wStatus = today.find("wea\">(.+?)<")
                        let wTempH = today.find("span>(.+?)</span>")
                        let wTempL = today.find("i>(.+?)℃")
                        if wTempH.isEmpty || wTempL.isEmpty {
                            weathers[0].weatherString = wTempL + wTempH + "℃"
                        } else {
                            weathers[0].weatherString = wTempL + "~" + wTempH + "℃"
                        }
                        if wStatus.contains("雪") {
                            weathers[0].weatherIconString1 = iconString("雪")
                        } else {
                            weathers[0].weatherIconString1 = iconString(wStatus)
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
            semaphore.wait()
            
            var tomorrowWeather = Weather()
            batch(urlString: "http://www.weather.com.cn/weather/101030100.shtml") { result in
                switch result {
                case .success(let (data, _)):
                    if let html = String(data: data, encoding: .utf8) {
                        let today = html.find("（明天）(.+?)</i>")
                        let wStatus = today.find("wea\">(.+?)<")
                        let wTempH = today.find("span>(.+?)</span>")
                        let wTempL = today.find("i>(.+?)℃")
                        if wTempH.isEmpty || wTempL.isEmpty {
                            weathers[1].weatherString = wTempL + wTempH + "℃"
                        } else {
                            weathers[1].weatherString = wTempL + "~" + wTempH + "℃"
                        }
                        if wStatus.contains("雪") {
                            weathers[1].weatherIconString1 = iconString("雪")
                        } else {
                            weathers[1].weatherIconString1 = iconString(wStatus)
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
            semaphore.wait()
            
            let weathers = [todayWeather, tomorrowWeather]
            DispatchQueue.main.async {
                completion(.success(weathers))
            }
        }
    }
}
