//
//  VerificationCodeManager.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/2.
//

import Foundation

struct VerficationCodeManager {
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
}
