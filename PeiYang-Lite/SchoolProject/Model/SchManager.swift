//
//  SchManager.swift
//  PeiYang-Lite
//
//  Created by Zrzz on 2021/4/5.
//

import Foundation

// MARK: 用于解析返回的数据
struct SchResponseModel<T: Codable>: Codable {
    var errorCode: Int?
    var msg: String?
    var data: T?
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case msg, data
    }
}

struct SchManager {
    
    static let BASE_URL = "http://47.94.198.197:10805/api"
    static let tokenKey = "SCHTOKENKEY"
    
    static var schToken: String? {
        Storage.defaults.string(forKey: tokenKey)
    }
    
    static func request(
        _ path: String,
        query: [String: String] = [:],
        headers: [String: String] = [:],
        method: Network.Method = .get,
        body: [String: Any] = [:],
        async: Bool = true,
        completion: @escaping (Result<(Data, HTTPURLResponse), Network.Failure>) -> Void
    ) {
        let url = BASE_URL + path
        var tmpQuery = query
        var tmpBody = body
        if method == .get {
            tmpQuery["token"] = schToken
        } else if method == .post {
            tmpBody["token"] = schToken
        }
        return Network.fetch(url, query: tmpQuery, headers: headers, method: method, body: tmpBody, async: async, completion: completion)
    }
    
    static func uploadImage(
        _ path: String,
        imageData: [String: Data],
        query: [String: String] = [:],
        headers: [String: String] = [:],
        method: Network.Method = .get,
        body: [String: Any] = [:],
        async: Bool = true,
        completion: @escaping (Result<(Data, HTTPURLResponse), Network.Failure>) -> Void
    ) {
        let url = BASE_URL + path
        var tmpBody = body
        tmpBody["token"] = schToken
        return Network.requestWithFormData(urlString: url, parameters: tmpBody, dataPath: imageData, completion: completion)
    }
}
