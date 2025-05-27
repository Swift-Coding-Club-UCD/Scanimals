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
    VStack(spacing: 4) {
      ZStack {
        // background shape
        RoundedRectangle(cornerRadius: 8)
          .fill(Color.secondary.opacity(0.1))
          .frame(width: 80, height: 80)

        // real photo or placeholder
        if let photo = animal.image {
          Image(uiImage: photo)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        } else {
          Image("placeholder")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
      }

      Text(animal.name)
        .font(.caption2)
        .lineLimit(1)
    }
  }
}
