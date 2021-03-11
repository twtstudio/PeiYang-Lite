//
//  QusetionManager.swift
//  WePeiYang
//
//  Created by 于隆祎 on 2020/9/20.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import Foundation
import UIKit

// MARK: - SchQuestionData
struct SchQuestionData: Codable {
    var currentPage: Int?
    var data: [SchQuestionModel]?
    var firstPageURL: String?
    var from, lastPage: Int?
    var lastPageURL, nextPageURL, path: String?
    var perPage: Int?
    var prevPageURL: String?
    var to, total: Int?
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - SchQuestionModel
struct SchQuestionModel: Codable, Identifiable {
    var id: Int?
    var name, content: String?
    var userID, solved, noCommit, likes: Int?
    var createdAt, updatedAt, username: String?
    var msgCount: Int?
    var urlList: [String]?
    var thumbImg: String?
    var tags: [SchTagModel]?
    var thumbUrlList: [String]?
    var isLiked: Bool?
    var isOwner: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case userID = "user_id"
        case solved
        case noCommit = "no_commit"
        case likes, tags
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case username, msgCount
        case urlList = "url_list"
        case thumbImg, isLiked = "is_liked"
        case thumbUrlList = "thumb_url_list"
        case isOwner = "is_owner"
        case content = "description"
    }
}

struct SchQuestionManager {
    static func loadQuestions(limits: Int = 10, page: Int = 1, completion: @escaping (Result<([SchQuestionModel], Int), Network.Failure>) -> Void) {
        return searchQuestions(tags: [], string: "", limits: limits, page: page, completion: completion)
    }
    
    static func searchQuestions(tags: [SchTagModel] = [], string: String = "", limits: Int = 10, page: Int = 1, completion: @escaping (Result<([SchQuestionModel], Int), Network.Failure>) -> Void) {
        let tagList = tags.map { tag in tag.id ?? 0 }
        SchManager.request("/user/question/search?tagList=\(tagList)&searchString=\(string)&limits=\(limits)&page=\(page)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { (result) in
            switch result {
            case .success(let (data, _)):
                do {
                    let questionGet = try JSONDecoder().decode(SchResponseModel<SchQuestionData>.self, from: data)
                    completion(.success((questionGet.data?.data ?? [], questionGet.data?.total ?? 0)))
                } catch {
                    completion(.failure(error as! Network.Failure))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    static func postQuestion(title: String, content: String, tagList: [Int], campus: Int = 0, completion: @escaping (Result<Int, Network.Failure>) -> Void) {
        let paras = ["name": title, "description": content, "tagList": tagList.description, "campus": campus] as [String : Any]
        SchManager.request("/user/question/add",
                                  method: .post,
                                  body: paras) { (result) in
            switch result {
                case .success(let (data, _)):
                    do {
                        let res = try JSONDecoder().decode(SchResponseModel<[String: Int]>.self, from: data)
                        if let dict = res.data {
                            if dict.keys.contains("question_id") {
                                completion(.success(dict["question_id"] ?? 0))
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
    
    static func postImg(img: UIImage, question_id: Int, completion: @escaping (Result<String, Network.Failure>) -> Void) {
        let imageData = img.jpegData(compressionQuality: 0.5)!
        let paras =  ["question_id": question_id] as [String: Int]
        
        SchManager.uploadImage("/user/image/add", imageData: ["newImg": imageData], body: paras) { (result) in
            switch result {
            case .success(let (data, _)):
                do {
                    let res = try JSONDecoder().decode(SchResponseModel<[String: String]>.self, from: data)
                    if res.errorCode == 0 {
                        if ((res.data?.keys.contains("url")) != nil) {
                            completion(.success(res.data!["url"]!))
                        } else {
                            completion(.success(""))
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
    
    static func likeOrDislikeQuestion(id: Int, like: Bool, completion: @escaping (Result<Bool, Network.Failure>) -> Void) {
        let paras = ["id": id] as [String : Any]
        SchManager.request(like ? "/user/question/like" : "/user/question/dislike",
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
                        completion(.failure(error as! Network.Failure))
                    }
                case .failure(let err):
                    completion(.failure(err))
            }
        }
    }
    
    enum QuesGetType {
        case liked, my, solved
    }
    
    static func getQuestions(type: QuesGetType, limits: Int = 0, completion: @escaping (Result<[SchQuestionModel], Network.Failure>) -> Void) {
        SchManager.request(type == .liked ? "/user/likes/get/question" : "/user/question/get/myQuestion?limits=\(limits)") { (result) in
            switch result {
                case .success(let (data, _)):
                    do {
                        if type == .liked {
                            let res = try JSONDecoder().decode(SchResponseModel<[SchQuestionModel]>.self, from: data)
                            completion(.success(res.data ?? []))
                        } else {
                            let res = try JSONDecoder().decode(SchResponseModel<SchQuestionData>.self, from: data)
                            completion(.success(res.data?.data ?? []))
                        }
                    } catch {
                        completion(.failure(error as! Network.Failure))
                    }
                case .failure(let err):
                    completion(.failure(err))
            }
        }
    }
    
    static func deleteMyQuestion(questionId: Int, completion: @escaping (Result<Bool, Network.Failure>) -> Void) {
        let paras = ["question_id": questionId]
        SchManager.request("/user/question/delete",
                                  method: .post,
                                  body: paras) { (result) in
            switch result {
                case .success(let (data, _)):
                    do {
                        let res = try JSONDecoder().decode(SchResponseModel<Int>.self, from: data)
                        if res.errorCode == 0 {
                            completion(.success(true))
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
