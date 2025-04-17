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
    
    var role: String  // "멘토" or "러너"

    @Environment(\.modelContext) private var modelContext
    

    @Query private var mentors: [Mentor]
    @Query private var learners: [Learner]
    @Query private var questions: [Question]
    
    @State private var selectedMentor: Mentor?
    @State private var selectedLearner: Learner?
    @State private var selectedQuestion: Question?
    
    
    var body: some View {
        ZStack {
            C2App.BGColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Button("로그아웃") {
                        isLoggedIn = false
                    }
                    .foregroundColor(.red)
                    .padding()
                }
                
                Spacer()
                
                Text("멘토 수: \(mentors.count), 러너 수: \(learners.count), 질문 수: \(questions.count)")
                    .foregroundColor(.gray)

                
                if role == "러너", let mentor = selectedMentor {
                    Text("🎯 \(mentor.name)").font(.title2)
                    Text("📘 \(mentor.field)").font(.subheadline).foregroundColor(.gray)
                }

                if role == "멘토", let learner = selectedLearner {
                    Text("🎯 \(learner.name)").font(.title2)
                    Text("📘 \(learner.field)").font(.subheadline).foregroundColor(.gray)
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
                    if role == "멘토" {
                        guard let mentor = mentors.randomElement(),
                              let learner = learners.randomElement() else { return }
                        
                        let assignedIds = Set(mentor.assignedQuestions.map { $0.question.id })
                        let unassigned = questions.filter { !assignedIds.contains($0.id) }
                        
                        guard let question = unassigned.randomElement() else {
                            selectedMentor = mentor
                            selectedLearner = learner
                            selectedQuestion = nil
                            return
                        }
                        
                        let newAssigned = AssignedQuestion(question: question, mentor: mentor, learner: learner)
                        modelContext.insert(newAssigned)
                        
                        do { try modelContext.save() } catch { print(error) }
                        
                        selectedMentor = mentor
                        selectedLearner = learner
                        selectedQuestion = question
                        
                    } else if role == "러너" {
                        guard let learner = learners.randomElement(),
                              let mentor = mentors.randomElement() else { return }
                        
                        let assignedIds = Set(learner.assignedQuestions.map { $0.question.id })
                        let unassigned = questions.filter { !assignedIds.contains($0.id) }
                        
                        guard let question = unassigned.randomElement() else {
                            selectedMentor = mentor
                            selectedLearner = learner
                            selectedQuestion = nil
                            return
                        }
                        
                        let newAssigned = AssignedQuestion(question: question, mentor: mentor, learner: learner) // ❗추후 구조 맞게 수정
                        modelContext.insert(newAssigned)
                        
                        do { try modelContext.save() } catch { print(error) }
                        
                        selectedMentor = mentor
                        selectedLearner = learner
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
