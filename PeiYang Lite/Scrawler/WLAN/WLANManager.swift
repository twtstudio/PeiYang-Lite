//
//  WLANManager.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 8/7/20.
//

import Foundation

struct WLANManager {
    static let isLoginKey = "wlanIsLogin"
    static let isStoreKey = "wlanIsStore"
    
    static let usernameKey = "wlanUsername"
    static let passwordKey = "wlanPassword"
    
    static var isLogin: Bool { Storage.defaults.bool(forKey: isLoginKey) }
    static var isStore: Bool { Storage.defaults.bool(forKey: isStoreKey) }
    
    static var username: String { Storage.defaults.string(forKey: usernameKey) ?? "" }
    static var password: String { Storage.defaults.string(forKey: passwordKey) ?? "" }
    
    static func remove(_ key: String) { Storage.defaults.removeObject(forKey: key) }
    
    static func removeAll() {
        remove(isLoginKey)
<<<<<<< HEAD
        remove(isStoreKey)
=======
>>>>>>> e4291697b2a03afcf4cfbf314ae8cf47114102d1
        remove(usernameKey)
        remove(passwordKey)
        Storage.wlan.remove()
    }
    
    // MARK: - Login
    static func loginGet(completion: @escaping (Result<(String, String), Network.Failure>) -> Void) {
        Network.fetch("http://202.113.15.50:8800/") { result in
            switch result {
            case .success(let (data, _)):
                guard let html = String(data: data, encoding: .utf8) else {
                    completion(.failure(.urlError))
                    return
                }
                
                let csrfParam = html.find("<meta name=\"csrf-param\" content=\"([^\"]+)\">")
                let csrfToken = html.find("<meta name=\"csrf-token\" content=\"([^\"]+)\">")
                completion(.success((csrfParam, csrfToken)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func loginPost(captcha: String, completion: @escaping (Result<String, Network.Failure>) -> Void) {
        loginGet { result in
            switch result {
            case .success(let (csrfParam, csrfToken)):
                Network.fetch(
                    "http://202.113.15.50:8800/",
                    method: .post,
                    body: [
                        csrfParam: csrfToken,
                        "LoginForm[username]": username,
                        "LoginForm[password]": password,
//                        "LoginForm[verifyCode]": captcha 
                    ]
                ) { result in
                    switch result {
                    case .success(let (data, response)):
                        guard let html = String(data: data, encoding: .utf8) else {
                            completion(.failure(.requestFailed))
                            return
                        }
                        
                        if response.statusCode == 200, let url = response.url?.absoluteString {
                            if url == "http://202.113.15.50:8800/" {
                                completion(.failure(.loginFailed))
                            } else {
                                completion(.success(html))
                            }
                        } else {
                            completion(.failure(.unknownError))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Service
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
                
                if response.statusCode == 200, let url = response.url?.absoluteString {
                    if url == "http://202.113.15.50:8800/site/index" {
                        completion(.failure(.loginFailed))
                    } else {
                        completion(.success(html))
                    }
                } else {
                    completion(.failure(.unknownError))
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
    
    // MARK: - Check
    static func checkLogin(completion: @escaping (Result<String, Network.Failure>) -> Void) {
        fetch(urlString: "http://202.113.15.50:8800/home/", completion: completion)
    }
    
    // MARK: - WLAN
    static func wlanGet(completion: @escaping (Result<WLAN, Network.Failure>) -> Void) {
        DispatchQueue.global().async {
            let semaphore = DispatchSemaphore(value: 0)
            
            var overview = WLANOverview()
            batch(urlString: "http://202.113.15.50:8800/home/") { result in
                switch result {
                case .success(let html):
                    overview = WLANOverview(
                        state: html.find("状态</label><a .*?>(.+?)</a>"),// 正则需要改写finish
                        balance: html.find("账户余额</label>(.+?)<a"),//⬆️finish
                        traffic: html.find("可用流量</label>(.+?)&nbsp;&nbsp;")//⬆️ finish
<<<<<<< HEAD
=======
                        
>>>>>>> e4291697b2a03afcf4cfbf314ae8cf47114102d1
                    )
                    semaphore.signal()
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            semaphore.wait()
            
            var detailArray = [WLANDetail]()
            batch(urlString: "http://202.113.15.50:8800/log/detail") { result in
                switch result {
                case .success(let html):
                    detailArray = html.find("<tbody>(.+?)</tbody>")
                        .findArray("<tr(.+?)</tr>")
                        .map { WLANDetail(wlanDetail: $0.findArray("<td.+?>(.+?)</td>")) }
                    semaphore.signal()
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            semaphore.wait()
            
            let wlan = WLAN(overview: overview, detailArray: detailArray)
            DispatchQueue.main.async {
<<<<<<< HEAD
                // Storage save
                completion(.success(wlan))
                Storage.defaults.setValue(true, forKey: isStoreKey)
                Storage.wlan.object = wlan
                Storage.wlan.save()
=======
                completion(.success(wlan))
>>>>>>> e4291697b2a03afcf4cfbf314ae8cf47114102d1
            }
        }
    }
}
