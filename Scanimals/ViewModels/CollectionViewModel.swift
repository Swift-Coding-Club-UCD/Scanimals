//
//  CollectionViewModel.swift
//  Scanimals
//
//  Created by Adam Lee on 4/15/25.
//
import Foundation

// View Model for the CollectionView
// Hard-Coded example animals in the meantime
class CollectionViewModel: ObservableObject {
    @Published var leftColumn: [ScannedAnimal] = [
        ScannedAnimal(name: "Cow", imageName: "cow", fact: "Cows have best friends and get stressed when separated from them."),
        ScannedAnimal(name: "Cow", imageName: "cow", fact: "Cows have best friends and get stressed when separated from them."),
        ScannedAnimal(name: "Cow", imageName: "cow", fact: "Cows have best friends and get stressed when separated from them.")
    ]
    
    @Published var rightColumn: [ScannedAnimal] = [
        ScannedAnimal(name: "Cat", imageName: "cat", fact: "Cats spend nearly one-third of their lives cleaning themselves"),
        ScannedAnimal(name: "Cat", imageName: "cat", fact: "Cats spend nearly one-third of their lives cleaning themselves"),
        ScannedAnimal(name: "Cat", imageName: "cat", fact: "Cats spend nearly one-third of their lives cleaning themselves")
    ]
}
