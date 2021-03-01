//
//  SchCommentManager.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/2/26.
//

import Foundation


struct SchCommentManager {

    static func CommentGet(url: String, tagList: [Int]?, searchString: String,  completion: @escaping (Result<AccountMessage, Network.Failure>) -> Void) {
        Network.fetch(
            url,
//            query: [String : String],
            method: .get
           
        ) {
            result in
            switch result {
            case .success(let(data, response)):
                guard let accountMessage = try? JSONDecoder().decode(AccountMessage.self, from: data) else {
                    completion(.failure(.requestFailed))
                    return
                }
                completion(.success(accountMessage))
                switch response.statusCode {
                case 200:
                    completion(.success(accountMessage))
                case 401:
                    completion(.failure(.loginFailed))
                default:
                    completion(.failure(.unknownError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
   
}
