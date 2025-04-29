//
//  ContentView.swift
//  Scanimals
//
//  Created by Adam Lee on 4/14/25.
//

import SwiftUI
// The current UI implements the Figma Design
// Information Tab is omitted since it feels more intuitive
// to access the information through tapping an animal's picture
// either from the home tab or collection tab
struct ContentView: View {
    var body: some View {
        TabView{
            Tab("Home", systemImage: "house") {
                HomeView()
            }
            
            Tab("Scan", systemImage: "camera") {
                CameraView()
            }
            
            Tab("Collection", systemImage: "book.closed") {
                CollectionView()
            }
        }
    }
}

#Preview {
    ContentView()
}
