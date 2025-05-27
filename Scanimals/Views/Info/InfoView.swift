//
//  InfoView.swift
//  Scanimals
//
//  Created by Adam Lee on 4/15/25.
//
import SwiftUI

struct InfoView: View {
    let animal: ScannedAnimal
    @StateObject private var vm: InfoViewModel

    init(animal: ScannedAnimal) {
        self.animal = animal
        _vm = StateObject(
            wrappedValue: InfoViewModel(
                apiKey: APIConfig.geminiKey,
                initialFact: animal.fact
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Animal Image
                if let uiImage = animal.image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }

                // Animal Name
                Text(animal.name)
                    .font(.title)
                    .fontWeight(.bold)

                // Fact / Loading / Error
                Group {
                    if vm.isLoading {
                        ProgressView()
                    } else if let err = vm.errorMessage {
                        Text(err)
                            .foregroundColor(.red)
                    } else {
                        Text(vm.fact)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.loadFactIfNeeded(for: animal.name)
        }
    }
}

