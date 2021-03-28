//
//  LgSupplyManager.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/3.
//

import Foundation
struct LgSupplyPhManager {
    static let ticket = "YmFuYW5hLjM3YjU5MDA2M2Q1OTM3MTY0MDVhMmM1YTM4MmIxMTMwYjI4YmY4YTc="
    static let domain = "weipeiyang.twt.edu.cn"
//    static var token = ""
    
    static func CodePost(phone: String, token: String, completion: @escaping (Result<OrdinaryMessage, Network.Failure>) -> Void) {
        Network.fetch(
            "https://api.twt.edu.cn/api/user/phone/msg",
            query: [
                "phone": phone
            ],
            headers:[
                "ticket": ticket,
                "domain": domain,
                "token": token
            ],
            method: .post
        ) {
            result in
            switch result {
            case .success(let(data, response)):
                guard let ReturnMessage = try? JSONDecoder().decode(OrdinaryMessage.self, from: data) else {
                    completion(.failure(.requestFailed))
                    return
                }
                switch response.statusCode {
                case 200:
                    completion(.success(ReturnMessage))
                case 401:
                    completion(.failure(.loginFailed))
                default:
                    completion(.failure(.unknownError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func SupplyPost(telephone: String, verifyCode: String, email: String, token: String, completion: @escaping (Result<OrdinaryMessage, Network.Failure>) -> Void) {
        Network.fetch(
            "https://api.twt.edu.cn/api/user/single",
            query: [
                "telephone": telephone,
                "verifyCode": verifyCode,
                "email": email
            ],
            headers:[
                "ticket": ticket,
                "domain": domain,
                "token": token
            ],
            method: .put
        ) {
            result in
            switch result {
            case .success(let(data, response)):
                guard let ReturnMessage = try? JSONDecoder().decode(OrdinaryMessage.self, from: data) else {
                    completion(.failure(.requestFailed))
                    return
                }
                switch response.statusCode {
                case 200:
                    completion(.success(ReturnMessage))
                case 401:
                    completion(.failure(.loginFailed))
                default:
                    completion(.failure(.unknownError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
