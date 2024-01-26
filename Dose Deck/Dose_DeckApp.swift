//
//  Dose_DeckApp.swift
//  Dose Deck
//
//  Created by Taranjeet Singh Bedi on 26/01/24.
//

import SwiftUI
import Firebase
@main
struct Dose_DeckApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
