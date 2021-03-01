//
//  FgVerifyCodeManager.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/2.
//

import Foundation

struct ForgetManager {
    static let ticket = "YmFuYW5hLjM3YjU5MDA2M2Q1OTM3MTY0MDVhMmM1YTM4MmIxMTMwYjI4YmY4YTc="
    static let domain = "weipeiyang.twt.edu.cn"
    static var telephone = ""
    
    static func CodePost(phone: String, completion: @escaping (Result<OrdinaryMessage, Network.Failure>) -> Void) {
        Network.fetch(
            "https://api.twt.edu.cn/api/password/reset/msg",
            headers:[
                "ticket": ticket,
                "domain": domain
            ], method: .post,
            body: ["phone": phone]
        ) { result in
            switch result {
            case .success(let(data, response)):
                guard let ReturnMessage = try? JSONDecoder().decode(OrdinaryMessage.self, from: data) else {
                    completion(.failure(.requestFailed))
                    return
                }
                completion(.success(ReturnMessage))
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

    static func VertifyCodePost(phone: String, code: String, completion: @escaping (Result<OrdinaryMessage, Network.Failure>) -> Void) {
        telephone = phone
        Network.fetch(
            "https://api.twt.edu.cn/api/password/reset/verify",
            headers:[
                "ticket": ticket,
                "domain": domain
            ], method: .post,
            body: [
                "phone": phone,
                "code": code
            ]
        ) { result in
            switch result {
            case .success(let(data, response)):
                guard let ReturnMessage = try? JSONDecoder().decode(OrdinaryMessage.self, from: data) else {
                    completion(.failure(.requestFailed))
                    return
                }
                completion(.success(ReturnMessage))
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
    
    static func ChangePsPost(password: String, completion: @escaping (Result<OrdinaryMessage, Network.Failure>) -> Void) {
        Network.fetch(
            "https://api.twt.edu.cn/api/password/reset",
            headers:[
                "ticket": ticket,
                "domain": domain
            ], method: .post,
            body: [
                "phone": telephone,
                "password": password
            ]
        ) { result in
            switch result {
            case .success(let(data, response)):
                guard let ReturnMessage = try? JSONDecoder().decode(OrdinaryMessage.self, from: data) else {
                    completion(.failure(.requestFailed))
                    return
                }
                completion(.success(ReturnMessage))
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
