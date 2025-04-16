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
                
                NavigationLink("상세 페이지로 이동") {
                    DetailView(itemTitle: "예시 아이템")
                }
        
                
                Button("뽑기") {
                    if let mentor = mentors.randomElement() {
                        selectedMentor = mentor
                    }
                    if let question = questions.randomElement() {
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
