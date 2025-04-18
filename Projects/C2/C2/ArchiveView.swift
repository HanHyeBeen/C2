//
//  ArchiveView.swift
//  C2
//
//  Created by Enoch on 4/15/25.
//

import SwiftUI
import SwiftData

struct ArchiveView: View {
    let role: String
    
    @Query private var assignedQuestions: [AssignedQuestion]
    
    // 멘토 기준 그룹핑 (러너일 때 사용)
    private var mentorDict: [Mentor: [AssignedQuestion]] {
        let nonNil = assignedQuestions.compactMap { aq -> (Mentor, AssignedQuestion)? in
            guard let mentor = aq.mentor else { return nil }
            return (mentor, aq)
        }
        return Dictionary(grouping: nonNil, by: { $0.0 }).mapValues { $0.map { $0.1 } }
    }
    
    // 러너 기준 그룹핑 (멘토일 때 사용)
    private var learnerDict: [Learner: [AssignedQuestion]] {
        let nonNil = assignedQuestions.compactMap { aq -> (Learner, AssignedQuestion)? in
            guard let learner = aq.learner else { return nil }
            return (learner, aq)
        }
        return Dictionary(grouping: nonNil, by: { $0.0 }).mapValues { $0.map { $0.1 } }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if role == "멘토", learnerDict.isEmpty {
                    Text("아직 질문을 받은 러너가 없습니다.")
                        .foregroundColor(.gray)
                        .padding()
                } else if role == "러너", mentorDict.isEmpty {
                    Text("아직 질문을 받은 멘토가 없습니다.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    if role == "멘토" {
                        ForEach(Array(learnerDict.keys), id: \.id) { learner in
                            learnerCard(for: learner)
                        }
                    } else if role == "러너" {
                        ForEach(Array(mentorDict.keys), id: \.id) { mentor in
                            mentorCard(for: mentor)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("보관함")
    }
    
    // 🔹 뷰 조각을 따로 메서드로 분리
    // 멘토 카드
    @ViewBuilder
    private func mentorCard(for mentor: Mentor) -> some View {
        NavigationLink {
            DetailView(mentor: mentor, learner: nil, questions: mentorDict[mentor] ?? [], itemTitle: mentor.name)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                Text("🎯 멘토: \(mentor.name)")
                    .font(.title3)
                    .foregroundColor(.black)
                
                Text("📘 분야: \(mentor.field)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // 러너 카드
    @ViewBuilder
    private func learnerCard(for learner: Learner) -> some View {
        NavigationLink {
            DetailView(mentor: nil, learner: learner, questions: learnerDict[learner] ?? [], itemTitle: learner.name)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                Text("🎯 러너: \(learner.name)")
                    .font(.title3)
                    .foregroundColor(.black)
                
                Text("📘 분야: \(learner.field)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)
        }
    }
}
