//
//  SchTagsManager.swift
//  WePeiYang
//
//  Created by 于隆祎 on 2020/9/20.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import Foundation

// MARK: - SchTagModel
struct SchTagModel: Codable {
    var id: Int?
    var name: String?
    var description: String?
    var children: [SchTagModel]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, children
        case description = "description"
    }
}

struct SchTagsManager {
    static func tagGet(completion: @escaping (Result<[SchTagModel], Network.Failure>) -> Void) {
        SchNetworkManager.request("/user/tag/get/all") { (result) in
            switch result {
            case .success(let (data, _)):
                do {
                    let tagsGet = try JSONDecoder().decode(SchResponseModel<[SchTagModel]>.self, from: data)
                    if let tags = tagsGet.data {
                        if !tags.isEmpty && tags[0].name == "天津大学" {
                            completion(.success(tags[0].children ?? []))
                        }
                    }
                    
                } catch {
                    completion(.failure(error as! Network.Failure))
                }
            case .failure(let err):
                print("获取标签失败", err)
            }
        }
    }
}
