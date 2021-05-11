//
//  AcMessageManager.swift
//  PeiYang-Lite
//
//  Created by Zr埋 on 2021/5/11.
//

import Foundation

// MARK: - AccountMessageResult
struct AccountMessageResult: Codable {
    let errorCode: Int
    let message: String
    let result: [AccountMessageData]
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, result
    }
}

// MARK: - Result
struct AccountMessageData: Codable {
    let id: Int
    let resultOperator, targetUser, title, content: String?
    let createdAt, read: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case resultOperator = "operator"
        case targetUser, title, content, createdAt, read
    }
}


struct AcMessageManager {
    static let ticket = "YmFuYW5hLjM3YjU5MDA2M2Q1OTM3MTY0MDVhMmM1YTM4MmIxMTMwYjI4YmY4YTc="
    static let domain = "weipeiyang.twt.edu.cn"
    
    static func getAllMessages(completion: @escaping (Result<[AccountMessageData], Network.Failure>) -> Void) {
        Network.fetch(
            "https://api.twt.edu.cn/api/notification/message/user",
            headers:[
                "ticket": ticket,
                "domain": domain,
                "token": Storage.defaults.string(forKey: SharedMessage.userTokenKey) ?? ""
            ],
            method: .get
        ) {
            result in
            switch result {
            case .success(let(data, response)):
                guard let returnMessage = try? JSONDecoder().decode(AccountMessageResult.self, from: data) else {
                    completion(.failure(.requestFailed))
                    return
                }
                switch response.statusCode {
                case 200:
                    completion(.success(returnMessage.result))
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
