//
//  SchNetworkManager.swift
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

struct SchNetworkManager {
    
    static let BASE_URL = "http://47.93.253.240:10805/api"
    static let schtokenKey = "SCHTOKENKEY"
    
    static func request(
        _ path: String,
        query: [String: String] = [:],
        headers: [String: String] = [:],
        method: Network.Method = .get,
        body: [String: String] = [:],
        async: Bool = true,
        completion: @escaping (Result<(Data, HTTPURLResponse), Network.Failure>) -> Void
    ) {
        let url = BASE_URL + path
        var tmpBody = body
        tmpBody["token"] = Storage.defaults.string(forKey: schtokenKey)
        return Network.fetch(url, query: query, headers: headers, method: method, body: tmpBody, async: async, completion: completion)
    }
}
