//
//  HomeViewModel.swift
//  Scanimals
//
//  Created by Adam Lee on 4/15/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore

// View Model for the HomeView
// Hard-Coded example animals in the meantime
class HomeViewModel: ObservableObject {
    //Observableobject creates class that can be observed and shared between multiple views
    //Published mark properties that trigger UI updates when they are changed
    @Published var scannedItems: [ScannedAnimal] = []
    
    @Published var folders: [Folder] = []
    
    private let firestoreService = FirestoreService()
    
    init() {
        print("HomeViewModel: Initializing...")
        Task {
            await loadData()
        }
    }
    
    @MainActor
    private func loadData() async {
        do {
            print("HomeViewModel: Loading data from Firestore...")
            scannedItems = try await firestoreService.fetchScannedItems()
            folders = try await firestoreService.fetchFolders()
            print("HomeViewModel: Successfully loaded \(scannedItems.count) items and \(folders.count) folders")
        } catch {
            print("HomeViewModel: Error loading data: \(error)")
        }
    }
    
    func createFolder(name: String) {
        print("HomeViewModel: Creating folder '\(name)'...")
        let newFolder = Folder(name: name)
        folders.append(newFolder)
        Task {
            do {
                try await firestoreService.saveFolder(newFolder)
                print("HomeViewModel: Successfully saved folder '\(name)'")
            } catch {
                print("HomeViewModel: Error saving folder: \(error)")
            }
        }
    }
    
    func deleteFolder(at indexSet: IndexSet) {
        for index in indexSet {
            let folder = folders[index]
            print("HomeViewModel: Deleting folder '\(folder.name)'...")
            Task {
                do {
                    try await firestoreService.deleteFolder(id: folder.id)
                    print("HomeViewModel: Successfully deleted folder '\(folder.name)'")
                } catch {
                    print("HomeViewModel: Error deleting folder: \(error)")
                }
            }
        }
        folders.remove(atOffsets: indexSet)
    }
    
    func addAnimalToFolder(animal: ScannedAnimal, folderId: UUID) {
        if let index = folders.firstIndex(where: { $0.id == folderId }) {
            print("HomeViewModel: Adding animal '\(animal.name)' to folder '\(folders[index].name)'...")
            folders[index].scannedAnimals.append(animal)
            Task {
                do {
                    try await firestoreService.saveFolder(folders[index])
                    print("HomeViewModel: Successfully added animal to folder")
                } catch {
                    print("HomeViewModel: Error saving folder: \(error)")
                }
            }
        }
    }
    
    func removeAnimalFromFolder(animalId: UUID, folderId: UUID) {
        if let folderIndex = folders.firstIndex(where: { $0.id == folderId }),
           let animalIndex = folders[folderIndex].scannedAnimals.firstIndex(where: { $0.id == animalId }) {
            let animal = folders[folderIndex].scannedAnimals[animalIndex]
            print("HomeViewModel: Removing animal '\(animal.name)' from folder '\(folders[folderIndex].name)'...")
            folders[folderIndex].scannedAnimals.remove(at: animalIndex)
            Task {
                do {
                    try await firestoreService.saveFolder(folders[folderIndex])
                    print("HomeViewModel: Successfully removed animal from folder")
                } catch {
                    print("HomeViewModel: Error saving folder: \(error)")
                }
            }
        }
    }
    
    func addScannedAnimal(_ animal: ScannedAnimal) {
        print("HomeViewModel: Adding scanned animal '\(animal.name)'...")
        scannedItems.insert(animal, at: 0)
        Task {
            do {
                try await firestoreService.saveScannedItem(animal)
                print("HomeViewModel: Successfully saved scanned animal")
            } catch {
                print("HomeViewModel: Error saving scanned item: \(error)")
            }
        }
    }
}
