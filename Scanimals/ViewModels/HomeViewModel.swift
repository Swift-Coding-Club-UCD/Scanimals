//
//  HomeViewModel.swift
//  Scanimals
//
//  Created by Adam Lee on 4/15/25.
//

import Foundation

// View Model for the HomeView
final class HomeViewModel: ObservableObject {
  @Published var scannedItems: [ScannedAnimal] = []
}
