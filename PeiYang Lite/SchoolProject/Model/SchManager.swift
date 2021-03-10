//
//  SchManager.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/26.
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
    
    static let BASE_URL = "http://47.93.253.240:10805/api"
    static let tokenKey = "SCHTOKENKEY"
    
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
        tmpQuery["token"] = Storage.defaults.string(forKey: tokenKey)
        return Network.fetch(url, query: tmpQuery, headers: headers, method: method, body: body, async: async, completion: completion)
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
        tmpBody["token"] = Storage.defaults.string(forKey: tokenKey)
        return Network.requestWithFormData(urlString: url, parameters: tmpBody, dataPath: imageData, completion: completion)
    }
}
