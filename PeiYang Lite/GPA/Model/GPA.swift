//
//  GPA.swift
//  PeiYang Lite
//
//  Created by TwTStudio on 7/16/20.
//

import Foundation

struct SingleGPA: Codable, Storable, Hashable {
    let semester: String
    let courseCode: String
    let no: String
    let name: String
    let type: String
    let classProperty: String
    let credit: Double
    let score: Double
    let scoreProperty: String
    let gpa: Double
    
    init(semester: String, courseCode: String, no: String, name: String, type: String, classProperty: String, credit: Double, score: Double, scoreProperty: String, gpa: Double) {
        self.semester = semester
        self.courseCode = courseCode
        self.no = no
        self.name = name
        self.type = type
        self.classProperty = classProperty
        self.credit = credit
        self.score = score
        self.scoreProperty = scoreProperty
        self.gpa = gpa
    }
    
    init(pgGPA: [String]) {
        self.semester = pgGPA[0]
        self.no = pgGPA[2]
        self.courseCode = pgGPA[1]
        self.name = pgGPA[3]
        self.type = pgGPA[4]
        self.classProperty = "无分类"
        self.credit = Double(pgGPA[5]) ?? 0
        self.score = Double(pgGPA[9]) ?? 0
        self.scoreProperty = ""
        self.gpa = Double(pgGPA[10]) ?? 0
    }
    
    init(pgGPA2: [String]) {
        self.semester = pgGPA2[0]
        self.no = pgGPA2[2]
        self.courseCode = pgGPA2[1]
        self.name = pgGPA2[3]
        self.type = pgGPA2[4]
        self.classProperty = "无分类"
        self.credit = Double(pgGPA2[5]) ?? 0
        self.score = Double(pgGPA2[7]) ?? 0
        self.scoreProperty = ""
        self.gpa = Double(pgGPA2[8]) ?? 0
    }
    
    init(fullGPA: [String]) {
        self.semester = fullGPA[0]
        self.no = fullGPA[1]
        self.courseCode = ""
        self.name = fullGPA[2]
        self.type = fullGPA[3]
        self.classProperty = fullGPA[4]
        self.credit = Double(fullGPA[5]) ?? 0
        self.score = Double(fullGPA[6]) ?? 0
        self.scoreProperty = fullGPA[7]
        self.gpa = Double(fullGPA[8]) ?? 0
    }
    
    init(partialGPA: [String]) {
        self.semester = partialGPA[0]
        self.no = partialGPA[1]
        self.courseCode = ""
        self.name = partialGPA[2]
        self.type = partialGPA[3]
        self.classProperty = partialGPA[4]
        self.credit = 0
        self.score = 0
        self.scoreProperty = ""
        self.gpa = 0
    }
    
    init() {
        self.semester = ""
        self.no = ""
        self.courseCode = ""
        self.name = ""
        self.type = ""
        self.classProperty = ""
        self.credit = 0
        self.score = 0
        self.scoreProperty = ""
        self.gpa = 0
    }
}

struct SemesterGPA: Codable, Storable {
    let semester: Semester
    let gpaArray: [SingleGPA]
    let credit: Double
    let score: Double
    let gpa: Double
    
//    init(semester: Semester, gpaArray: [SingleGPA], credit: Double, score: Double, gpa: Double) {
//        self.semester = semester
//        self.gpaArray = gpaArray
//        self.credit = credit
//        self.score = score
//        self.gpa = gpa
//    }
    
    init(semester: Semester, gpaArray: [SingleGPA]) {
        self.semester = semester
        self.gpaArray = gpaArray
        
        let creditArray = gpaArray.map(\.credit)
        let scoreArray = gpaArray.map(\.score)
        let gpaArray_ = gpaArray.map(\.gpa)
        
        let allCredit = creditArray.reduce(0, +)
        let weightScoreArray = zip(creditArray, scoreArray).map { $0.0 * $0.1 }
        let weightGPAArray = zip(creditArray, gpaArray_).map { $0.0 * $0.1 }
        
        self.credit = allCredit
        if allCredit == 0 {
            self.score = 0
            self.gpa = 0
        } else {
            self.score = weightScoreArray.reduce(0, +) / allCredit
            self.gpa = weightGPAArray.reduce(0, +) / allCredit
        }
    }
    
    init() {
        self.semester = Semester()
        self.gpaArray = []
        self.credit = 0
        self.score = 0
        self.gpa = 0
    }
}

struct GPA: Codable, Storable {
    let semesterGPAArray: [SemesterGPA]
    let credit: Double
    let score: Double
    let gpa: Double
    
//    init(semesterGPAArray: [SemesterGPA], credit: Double, score: Double, gpa: Double) {
//        self.semesterGPAArray = semesterGPAArray
//        self.credit = credit
//        self.score = score
//        self.gpa = gpa
//    }
    
    init(semesterGPAArray: [SemesterGPA]) {
        self.semesterGPAArray = semesterGPAArray
        
        let creditArray = semesterGPAArray.map(\.credit)
        let scoreArray = semesterGPAArray.map(\.score)
        let gpaArray_ = semesterGPAArray.map(\.gpa)
        
        let allCredit = creditArray.reduce(0, +)
        let weightScoreArray = zip(creditArray, scoreArray).map { $0.0 * $0.1 }
        let weightGPAArray = zip(creditArray, gpaArray_).map { $0.0 * $0.1 }
        
        self.credit = allCredit
        if allCredit == 0 {
            self.score = 0
            self.gpa = 0
        } else {
            self.score = weightScoreArray.reduce(0, +) / allCredit
            self.gpa = weightGPAArray.reduce(0, +) / allCredit
        }
    }
    
    init() {
        self.semesterGPAArray = []
        self.credit = 0
        self.score = 0
        self.gpa = 0
    }
}
