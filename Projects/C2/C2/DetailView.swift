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
                                        Image(systemName: "plus.circle")
                                            .font(.title2)
                                            .foregroundColor(.blue)
                                            .padding(.trailing, 8)
                                    }
                                } else if editingMemoID == aq.id {
                                    VStack(alignment: .trailing, spacing: 6) {
                                        TextField("메모를 입력하세요", text: $memoText)
                                            .font(.custom("SUIT-ExtraBold", size: 16))
                                        //                                            .textFieldStyle(.roundedBorder)
                                        
                                        Button("저장") {
                                            aq.memo = memoText
                                            aq.dateMemoAdded = Date()
                                            try? modelContext.save()
                                            editingMemoID = nil
                                        }
                                        .font(.custom("SUIT-ExtraBold", size: 16))
                                    }
                                    .frame(maxWidth: 250)
                                    .padding()
                                    .background(
                                        Rectangle()
                                            .fill(C2App.MainColor).opacity(0.3))
                                            .cornerRadius(20)
                                } else if let memo = aq.memo, let date = aq.dateMemoAdded {
                                    VStack(alignment: .leading, spacing: 6) {
                                        HStack {
                                            Text(date.formatted(.dateTime.year().month().day()))
                                                .font(.custom("SUIT-Bold", size: 16))
                                                .foregroundColor(C2App.TextSecondary)
                                            Spacer()
                                            Button {
                                                editingMemoID = aq.id
                                                memoText = memo
                                            } label: {
                                                Image(systemName: "pencil")
                                                    .foregroundColor(.orange)
                                            }
                                            
                                            Button {
                                                showingDeleteAlertID = aq.id
                                            } label: {
                                                Image(systemName: "trash")
                                                    .foregroundColor(.red)
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
                                            .foregroundColor(.black)
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
}
