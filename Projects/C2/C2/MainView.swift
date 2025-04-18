//
//  MainView.swift
//  C2
//
//  Created by Enoch on 4/15/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Binding var isLoggedIn: Bool
    var role: String  // "멘토" 또는 "러너"

    @Environment(\.modelContext) private var modelContext

    // 전체 데이터 쿼리
    @Query private var mentors: [Mentor]
    @Query private var learners: [Learner]
    @Query private var questions: [Question]
    @Query private var assignedQuestions: [AssignedQuestion]

    // 화면에 표시할 선택된 정보들
    @State private var selectedMentor: Mentor?
    @State private var selectedLearner: Learner?
    @State private var selectedQuestion: Question?

    // 현재 로그인된 유저 정보 (ContentView에서 전달)
    @Binding var currentMentor: Mentor?
    @Binding var currentLearner: Learner?

    var body: some View {
        ZStack {
            C2App.BGColor.ignoresSafeArea()

            VStack(spacing: 20) {
                // 로그아웃 버튼
                HStack {
                    Spacer()
                    Button("로그아웃") {
                        isLoggedIn = false
                    }
                    .foregroundColor(.red)
                    .padding()
                }

                Spacer()

                // 통계 정보
                Text("멘토 수: \(mentors.count), 러너 수: \(learners.count), 질문 수: \(questions.count)")
                    .foregroundColor(.gray)

                // 역할별 이름, 분야 표시
                if role == "러너", let mentor = selectedMentor {
                    Text("🎯 \(mentor.name)").font(.title2)
                    Text("📘 \(mentor.field)").font(.subheadline).foregroundColor(.gray)
                }

                if role == "멘토", let learner = selectedLearner {
                    Text("🎯 \(learner.name)").font(.title2)
                    Text("📘 \(learner.field)").font(.subheadline).foregroundColor(.gray)
                }

                // 선택된 질문 표시
                if let question = selectedQuestion {
                    Text("❓ \(question.content)")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.top)
                }

                // 보관함 이동
                NavigationLink("보관함으로 이동") {
                    ArchiveView(role: role)
                }

                // 뽑기 버튼
                Button("뽑기") {
                    if role == "멘토" {
                        // 현재 로그인된 멘토가 있는지 확인
//                        guard let mentor = currentMentor else { return }
                        // 러너 중 무작위로 1명 선택
                        guard let learner = learners.randomElement() else { return }

                        // 이 러너가 이미 받은 질문들의 ID 수집
                        let assignedToLearner = assignedQuestions.filter { $0.learner?.id == learner.id }
                        let assignedIds = Set(assignedToLearner.map { $0.question.id })

                        // 아직 받지 않은 질문 중 하나 선택
                        let unassigned = questions.filter { !assignedIds.contains($0.id) }
                        guard let question = unassigned.randomElement() else {
                            currentLearner = learner
                            selectedQuestion = nil
                            return
                        }

                        // 새로운 배정 생성 후 저장
                        let newAssigned = AssignedQuestion(question: question, mentor: nil, learner: learner)
                        modelContext.insert(newAssigned)

                        do {
                            try modelContext.save()
                            print("✅ 러너 뽑기 완료: \(learner.name) | 질문: \(question.content)")
                        } catch {
                            print("❌ 저장 실패: \(error.localizedDescription)")
                        }

                        currentLearner = learner
                        selectedLearner = learner
                        selectedQuestion = question
                    }

                    else if role == "러너" {
                        // 현재 로그인된 러너가 있는지 확인
//                        guard let learner = currentLearner,
                        guard let mentor = mentors.randomElement() else { return }

                        // 이 멘토가 받은 질문 ID 수집
                        let assignedToLearner = assignedQuestions.filter { $0.mentor?.id == mentor.id }
                        let assignedIds = Set(assignedToLearner.map { $0.question.id })

                        // 아직 받지 않은 질문 중 하나 선택
                        let unassigned = questions.filter { !assignedIds.contains($0.id) }
                        guard let question = unassigned.randomElement() else {
                            currentMentor = mentor
                            selectedQuestion = nil
                            return
                        }

                        // 새로운 배정 생성 후 저장
                        let newAssigned = AssignedQuestion(question: question, mentor: mentor, learner: nil)
                        modelContext.insert(newAssigned)

                        do {
                            try modelContext.save()
                            print("✅ 멘토 뽑기 완료: \(mentor.name) | 질문: \(question.content)")
                        } catch {
                            print("❌ 저장 실패: \(error.localizedDescription)")
                        }

                        currentMentor = mentor
                        selectedMentor = mentor
                        selectedQuestion = question
                    }
                }
                .font(.title2)

                Spacer()
            }
            .navigationTitle("메인")
        }
    }
}
