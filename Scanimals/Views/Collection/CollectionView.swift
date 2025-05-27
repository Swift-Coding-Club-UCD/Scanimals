//
//  CollectionView.swift
//  Scanimals
//
//  Created by Adam Lee on 4/15/25.
//
import SwiftUI

import SwiftUI

struct CollectionView: View {
    @EnvironmentObject private var homeVM: HomeViewModel

    // Two flexible columns
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack { //
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(homeVM.scannedItems) { animal in
                        NavigationLink {
                            InfoView(animal: animal)
                        } label: {
                            CompactAnimalView(animal: animal)
                                .frame(height: 120)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Collection") 
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CollectionView()
      .environmentObject({
          let vm = HomeViewModel()
          // Add sample data for preview if needed
          // vm.scannedItems = [ ... ]
          return vm
      }())
}

#Preview {
    CollectionView()
      .environmentObject({
          let vm = HomeViewModel()
          vm.scannedItems = [
            ScannedAnimal(name: "Lion", fact: "King of the jungle", image: UIImage(named:"lion")),
            ScannedAnimal(name: "Elephant", fact: "Largest land mammal", image: UIImage(named:"elephant"))
          ]
          return vm
      }())
}
