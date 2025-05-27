//
//  ScannedAnimalView.swift
//  Scanimals
//
//  Created by Adam Lee on 4/14/25.
//

import SwiftUI

struct ScannedAnimalView: View {
    let animal: ScannedAnimal

    var body: some View {
        VStack(spacing: 8) {
            // Photo or placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondary.opacity(0.1))
                    .frame(height: 200)

                if let ui = animal.image {
                    Image(uiImage: ui)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(12)
                } else {
                    Image("placeholder")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(12)
                }
            }

            // Name
            Text(animal.name)
                .font(.headline)
                .lineLimit(1)
        }
    }
}


