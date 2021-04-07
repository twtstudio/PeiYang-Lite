
//
//  StyCollectionManager.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/3/7.
//
import Foundation

class StyCollectionManager {
    static let ticket = "YmFuYW5hLjM3YjU5MDA2M2Q1OTM3MTY0MDVhMmM1YTM4MmIxMTMwYjI4YmY4YTc="
    static let domain = "weipeiyang.twt.edu.cn"
    
    static func getCollections(buildings: [StudyBuilding], completion: @escaping (Result<[CollectionClass], Network.Failure>) -> Void) {
        Network.fetch(
            "https://selfstudy.twt.edu.cn/getCollections",
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
                guard let ReturnMessage = try? JSONDecoder().decode(Collections.self, from: data) else {
                    completion(.failure(.requestFailed))
                    return
                }
                var returnMessageData: [CollectionClass] = []
                DataStorage.store(ReturnMessage.data.classroomID ?? [], in: .caches, as: "studyroom/collections.json")
                for code in ReturnMessage.data.classroomID ?? [] {
                    for building in buildings {
                        for area in building.areas {
                            for room in area.classrooms {
                                if room.classroomID == code {
                                    returnMessageData.append(CollectionClass(sectionName: area.areaID, classMessage: room, buildingName: building.building))
                                }
                            }
                        }
                    }
                }
                switch response.statusCode {
                case 200:
                    completion(.success(returnMessageData))
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
                "token": Storage.defaults.string(forKey: SharedMessage.userTokenKey) ?? ""
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
                "token": Storage.defaults.string(forKey: SharedMessage.userTokenKey) ?? ""
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
    let data: CollectionsData
    let errorCode: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

// MARK: - DataClass
struct CollectionsData: Codable {
    let classroomID: [String]?

    enum CodingKeys: String, CodingKey {
        case classroomID = "classroom_id"
    }
}

// MARK: - StudyroomOrdinaryMessage
struct StudyroomOrdinaryMessage: Codable {
    let data: NilData
    let errorCode: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

// MARK: - DataClass
struct NilData: Codable {
}



