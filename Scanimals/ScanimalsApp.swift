//
//  ScanimalsApp.swift
//  Scanimals
//
//  Created by Adam Lee on 4/14/25.
//

import SwiftUI
// App follows the (MVVM) - Model-View-ViewModel for app development management
@main
struct ScanimalsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(HomeViewModel())
        }
    }
}
