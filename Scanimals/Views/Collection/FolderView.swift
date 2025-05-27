import SwiftUI

struct FolderView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var showingNewFolderAlert = false
    @State private var newFolderName = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(homeViewModel.folders) { folder in
                    NavigationLink(destination: FolderDetailView(folder: folder)) {
                        HStack {
                            Image(systemName: "folder")
                                .foregroundColor(.blue)
                            Text(folder.name)
                            Spacer()
                            Text("\(folder.scannedAnimals.count) items")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: homeViewModel.deleteFolder)
            }
            .navigationTitle("Collections")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewFolderAlert = true }) {
                        Image(systemName: "folder.badge.plus")
                    }
                }
            }
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

struct FolderDetailView: View {
    let folder: Folder
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    @State private var itemToDelete: ScannedAnimal?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(folder.scannedAnimals) { animal in
                    NavigationLink(destination: InfoView(animal: animal)) {
                        CompactAnimalView(animal: animal)
                            .contextMenu {
                                Button(role: .destructive) {
                                    itemToDelete = animal
                                    showingDeleteAlert = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(folder.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete Collection", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .alert("Delete Item", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                itemToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let item = itemToDelete {
                    // Delete specific item
                    homeViewModel.removeAnimalFromFolder(animalId: item.id, folderId: folder.id)
                    itemToDelete = nil
                } else {
                    // Delete entire folder
                    if let index = homeViewModel.folders.firstIndex(where: { $0.id == folder.id }) {
                        homeViewModel.deleteFolder(at: IndexSet(integer: index))
                        dismiss()
                    }
                }
            }
        } message: {
            if itemToDelete != nil {
                Text("Are you sure you want to delete this item from the collection?")
            } else {
                Text("Are you sure you want to delete this collection? This action cannot be undone.")
            }
        }
    }
} 