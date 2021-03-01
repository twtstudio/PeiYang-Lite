//
//  WeatherManager.swift
//  PeiYang Lite
//
//  Created by Zr埋 on 2020/9/22.
//

import Foundation

class WeatherManager {
    let url = URL(string: "http://www.weather.com.cn/weather/101030100.shtml")!
    
    func batch(completion: @escaping (Result<(Data, HTTPURLResponse), Network.Failure>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = Network.Method.get.rawValue
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print(error?.localizedDescription ?? "Unknown Error")
                completion(.failure(.requestFailed))
                return
            }
            completion(.success((data, response)))
        }.resume()
    }
    
    func weatherGet(completion: @escaping (Result<Weather, Network.Failure>) -> Void) {
        var todayWeather = Weather()
        self.batch { result in
            switch result {
            case .success(let (data, _)):
                if let html = String(data: data, encoding: .utf8) {
                    let today = html.find("（今天）(.+?)</i>")
                    let wStatus = today.find("wea\">(.+?)<")
                    let wTempH = today.find("span>(.+?)</span>")
                    let wTempL = today.find("i>(.+?)℃")
                    todayWeather.wStatus = wStatus
                    if wTempH.isEmpty || wTempL.isEmpty {
                        todayWeather.weatherString = wTempL + wTempH + "℃"
                    } else {
                        todayWeather.weatherString = wTempL + "~" + wTempH
                    }
                    todayWeather.weatherIconString1 = self.iconString(wStatus)
                }
            case .failure(let error):
                completion(.failure(error))
            }
            completion(.success(todayWeather))
            
        }
    }
    
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
