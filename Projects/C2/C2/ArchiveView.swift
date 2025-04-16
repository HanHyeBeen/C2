//
//  ArchiveView.swift
//  C2
//
//  Created by Enoch on 4/15/25.
//

import SwiftUI
import SwiftData

struct ArchiveView: View {
    let archiveItems = ["아이템 1", "아이템 2", "아이템 3"]

    var body: some View {
        List(archiveItems, id: \.self) { item in
            NavigationLink(destination: DetailView(itemTitle: item)) {
                Text(item)
            }
        }
        .navigationTitle("보관함")
    }
}
