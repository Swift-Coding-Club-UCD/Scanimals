//
//  HomeView.swift
//  Scanimals
//
//  Created by Adam Lee on 4/14/25.
//
import SwiftUI


struct HomeView : View {
    @EnvironmentObject var viewModel: HomeViewModel

    
    var body: some View {
        // NavigationStack allows the user to tap on a view
        // and be directed to another view
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Recently Scanned")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    
                    // Iterate through each scanned animal in the HomeViewModel
                    ForEach(viewModel.scannedItems) { item in
                        // Wrapping a view within a NavigationLink allows us to set a destination view for the wrapped view
                        // Here, the destination is our InfoView
                        // each item within the HomeViewModel is a ScannedAnimal which conforms to InfoView's animal parameter
                        NavigationLink(destination: InfoView(animal: item)) {
                            ScannedAnimalView(animal: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
        
    }
}

#Preview {
    HomeView()
}
