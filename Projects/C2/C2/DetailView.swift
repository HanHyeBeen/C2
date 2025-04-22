//
//  DetailView.swift
//  C2
//
//  Created by Enoch on 4/15/25.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    let mentor: Mentor?
    let learner: Learner?
    let questions: [AssignedQuestion]
    let itemTitle: String
    let itemSub: String

    @Environment(\.modelContext) private var modelContext
    @State private var editingMemoID: UUID?
    @State private var memoText: String = ""
    
    @State private var showingDeleteAlertID: UUID?


    var body: some View {
        ZStack {
            C2App.BGColor
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(questions, id: \.id) { aq in
                        VStack(alignment: .leading, spacing: 6) {
                            
                            // 질문 말풍선 (왼쪽 정렬)
                            HStack {
                                Text("\(aq.question.content)")
                                    .font(.custom("SUIT-ExtraBold", size: 16))
                                    .foregroundColor(C2App.TextPrimary)
                                    .padding(16)
                                    .background(
                                        Image("memo_Q")
                                            .resizable()
                                        
//                                        Rectangle()
//                                            .fill(C2App.MainColor))
//                                            .cornerRadius(20)
                                    )
                                Spacer()
                            }
                            
                            // 메모 or + 버튼 (줄바꿈 후 오른쪽 정렬)
                            HStack {
                                Spacer()
                                
                                if aq.memo == nil && editingMemoID != aq.id {
                                    Button {
                                        editingMemoID = aq.id
                                        memoText = ""
                                    } label: {
                                        Image("AddBtn")
                                            .resizable()
                                            .frame(width: 72, height: 60)
                                            .padding(.trailing, 8)
                                    }
                                } else if editingMemoID == aq.id {
                                    VStack(alignment: .trailing, spacing: 6) {
                                        HStack {
                                            Text(formatDate(Date()))
                                                .font(.custom("SUIT-Bold", size: 16))
                                                .foregroundColor(C2App.TextSecondary)
                                            
                                            Spacer()
                                            
                                            Button {
                                                editingMemoID = nil
                                                memoText = ""
                                            } label: {
                                                ZStack {
                                                    Image("DeleteBtn")
                                                        .resizable()
                                                        .frame(width: 21, height: 21)
                                                }
                                            }
                                        }
                                        
                                        TextField(
                                            "",
                                            text: $memoText,
                                            prompt: Text("메모를 입력하세요")
                                                .font(.custom("SUIT-ExtraBold", size: 16))
                                                .foregroundColor(C2App.TextSub)
                                            )
                                            .font(.custom("SUIT-ExtraBold", size: 16))
                                            .foregroundColor(C2App.TextPrimary)
                                            .padding(.vertical, 8)
                                        
                                        HStack {
                                            Spacer()
                                            
                                            Button {
                                                aq.memo = memoText
                                                aq.dateMemoAdded = Date()
                                                try? modelContext.save()
                                                editingMemoID = nil
                                            } label: {
                                                ZStack {
                                                    Image("Detail_SaveBtn")
                                                        .resizable()
                                                        .frame(width: 60, height: 32)
                                                    
                                                    Text("저장")
                                                        .font(.custom("SUIT-ExtraBold", size: 16))
                                                        .foregroundColor(C2App.Sub1)
                                                }
                                            }
                                        }
                                    }
                                    .frame(maxWidth: 250)
                                    .padding()
                                    .background(
                                        Image("memo_A")
                                            .resizable()
                                    )
                                } else if let memo = aq.memo, let date = aq.dateMemoAdded {
                                    VStack(alignment: .leading, spacing: 6) {
                                        HStack {
                                            Text(formatDate(Date()))
                                                .font(.custom("SUIT-Bold", size: 16))
                                                .foregroundColor(C2App.TextSecondary)
                                            Spacer()
                                            Button {
                                                editingMemoID = aq.id
                                                memoText = memo
                                            } label: {
                                                Image("EditBtn")
                                                    .resizable()
                                                    .frame(width: 21, height: 21)
                                            }
                                            .padding(.trailing, 8)
                                            
                                            Button {
                                                showingDeleteAlertID = aq.id
                                            } label: {
                                                Image("DeleteBtn")
                                                    .resizable()
                                                    .frame(width: 21, height: 21)
                                            }
                                            .alert("메모를 삭제하시겠습니까?", isPresented: Binding(
                                                get: { showingDeleteAlertID == aq.id },
                                                set: { if !$0 { showingDeleteAlertID = nil } }
                                            )) {
                                                Button("삭제", role: .destructive) {
                                                    aq.memo = nil
                                                    aq.dateMemoAdded = nil
                                                    try? modelContext.save()
                                                    showingDeleteAlertID = nil
                                                }
                                                Button("취소", role: .cancel) {
                                                    showingDeleteAlertID = nil
                                                }
                                            }
                                        }

                                        Text(memo)
                                            .font(.custom("SUIT-ExtraBold", size: 16))
                                            .foregroundColor(C2App.TextPrimary)
                                            .padding(.top, 4)
                                    }
                                    .padding()
                                    .background(
                                        Image("memo_A")
                                            .resizable()
//                                        Rectangle()
//                                            .fill(C2App.MainColor).opacity(0.3))
//                                            .cornerRadius(20)
                                        )
                                    .frame(maxWidth: 250)
                                }
                            }
                        }
                        .padding(.bottom, 20)
                    }



                    Spacer()
                }
                .padding()
            }
            .navigationTitle(itemTitle + "(" + itemSub + ")")
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        return formatter.string(from: date)
    }

}
