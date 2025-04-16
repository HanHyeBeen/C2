//
//  LoginView.swift
//  C2
//
//  Created by Enoch on 4/15/25.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var userId: String = ""

    var body: some View {
        ZStack {
            Image("BGcolor")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                
                Text("로그인 페이지")
                    .font(.largeTitle)
                    .bold()
                
                Button(action: {
                    // 로그인 로직 예시
                    isLoggedIn = true
                }) {
                    Text("로그인")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
        }
    }
}
