//
//  SchAnswerManager.swift
//  PeiYang-Lite
//
//  Created by Zrzz on 2021/4/5.
//

import Foundation

struct SchAnswerManager {
    static func answerGet(id: Int, completion: @escaping (Result<[SchCommentModel], Error>) -> Void) {
        SchManager.request("/user/question/get/answer?question_id=\(id)") { (result) in
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
    
    static func commentAnswer(answerId: Int, score: Int, commit: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let paras = ["answer_id": answerId, "score": score, "commit": commit] as [String: Any]
        SchManager.request("/user/answer/commit",
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
                        completion(.failure(error))
                    }
                case .failure(let err):
                    completion(.failure(err))
            }
        }
    }
    
    static func likeOrDislikeAnswer(answerId: Int, like: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        let paras = ["id": answerId]
        SchManager.request(like ? "/user/answer/like" : "/user/answer/dislike",
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
