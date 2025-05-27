//
//  ContentView.swift
//  Scanimals
//
//  Created by Adam Lee on 4/14/25.
//

import SwiftUI

struct ContentView: View {
    // Create one source-of-truth for all scanned animals
    @StateObject private var homeVM = HomeViewModel()

    var body: some View {
        TabView {
            // Home Tab
            HomeView()
                .environmentObject(homeVM)
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            // Scan Tab
            CameraView()
                .environmentObject(homeVM)
                .tabItem {
                    Label("Scan", systemImage: "camera")
                }

            // Collection Tab
            CollectionView()
                .environmentObject(homeVM)
                .tabItem {
                    Label("Collection", systemImage: "book.closed")
                }
        }
    }
}

#Preview {
    ContentView()
}
