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
                Question(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, content: "MBTI는?"),
                Question(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, content: "좋아하는 색은?"),
                Question(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, content: "좋아하는 음식은?"),
                Question(id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!, content: "좋아하는 계절은?"),
                Question(id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!, content: "요즘 많이 듣는 음악은?"),
                Question(id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!, content: "최근에 다녀온 여행지는?"),
                Question(id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!, content: "스트레스 받을 때 힐링하는 방법은?"),
                Question(id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!, content: "가보고 싶은 국내/해외 여행지는?"),
                Question(id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!, content: "좋아하는 영화는?")
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
