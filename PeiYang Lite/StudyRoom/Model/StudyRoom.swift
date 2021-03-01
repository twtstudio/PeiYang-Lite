//
//  StudyRoom.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2020/11/14.
//

import SwiftUI

// MARK: - BuildingAndClass
struct Building: Codable, Identifiable {
    let id = UUID()
    let errorCode: Int
    let message: String
    let data: [Datum]

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

// MARK: - Datum
struct Datum: Codable, Identifiable {
    let id = UUID()
    let buildingID, building, campusID: String
    let areaID: String?
    let classrooms: [Classroom]

    
    enum CodingKeys: String, CodingKey {
        case buildingID = "building_id"
        case building
        case campusID = "campus_id"
        case areaID = "area_id"
        case classrooms
    }
}
// MARK: - Classroom
struct Classroom: Codable, Identifiable {
    let id = UUID()
    let classroomID, classroom, capacity, buildingID: String

    enum CodingKeys: String, CodingKey {
        case classroomID = "classroom_id"
        case classroom, capacity
        case buildingID = "building_id"
    }
}

class StudyRoomManager {
    static func allBuidlingGet(completion: @escaping (Result<Building, Network.Failure>) -> Void) {
        Network.fetch(
            "https://selfstudy.twt.edu.cn/api/getBuildingList.php",
            method: .get
        ) {
            result in
            switch result {
            case .success(let(data, response)):
                guard let ReturnMessage = try? JSONDecoder().decode(Building.self, from: data) else {
                    completion(.failure(.requestFailed))
                    return
                }
                completion(.success(ReturnMessage))
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


