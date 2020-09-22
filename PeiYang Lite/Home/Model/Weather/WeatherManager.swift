//
//  WeatherManager.swift
//  PeiYang Lite
//
//  Created by Zr埋 on 2020/9/22.
//

import Foundation

class WeatherManager {
    static func weatherGet(completion: @escaping (Result<Weather, Network.Failure>) -> Void) {
        
        Network.fetch("http://www.weather.com.cn/weather/101030100.shtml") { (result) in
            switch result {
            case .success(let (data, _)):
                if let html = String(data: data, encoding: .utf8) {
                    let  weather = Weather(html: html)
                    // save Data
                    
                    Storage.weather.object = weather
                    Storage.weather.save()
                    completion(.success(weather))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
}
