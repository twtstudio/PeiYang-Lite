//
//  SchTagManager.swift
//  WePeiYang
//
//  Created by 于隆祎 on 2020/9/20.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import Foundation

// MARK: - SchTagModel
class SchTagModel: Codable, Equatable {
    var id: Int?
    var name: String?
    var description, tagDescription: String?
    var isSelected: Bool?
    var children: [SchTagModel]?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case description = "description"
        case tagDescription = "tag_description"
        case children, isSelected
    }
    
    init(id: Int?, name: String?, description: String?, tagDescription: String?, isSelected: Bool?, children: [SchTagModel]?) {
        self.id = id
        self.name = name
        self.description = description
        self.tagDescription = tagDescription
        self.isSelected = isSelected
        self.children = children
    }
    
    static func ==(lhs: SchTagModel, rhs: SchTagModel) -> Bool {
        return lhs.id == rhs.id
    }
}

struct SchTagManager {
    static func tagGet(completion: @escaping (Result<[SchTagModel], Network.Failure>) -> Void) {
        SchManager.request("/user/tag/get/all") { (result) in
            switch result {
            case .success(let (data, _)):
                do {
                    let tagsGet = try JSONDecoder().decode(SchResponseModel<[SchTagModel]>.self, from: data)
                    if var tags = tagsGet.data {
                        if !tags.isEmpty && tags[0].name == "天津大学" {
                            tags = tags[0].children ?? []
                            for i in tags.indices {
                                tags[i].isSelected = false
                            }
                            completion(.success(tags))
                        }
                    }
                    
                } catch {
                    completion(.failure(error as! Network.Failure))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}
