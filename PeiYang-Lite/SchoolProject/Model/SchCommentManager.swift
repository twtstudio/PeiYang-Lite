//
//  SchCommentManager.swift
//  WePeiYang
//
//  Created by 于隆祎 on 2020/9/20.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import Foundation

// MARK: - SchCommentModel
// 这个是问题回复和评论的杂合体
struct SchCommentModel: Codable {
    var id: Int?
    var contain: String?
    var adminID: Int?
    var score: Int?
    var commit: String?
    var userID, likes: Int?
    var createdAt, updatedAt, username: String?
    var isLiked: Bool?
    var adminName: String?
    
    enum CodingKeys: String, CodingKey {
        case id, contain
        case userID = "user_id"
        case likes, adminID = "admin_id"
        case score, commit
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case username, adminName = "admin_name"
        case isLiked = "is_liked"
    }
}


struct SchCommentManager {
    static func commentGet(id: Int, completion: @escaping (Result<[SchCommentModel], Error>) -> Void) {
        SchManager.request("/user/question/get/commit?question_id=\(id)") { (result) in
            switch result {
                case .success(let (data, _)):
                    do {
                        let res = try JSONDecoder().decode(SchResponseModel<[SchCommentModel]>.self, from: data)
                        completion(.success(res.data ?? []))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let err):
                    completion(.failure(err))
            }
        }
    }
    
    static func addComment(questionId: Int, contain: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let paras = ["question_id": questionId, "contain": contain] as [String : Any]
        SchManager.request("/user/commit/add/question",
                                  method: .post,
                                  body: paras) { (result) in
            switch result {
                case .success(let (data, _)):
                    do {
                        let res = try JSONDecoder().decode(SchResponseModel<[String: Int]>.self, from: data)
                        if res.errorCode == 0 {
                            completion(.success(true))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let err):
                    completion(.failure(err))
            }
        }
    }
    
    static func likeOrDislikeComment(commentId: Int, like: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        let paras = ["id": commentId]
        SchManager.request(like ? "/user/commit/like" : "/user/commit/dislike",
                                  method: .post,
                                  body: paras) { (result) in
            switch result {
                case .success(let (data, _)):
                    do {
                        let res = try JSONDecoder().decode(SchResponseModel<[String: Int]>.self, from: data)
                        if res.errorCode == 0 {
                            completion(.success(true))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let err):
                    completion(.failure(err))
            }
        }
    }
}

