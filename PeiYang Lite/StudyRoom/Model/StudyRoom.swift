//
//  StudyRoom.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2020/11/14.
//

import SwiftUI

// MARK: - StudyRooms
struct StudyRooms: Codable, Identifiable, Hashable {
    var id = UUID()
    let data: [StudyBuilding]
    let errorCode: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case data
        case errorCode = "error_code"
        case message
    }
}

// MARK: - StudyBuilding
struct StudyBuilding: Codable, Hashable, Identifiable{
    var id = UUID()
    let buildingID: String
    let areas: [Area]
    let building, campusID: String

    enum CodingKeys: String, CodingKey {
        case buildingID = "building_id"
        case areas, building
        case campusID = "campus_id"
    }
}

// MARK: - Area
struct Area: Codable, Identifiable, Hashable {
    var id = UUID()
    
    let areaID: String
    let classrooms: [Classroom]

    enum CodingKeys: String, CodingKey {
        case areaID = "area_id"
        case classrooms
    }
}

// MARK: - Classroom
struct Classroom: Codable, Identifiable, Hashable {
    var id = UUID()
    let classroomID, classroom, status: String
   

    enum CodingKeys: String, CodingKey {
        case classroomID = "classroom_id"
        case classroom, status
    }
}
// 收藏储存结构体
struct CollectionClass: Hashable {
    var id = UUID()
    var classMessage: Classroom
    var buildingName: String
}

//class StudyRoomModel: ObservableObject {
//    @Published var day: Int = 0
//    @Published var weeks: Int = 0
//    @Published var studyRoomSelectTime: String = ""
//}



class StudyRoomManager {
    static let ticket = "YmFuYW5hLjM3YjU5MDA2M2Q1OTM3MTY0MDVhMmM1YTM4MmIxMTMwYjI4YmY4YTc="
    static let domain = "weipeiyang.twt.edu.cn"
//    static func allBuidlingGet(completion: @escaping (Result<StudyRooms, Network.Failure>) -> Void) {
//        Network.fetch(
//            "https://selfstudy.twt.edu.cn/getBuildingList",
//            method: .get
//        ) {
//            result in
//            switch result {
//            case .success(let(data, response)):
//                guard let ReturnMessage = try? JSONDecoder().decode(StudyRooms.self, from: data) else {
//                    completion(.failure(.requestFailed))
//                    return
//                }
//                completion(.success(ReturnMessage))
//                switch response.statusCode {
//                case 200:
//                    completion(.success(ReturnMessage))
//                case 401:
//                    completion(.failure(.urlError))
//                default:
//                    completion(.failure(.unknownError))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    static func allBuidlingGet(term: String, week: String, day: String, completion: @escaping (Result<StudyRooms, Network.Failure>) -> Void) {
        Network.fetch(
            "https://selfstudy.twt.edu.cn/getDayData/" + term + "/" + week + "/" + day,
            method: .get
        ) {
            result in
            switch result {
            case .success(let(data, response)):
                guard let ReturnMessage = try? JSONDecoder().decode(StudyRooms.self, from: data) else {
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

// MARK: - 字符串截取
extension String {
    /// String使用下标截取字符串
    /// string[index] 例如："abcdefg"[2] // c
    subscript (i:Int)->String{
        if(self == "") {return ""}
        let startIndex = self.index(self.startIndex, offsetBy: i)
        let endIndex = self.index(startIndex, offsetBy: 1)
        return String(self[startIndex..<endIndex])
    }
    /// String使用下标截取字符串
    /// string[index..<index] 例如："abcdefg"[3..<4] // d
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    /// String使用下标截取字符串
    /// string[index,length] 例如："abcdefg"[3,2] // de
    subscript (index:Int , length:Int) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(startIndex, offsetBy: length)
            return String(self[startIndex..<endIndex])
        }
    }
    // 截取 从头到i位置
    func substring(to:Int) -> String{
        return self[0..<to]
    }
    // 截取 从i到尾部
    func substring(from:Int) -> String{
        return self[from..<self.count]
    }
    // 查找子字符串
    func findString(_ sub: String)-> Int {
        var pos = -1
        if let range = range(of: sub, options: .literal) {
            if !range.isEmpty {
                pos = self.distance(from: startIndex, to: range.lowerBound)
            }
        }
        return pos
    }
    
}



