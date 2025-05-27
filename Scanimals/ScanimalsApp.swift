//
//  ScanimalsApp.swift
//  Scanimals
//
//  Created by Adam Lee on 4/14/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

@main
struct ScanimalsApp: App {
    init() {
        FirebaseApp.configure()
        
        // Configure Firestore settings
        let db = Firestore.firestore()
        let settings = db.settings
        settings.isPersistenceEnabled = true
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        db.settings = settings
        
        print("Firebase initialized successfully")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(HomeViewModel())
        }
    }
}
