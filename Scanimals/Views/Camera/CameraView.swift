//
//  CameraView.swift
//  image classificarion
//
//  Created by Yan Bin Jiang on 4/22/25.
//
import SwiftUI

struct CameraView: View {
    @EnvironmentObject private var homeVM: HomeViewModel
    @StateObject private var viewModel = CameraViewModel()
    @State private var path = NavigationPath() // For NavigationStack
    // Keep track of the last count of path to detect pop specifically
    @State private var previousPathCount = 0

    var body: some View {
        NavigationStack(path: $path) { //
            ZStack {
                CameraPreview(session: viewModel.session) //
                    .ignoresSafeArea()

                VStack { //
                    Spacer()
                    Button(action: viewModel.capture) { //
                        Circle()
                            .strokeBorder(.white, lineWidth: 4)
                            .frame(width: 70, height: 70)
                            .background(Circle().fill(Color.white.opacity(0.2)))
                    }
                    .padding(.bottom, 20)
                }

                // Status overlay
                VStack(alignment: .leading, spacing: 8) { //
                    Text(viewModel.classificationLabel) //
                        .font(.headline)
                    if let error = viewModel.errorMessage { //
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .navigationDestination(for: ScannedAnimal.self) { animal in //
                InfoView(animal: animal)
            }
            .onAppear {
                viewModel.startCameraSession() // Make sure this method name matches CameraViewModel
                
                viewModel.onAnimalScanned = { animal in //
                    homeVM.scannedItems.insert(animal, at: 0) //
                    path.append(animal) // This triggers navigation
                }
                // If path is empty when view appears (e.g. returning to tab), ensure reset state.
                if path.isEmpty {
                    viewModel.clearAndResetState()
                }
            }
            .onDisappear {
                viewModel.stopCameraSession() // Make sure this method name matches CameraViewModel
            }
            .onChange(of: path) { newPath in
                // If newPath is empty AND previousPathCount was greater than 0,
                // it means we've popped back to the root (CameraView).
                if newPath.isEmpty && previousPathCount > 0 {
                    viewModel.clearAndResetState()
                }
                previousPathCount = newPath.count
            }
        }
        // This was in your provided code, if CameraView is a root of a tab in ContentView
        // it might already be getting homeVM from ContentView's environment.
        // If not, and it's presented some other way, this explicit injection is needed.
        // .environmentObject(homeVM) // - Usually not needed if already in environment
    }
}
