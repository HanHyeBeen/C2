//
//  LoginView.swift
//  C2
//
//  Created by Enoch on 4/15/25.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    
    @Binding var isLoggedIn: Bool
    @Binding var selectedRole: String  // 기존의 State가 아닌 Binding으로 바꿔야 합니다
    
    @State private var userId: String = ""
//    @State private var selectedRole: String = ""
    @State private var selectedField: String = ""

    var body: some View {
        ZStack {
            C2App.BGColor
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
            //로고
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 132.94714, height: 155)
                    .background(
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 132.9471435546875)
                            .clipped()
                    )
                
                
            //닉네임 입력
                TextField("닉네임 (영문)", text: $userId)
                    .padding(.vertical, 15) // 텍스트 필드 안 상하 여백
                    .background(Color(red: 0.71, green: 0.94, blue: 0.99).opacity(0.2)) // 배경
                    .cornerRadius(10) // 둥근 테두리
                    .padding(.top, 30) // 상 여백
                    .font(
                        Font.custom("SUIT Variable", size: 20)
                            .weight(.heavy)
                    ) // 폰트 스타일
                    .multilineTextAlignment(.center)
                
                
            //러너 멘토 선택
                HStack(spacing: 0) {
                    RoleButton(title: "러너", tag: "러너", selectedRole: $selectedRole)
                    RoleButton(title: "멘토", tag: "멘토", selectedRole: $selectedRole)
                }
                
                
            //분야 선택
                Menu {
                    Picker("분야", selection: $selectedField) {
                        Text("탐색 중").tag("탐색 중")
                        Text("도메인").tag("도메인")
                        Text("디자인").tag("디자인")
                        Text("테크").tag("테크")
                    }
                } label: {
                    ZStack {
                        // 가운데 정렬 텍스트
                        Text(selectedField.isEmpty ? "분야" : selectedField)
                            .font(Font.custom("SUIT Variable", size: 20).weight(.heavy))
                            .foregroundColor(selectedField.isEmpty ? C2App.TextSub : C2App.TextPrimary)
                            .multilineTextAlignment(.center)
                        
                        // 오른쪽 아이콘
                        HStack {
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(C2App.TextSub)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(C2App.MainColor.opacity(0.2))
                    .cornerRadius(10)
                }
                    
            
            //로그인 버튼
                Button(action: {
                    // 로그인 로직 예시
                    isLoggedIn = true
                }) {
                    Text("로그인")
                        .padding()
                        .font(
                          Font.custom("SUIT Variable", size: 20)
                            .weight(.heavy)
                        ) // 폰트 스타일
                        .frame(maxWidth: .infinity)
                        .background(C2App.MainColor)
                        .foregroundColor(C2App.TextPrimary)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 70)
        }
    }
    
    struct RoleButton: View {
        var title: String
        var tag: String
        @Binding var selectedRole: String

        var isSelected: Bool {
            selectedRole == tag
        }

        var imageName: String {
            switch tag {
            case "러너":
                return isSelected ? "learner_selected" : "learner_unselected"
            case "멘토":
                return isSelected ? "mentor_selected" : "mentor_unselected"
            default:
                return ""
            }
        }

        var body: some View {
            Button(action: {
                selectedRole = tag
            }) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 129.5, height: 48)
            }
            .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일 제거
            .animation(.easeInOut(duration: 0.5), value: isSelected)
        }
    }
}
