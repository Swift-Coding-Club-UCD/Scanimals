//
//  Untitled.swift
//  Scanimals
//
//  Created by Adam Lee on 4/15/25.
//
import SwiftUI

struct CompactAnimalView: View {
    let animal: ScannedAnimal

    var body: some View {
        VStack(spacing: 6) {
            Text(animal.name)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            if let uiImage = animal.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .cornerRadius(10)
            } else {
                Image(animal.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .cornerRadius(10)
            }
        }
        .frame(width: 140)
        .padding(4)
        .cornerRadius(12)
    }
}
