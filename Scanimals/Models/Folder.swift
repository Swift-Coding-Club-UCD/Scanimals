import Foundation

struct Folder: Identifiable {
    let id: UUID = UUID()
    var name: String
    var scannedAnimals: [ScannedAnimal]
    
    init(name: String, scannedAnimals: [ScannedAnimal] = []) {
        self.name = name
        self.scannedAnimals = scannedAnimals
    }
} 