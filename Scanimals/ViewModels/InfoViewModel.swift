import Foundation
import GoogleGenerativeAI

@MainActor
final class InfoViewModel: ObservableObject {
    // MARK: Published state
    @Published var fact: String
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: Private
    private let gemini: GeminiService
    private let maxRetries = 3

    /// - Parameters:
    ///   - apiKey: your Gemini API key
    ///   - initialFact: a fact string you may have already fetched upstream
    init(apiKey: String, initialFact: String?) {
        self.fact = initialFact ?? ""
        self.gemini = GeminiService(apiKey: apiKey)
    }

    /// Call this on view appear to fetch only if `fact` was empty.
    func loadFactIfNeeded(for animal: String) async {
        guard fact.isEmpty else { return }
        await fetchFact(for: animal)
    }

    /// Force a fresh fetch (with retries).
    func retryFact(for animal: String) async {
        fact = ""            // clear out old fact
        await fetchFact(for: animal)
    }

    // MARK: - Private

    private func fetchFact(for animal: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        for attempt in 1...maxRetries {
            do {
                let newFact = try await gemini.generateAnimalFact(for: animal)
                fact = newFact
                return
            } catch {
                if attempt == maxRetries {
                    fact = "No fact available"
                    errorMessage = "Unable to load fact. Please try again later."
                } else {
                    // exponential back-off: 1s, 2s, 3s…
                    try? await Task.sleep(nanoseconds: UInt64(1_000_000_000 * attempt))
                }
            }
        }
    }
}
