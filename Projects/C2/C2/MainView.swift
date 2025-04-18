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
    var userID: String
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
    
    @State private var canDraw: Bool = true

    @State private var popupName: String = ""
    @State private var popupField: String = ""
    @State private var popupQuestion: String = ""
    @State private var showingResultPopup: Bool = false

    
    var body: some View {
        ZStack {
            C2App.BGColor.ignoresSafeArea()

            VStack() {
                HStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 119, height: 44)
                        .background(
                            Image("main_logo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 119, height: 44)
                                .clipped()
                        )
                        .padding(20)
                    
                        Spacer()
                    
                    // 보관함 이동
                    NavigationLink("보관함") {
                        ArchiveView(role: role)
                    }
                    .padding(20)
                }
                
                Spacer()
                
                Text("\(userID)")
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding(10)
                    .border(Color.gray)

                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 379, height: 526)
                  .background(
                    Image("RandomBall")
                      .resizable()
                      .frame(width: 379, height: 526)
                      .clipped()
                  )

                // 통계 정보
//                Text("멘토 수: \(mentors.count), 러너 수: \(learners.count), 질문 수: \(questions.count)")
//                    .foregroundColor(.gray)

                // 역할별 이름, 분야 표시
                if role == "러너", let mentor = selectedMentor {
//                    Text("🎯 \(mentor.name)").font(.title2)
//                    Text("📘 \(mentor.field)").font(.subheadline).foregroundColor(.gray)
                }

                if role == "멘토", let learner = selectedLearner {
//                    Text("🎯 \(learner.name)").font(.title2)
//                    Text("📘 \(learner.field)").font(.subheadline).foregroundColor(.gray)
                }

                // 선택된 질문 표시
                if let question = selectedQuestion {
//                    Text("❓ \(question.content)")
//                        .font(.headline)
//                        .foregroundColor(.black)
//                        .padding(.top)
                }

                
                
                // 뽑기 버튼
                Button("뽑기") {
                    if role == "멘토" {
                        // 질문이 남아있는 러너들만 필터링
                        let availableLearners = learners.filter { learner in
                            let received = assignedQuestions.filter { $0.learner?.id == learner.id }.map { $0.question.id }
                            return Set(received).count < questions.count
                        }
                        
                        // 조건에 맞는 러너가 없으면 리턴
                        guard let learner = availableLearners.randomElement() else {
                            print("❌ 모든 러너가 질문을 다 받았습니다.")
                            return
                        }

                        let assignedToLearner = assignedQuestions.filter { $0.learner?.id == learner.id }
                        let assignedIds = Set(assignedToLearner.map { $0.question.id })
                        let unassigned = questions.filter { !assignedIds.contains($0.id) }

                        guard let question = unassigned.randomElement() else {
                            currentLearner = learner
                            selectedQuestion = nil
                            return
                        }

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
                        popupName = learner.name
                        popupField = learner.field
                        popupQuestion = question.content
                        showingResultPopup = true

                    }

                    else if role == "러너" {
                        // 질문이 남아있는 멘토들만 필터링
                        let availableMentors = mentors.filter { mentor in
                            let received = assignedQuestions.filter { $0.mentor?.id == mentor.id }.map { $0.question.id }
                            return Set(received).count < questions.count
                        }

                        guard let mentor = availableMentors.randomElement() else {
                            print("❌ 모든 멘토가 질문을 다 받았습니다.")
                            return
                        }

                        let assignedToMentor = assignedQuestions.filter { $0.mentor?.id == mentor.id }
                        let assignedIds = Set(assignedToMentor.map { $0.question.id })
                        let unassigned = questions.filter { !assignedIds.contains($0.id) }

                        guard let question = unassigned.randomElement() else {
                            currentMentor = mentor
                            selectedQuestion = nil
                            return
                        }

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
                        popupName = mentor.name
                        popupField = mentor.field
                        popupQuestion = question.content
                        showingResultPopup = true
                    }
                }
                .font(.title2)
                .disabled(!canDraw) // ✅ 비활성화 조건 적용
                .opacity(canDraw ? 1 : 0.4) // 선택적: 시각적으로 흐리게 표시

                Spacer()
                
                // 로그아웃 버튼
                HStack {
                    Spacer()
                    Button("로그아웃") {
                        isLoggedIn = false
                    }
                    .foregroundColor(.red)
                    .padding()
                }

            }
            .onAppear {
                updateCanDrawStatus()
            }
            .onChange(of: assignedQuestions) { _ in
                updateCanDrawStatus()
            }
            .navigationTitle("")
            .alert("질문이 배정되었습니다", isPresented: $showingResultPopup, actions: {
                Button("확인", role: .cancel) { }
            }, message: {
                Text("""
                이름: \(popupName)
                분야: \(popupField)
                질문: \(popupQuestion)
                """)
            })

        }
    }
    
    private func updateCanDrawStatus() {
        if role == "멘토" {
            let availableLearners = learners.filter { learner in
                let received = assignedQuestions.filter { $0.learner?.id == learner.id }.map { $0.question.id }
                return Set(received).count < questions.count
            }
            canDraw = !availableLearners.isEmpty
        } else if role == "러너" {
            let availableMentors = mentors.filter { mentor in
                let received = assignedQuestions.filter { $0.mentor?.id == mentor.id }.map { $0.question.id }
                return Set(received).count < questions.count
            }
            canDraw = !availableMentors.isEmpty
        }
    }

}
