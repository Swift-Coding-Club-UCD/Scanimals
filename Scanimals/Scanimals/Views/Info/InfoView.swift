//
//  InfoView.swift
//  Scanimals
//
//  Created by Adam Lee on 4/15/25.
//

import SwiftUI

// Displays the information of an animal
struct InfoView: View {
    let animal: ScannedAnimal

    var body: some View {
        VStack(spacing: 20) {
            
            Image(animal.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .cornerRadius(12)
            
            Text(animal.fact)


            Spacer()
        }
        .padding()
        .navigationTitle(animal.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

