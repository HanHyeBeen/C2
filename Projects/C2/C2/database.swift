//
//  database.swift
//  C2
//
//  Created by Enoch on 4/16/25.
//

import Foundation
import SwiftData

// 멘토 정보
@Model
class Mentor {
    @Attribute(.unique) var id: UUID
    var name: String
    var field: String
    var isSelected: Bool      // <- 랜덤 배정 여부
    @Relationship(deleteRule: .cascade) var assignedQuestions: [AssignedQuestion]

    init(name: String, field: String, isSelected: Bool = false) {
        self.id = UUID()
        self.name = name
        self.field = field
        self.isSelected = isSelected
        self.assignedQuestions = []
    }
}


// 질문 정보
@Model
class Question {
    @Attribute(.unique) var id: UUID
    var content: String

    init(content: String) {
        self.id = UUID()
        self.content = content
    }
}

// 멘토에게 할당된 질문
@Model
class AssignedQuestion {
    @Attribute(.unique) var id: UUID
    var content: String         // 실제 질문 내용 복사본
    var dateAssigned: Date
    var memo: String?
    var dateMemoAdded: Date?
    
    @Relationship var mentor: Mentor

    init(content: String, dateAssigned: Date = Date(), mentor: Mentor) {
        self.id = UUID()
        self.content = content
        self.dateAssigned = dateAssigned
        self.mentor = mentor
    }
}
