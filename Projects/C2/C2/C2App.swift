//
//  C2App.swift
//  C2
//
//  Created by Enoch on 4/8/25.
//

import SwiftUI
import SwiftData

@main
struct C2App: App {
    static let MainColor: Color = Color(red: 0.71, green: 0.94, blue: 0.99)
    static let Sub1: Color = Color(red: 0.18, green: 0.27, blue: 0.36)
    static let Sub2: Color = Color(red: 0.85, green: 0.85, blue: 0.9)
    static let Point1: Color = Color(red: 1, green: 0.9, blue: 0.43)
    static let Point2: Color = Color(red: 0.42, green: 0.36, blue: 0.65)
    
    static let BGColor: Color = Color(red: 0.98, green: 0.98, blue: 0.98)
    
    static let TextPrimary: Color = Color(red: 0.2, green: 0.2, blue: 0.2)
    static let TextSecondary: Color = Color(red: 0.4, green: 0.4, blue: 0.4)
    static let TextSub: Color = Color(red: 0.74, green: 0.73, blue: 0.73)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
