//
//  HomeViewModel.swift
//  Scanimals
//
//  Created by Adam Lee on 4/15/25.
//

import Foundation

// View Model for the HomeView
// Hard-Coded example animals in the meantime
class HomeViewModel: ObservableObject {
    //Observableobject creates class that can be observed and shared between multiple views
    //Published mark properties that trigger UI updates when they are changed
    @Published var scannedItems: [ScannedAnimal] = [
        ScannedAnimal(name: "Lion", imageName: "lion", fact: "Lions roar the loudest of all big cats"),
        ScannedAnimal(name: "Cat", imageName: "cat", fact: "Cats spend nearly one-third of their lives cleaning themselves"),
        ScannedAnimal(name: "Cow", imageName: "cow", fact: "Cows have best friends and get stressed when separated from them.")
    ]
}
