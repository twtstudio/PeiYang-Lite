//
//  SchUserManager.swift
//  PeiYang-Lite
//
//  Created by Zrzz on 2021/4/5.
//
import Foundation

// MARK: - SchUserModel
struct SchUserModel: Codable {
    var id: Int?
    var name, studentID: String?
    var myQuestionNum, mySolvedQuestionNum, myLikedQuestionNum, myCommitNum: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case studentID = "student_id"
        case myQuestionNum = "my_question_num"
        case mySolvedQuestionNum = "my_solved_question_num"
        case myLikedQuestionNum = "my_liked_question_num"
        case myCommitNum = "my_commit_num"
    }
}

struct SchUserManager {
    static func getDetail(completion: @escaping (Result<SchUserModel, Error>) -> Void) {
        SchManager.request("/user/userData") { (result) in
            switch result {
            case .success(let (data, _)):
                do {        
                    let user = try JSONDecoder().decode(SchResponseModel<SchUserModel>.self, from: data)
                    completion(.success(user.data ?? SchUserModel()))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    static func login(completion: @escaping (Result<Bool, Error>) -> Void) {
        SchManager.request("/user/login",
                                  method: .post,
                                  body: [
                                    "username": SharedMessage.username,
                                    "password": SharedMessage.password
                                  ]) { (result) in
            switch result {
            case .success(let (data, _)):
                do {
                    let res = try JSONDecoder().decode(SchResponseModel<[String: String]>.self, from: data)
                    if let dict = res.data {
                        if dict.keys.contains("token") {
                            let token = dict["token"]
                            Storage.defaults.set(token, forKey: SchManager.tokenKey)
                            completion(.success(true))
                        }
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
