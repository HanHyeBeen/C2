//
//  ArchiveView.swift
//  C2
//
//  Created by Enoch on 4/15/25.
//

import SwiftUI
import SwiftData

struct ArchiveView: View {
    @Query private var assignedQuestions: [AssignedQuestion]

    // body 밖으로 mentorDict 분리
    private var mentorDict: [Mentor: [AssignedQuestion]] {
        Dictionary(grouping: assignedQuestions) { $0.mentor }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if mentorDict.isEmpty {
                    Text("아직 질문을 받은 멘토가 없습니다.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(Array(mentorDict.keys), id: \.id) { mentor in
                        mentorCard(for: mentor)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("보관함")
    }

    // 🔹 뷰 조각을 따로 메서드로 분리
    @ViewBuilder
    private func mentorCard(for mentor: Mentor) -> some View {
        NavigationLink {
            DetailView(mentor: mentor, questions: mentorDict[mentor] ?? [], itemTitle: mentor.name)
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
}
