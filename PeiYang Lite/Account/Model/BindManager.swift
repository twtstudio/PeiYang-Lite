//
//  BindManager.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/8.
//

import SwiftUI

struct BindManager{
    static let ticket = "YmFuYW5hLjM3YjU5MDA2M2Q1OTM3MTY0MDVhMmM1YTM4MmIxMTMwYjI4YmY4YTc="
    static let domain = "weipeiyang.twt.edu.cn"
    static let token = SupplyPhManager.token
    
    static func BindPhPut(telephone: String, verifyCode: String, completion: @escaping (Result<OrdinaryMessage, Network.Failure>) -> Void) {
        Network.fetch(
            "https://api.twt.edu.cn/api/user/single/phone",
            query: [
                "phone": telephone,
                "code": verifyCode
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
    
    static func BindEmPut(email: String, completion: @escaping (Result<OrdinaryMessage, Network.Failure>) -> Void) {
        Network.fetch(
            "https://api.twt.edu.cn/api/user/single/email",
            query: [
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
    
    static func ChangeName(username: String, completion: @escaping (Result<OrdinaryMessage, Network.Failure>) -> Void) {
        Network.fetch(
            "https://api.twt.edu.cn/api/user/single/username",
            query: [
                "username": username
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
