//
//  InfoView.swift
//  Scanimals
//
//  Created by Adam Lee on 4/15/25.
//
// InfoView.swift
import SwiftUI

struct InfoView: View {
    let animal: ScannedAnimal // This will now have the processed name
    @StateObject private var vm: InfoViewModel

    init(animal: ScannedAnimal) {
        self.animal = animal
        // Ensure APIConfig.geminiKey is correctly accessible here as per your setup
        // This was the previous setup:
        _vm = StateObject(
            wrappedValue: InfoViewModel(
                apiKey: APIConfig.geminiKey, // Make sure APIConfig is available
                initialFact: animal.fact
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 24) { // Increased main spacing
                // Animal Image
                if let uiImage = animal.image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit() // Keeps aspect ratio, fits within frame
                        .frame(maxHeight: 300) // Allow image to be a bit taller if it fits
                        .clipShape(RoundedRectangle(cornerRadius: 16)) // Slightly more rounded
                        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4) // Softer shadow
                        .padding(.horizontal) // Add horizontal padding to the image container
                }

                // Animal Name - now cleaned and capitalized
                Text(animal.name) // Will display "Switch" for your example
                    .font(.system(.largeTitle, design: .rounded)) // More modern font design
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Fact / Loading / Error Section
                Group {
                    if vm.isLoading {
                        ProgressView("Fetching interesting fact...")
                            .padding(.top, 20)
                    } else if let err = vm.errorMessage {
                        VStack(spacing: 10) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                            Text("Oops!")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text(err)
                                .font(.body)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    } else if vm.fact.isEmpty || vm.fact == "No fact available" { // Handle empty/default case
                        VStack(spacing: 10) {
                            Image(systemName: "questionmark.diamond.fill")
                                .font(.largeTitle)
                                .foregroundColor(.secondary)
                            Text("No Fact Found")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text("We couldn't find a fun fact for \(animal.name) right now.")
                                .font(.body)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    } else {
                        // The actual fact
                        Text(vm.fact)
                            .font(.system(.body, design: .serif)) // Serif font can be nice for reading
                            .multilineTextAlignment(.leading) // Leading alignment for readability of paragraphs
                            .lineSpacing(5) // Add some line spacing
                            .padding(.horizontal)
                    }
                }
                .padding(.top, 10) // Add some space above the fact/loading group

                // Spacer to push content up if it's short, but ScrollView handles main scrolling
                // Spacer() // May not be needed if content naturally fills or scrolls

            }
            .padding(.vertical, 20) // Add overall vertical padding to the VStack content
        }
        // Use .inline for a centered, smaller title if this view is in a NavigationStack
        // Or remove .navigationBarTitleDisplayMode if you want the default behavior for the context.
        // If InfoView is the root of a new NavigationStack (e.g. if presented modally),
        // you might set its own .navigationTitle here.
        // For now, assuming it's pushed, it inherits the title or uses the default.
        // .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.loadFactIfNeeded(for: animal.name)
        }
    }
}

