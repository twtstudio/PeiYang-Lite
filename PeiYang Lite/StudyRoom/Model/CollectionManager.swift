//
//  CollectionManager.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/3/7.
//

import Foundation

class CollectionManager {
    static let ticket = "YmFuYW5hLjM3YjU5MDA2M2Q1OTM3MTY0MDVhMmM1YTM4MmIxMTMwYjI4YmY4YTc="
    static let domain = "weipeiyang.twt.edu.cn"
    static let token = SupplyPhManager.token
    
    static func getCollections(completion: @escaping (Result<Collections, Network.Failure>) -> Void) {
        
        Network.fetch(
            "https://selfstudy.twt.edu.cn/getCollections",
            headers:[
                "ticket": ticket,
                "domain": domain,
                "token": token
            ],
            method: .get
        ) {
            result in
            switch result {
            case .success(let(data, response)):
                guard let ReturnMessage = try? JSONDecoder().decode(Collections.self, from: data) else {
                    completion(.failure(.requestFailed))
                    return
                }
                switch response.statusCode {
                case 200:
                    completion(.success(ReturnMessage))
                case 401:
                    completion(.failure(.urlError))
                default:
                    completion(.failure(.unknownError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    static func addFavour(classroomID: String, completion: @escaping (Result<StudyroomOrdinaryMessage, Network.Failure>) -> Void) {
        Network.fetch(
            "https://selfstudy.twt.edu.cn/addCollection",
            headers:[
                "ticket": ticket,
                "domain": domain,
                "token": token
            ],
            method: .post,
            body: ["classroom_id": classroomID]
        ) {
            result in
            switch result {
            case .success(let(data, response)):
                guard let ReturnMessage = try? JSONDecoder().decode(StudyroomOrdinaryMessage.self, from: data) else {
                    completion(.failure(.requestFailed))
                    return
                }
                switch response.statusCode {
                case 200:
                    completion(.success(ReturnMessage))
                case 401:
                    completion(.failure(.urlError))
                default:
                    completion(.failure(.unknownError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func deleteFavour(classroomID: String, completion: @escaping (Result<StudyroomOrdinaryMessage, Network.Failure>) -> Void) {
        Network.fetch(
            "https://selfstudy.twt.edu.cn/deleteCollection",
            headers:[
                "ticket": ticket,
                "domain": domain,
                "token": token
            ],
            method: .post,
            body: ["classroom_id": classroomID]
        ) {
            result in
            switch result {
            case .success(let(data, response)):
                guard let ReturnMessage = try? JSONDecoder().decode(StudyroomOrdinaryMessage.self, from: data) else {
                    completion(.failure(.requestFailed))
                    return
                }
                switch response.statusCode {
                case 200:
                    completion(.success(ReturnMessage))
                case 401:
                    completion(.failure(.urlError))
                default:
                    completion(.failure(.unknownError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}




// MARK: - Collections
struct Collections: Codable {
    let data: DataClass
    let errorCode: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let classroomID: [String]?

    enum CodingKeys: String, CodingKey {
        case classroomID = "classroom_id"
    }
}

// MARK: - StudyroomOrdinaryMessage
struct StudyroomOrdinaryMessage: Codable {
    let errorCode: Int
    let message: String
    let data: JSONNull?

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}
