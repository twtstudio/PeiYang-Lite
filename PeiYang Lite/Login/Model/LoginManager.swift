//
//  LoginByPs.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/1/28.
//
//

import Foundation

struct LoginManager {
    
    static let isTokenKey = "tokenIsGet"
    static let isAcLogin = "acIsget"

    static var token: String { Storage.defaults.string(forKey: isTokenKey) ?? "" }
   
    
    static let ticket = "YmFuYW5hLjM3YjU5MDA2M2Q1OTM3MTY0MDVhMmM1YTM4MmIxMTMwYjI4YmY4YTc="
    static let domain = "weipeiyang.twt.edu.cn"
    
    
    static func LoginPost(account: String, password: String, completion: @escaping (Result<AccountMessage, OrdinaryMessage>) -> Void) {
        Network.fetch(
            "https://api.twt.edu.cn/api/auth/common",
            headers:[
                "ticket": ticket,
                "domain": domain
            ], method: .post,
            body: [
                "account": account,
                "password": password
            ]
        ) {
            result in
            switch result {
            case .success(let(data, response)):
                guard let accountMessage = try? JSONDecoder().decode(AccountMessage.self, from: data) else {
                    let wrongMessage = try? JSONDecoder().decode(OrdinaryMessage.self, from: data)
                    completion(.failure(wrongMessage ?? OrdinaryMessage(errorCode: 0, message: "请求异常", result: nil)))
                    return
                }
                switch response.statusCode {
                case 200:
                    completion(.success(accountMessage))
                case 401:
                    completion(.failure(OrdinaryMessage(errorCode: 0, message: "网络异常", result: nil)))
                default:
                    completion(.failure( OrdinaryMessage(errorCode: 0, message: "网络问题", result: nil)))
                }
            case .failure(_):
                completion(.failure(OrdinaryMessage(errorCode: 0, message: "网络异常", result: nil)))
            }
        }
    }
    
   
}

struct AccountMessage: Codable {
    let errorCode: Int
    let message: String
    let result: accountResult

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, result
    }
}

// MARK: - accountResult
struct accountResult: Codable {
    let userNumber:String
    var nickname: String
    var telephone: String?
    var email: String?
    let token, role, realname: String
    let gender, department, major, stuType: String
    let avatar, campus: String
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

// MARK: - OrdinaryMessage
struct OrdinaryMessage: Codable, Error {
    let errorCode: Int
    let message: String
    let result: JSONNull?

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, result
    }
}

