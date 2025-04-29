//
//  ScanView.swift
//  Scanimals
//
//  Created by Adam Lee on 4/15/25.
//



//
//  ContentView.swift
//  image classificarion
//
//  Created by Yan Bin Jiang on 4/22/25.
//

import SwiftUI
import UIKit
import CoreML
import Vision
import PhotosUI

struct CameraView: View {
    @State private var selectedImage: UIImage?
    @State private var classificationLabel: String = "No image selected"
    @State private var showingCamera = false
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var currentAnimalName: String = ""

    var body: some View {
        VStack {
            // displayes selected Image user picked
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }
            
            // Displays the classified text
            Text(classificationLabel).padding()
            
            // take photo and gallery buttons
            HStack(spacing: 20) {
                Button("Take Photo") {
                    showingCamera = true
                }
                
                //update photoItem to photo user picks and loads it
                PhotosPicker("Pick from Gallery", selection: $photoItem, matching: .images)
                    .onChange(of: photoItem) { _ in loadImage() }
            }
            
        }
        .sheet(isPresented: $showingCamera, onDismiss: classifySelectedImage) {
            InCameraView(selectedImage: $selectedImage)
        }
    }
    
    //PhotoPickerItem is selected photo form PhotoPickers
    @State private var photoItem: PhotosPickerItem?

    func loadImage() {
        guard let photoItem else { return }
        // start async operation
        Task {
            // get raw data of the selected photo
            if let data = try? await photoItem.loadTransferable(type: Data.self),
               // convert raw data to uIImage that Swift can show
               let uiImage = UIImage(data: data) {
                selectedImage = uiImage
                classify(image: uiImage)
            }
        }
    }
    
    func classifySelectedImage() {
        if let image = selectedImage {
            classify(image: image)
        }
    }

    func classify(image: UIImage) {
        //convert uIImage to CIImage into image processing format
        guard let ciImage = CIImage(image: image),
              //load model
              let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
            classificationLabel = "Failed to load model"
            return
        }
        // request to classify the image
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let top = results.first else {
                classificationLabel = "Failed to classify"
                return
            }
            classificationLabel = "\(top.identifier) (\(Int(top.confidence * 100))%)"
            addScannedAnimal(name: top.identifier)
        }

        //creates a separate background thread for performing the request
        DispatchQueue.global(qos: .userInitiated).async {
            // takes the CIImage and executes our ML Model
            let handler = VNImageRequestHandler(ciImage: ciImage)
            do {
                try handler.perform([request])
            } catch {
                classificationLabel = "Classification error: \(error.localizedDescription)"
            }
        }
    }
    func addScannedAnimal(name: String) {
         guard let image = selectedImage else { return }

         let newAnimal = ScannedAnimal(
             name: name,
             imageName: "", // No file name needed now
             fact: "",      // Empty for now
             image: image   // ✅ Store the real UIImage
         )

         homeViewModel.scannedItems.insert(newAnimal, at: 0)
     }
    
}

#Preview {
    ContentView()
        .environmentObject(HomeViewModel())  // ✅ ADD THIS
}
