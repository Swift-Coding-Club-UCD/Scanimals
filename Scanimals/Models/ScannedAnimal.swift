//
//  ScannedAnimal.swift
//  Scanimals
//
//  Created by Adam Lee on 4/14/25.
//
// ScannedAnimal.swift
import Foundation
import UIKit

struct ScannedAnimal: Identifiable, Equatable, Hashable { // <<< Add Hashable here
  let id = UUID()
  let name: String
  let fact: String
  var image: UIImage?

  // Equatable conformance (you should already have this, often by id)
  static func == (lhs: ScannedAnimal, rhs: ScannedAnimal) -> Bool {
    return lhs.id == rhs.id
  }

  // Hashable conformance
  func hash(into hasher: inout Hasher) {
    hasher.combine(id) // Hashing by the unique ID is standard practice
  }
}
