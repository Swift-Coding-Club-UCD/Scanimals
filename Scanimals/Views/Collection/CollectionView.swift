//
//  CollectionView.swift
//  Scanimals
//
//  Created by Adam Lee on 4/15/25.
//

import SwiftUI

struct CollectionView: View {
    @StateObject private var viewModel = CollectionViewModel()
    // data that can be shared to children views and used within its own view, local view only data
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack(alignment: .top, spacing: 50) {
                    VStack(spacing: 16) {
                        ForEach(viewModel.leftColumn) { item in
                            NavigationLink(destination: InfoView(animal: item)) {
                                CompactAnimalView(animal: item)
                                    .frame(maxWidth: 100)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    VStack(spacing: 16) {
                        ForEach(viewModel.rightColumn) { item in
                            NavigationLink(destination: InfoView(animal: item)) {
                                CompactAnimalView(animal: item)
                                    .frame(maxWidth: 100)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
