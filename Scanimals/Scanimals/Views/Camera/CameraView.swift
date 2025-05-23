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
    // private var only accessible within the view
    // state to store the selected image in UIImage format
    @State private var selectedImage: UIImage? 
    // label to display the classification result
    @State private var classificationLabel: String = "No image selected"
    // state to control the camera view
    @State private var showingCamera = false
    // access the shared view model to update the scannedItems array
    @EnvironmentObject var homeViewModel: HomeViewModel
    // state to store the current animal name
    @State private var currentAnimalName: String = ""

    var body: some View {
        VStack {
            // displayes selected Image user picked
            // if selectedImage is not nil, display the image
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
                
                // PhotosPicker is a SwiftUI view that allows users to pick images from the photo library
                // selection is the binding to the photoItem state variable, which is used to store the selected photo
                // matching is the type of media that can be picked, in this case only images
                // onChange is a closure that is called when the photoItem state variable is changed, in this case when the user picks a photo
                // loadImage() is a function that is called when the user picks a photo, it is used to load the selected photo into the selectedImage state variable

                PhotosPicker("Pick from Gallery", selection: $photoItem, matching: .images)
                    .onChange(of: photoItem) { _ in loadImage() }
            }
            
        }
        // sheet is a SwiftUI view that allows you to present a modal view
        // isPresented is a binding to the showingCamera state variable, which is used to control whether the camera view is displayed
        // onDismiss is a closure that is called when the camera view is dismissed, in this case when the user takes a photo or picks a photo from the gallery
        // InCameraView is the view that is presented when the user takes a photo or picks a photo from the gallery
        // selectedImage is the binding to the selectedImage state variable, which is used to store the selected photo
        .sheet(isPresented: $showingCamera, onDismiss: classifySelectedImage) {
            InCameraView(selectedImage: $selectedImage)
        }
    }
    

    // state variable to store the selected photo from the photo library
    @State private var photoItem: PhotosPickerItem?

    // loadImage() is a function that is called when the user picks a photo, it is used to load the selected photo into the selectedImage state variable
    func loadImage() {
        // if photoItem is nil, return
        guard let photoItem else { return }
        // Task is a SwiftUI view that allows you to perform asynchronous operations
        // async allows you to run code concurrently without blocking the main thread
        // await is used to wait for the photoItem to be loaded into the selectedImage state variable
        
        Task {
            // load raw data of the selected photo
            if let data = try? await photoItem.loadTransferable(type: Data.self),
               // convert raw data to uIImage that Swift can display
               // binary image data into an actual image in UIImage format

               let uiImage = UIImage(data: data) {
                // set the selectedImage state variable to the uiImage
                selectedImage = uiImage
                // classify the selected photo using the classify function
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
        //convert UIImage to CIImage, which is the image processing format
        guard let ciImage = CIImage(image: image),
              //load model from the model file using VNCoreMLModel
              let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
            classificationLabel = "Failed to load model"
            return
        }
        // VNCoreMLRequest is a class that is used to classify images using a Core ML model
        // model is the model that is used to classify the image
        // request is the request to classify the image
        // error is the error that is returned if the image cannot be classified
        // results is the results of the classification
        // top is the top result of the classification
        // identifier is the identifier of the top result
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let top = results.first else {
                classificationLabel = "Failed to classify"
                return
            }
            // set the classificationLabel state variable to the top result of the classification
            // top.identifier is the identifier of the top result
            // top.confidence is the confidence of the top result
            // Int(top.confidence * 100) is the confidence of the top result as an integer
            classificationLabel = "\(top.identifier) (\(Int(top.confidence * 100))%)"
            // add the top result to the scannedItems array
            addScannedAnimal(name: top.identifier)
        }

        // DispatchQueue is a class that is used to manage the execution of tasks
        DispatchQueue.global(qos: .userInitiated).async {
            // VNImageRequestHandler is a class that is used to handle image requests
            // ciImage is the image that is being classified
            // handler is the handler for the image request
            let handler = VNImageRequestHandler(ciImage: ciImage)
            // perform the request
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
             image: image   // store the real UIImage
         )

         homeViewModel.scannedItems.insert(newAnimal, at: 0)
     }
    
}

#Preview {
    ContentView()
        .environmentObject(HomeViewModel())  // ✅ ADD THIS
}
