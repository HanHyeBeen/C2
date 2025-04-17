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

    @Environment(\.modelContext) private var modelContext
    

    @Query private var mentors: [Mentor]
    @Query private var questions: [Question]
    
    @State private var selectedMentor: Mentor?
    @State private var selectedQuestion: Question?
    
    
    var body: some View {
        ZStack {
            C2App.BGColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Button(action: {
                        // 로그아웃 처리
                        isLoggedIn = false
                    }) {
                        Text("로그아웃")
                            .foregroundColor(.red)
                    }
                    .padding()
                }
                
                Spacer()
                
                if let mentor = selectedMentor {
                    Text("🎯 \(mentor.name)")
                        .font(.title2)
                        .foregroundColor(.black)
                    Text("📘 \(mentor.field)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                if let question = selectedQuestion {
                    Text("❓ \(question.content)")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.top)
                }

                
                NavigationLink("보관함으로 이동") {
                    ArchiveView()
                }
        
                
                Button("뽑기") {
                    guard let mentor = mentors.randomElement() else { return }

                    let assignedQuestionIds = Set(
                        mentor.assignedQuestions.map { $0.question.id }
                    )
                    let unassignedQuestions = questions.filter {
                        !assignedQuestionIds.contains($0.id)
                    }

                    guard let question = unassignedQuestions.randomElement() else {
                        selectedMentor = mentor
                        selectedQuestion = nil
                        print("⚠️ 이 멘토는 더 이상 받을 질문이 없습니다.")
                        return
                    }

                    let newAssigned = AssignedQuestion(question: question, mentor: mentor)
                    modelContext.insert(newAssigned)

                    do {
                        try modelContext.save()
                        print("✅ 질문 '\(question.content)'이 멘토 '\(mentor.name)'에게 할당됨")
                    } catch {
                        print("❌ 저장 실패: \(error)")
                    }

                    selectedMentor = mentor
                    selectedQuestion = question
                }

                .font(.title2)
                
                
                Spacer()
            }
            .navigationTitle("메인")
        }
    }
    
}
