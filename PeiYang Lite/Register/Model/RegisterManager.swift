//
//  RegisterManager.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/2.
//

import Foundation

struct RegisterManager {
    static let ticket = "YmFuYW5hLjM3YjU5MDA2M2Q1OTM3MTY0MDVhMmM1YTM4MmIxMTMwYjI4YmY4YTc="
    static let domain = "weipeiyang.twt.edu.cn"
    
    static func CodePost(phone: String, completion: @escaping (Result<OrdinaryMessage, Network.Failure>) -> Void) {
        Network.fetch(
            "https://api.twt.edu.cn/api/register/phone/msg",
            headers:[
                "ticket": ticket,
                "domain": domain
            ], method: .post,
            body: ["phone": phone]
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

    static func RegisterPost(userNumber: String, nickname: String, phone: String, verifyCode: String, password: String, email: String, idNumber: String, completion: @escaping (Result<OrdinaryMessage, Network.Failure>) -> Void) {
        Network.fetch(
            "https://api.twt.edu.cn/api/register",
            headers:[
                "ticket": ticket,
                "domain": domain
            ], method: .post,
            body: [
                "userNumber": userNumber,
                "nickname": nickname,
                "phone": phone,
                "verifyCode": verifyCode,
                "password": password,
                "email": email,
                "idNumber": idNumber
            ]
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
    
    static func FirstPost(userNumber: String, username: String, completion: @escaping (Result<OrdinaryMessage, Network.Failure>) -> Void) {
        Network.fetch(
            "https://api.twt.edu.cn/api/register/checking/\(userNumber)/\(username)",
            headers:[
                "ticket": ticket,
                "domain": domain
            ],
            method: .get
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
    static func SecondPost(idNumber: String, email: String, phone: String, completion: @escaping (Result<OrdinaryMessage, Network.Failure>) -> Void) {
        Network.fetch(
            "https://api.twt.edu.cn/api/register/checking",
            query: [
                "idNumber": idNumber,
                "email": email,
                "phone": phone
            ],
            headers:[
                "ticket": ticket,
                "domain": domain
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

}
