//
//  ECardManager.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/26/20.
//

import Foundation

struct ECardManager {
    static let isLoginKey = "ecardIsLogin"
    static let isStoreKey = "ecardIsStore"
    
    static let usernameKey = "ecardUsername"
    static let passwordKey = "ecardPassword"
    
    static let urlHead = "https://ecard.tju.edu.cn/epay/"
    
    static var isLogin: Bool { Storage.defaults.bool(forKey: isLoginKey) }
    static var isStore: Bool { Storage.defaults.bool(forKey: isStoreKey) }
    
    static var username: String { Storage.defaults.string(forKey: usernameKey) ?? "" }
    static var password: String { Storage.defaults.string(forKey: passwordKey) ?? "" }
    
    static func remove(_ key: String) { Storage.defaults.removeObject(forKey: key) }
    
    static func removeAll() {
        remove(isLoginKey)
        remove(usernameKey)
        remove(passwordKey)
        Storage.ecard.remove()
    }
    
    // MARK: - Login
    static func loginGet(completion: @escaping (Result<String, Network.Failure>) -> Void) {
        Network.fetch("https://ecard.tju.edu.cn/epay/person/index") { result in
            switch result {
            case .success(let (data, _)):
                guard let html = String(data: data, encoding: .utf8) else {
                    completion(.failure(.urlError))
                    return
                }
                
                completion(.success(html))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func loginPost(captcha: String, completion: @escaping (Result<String, Network.Failure>) -> Void) {
        loginGet { result in
            switch result {
            case .success(let html):
                let csrf = html.find("name=\"_csrf\" content=\"([^\"]+)\"")
                Network.fetch(
                    urlHead + "j_spring_security_check",
                    method: .post,
                    body: [
                        "_csrf": csrf,
                        "j_username": username,
                        "j_password": password,
                        "imageCodeName": captcha
                    ]
                ) { result in
                    switch result {
                    case .success(let (data, response)):
                        guard let html = String(data: data, encoding: .utf8) else {
                            completion(.failure(.requestFailed))
                            return
                        }
                        
                        if response.statusCode == 200, let url = response.url?.absoluteString {
                            if url.contains(urlHead + "person/index") || url.contains("发生错误") {
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
//        loginPost(captcha: "") { result in
//            switch result {
//            case .success:
                Network.fetch(urlString, query: query, method: method, body: body, async: async) { result in
                    switch result {
                    case .success(let (data, _)):
                        guard let html = String(data: data, encoding: .utf8) else {
                            completion(.failure(.requestFailed))
                            return
                        }
                        
                        completion(.success(html))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
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
    
    //MARK: - Check
    static func checkLogin(completion: @escaping (Result<String, Network.Failure>) -> Void) {
        fetch(urlString: urlHead, completion: completion)
    }
    
    // MARK: - ECard
    static func ecardPost(_ qdates: [String], completion: @escaping (Result<ECard, Network.Failure>) -> Void) {
        enum qtypes: String, CaseIterable {
            case recharge = "1"
            case consume = "2"
        }
        
        enum resources: String, CaseIterable {
            case dailyConsumes = "consumeStat"
            case siteConsumes = "consumeComp"
            case siteRecharges = "dpsStat"
        }
        
        DispatchQueue.global().async {
            let semaphore = DispatchSemaphore(value: 0)
            
            var overview = ECardOverview()
            batch(urlString: urlHead + "myepay/index") { result in
                switch result {
                case .success(let html):
//                    let table = html.find("<table class=\"card-info\"(.+?)</table>")
                    overview = ECardOverview(
                        no: html.find("学/工号： ([^&]+)"),
                        state: "",
                        balance: "",
                        expire: "",
                        subsidy: html.find("账户余额：([^元]+)")
                    )
                    semaphore.signal()
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            semaphore.wait()
            
            var periodAmountArray = [PeriodAmount]()
            for qdate in qdates {
                var transactionArray = [Transaction]()
                for qtype in qtypes.allCases {
                    batch(
                        .post,
                        urlString: "https://ecard.tju.edu.cn/epay/consume/index",
                        query: [
                            "p_p_id": "transDtl_WAR_ecardportlet",
                            "p_p_state": "exclusive",
                            "_transDtl_WAR_ecardportlet_action": "dtlmoreview"
                        ],
                        body: [
                            "_transDtl_WAR_ecardportlet_qdate": qdate,
                            "_transDtl_WAR_ecardportlet_qtype": qtype.rawValue
                        ]
                    ) { result in
                        switch result {
                        case .success(let html):
                            let subtransactionArray = html
                                .findArray("<tr>(.+?)</tr>")[1...]
                                .map { transactionHTML -> Transaction in
                                    let transaction = transactionHTML.findArray("([^>]+?)</")
                                    return Transaction(qtype: qtype.rawValue, transaction: transaction)
                                }
                            
                            transactionArray += subtransactionArray
                            semaphore.signal()
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                    semaphore.wait()
                }
                
                var dailyConsumeArray = [DailyAmount]()
                var siteConsumeArray = [SiteAmount]()
                var siteRechargeArray = [SiteAmount]()
                for resource in resources.allCases {
                    batch(
                        .post,
                        urlString: "http://59.67.37.10:10000/web/guest/myactive",
                        query: [
                            "p_p_id": "myActive_WAR_ecardportlet",
                            "p_p_lifecycle": "2",
                            "p_p_resource_id": resource.rawValue
                        ],
                        body: [
                            "_myActive_WAR_ecardportlet_days": qdate
                        ]
                    ) { result in
                        switch result {
                        case .success(let html):
                            switch resource {
                            case .dailyConsumes:
                                dailyConsumeArray = html
                                    .findArrays("\\[\"([0-9]+)\",[0-9]+,[0-9]+,([0-9\\.]+)\\]")
                                    .map { DailyAmount(dailyAmount: $0) }
                            case .siteConsumes:
                                siteConsumeArray = html
                                    .findArrays("\\[[0-9]+,\"([^,]+)\",([0-9\\.]+)\\]")
                                    .map { SiteAmount(siteAmount: $0) }
                            case .siteRecharges:
                                siteRechargeArray = html
                                    .findArrays("\\[[0-9]+,\"([^,]+)\",([0-9\\.]+)\\]")
                                    .map { SiteAmount(siteAmount: $0) }
                            }
                            semaphore.signal()
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                    semaphore.wait()
                }
                
                let periodAmount = PeriodAmount(
                    period: qdate,
                    transactionArray: transactionArray,
                    dailyConsumeArray: dailyConsumeArray,
                    siteConsumeArray: siteConsumeArray,
                    siteRechargeArray: siteRechargeArray
                )
                periodAmountArray.append(periodAmount)
            }
            
            let ecard = ECard(overview: overview, periodAmountArray: periodAmountArray)
            DispatchQueue.main.async {
                completion(.success(ecard))
                // Storage save
                Storage.defaults.setValue(true, forKey: isStoreKey)
            }
        }
    }
}
