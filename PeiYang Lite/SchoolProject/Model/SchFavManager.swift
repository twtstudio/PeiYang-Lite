//
//  SchFavManager.swift
//  PeiYang Lite
//
//  Created by Zrzz on 2021/3/13.
//

import Foundation

struct SchFavManager {
    static func favGet(completion: @escaping (Result<[SchQuestionModel], Network.Failure>) -> Void) {
        SchManager.request("/user/favorite/get/all") { (result) in
            switch result {
                case .success(let (data, _)):
                    do {
                        let res = try JSONDecoder().decode(SchResponseModel<[SchQuestionModel]>.self, from: data)
                        completion(.success(res.data ?? []))
                    } catch {
                        completion(.failure(error as! Network.Failure))
                    }
                case .failure(let err):
                    completion(.failure(err))
            }
        }
    }
    
    static func favOrUnfavQuestion(questionId: Int, fav: Bool, completion: @escaping (Result<Bool, Network.Failure>) -> Void) {
        let paras = ["question_id": questionId]
        SchManager.request(fav ? "/user/question/favorite" : "/user/question/unfavorite",
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
}


