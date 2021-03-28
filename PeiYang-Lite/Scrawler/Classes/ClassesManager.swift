//
//  ClassesSSOManager.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/5/20.
//
import Foundation

struct ClassesManager {
    static let isLoginKey = "classesIsLogin"
    static let isGPAStoreKey = "gpaIsStore"
    static let isCourseStoreKey = "courseIsStore"
    
    
    static let usernameKey = "classesUsername"
    static let passwordKey = "classesPassword"
    
    static var isLogin: Bool { Storage.defaults.bool(forKey: isLoginKey) }
    static var isGPAStore: Bool { Storage.defaults.bool(forKey: isGPAStoreKey) }
    static var isCourseStore: Bool { Storage.defaults.bool(forKey: isCourseStoreKey)}
    
    static var username: String { Storage.defaults.string(forKey: usernameKey) ?? "" }
    static var password: String { Storage.defaults.string(forKey: passwordKey) ?? "" }
    
    // 0为本科生 1为研究生
    private static var type: Int = 0
    
    static func remove(_ key: String) { Storage.defaults.removeObject(forKey: key) }
    
    static func removeAll() {
        remove(isLoginKey)
        remove(isGPAStoreKey)
        remove(isCourseStoreKey)
        remove(usernameKey)
        remove(passwordKey)
        Storage.courseTable.remove()
        Storage.gpa.remove()
    }
    
