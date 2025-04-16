//
//  ContentView.swift
//  C2
//
//  Created by Enoch on 4/8/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            if isLoggedIn {
                MainView(isLoggedIn: $isLoggedIn)
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
        .task {
            await addInitialDataIfNeeded()
        }
    }
    
    func addInitialDataIfNeeded() async {
        do {
            let mentorCount = try modelContext.fetchCount(FetchDescriptor<Mentor>())
            let questionCount = try modelContext.fetchCount(FetchDescriptor<Question>())
            
            guard mentorCount == 0, questionCount == 0 else { return }
            
            let mentors = [
                Mentor(name: "Leeo", field: "Tech"),
                Mentor(name: "Friday", field: "Design"),
                Mentor(name: "MK", field: "Education")
            ]
            
            let questions = [
                Question(content: "MBTI는?"),
                Question(content: "좋아하는 색은?"),
                Question(content: "좋아하는 음식은?")
            ]
            
            for mentor in mentors {
                modelContext.insert(mentor)
            }
            
            for question in questions {
                modelContext.insert(question)
            }
            
            try modelContext.save()
            print("✅ 초기 데이터 등록 완료")
            
        } catch {
            print("❌ 초기 데이터 등록 실패: \(error.localizedDescription)")
        }
    }
}
//
//
//#Preview {
//    ContentView()
//}
