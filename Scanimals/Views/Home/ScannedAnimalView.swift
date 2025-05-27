//
//  ScannedAnimalView.swift
//  Scanimals
//
//  Created by Adam Lee on 4/14/25.
//

import SwiftUI

struct ScannedAnimalView: View {
    let animal: ScannedAnimal
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var showingFolderPicker = false
    
    var body: some View {
        VStack(spacing: 8) {
            Text(animal.name)
            
            if let uiImage = animal.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .cornerRadius(12)
                    .frame(width: 300, height: 400)
                    .scaledToFill()
                    .contextMenu {
                        if !homeViewModel.folders.isEmpty {
                            Button {
                                showingFolderPicker = true
                            } label: {
                                Label("Add to Collection", systemImage: "folder.badge.plus")
                            }
                        }
                    }
            } else {
                Image(animal.imageName)
                    .resizable()
                    .cornerRadius(12)
                    .frame(width: 300, height: 400)
                    .scaledToFill()
            }
        }
        .padding()
        .sheet(isPresented: $showingFolderPicker) {
            FolderPickerView(selectedFolderId: .constant(nil)) { folderId in
                homeViewModel.addAnimalToFolder(animal: animal, folderId: folderId)
            }
        }
    }
}


