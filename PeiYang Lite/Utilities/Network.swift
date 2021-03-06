//
//  Network.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/5/20.
//

import SwiftUI

struct Network {
    enum Failure: Error {
        case urlError, requestFailed, loginFailed, unknownError
        private static let pair: [Failure: Localizable] = [
            .urlError: .urlError,
            .requestFailed: .requestFailed,
            .loginFailed: .loginFailed,
            .unknownError: .unknownError,
        ]
        
        var localizedStringKey: LocalizedStringKey {
            Failure.pair[self]?.rawValue ?? ""
        }
        
    }
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }
    
    static func uploadFile(
        _ urlString: String,
        fileURL: URL,
        query: [String: String] = [:],
        headers: [String: String] = [:],
        method: Method = .post,
        body: [String: String] = [:],
        async: Bool = true,
        completion: @escaping (Result<(Data, HTTPURLResponse), Failure>) -> Void
    ) {
        // URL
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        // Query
        var requestURL: URL
        if query.isEmpty {
            requestURL = url
        } else {
            var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            comps.queryItems = comps.queryItems ?? []
            comps.queryItems!.append(contentsOf: query.map { URLQueryItem(name: $0.0, value: $0.1) })
            requestURL = comps.url!
        }
        
        // Headers
        var request = URLRequest(url: requestURL)
        /// TODO: Check if cookies been stored in `Storage.defaults`, if true then add to headers
        if !headers.isEmpty {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Method
        request.httpMethod = method.rawValue
        
        // Body
        request.httpBody = body.percentEncoded()
        
        // Request
        URLSession.shared.uploadTask(with: request, fromFile: fileURL){ data, response, error in
            func process() {
                guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                    print(error?.localizedDescription ?? "Unknown Error")
                    completion(.failure(.requestFailed))
                    return
                }
                completion(.success((data, response)))
                
                // Save Cookies
                guard let url = response.url, let headers = response.allHeaderFields as? [String: String] else {
                    completion(.failure(.requestFailed))
                    return
                }
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: url)
                HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)
                for cookie in cookies {
                    var cookieProperties = [HTTPCookiePropertyKey: Any]()
                    cookieProperties[.name] = cookie.name
                    cookieProperties[.value] = cookie.value
                    cookieProperties[.domain] = cookie.domain
                    cookieProperties[.path] = cookie.path
                    cookieProperties[.version] = cookie.version
                    cookieProperties[.expires] = Date().addingTimeInterval(31536000)
                    
                    if let newCookie = HTTPCookie(properties: cookieProperties) {
                        HTTPCookieStorage.shared.setCookie(newCookie)
                    }
                }
            }
            
            if async {
                DispatchQueue.main.async {
                    process()
                }
            } else {
                process()
            }
        }.resume()
    }
    
    static func fetch(
        _ urlString: String,
        query: [String: String] = [:],
        headers: [String: String] = [:],
        method: Method = .get,
        body: [String: Any] = [:],
        async: Bool = true,
        completion: @escaping (Result<(Data, HTTPURLResponse), Failure>) -> Void
    ) {
        // URL
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        // Query
        var requestURL: URL
        if query.isEmpty {
            requestURL = url
        } else {
            var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            comps.queryItems = comps.queryItems ?? []
            comps.queryItems!.append(contentsOf: query.map { URLQueryItem(name: $0.0, value: $0.1) })
            requestURL = comps.url!
        }
        
        // Headers
        var request = URLRequest(url: requestURL)
        /// TODO: Check if cookies been stored in `Storage.defaults`, if true then add to headers
        if !headers.isEmpty {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Method
        request.httpMethod = method.rawValue
        
        // Body
        request.httpBody = body.percentEncoded()
        
        // Request
        URLSession.shared.dataTask(with: request) { data, response, error in
            func process() {
                guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                    print(error?.localizedDescription ?? "Unknown Error")
                    completion(.failure(.requestFailed))
                    return
                }
                completion(.success((data, response)))
                
                // Save Cookies
                guard let url = response.url, let headers = response.allHeaderFields as? [String: String] else {
                    completion(.failure(.requestFailed))
                    return
                }
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: url)
                HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)
                for cookie in cookies {
                    var cookieProperties = [HTTPCookiePropertyKey: Any]()
                    cookieProperties[.name] = cookie.name
                    cookieProperties[.value] = cookie.value
                    cookieProperties[.domain] = cookie.domain
                    cookieProperties[.path] = cookie.path
                    cookieProperties[.version] = cookie.version
                    cookieProperties[.expires] = Date().addingTimeInterval(31536000)
                    
                    if let newCookie = HTTPCookie(properties: cookieProperties) {
                        HTTPCookieStorage.shared.setCookie(newCookie)
                    }
                }
                
                
                
                /// TODO: Add cookies to `Storage.defaults`
            }
            
            if async {
                DispatchQueue.main.async {
                    process()
                }
            } else {
                process()
            }
        }.resume()    }
    
    static func batch(
        _ urlString: String,
        query: [String: String] = [:],
        headers: [String: String] = [:],
        method: Method = .get,
        body: [String: String] = [:],
        completion: @escaping (Result<(Data, HTTPURLResponse), Failure>) -> Void
    ) {
        fetch(urlString, query: query, headers: headers, method: method, body: body, async: false, completion: completion)
    }
    
    static func requestWithFormData(urlString: String, parameters: [String: Any], dataPath: [String: Data], completion: @escaping (Result<(Data, HTTPURLResponse), Failure>) -> Void){
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = Method.post.rawValue
        let boundary = "Boundary+\(arc4random())\(arc4random())"
        var body = Data()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
        for (key, value) in dataPath {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(arc4random())\"\r\n") //此處放入file name，以隨機數代替，可自行放入
            body.appendString(string: "Content-Type: image/png\r\n\r\n") //image/png 可改為其他檔案類型 ex:jpeg
            body.append(value)
            body.appendString(string: "\r\n")
        }
        
        body.appendString(string: "--\(boundary)--\r\n")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            func process() {
                guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                    print(error?.localizedDescription ?? "Unknown Error")
                    completion(.failure(.requestFailed))
                    return
                }
                completion(.success((data, response)))
                
                // Save Cookies
                guard let url = response.url, let headers = response.allHeaderFields as? [String: String] else {
                    completion(.failure(.requestFailed))
                    return
                }
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: url)
                HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)
                for cookie in cookies {
                    var cookieProperties = [HTTPCookiePropertyKey: Any]()
                    cookieProperties[.name] = cookie.name
                    cookieProperties[.value] = cookie.value
                    cookieProperties[.domain] = cookie.domain
                    cookieProperties[.path] = cookie.path
                    cookieProperties[.version] = cookie.version
                    cookieProperties[.expires] = Date().addingTimeInterval(31536000)
                    
                    if let newCookie = HTTPCookie(properties: cookieProperties) {
                        HTTPCookieStorage.shared.setCookie(newCookie)
                    }
                }
            }
            
            DispatchQueue.main.async {
                process()
            }
        }.resume()
    }
    
    static func uploadImage(
        _ urlString: String,
        imageData: Data,
        query: [String: String] = [:],
        headers: [String: String] = [:],
        method: Method = .post,
        body: [String: Any] = [:],
        async: Bool = true,
        completion: @escaping (Result<(Data, HTTPURLResponse), Failure>) -> Void
    ) {
        // URL
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        // Query
        var requestURL: URL
        if query.isEmpty {
            requestURL = url
        } else {
            var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            comps.queryItems = comps.queryItems ?? []
            comps.queryItems!.append(contentsOf: query.map { URLQueryItem(name: $0.0, value: $0.1) })
            requestURL = comps.url!
        }
        
        // Headers
        var request = URLRequest(url: requestURL)
        /// TODO: Check if cookies been stored in `Storage.defaults`, if true then add to headers
        if !headers.isEmpty {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Method
        request.httpMethod = method.rawValue
        
        // Body
        request.httpBody = body.percentEncoded()
        
        // Request
        URLSession.shared.uploadTask(with: request, from: photoDataToFormData(data: imageData, boundary: UUID().uuidString, fileName: "1.jpg")) { data, response, error in
            func process() {
                guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                    print(error?.localizedDescription ?? "Unknown Error")
                    completion(.failure(.requestFailed))
                    return
                }
                completion(.success((data, response)))
                
                // Save Cookies
                guard let url = response.url, let headers = response.allHeaderFields as? [String: String] else {
                    completion(.failure(.requestFailed))
                    return
                }
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: url)
                HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)
                for cookie in cookies {
                    var cookieProperties = [HTTPCookiePropertyKey: Any]()
                    cookieProperties[.name] = cookie.name
                    cookieProperties[.value] = cookie.value
                    cookieProperties[.domain] = cookie.domain
                    cookieProperties[.path] = cookie.path
                    cookieProperties[.version] = cookie.version
                    cookieProperties[.expires] = Date().addingTimeInterval(31536000)
                    
                    if let newCookie = HTTPCookie(properties: cookieProperties) {
                        HTTPCookieStorage.shared.setCookie(newCookie)
                    }
                }
            }
            
            if async {
                DispatchQueue.main.async {
                    process()
                }
            } else {
                process()
            }
        }.resume()
    }
    
    static func photoDataToFormData(data: Data, boundary:String,fileName:String) -> Data {
        let fullData = NSMutableData()
        // 1 - Boundary should start with --
        let lineOne = "--" + boundary + "\r\n"

        fullData.append(lineOne.data(using: .utf8) ?? Data())

        // 2
        let lineTwo = "Content-Disposition: form-data; name=\"image\"; filename=\"" + fileName + "\"\r\n"
        fullData.append(lineTwo.data(using: .utf8) ?? Data())

        // 3
        let lineThree = "Content-Type: image/jpg\r\n\r\n"
        fullData.append(lineThree.data(using: .utf8) ?? Data())

        // 4
        fullData.append(data)

        // 5
        let lineFive = "\r\n"
        fullData.append(lineFive.data(using: .utf8) ?? Data())

        // 6 - The end. Notice -- at the start and at the end
        let lineSix = "--" + boundary + "--\r\n"
        fullData.append(lineSix.data(using: .utf8) ?? Data())

        return fullData as Data
    }
}

extension Data{
    
    mutating func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}
