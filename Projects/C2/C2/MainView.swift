//
//  MainView.swift
//  C2
//
//  Created by Enoch on 4/15/25.
//

import SwiftUI

struct MainView: View {
    @Binding var isLoggedIn: Bool

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
                
                Text("메인 페이지")
                    .font(.title)
                
                NavigationLink("보관함으로 이동") {
                    ArchiveView()
                }
                
                NavigationLink("상세 페이지로 이동") {
                    DetailView(itemTitle: "예시 아이템")
                }
                
                Spacer()
            }
            .navigationTitle("메인")
        }
    }
}
