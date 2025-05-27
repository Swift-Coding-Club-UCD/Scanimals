//
//  CameraViewModel.swift
//  Scanimals
//
//  Created by Adam Lee on 5/26/25.
//
import SwiftUI
import Combine
import AVFoundation

@MainActor
final class CameraViewModel: ObservableObject {
    @Published var image: UIImage? // Still useful to temporarily hold the captured image for the ScannedAnimal object
    @Published var classificationLabel: String = "Point camera to scan" // Initial prompt
    @Published var animalFact: String = "" // Will be cleared
    @Published var errorMessage: String?
    @Published var scannedAnimalForNavigation: ScannedAnimal? = nil // Triggers navigation

    let session: AVCaptureSession
    private let cameraService = CameraService.shared
    private var photoCancellable: AnyCancellable?
    private let mlService = MLService.shared

    var onAnimalScanned: ((ScannedAnimal) -> Void)?

    init() {
        session = cameraService.getSession()
        do {
            try cameraService.configureSession()
        } catch {
            self.errorMessage = error.localizedDescription
        }

        photoCancellable = cameraService.$photo
            .receive(on: DispatchQueue.main) // <<< ADD THIS LINE
            .sink { [weak self] img in
                guard let self = self, let img = img else { return }
                // Now self.image is guaranteed to be set on the main thread
                self.image = img
                Task { await self.process(image: img) }
            }
        clearAndResetState()
    }

    func startCameraSession() {
        cameraService.startSession() //
    }

    func stopCameraSession() {
        cameraService.stopSession() //
    }

    func capture() {
        // Update UI to show capturing in progress
        Task { @MainActor in
            self.classificationLabel = "Capturing..."
            self.errorMessage = nil
            self.animalFact = ""
        }
        cameraService.capturePhoto() //
    }

    private func process(image: UIImage) async {
        self.classificationLabel = "Processing..." // Already on main actor
        do {
            let rawName = try await mlService.classify(image) // e.g., "switch, electric switch, electrical switch"

            // 1. Process the name: Take the first component and trim whitespace
            var finalName = rawName
            if let firstComponent = rawName.split(separator: ",").first {
                finalName = String(firstComponent).trimmingCharacters(in: .whitespacesAndNewlines)
            }

            // 2. Capitalize the first letter
            if !finalName.isEmpty {
                finalName = finalName.prefix(1).uppercased() + finalName.dropFirst()
            }
            // Now 'finalName' should be something like "Switch"

            // Use the processed 'finalName' to generate the fact
            let fact = try await mlService.generateFact(for: finalName)
            
            let scannedAnimal = ScannedAnimal(
                name: finalName, // Use the cleaned and capitalized name
                fact: fact,
                image: image
            )
            
            onAnimalScanned?(scannedAnimal)

            self.scannedAnimalForNavigation = scannedAnimal
            
        } catch {
            self.errorMessage = error.localizedDescription
            self.classificationLabel = "Error processing"
        }
    }

    /// Call this to reset the state for a new scan, typically after InfoView is dismissed.
    func clearAndResetState() {
        // Don't nullify self.image here if InfoView depends on it being briefly available via ScannedAnimal.
        // self.image is the raw captured photo, ScannedAnimal carries its own copy.
        self.classificationLabel = "Point camera to scan"
        self.animalFact = ""
        self.errorMessage = nil
        self.scannedAnimalForNavigation = nil // Very important to allow future navigations
    }
}
