//
//  DetailView.swift
//  C2
//
//  Created by Enoch on 4/15/25.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    let mentor: Mentor
    let questions: [AssignedQuestion]
    let itemTitle: String

    @Environment(\.modelContext) private var modelContext
    @State private var editingMemoID: UUID?
    @State private var memoText: String = ""

    var body: some View {
        ZStack {
            C2App.BGColor
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Text("받은 질문 목록:")
                        .font(.headline)

                    ForEach(questions, id: \.id) { aq in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("\(aq.question.content)")
                                    .font(.body)
                                
                                Spacer()
                                
                                // 메모가 있는 경우: 수정/삭제 버튼
                                if aq.memo != nil {
                                    Button {
                                        editingMemoID = aq.id
                                        memoText = aq.memo ?? ""
                                    } label: {
                                        Image(systemName: "pencil")
                                            .foregroundColor(.orange)
                                    }
                                    
                                    Button {
                                        aq.memo = nil
                                        aq.dateMemoAdded = nil
                                        try? modelContext.save()
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                    
                                } else {
                                    // 메모가 없으면 + 버튼
                                    Button {
                                        if editingMemoID == aq.id {
                                            editingMemoID = nil
                                        } else {
                                            editingMemoID = aq.id
                                            memoText = ""
                                        }
                                    } label: {
                                        Image(systemName: "plus.circle")
                                            .foregroundColor(.blue)
                                    }
                                }
                            
//                                Button {
//                                    if editingMemoID == aq.id {
//                                        // 취소
//                                        editingMemoID = nil
//                                    } else {
//                                        // 해당 질문에 대해 편집 시작
//                                        editingMemoID = aq.id
//                                        memoText = aq.memo ?? ""
//                                    }
//                                } label: {
//                                    Image(systemName: editingMemoID == aq.id ? "xmark.circle.fill" : "plus.circle")
//                                        .foregroundColor(.blue)
//                                }
                            }

                            // 메모 입력창
                            if editingMemoID == aq.id {
                                VStack(alignment: .leading) {
                                    TextField("메모를 입력하세요", text: $memoText)
                                        .textFieldStyle(.roundedBorder)

                                    Button("저장") {
                                        aq.memo = memoText
                                        aq.dateMemoAdded = Date()
                                        try? modelContext.save()
                                        editingMemoID = nil
                                    }
                                    .font(.caption)
                                    .padding(.top, 4)
                                }
                            }

                            // 저장된 메모 보여주기
                            if let memo = aq.memo {
                                Text("📝 메모: \(memo)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(8)
                        .shadow(radius: 1)
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("\(itemTitle)")
        }
    }
}