    // MARK: - SSO
    static func ssoGet(completion: @escaping (Result<String, Network.Failure>) -> Void) {
        Network.fetch("https://sso.tju.edu.cn/cas/login") { result in
            switch result {
            case .success(let (data, _)):
                guard let html = String(data: data, encoding: .utf8) else {
                    completion(.failure(.urlError))
                    return
                }
                
                let execution = html.find("name=\"execution\" value=\"([^\"]+)\"")
                completion(.success(execution))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func ssoPost(captcha: String, completion: @escaping (Result<String, Network.Failure>) -> Void) {
        ssoGet { result in
            switch result {
            case .success(let execution):
                if execution.isEmpty {
                    completion(.success("登录成功"))
                } else {
                    Network.fetch(
                        "https://sso.tju.edu.cn/cas/login",
                        method: .post,
                        body: [
                            "username": username,
                            "password": password,
                            "captcha": captcha,
                            "execution": execution,
                            "_eventId": "submit"
                        ]
                    ) { result in
                        switch result {
                        case .success(let (data, response)):
                            guard let html = String(data: data, encoding: .utf8) else {
                                completion(.failure(.requestFailed))
                                return
                            }
                            
                            switch response.statusCode {
                            case 200:
                                let message = html.find("<h2>([^<>]+)</h2>")
                                completion(.success(message))
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
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Service
    static func fetch(
        _ method: Network.Method = .get,
        urlString: String,
        query: [String: String] = [:],
        body: [String: String] = [:],
        async: Bool = true,
        completion: @escaping (Result<String, Network.Failure>) -> Void
    ) {
        Network.fetch(urlString, query: query, method: method, body: body, async: async) { result in
            switch result {
            case .success(let (data, response)):
                guard let html = String(data: data, encoding: .utf8) else {
                    completion(.failure(.requestFailed))
                    return
                }
                
                if response.statusCode == 200, let url = response.url?.absoluteString {
                    if url.contains("https://sso.tju.edu.cn/cas/login") {
                        completion(.failure(.loginFailed))
                    } else {
                        completion(.success(html))
                    }
                } else {
                    completion(.failure(.unknownError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func batch(
        _ method: Network.Method = .get,
        urlString: String,
        query: [String: String] = [:],
        body: [String: String] = [:],
        completion: @escaping (Result<String, Network.Failure>) -> Void
    ) {
        fetch(method, urlString: urlString, query: query, body: body, async: false, completion: completion)
    }
    
    // MARK: - Check
    static func checkLogin(completion: @escaping (Result<String, Network.Failure>) -> Void) {
        fetch(urlString: "http://classes.tju.edu.cn/eams/homeExt.action", completion: completion)
    }
    
    // MARK: - Semester
    static func semesterPost(completion: @escaping (Result<[Semester], Network.Failure>) -> Void) {
        fetch(.post, urlString: "http://classes.tju.edu.cn/eams/dataQuery.action") { result in
            switch result {
            case .success:
                fetch(
                    .post,
                    urlString: "http://classes.tju.edu.cn/eams/dataQuery.action",
                    body: ["dataType": "semesterCalendar"]
                ) { result in
                    switch result {
                    case .success(let html):
                        let allSemesters = html
                            .findArrays("id:([0-9]+),schoolYear:\"([0-9]+)-([0-9]+)\",name:\"(1|2)\"")
                            .map { Semester(semester: $0) }
                        
                        var indexPair = [Int]()
                        for (i, semester) in allSemesters.enumerated() {
                            if semester == Semester.origin || semester == Semester.current {
                                indexPair.append(i)
                            }
                        }
                        
                        //                        let validSemesters = allSemesters[indexPair[0]...indexPair[1]]
                        let validSemesters = allSemesters[(indexPair.first ?? 0)...(indexPair.last ?? 0)]
                        
                        completion(.success(Array(validSemesters)))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - GPA
extension ClassesManager {
    static func getGPA(completion: @escaping ((Result<GPA, Error>) -> Void)) {
        
    }
    
    static func gpaGet(completion: @escaping (Result<GPA, Network.Failure>) -> Void) {
        semesterPost { result in
            switch result {
            case .success(let semesterArray):
                DispatchQueue.global().async { // `sleep` causes freezing UI if using the main thread
                    let semaphore = DispatchSemaphore(value: 0)
                    
                    var semesterGPAArray = [SemesterGPA]()
                    for semester in semesterArray {
                        batch(
                            urlString: "http://classes.tju.edu.cn/eams/teach/grade/course/person!search.action",
                            query: ["semesterId": semester.id]
                        ) { result in
                            switch result {
                            case .success(let html):
                                let gpaArray = html
                                    .replacingOccurrences(of: "\r", with: "") // only worked after `\r` removed, insane!
                                    .findArray("<tr .+?\">(.+?)</tr>")
                                    .map { singleGPAHTML -> SingleGPA in
                                        let singleGPA = singleGPAHTML.findArray("<td[^>]*>\\s*([^<\\t\\n]*)")
                                        switch singleGPA.count {
                                        case 9:
//                                            return SingleGPA(fullGPA: singleGPA)
                                            return singleGPA[1].contains("S") ? SingleGPA(pgGPA2: singleGPA) : SingleGPA(fullGPA: singleGPA)
                                        case 11:
                                            return SingleGPA(pgGPA: singleGPA)
                                        case 6:
                                            return SingleGPA(partialGPA: singleGPA)
                                        default:
                                            return SingleGPA()
                                        }
                                    }
                                
                                let semesterGPA = SemesterGPA(semester: semester, gpaArray: gpaArray)
                                semesterGPAArray.append(semesterGPA)
                                semaphore.signal()
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                        sleep(1)
                        semaphore.wait()
                    }
                    
                    let gpa = GPA(semesterGPAArray: semesterGPAArray)
                    DispatchQueue.main.async { // crazy, huh?
                        completion(.success(gpa))
                        // Storage save
                        Storage.defaults.setValue(true, forKey: isGPAStoreKey)
                        Storage.gpa.object = gpa
                        Storage.gpa.save()
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - CourseTable
extension ClassesManager {
    private enum ClassTableType {
        case major, minor
    }
    
    private static func dataQuery(completion: @escaping (Result<(String, Bool), Error>) -> Void) {
        var semesterId = ""
        var hasMinor = false
        
        let queue = DispatchQueue(label: "ClassTableDataQuery")
        let semaphore = DispatchSemaphore(value: 0)
        
        // 查看是否有效
        
        queue.async {
            fetch(.post, urlString: "http://classes.tju.edu.cn/eams/dataQuery.action") { result in
                switch result {
                case .success:
                    semaphore.signal()
                case .failure(let error):
                    semaphore.signal()
                    completion(.failure(error))
                }
            }
        }
        
        // 查看学期
        queue.async {
            semaphore.wait()
            fetch(
                .post,
                urlString: "http://classes.tju.edu.cn/eams/dataQuery.action",
                body: ["dataType": "semesterCalendar"]
            ) { result in
                switch result {
                case .success(let html):
                    let allSemesters = html
                        .findArrays("id:([0-9]+),schoolYear:\"([0-9]+)-([0-9]+)\",name:\"(1|2)\"")
                        .map { Semester(semester: $0) }
                    
                    var indexPair = [Int]()
                    for (i, semester) in allSemesters.enumerated() {
                        if semester == Semester.origin || semester == Semester.current {
                            indexPair.append(i)
                        }
                    }
                    let validSemesters = allSemesters[(indexPair.first ?? 0)...(indexPair.last ?? 0)]
                    
                    semesterId = (Array(validSemesters).last ?? Semester()).id
                    semaphore.signal()
                case .failure(let error):
                    semaphore.signal()
                    completion(.failure(error))
                }
            }
        }
        
        // 查看是否有辅修
        queue.async {
            semaphore.wait()
            fetch(
                .post,
                urlString: "http://classes.tju.edu.cn/eams/dataQuery.action",
                body: ["entityId": ""]
            ) { result in
                switch result {
                case .success(let html):
                    hasMinor = html.contains("辅修")
                    semaphore.signal()
                case .failure(let error):
                    semaphore.signal()
                    completion(.failure(error))
                }
            }
        }

        queue.async {
            semaphore.wait()
            DispatchQueue.main.async {
                log("加载完毕")
                completion(.success((semesterId, hasMinor)))
            }
        }
    }
    
    static func getCourseTable(completion: @escaping (Result<CourseTable, Error>) -> Void) {
        let queue = DispatchQueue(label: "ClassTableGET")
        let semaphore = DispatchSemaphore(value: 0)
        
        var _semesterId = ""
        var _hasMinor = false
        
        queue.async {
            fetch(urlString: "http://classes.tju.edu.cn/eams/stdDetail.action") { (result) in
                switch result {
                    case .success(let s):
                        if s.contains("本科") {
                            type = 0
                        }
                        if s.contains("研究") {
                            type = 1
                        }
                        semaphore.signal()
                    case .failure(let err):
                        completion(.failure(err))
                        return
                }
            }
        }
        
        queue.async {
            semaphore.wait()
            dataQuery { (result) in
                switch result {
                case .success(let (semesterId, hasMinor)):
                    _semesterId = semesterId
                    _hasMinor = hasMinor
                    semaphore.signal()
                case .failure(let err):
                    log("ClasstableDataManager get classTable FAILED!")
                    completion(.failure(err))
                    return
                }
            }
        }
        
        queue.async {
            semaphore.wait()
            // 主修课表
            getDetailTable(type: .major, semesterId: _semesterId, completion: { (result) in
                switch result {
                case .success(let model):
                    var newModel = model
                    // 辅修课表
                    if _hasMinor {
                        // 防止过快点击
                        sleep(UInt32(1))
                        getDetailTable(type: .minor, semesterId: _semesterId) { (result) in
                            switch result {
                            case .success(let minorModel):
                                newModel.courseArray += minorModel.courseArray
                                log("获取辅修课表成功")
                                completion(.success(newModel))
                                return
                            case .failure(let err):
                                log("辅修课表获取失败", err)
                                completion(.success(newModel))
                                return
                            }
                        }
                    } else {
                        completion(.success(newModel))
                        return
                    }
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
            })
        }
    }
    
    /// 获取详细课表
    /// - Parameter completion: 回调函数 Result<ClassTableModel, WPYNetwork.Failure>
    private static func getDetailTable(type: ClassTableType, semesterId: String, completion: @escaping (Result<CourseTable, Error>) -> Void) {
        var ids = ""
        var html = ""
        let projectId = type == .major ? 1 : 2
        
        let queue = DispatchQueue(label: "ClassTableGet")
        let semaphore = DispatchSemaphore(value: 0)
        
        if self.type == 0 {
            // 切换projectId
            queue.async {
                fetch(urlString: "http://classes.tju.edu.cn/eams/courseTableForStd!index.action?projectId=\(projectId)") { result in
                    switch result {
                    case .success(_):
                        semaphore.signal()
                    case .failure(let error):
                        completion(.failure(error))
                        return
                    }
                }
            }

            // 获取ids
            queue.async {
                semaphore.wait()
                fetch(urlString: "http://classes.tju.edu.cn/eams/courseTableForStd!innerIndex.action?projectId=\(projectId)") { result in
                    switch result {
                    case .success(let html):
                        ids = html.find("\"ids\",\"([^\"]+)\"")
                        semaphore.signal()
                    case .failure(let error):
                        completion(.failure(error))
                        return
                    }
                }
            }
        } else {
            fetch(urlString: "http://classes.tju.edu.cn/eams/courseTableForStd!innerIndex.action") { result in
                switch result {
                case .success(let html):
                    ids = html.find("\"ids\",\"([^\"]+)\"")
                    semaphore.signal()
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
            }
        }
        // 获取课表
        queue.async {
            semaphore.wait()
            fetch(
                .post,
                urlString: "http://classes.tju.edu.cn/eams/courseTableForStd!courseTable.action",
                body: [
                    "ignoreHead": "1",
                    "setting.kind": "std",
                    "semester.id": semesterId,
                    "ids": ids
                ]
            ) { result in
                switch result {
                case .success(let h):
                    html = h
                    semaphore.signal()
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
            }
        }
        
        // 解析并返回
        queue.async {
            semaphore.wait()
            DispatchQueue.main.async {
                completion(.success(parseClassTableHtml(html: html)))
            }
        }
    }
    
    private static func parseClassTableHtml(html: String) -> CourseTable {
        let arrangeHTML = html.find("in TaskActivity(.+)fillTable")
        var arrangePairArray = [(String, Arrange)]()
        for arrangeItem in arrangeHTML.components(separatedBy: "var teachers")[1...] {
            let rawTeachers = arrangeItem.find("var actTeachers = ([^;]+);")
            let teacherArray = rawTeachers.findArray("\"([^\"]+)\"")
            
            let threePair = arrangeItem.findArrays("\"([^\"]+)\",\"[^\"]*\",\"([^\"]*)\",\"([01]+)\"")[0]
            let name = threePair[1]
            let location = threePair[2]
            let rawWeeks = threePair[3]
            var weekArray = [Int]()
            for (i, b) in rawWeeks.enumerated() {
                if b == "1" {
                    weekArray.append(i)
                }
            }
            
            let twoPair = arrangeItem.findArrays("([0-9]+)\\*unitCount\\+([0-9]+)")
            let weekday = Int(twoPair[0][1]) ?? 0
            let unitArray = twoPair.map { Int($0[2]) ?? 0 }
            
            arrangePairArray.append(
                (
                    name,
                    Arrange(
                        teacherArray: teacherArray,
                        weekArray: weekArray,
                        weekday: weekday,
                        unitArray: unitArray,
                        location: location
                    )
                )
            )
        }
        
        let courseHTML = html.find("<tbody(.+)</tbody>")
        let courseArray = courseHTML.components(separatedBy: "<tr>")[1...]
            .map { courseItem -> Course in
                guard !courseItem.findArrays("(<td>.*?</td>)").isEmpty else { return Course()}
                return Course(
                    fullCourse: courseItem
                        .findArrays("(<td>.*?</td>)")
                        .map { $0[1].find("([^>\\s]+)\\s*<") },
                    arrangePairArray: arrangePairArray
                )
            }
        ColorHelper.shared = ColorHelper(courseArray)
        
        Storage.defaults.setValue(true, forKey: isCourseStoreKey)
        Storage.courseTable.object = CourseTable(courseArray: courseArray)
        Storage.courseTable.save()
        return CourseTable(courseArray: courseArray)
    }
}
