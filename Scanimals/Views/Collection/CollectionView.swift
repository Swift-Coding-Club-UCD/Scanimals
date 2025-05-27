//
//  CollectionView.swift
//  Scanimals
//
//  Created by Adam Lee on 4/15/25.
//

import SwiftUI

struct CollectionView: View {
    @StateObject private var viewModel = CollectionViewModel()
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var showingNewFolderAlert = false
    @State private var newFolderName = ""
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Folders Section
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Collections")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Button(action: { showingNewFolderAlert = true }) {
                                Image(systemName: "folder.badge.plus")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(homeViewModel.folders) { folder in
                                    NavigationLink(destination: FolderDetailView(folder: folder)) {
                                        VStack {
                                            Image(systemName: "folder.fill")
                                                .font(.system(size: 40))
                                                .foregroundColor(.blue)
                                            Text(folder.name)
                                                .font(.caption)
                                                .lineLimit(1)
                                            Text("\(folder.scannedAnimals.count) items")
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                        .frame(width: 80, height: 100)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(10)
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                if let index = homeViewModel.folders.firstIndex(where: { $0.id == folder.id }) {
                                                    homeViewModel.deleteFolder(at: IndexSet(integer: index))
                                                }
                                            } label: {
                                                Label("Delete Collection", systemImage: "trash")
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                  
                }
                .padding(.vertical)
            }
            .navigationTitle("Collection")
            .alert("New Collection", isPresented: $showingNewFolderAlert) {
                TextField("Collection Name", text: $newFolderName)
                Button("Cancel", role: .cancel) {
                    newFolderName = ""
                }
                Button("Create") {
                    if !newFolderName.isEmpty {
                        homeViewModel.createFolder(name: newFolderName)
                        newFolderName = ""
                    }
                }
            }
        }
    }
}
