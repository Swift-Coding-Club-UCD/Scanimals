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
            Text(animal.name)
            
            
            if let uiImage = animal.image{
                
                Image(uiImage: uiImage)
                    .resizable()
                    .cornerRadius(12)
                    .frame(width: 300, height: 400)
                    .scaledToFill()
                
            }else{
                Image(animal.imageName)
                    .resizable()
                    .cornerRadius(12)
                    .frame(width: 300, height: 400)
                    .scaledToFill()
            }
        }
        .padding()
    }
}


