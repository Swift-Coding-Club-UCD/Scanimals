import SwiftUI

struct FolderPickerView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Binding var selectedFolderId: UUID?
    let onSelect: (UUID) -> Void
    
    @State private var newFolderName: String = ""
    
    var body: some View {
        NavigationView {
            List {
                // Section for creating a new folder
                Section(header: Text("Create New Folder")) {
                    HStack {
                        TextField("Folder name", text: $newFolderName)
                        Button(action: {
                            let trimmedName = newFolderName.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !trimmedName.isEmpty else { return }
                            homeViewModel.createFolder(name: trimmedName)
                            newFolderName = ""
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        .disabled(newFolderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                
                // Section for picking an existing folder
                Section(header: Text("Select Folder")) {
                    ForEach(homeViewModel.folders) { folder in
                        Button(action: {
                            selectedFolderId = folder.id
                            onSelect(folder.id)
                            dismiss()
                        }) {
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
                }
            }
            .navigationTitle("Add to Collection")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
} 