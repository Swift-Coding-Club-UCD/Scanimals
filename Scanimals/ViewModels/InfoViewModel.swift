import Foundation
import SwiftUI

@MainActor
class InfoViewModel: ObservableObject {
    @Published var fact: String = "Loading fact..."
    @Published var isLoading: Bool = true
    @Published var errorMessage: String? = nil
    private let geminiService: GeminiService
    private let maxRetries = 3
    
    init(apiKey: String) {
        self.geminiService = GeminiService(apiKey: apiKey)
    }
    
    func generateFact(for animal: String) async {
        isLoading = true
        errorMessage = nil
        
        for attempt in 1...maxRetries {
            do {
                let generatedFact = try await geminiService.generateAnimalFact(for: animal)
                fact = generatedFact
                isLoading = false
                return
            } catch {
                print("Attempt \(attempt) failed: \(error)")
                if attempt == maxRetries {
                    errorMessage = "Unable to generate fact. Please try again later."
                    fact = "No fact available"
                } else {
                    // Wait before retrying
                    try? await Task.sleep(nanoseconds: UInt64(1_000_000_000 * attempt))
                }
            }
        }
        
        isLoading = false
    }
    
    func retryGeneration(for animal: String) {
        Task {
            await generateFact(for: animal)
        }
    }
} 