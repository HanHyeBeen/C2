//
//  DetailView.swift
//  C2
//
//  Created by Enoch on 4/15/25.
//

import SwiftUI

struct DetailView: View {
    let itemTitle: String

    var body: some View {
        ZStack {
            
            Image("BGcolor")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Text("상세 페이지")
                    .font(.title)
                
                Text("선택한 항목: \(itemTitle)")
                    .padding()
            }
            .navigationTitle("상세 정보")
        }
    }
}
