//
//  MLService.swift
//  Scanimals
//
//  Created by Adam Lee on 5/26/25.
//
import UIKit
import Vision
import CoreML

/// Handles image classification and fact generation via GeminiService
final class MLService {
    static let shared = MLService()

    private let classificationModel: VNCoreMLModel
    private let geminiService: GeminiService

    private init() {
        // Load Core ML model
        guard let vnModel = try? VNCoreMLModel(for: MobileNetV2_2().model) else {
            fatalError("Unable to load Core ML model")
        }
        self.classificationModel = vnModel

        // Initialize Gemini with API key from config
        let apiKey = APIConfig.geminiKey
        self.geminiService = GeminiService(apiKey: apiKey)
    }

    /// Classify the image and return the top identifier
    func classify(_ image: UIImage) async throws -> String {
        guard let ciImage = CIImage(image: image) else {
            throw MLServiceError.invalidImage
        }
        let request = VNCoreMLRequest(model: classificationModel)
        let handler = VNImageRequestHandler(ciImage: ciImage)
        try handler.perform([request])
        guard let obs = request.results?.first as? VNClassificationObservation else {
            throw MLServiceError.classificationFailed
        }
        return obs.identifier
    }

    /// Generate an animal fact using Gemini
    func generateFact(for animal: String) async throws -> String {
        try await geminiService.generateAnimalFact(for: animal)
    }
}

enum MLServiceError: Error {
    case invalidImage, classificationFailed
}
