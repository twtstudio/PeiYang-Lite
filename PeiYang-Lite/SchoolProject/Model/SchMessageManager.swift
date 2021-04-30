//
//  SchMessageManager.swift
//  PeiYang-Lite
//
//  Created by Zrzz on 2021/4/5.
//

import Foundation

struct SchMessageManager {
    static let SCH_MESSAGE_CONFIG_KEY = "SCH_MESSAGE_CONFIG_KEY"
    
    static func getUnreadCount(completion: @escaping (Result<(Int, [Int]), Error>) -> Void) {
        struct R: Codable {
            var total: Int
            var list: [Int]
        }
        
        SchManager.request("/user/message/number") { (result) in
            switch result {
            case .success(let (data, _)):
                do {
                    let res = try JSONDecoder().decode(SchResponseModel<R>.self, from: data)
                    completion(.success((res.data?.total ?? 0, res.data?.list ?? [])))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    static func getUnreadMessage(limits: Int = 0, type: Int = -1, completion: @escaping (Result<[SchMessageModel], Error>) -> Void) {
        SchManager.request("/user/message/get?limits=\(limits)&type=\(type)") { (result) in
            switch result {
            case .success(let (data, _)):
                do {
                    let res = try JSONDecoder().decode(SchResponseModel<SchMessageData>.self, from: data)
                    completion(.success(res.data?.data ?? []))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    static func getUnreadQuestion(completion: @escaping (Result<SchUnreadQuesitonData, Error>) -> Void) {
        SchManager.request("/user/message/qid") { (result) in
            switch result {
            case .success(let (data, _)):
                do {
                    let res = try JSONDecoder().decode(SchResponseModel<SchUnreadQuesitonData>.self, from: data)
                    completion(.success(res.data ?? SchUnreadQuesitonData()))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    static func setMessageRead(messageId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        SchManager.request("/user/message/read",
                                  method: .post,
                                  body: [
                                    "message_id": messageId
                                  ]) { (result) in
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
    
    static func setQuestionRead(questionId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        SchManager.request("/user/message/question",
                                  method: .post,
                                  body: [
                                    "question_id": questionId
                                  ]) { (result) in
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

// MARK: - SchMessageData
struct SchMessageData: Codable {
    var currentPage: Int?
    var data: [SchMessageModel]?
    var firstPageURL: String?
    var from, lastPage: Int?
    var lastPageURL: String?
    var nextPageURL: String?
    var path: String?
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

// MARK: - SchMessageModel
struct SchMessageModel: Codable {
    var id, type, visible: Int?
    var createdAt, updatedAt: String?
    var contain: SchMessageContain?
    var question: SchQuestionModel?

    enum CodingKeys: String, CodingKey {
        case id, type, visible
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case contain, question
    }
}

// MARK: - SchMessageContain
struct SchMessageContain: Codable {
    var id: Int?
    var contain: String?
    var userID, adminID, likes: Int?
    var createdAt, updatedAt, username: String?
    var adminName: String?
    var isLiked: Bool?
    var score: Int?
    var commit: String?
    
    enum CodingKeys: String, CodingKey {
        case id, contain
        case userID = "user_id"
        case adminID = "admin_id"
        case likes
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case username
        case adminName = "admin_name"
        case isLiked = "is_liked"
        case score, commit
    }
}

// MARK: - SchUnreadQuesitonData
struct SchUnreadQuesitonData: Codable {
    var messageCount: [Int]?
    var questionList: [SchUnreadQuestionList]?

    enum CodingKeys: String, CodingKey {
        case messageCount = "message_count"
        case questionList = "question_list"
    }
}

// MARK: - SchUnreadQuestionList
struct SchUnreadQuestionList: Codable {
    var questionID: Int?
    var isOwner, isFavorite: Bool?

    enum CodingKeys: String, CodingKey {
        case questionID = "question_id"
        case isOwner = "is_owner"
        case isFavorite = "is_favorite"
    }
}

