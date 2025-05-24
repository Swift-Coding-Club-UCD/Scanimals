import Foundation
import GoogleGenerativeAI

class GeminiService {
    private let model: GenerativeModel
    
    init(apiKey: String) {
        let config = GenerationConfig(
            temperature: 0.7,
            maxOutputTokens: 150
        )
        self.model = GenerativeModel(name: "gemini-2.0-flash", apiKey: apiKey, generationConfig: config)
    }
    
    func generateAnimalFact(for animal: String) async throws -> String {
        let prompt = "Generate a brief, interesting fact about \(animal). Keep it under 100 words and make it educational and engaging for children."
        
        do {
            let response = try await model.generateContent(prompt)
            
            if let text = response.text {
                return text
            } else {
                print("Error: No text in response")
                return "No fact available"
            }
        } catch {
            print("Error generating content: \(error)")
            throw error
        }
    }
}

// Response models
struct GeminiResponse: Codable {
    let candidates: [Candidate]?
    let error: GeminiError?
}

struct GeminiError: Codable {
    let code: Int
    let message: String
    let status: String
}

struct Candidate: Codable {
    let content: Content
    let finishReason: String?
    let safetyRatings: [SafetyRating]?
}

struct Content: Codable {
    let parts: [Part]
    let role: String?
}

struct Part: Codable {
    let text: String
}

struct SafetyRating: Codable {
    let category: String
    let probability: String
} 