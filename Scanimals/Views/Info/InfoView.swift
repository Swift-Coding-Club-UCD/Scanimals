//
//  InfoView.swift
//  Scanimals
//
//  Created by Adam Lee on 4/15/25.
//

import SwiftUI

// Displays the information of an animal
struct InfoView: View {
    let animal: ScannedAnimal
    @StateObject private var viewModel: InfoViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var showingFolderPicker = false
    
    init(animal: ScannedAnimal) {
        self.animal = animal
        _viewModel = StateObject(wrappedValue: InfoViewModel(apiKey: APIConfig.geminiKey))
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
                        .contextMenu {
                            if !homeViewModel.folders.isEmpty {
                                Button {
                                    showingFolderPicker = true
                                } label: {
                                    Label("Add to Collection", systemImage: "folder.badge.plus")
                                }
                            }
                        }
                }
                
                // Animal Name
                Text(animal.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                // Animal Fact
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    Text(viewModel.fact)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !homeViewModel.folders.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingFolderPicker = true
                    } label: {
                        Image(systemName: "folder.badge.plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingFolderPicker) {
            FolderPickerView(selectedFolderId: .constant(nil)) { folderId in
                homeViewModel.addAnimalToFolder(animal: animal, folderId: folderId)
            }
        }
        .task {
            // Generate fact when view appears
            await viewModel.generateFact(for: animal.name)
        }
    }
}

