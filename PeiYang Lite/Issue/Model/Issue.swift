//
//  Model.swift
//  PeiYang Lite
//
//  Created by 游奕桁 on 2021/2/26.
//

import Foundation

struct Tag {
    let id: Int
    let name: String
}

struct QuestionData {
    let id: Int
    let name: String
    let description: String
    let campus: Int
    let userId: Int
    let solved: Int
    let no_commit: Int
    let admin_commit: String
    let visible: Bool
    let likes: Int
    let created_at: Date
    let updated_at: Date
    let tags: [Tag]
    let answer_score: Int
    let answer_commit: String
    let msgCount: Int
    let url_list: [URL]
    
    init() {
        self.id = 1
        self.name = "问题"
        self.description = "微北洋课表是不是出问题了，有课显示没课"
        self.campus = 0
        self.userId = 0
        self.solved = 0
        self.no_commit = 0
        self.admin_commit = ""
        self.visible = true
        self.likes = 0
        self.created_at = DateComponents(calendar: Calendar.current, year: 2020, month: 9, day: 10, hour: 10, minute: 30).date ?? Date()
        self.updated_at = DateComponents(calendar: Calendar.current, year: 2020, month: 9, day: 10, hour: 10, minute: 30).date ?? Date()
        self.tags = [Tag(id: 0, name: "tag1")]
        self.answer_score = 0
        self.answer_commit = ""
        self.msgCount = 0
        self.url_list = []
    }
}
