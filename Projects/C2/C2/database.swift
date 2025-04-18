//
//  database.swift
//  C2
//
//  Created by Enoch on 4/16/25.
//

import Foundation
import SwiftData

// MARK: - 멘토 정보
@Model
class Mentor {
    @Attribute(.unique) var id: UUID
    var name: String
    var field: String
    var isSelected: Bool

    @Relationship(deleteRule: .cascade) var assignedQuestions: [AssignedQuestion]

    init(name: String, field: String, isSelected: Bool = false) {
        self.id = UUID()
        self.name = name
        self.field = field
        self.isSelected = isSelected
        self.assignedQuestions = []
    }
}

// MARK: - 러너 정보
@Model
class Learner {
    @Attribute(.unique) var id: UUID
    var name: String
    var field: String
    var isSelected: Bool

    @Relationship(deleteRule: .cascade) var assignedQuestions: [AssignedQuestion]

    init(name: String, field: String, isSelected: Bool = false) {
        self.id = UUID()
        self.name = name
        self.field = field
        self.isSelected = isSelected
        self.assignedQuestions = []
    }
}

// MARK: - 질문 정보
@Model
class Question {
    @Attribute(.unique) var id: UUID
    var content: String

    init(id: UUID = UUID(), content: String) {
        self.id = id
        self.content = content
    }
}

// MARK: - 멘토에게 할당된 질문
@Model
class AssignedQuestion {
    @Attribute(.unique) var id: UUID
    var dateAssigned: Date
    var memo: String?
    var dateMemoAdded: Date?

    @Relationship var mentor: Mentor?
    @Relationship var learner: Learner?
    @Relationship var question: Question  // ✅ 정석 연결

    init(question: Question, mentor: Mentor?, learner: Learner?, dateAssigned: Date = Date()) {
        self.id = UUID()
        self.dateAssigned = dateAssigned
        self.mentor = mentor
        self.learner = learner
        self.question = question
    }
}
