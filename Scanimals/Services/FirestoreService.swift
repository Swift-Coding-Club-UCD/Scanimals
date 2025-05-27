import Foundation
import FirebaseFirestore
import UIKit

class FirestoreService {
    private let db = Firestore.firestore()
    private let scannedItemsCollection = "scannedItems"
    private let foldersCollection = "folders"
    
    // MARK: - Scanned Items Operations
    
    func saveScannedItem(_ animal: ScannedAnimal) async throws {
        let data = try encodeScannedAnimal(animal)
        try await db.collection(scannedItemsCollection).document(animal.id.uuidString).setData(data)
    }
    
    func fetchScannedItems() async throws -> [ScannedAnimal] {
        let snapshot = try await db.collection(scannedItemsCollection).getDocuments()
        return try snapshot.documents.compactMap { document in
            try decodeScannedAnimal(from: document.data())
        }
    }
    
    func deleteScannedItem(id: UUID) async throws {
        try await db.collection(scannedItemsCollection).document(id.uuidString).delete()
    }
    
    // MARK: - Folder Operations
    
    func saveFolder(_ folder: Folder) async throws {
        let data = try encodeFolder(folder)
        try await db.collection(foldersCollection).document(folder.id.uuidString).setData(data)
    }
    
    func fetchFolders() async throws -> [Folder] {
        let snapshot = try await db.collection(foldersCollection).getDocuments()
        return try snapshot.documents.compactMap { document in
            try decodeFolder(from: document.data())
        }
    }
    
    func deleteFolder(id: UUID) async throws {
        try await db.collection(foldersCollection).document(id.uuidString).delete()
    }
    
    // MARK: - Helper Methods
    
    private func encodeScannedAnimal(_ animal: ScannedAnimal) throws -> [String: Any] {
        var data: [String: Any] = [
            "name": animal.name,
            "imageName": animal.imageName,
            "fact": animal.fact
        ]
        
        if let image = animal.image,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            data["imageData"] = imageData
        }
        
        return data
    }
    
    private func decodeScannedAnimal(from data: [String: Any]) throws -> ScannedAnimal {
        guard let name = data["name"] as? String,
              let imageName = data["imageName"] as? String,
              let fact = data["fact"] as? String else {
            throw NSError(domain: "FirestoreService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid data format"])
        }
        
        var image: UIImage?
        if let imageData = data["imageData"] as? Data {
            image = UIImage(data: imageData)
        }
        
        return ScannedAnimal(name: name, imageName: imageName, fact: fact, image: image)
    }
    
    private func encodeFolder(_ folder: Folder) throws -> [String: Any] {
        let scannedAnimalsData = try folder.scannedAnimals.map { try encodeScannedAnimal($0) }
        
        return [
            "name": folder.name,
            "scannedAnimals": scannedAnimalsData
        ]
    }
    
    private func decodeFolder(from data: [String: Any]) throws -> Folder {
        guard let name = data["name"] as? String,
              let scannedAnimalsData = data["scannedAnimals"] as? [[String: Any]] else {
            throw NSError(domain: "FirestoreService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid data format"])
        }
        
        let scannedAnimals = try scannedAnimalsData.compactMap { try decodeScannedAnimal(from: $0) }
        
        return Folder(name: name, scannedAnimals: scannedAnimals)
    }
} 
