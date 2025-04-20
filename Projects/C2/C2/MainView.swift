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

    @State private var showingAlertPopup: Bool = false
    @State private var alertMessage: String = ""

    
    var body: some View {
        ZStack {
            C2App.BGColor.ignoresSafeArea()
            
            VStack() {
                HStack {
                    // 로고 (개발자 모드 _ 로그아웃 기능)
                    Button(action: {
                        isLoggedIn = false
                    }) {
                        Image("main_logo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 119, height: 44)
                            .clipped()
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                    
                    // 보관함 이동
                    NavigationLink("보관함") {
                        ArchiveView(role: role)
                    }
                    .padding(20)
                }
                
                Spacer()
                
                Button(action: {
                    if role == "멘토", let mentor = currentMentor {
                        // mentor.id와 연결된 AssignedQuestion 모두 삭제
                        let relatedAssignments = assignedQuestions.filter { $0.mentor?.id == mentor.id }
                        for item in relatedAssignments {
                            modelContext.delete(item)
                        }
                        
                        // 상태 초기화
                        currentMentor = nil
                        selectedLearner = nil
                        selectedQuestion = nil
                        
                    } else if role == "러너", let learner = currentLearner {
                        let relatedAssignments = assignedQuestions.filter { $0.learner?.id == learner.id }
                        for item in relatedAssignments {
                            modelContext.delete(item)
                        }
                        
                        currentLearner = nil
                        selectedMentor = nil
                        selectedQuestion = nil
                    }
                    
                    popupName = ""
                    popupField = ""
                    popupQuestion = ""
                    showingResultPopup = false
                    
                    // 실제 저장
                    do {
                        try modelContext.save()
                        print("🧹 삭제 및 상태 초기화 완료")
                    } catch {
                        print("❌ 삭제 실패: \(error.localizedDescription)")
                    }
                    
                    // 다시 뽑기 가능 여부 확인
                    updateCanDrawStatus()
                }) {
                    Text("\(userID)")
                        .font(
                            Font.custom("UhBee Se_hyun Bold", size: 24)
                                .weight(.bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(C2App.TextPrimary)
                        .padding(10)
                        .overlay(
                            Rectangle()
                                .frame(height: 2) // 두께
                                .foregroundColor(C2App.TextSecondary), // 색상
                            alignment: .bottom
                        )
                }
                
                Spacer()
                
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 359, height: 506)
                    .background(
                        Image("RandomBall")
                            .resizable()
                            .frame(width: 359, height: 506)
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
                
                
                Spacer()
                
                
                // 뽑기 버튼
                Button(action: {
                    if !canDraw {
                        if role == "멘토" {
                            alertMessage = "모든 러너가 질문을 다 받았습니다."
                        } else if role == "러너" {
                            alertMessage = "모든 멘토가 질문을 다 받았습니다."
                        }
                        showingAlertPopup = true
                        return
                    }
                    
                    if role == "멘토" {
                        // 질문이 남아있는 러너들만 필터링
                        let availableLearners = learners.filter { learner in
                            let received = assignedQuestions.filter { $0.learner?.id == learner.id }.map { $0.question.id }
                            return Set(received).count < questions.count
                        }
                        
                        // 조건에 맞는 러너가 없으면 리턴
                        guard let learner = availableLearners.randomElement() else {
                            alertMessage = "모든 러너가 질문을 다 받았습니다."
                            showingAlertPopup = true
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
                            alertMessage = "모든 멘토가 질문을 다 받았습니다."
                            showingAlertPopup = true
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
                }) {
                    ZStack {
                        Image("RandomBtn")
                            .resizable()
                            .frame(width: 289, height: 66)
                        
                        Text("뽑   기")
                            .font(
                                Font.custom("SUIT-Variable", size: 20)
                                    .weight(.heavy)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(C2App.Sub1)
                    }
                    
                }
                .font(.title2)
                //                .disabled(!canDraw) // ✅ 비활성화 조건 적용
                //                .opacity(canDraw ? 1 : 0.4) // 선택적: 시각적으로 흐리게 표시
                
                Spacer()
                
                
            }
            .onAppear {
                updateCanDrawStatus()
            }
            .onChange(of: assignedQuestions) { _ in
                updateCanDrawStatus()
            }
            .navigationTitle("")
            
            // 팝업 - 랜덤 상대/주제
            if showingResultPopup {
                Color.black.opacity(0.3).ignoresSafeArea()
                
                VStack(spacing: 50) {
                    Text(popupName)
                        .font(.title).bold()
                    Text(popupField)
                        .foregroundColor(.gray)
                    
                    
                    Image("random_Frame_left")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    //                        .frame(width: 119, height: 44)
                        .clipped()
                    
                    Text(popupQuestion)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .frame(maxWidth: 250)
                    
                    
                    Image("random_Frame_right")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    //                        .frame(width: 119, height: 44)
                        .clipped()
                    
                    Button(action: {
                        showingResultPopup = false
                    }) {
                        Text("확 인")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background(Color.yellow)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white)
                        .shadow(radius: 10)
                )
                .padding(.horizontal, 30)
                .padding(.vertical, 100)
                .overlay(
                    // ✅ 알 뽑기 이미지 (하단)
                    Image("")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .offset(x: -80, y: 130),
                    alignment: .bottom
                )
                .transition(.scale)
                .animation(.spring(), value: showingResultPopup)
                
            }
            
            if showingAlertPopup {
                Color.black.opacity(0.3).ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Text("알림")
                        .font(.title).bold()
                    Text(alertMessage)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                    
                    Button("확 인") {
                        showingAlertPopup = false
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(Color.yellow)
                    .cornerRadius(12)
                }
                .padding()
                .frame(width: 332, height: 669)
                .background(
                    Image("RandomCard")
                        .resizable()
                        .frame(width: 289, height: 66)
                )
//                .background(
//                    RoundedRectangle(cornerRadius: 24)
//                        .fill(Color.white)
//                        .shadow(radius: 10)
//                )
                .padding(.horizontal, 30)
                .padding(.vertical, 100)
            }
        }
    }
    
    private func updateCanDrawStatus() {
        if role == "멘토" {
            // 질문이 남아있는 러너가 1명이라도 있는지 체크
            let availableLearners = learners.filter { learner in
                let received = assignedQuestions.filter { $0.learner?.id == learner.id }.map { $0.question.id }
                return Set(received).count < questions.count
            }
            canDraw = !availableLearners.isEmpty
        } else if role == "러너" {
            // 질문이 남아있는 멘토가 1명이라도 있는지 체크
            let availableMentors = mentors.filter { mentor in
                let received = assignedQuestions.filter { $0.mentor?.id == mentor.id }.map { $0.question.id }
                return Set(received).count < questions.count
            }
            canDraw = !availableMentors.isEmpty
        }
    }


}
