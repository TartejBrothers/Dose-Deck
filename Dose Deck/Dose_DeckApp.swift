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
    @State private var userIsLogged = false
    @StateObject private var datamanager = DataManager()
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(userIsLogged: $userIsLogged)
                .environmentObject(datamanager)
        }
    }
}
