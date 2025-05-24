//
//  ScannedAnimal.swift
//  Scanimals
//
//  Created by Adam Lee on 4/14/25.
//
import Foundation
import UIKit
// Scanned Animal Model
// Each Scanned Animal will have a unique ID, name, imageName, and fact
// Will add on more attributes later on if needed
struct ScannedAnimal: Identifiable {
    let id: UUID = UUID()
    let name: String
    let imageName: String
    let fact: String
    var image: UIImage? = nil
}
