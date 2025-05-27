//
//  CameraService.swift
//  Scanimals
//
//  Created by Adam Lee on 5/26/25.
//
import AVFoundation
import UIKit

/// Manages a single back-camera session for photo capture
final class CameraService: NSObject, AVCapturePhotoCaptureDelegate, ObservableObject {
    static let shared = CameraService()
    @Published var photo: UIImage?

    private let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private var isSessionConfigured = false

    /// Configure session once: back camera input + photo output
    func configureSession() throws {
        guard !isSessionConfigured else { return }
        session.beginConfiguration()
        session.sessionPreset = .photo

        // Back camera input
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            throw CameraError.noBackCamera
        }
        let input = try AVCaptureDeviceInput(device: device)
        guard session.canAddInput(input) else {
            throw CameraError.unableToAddInput
        }
        session.addInput(input)

        // Photo output
        guard session.canAddOutput(output) else {
            throw CameraError.unableToAddOutput
        }
        session.addOutput(output)

        output.maxPhotoDimensions = output.maxPhotoDimensions


        session.commitConfiguration()
        isSessionConfigured = true
    }

    /// Starts running the capture session
    func startSession() {
        guard !session.isRunning else { return }
        // AVFoundation recommends starting on a background queue to avoid locking up the UI
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }

    /// Stops the capture session
    func stopSession() {
        guard session.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.stopRunning()
        }
    }

    /// Triggers a photo capture
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.maxPhotoDimensions = output.maxPhotoDimensions
        output.capturePhoto(with: settings, delegate: self)
    }

    // MARK: - AVCapturePhotoCaptureDelegate

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        if let data = photo.fileDataRepresentation(), let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.photo = image
            }
        }
    }

    /// Expose session for preview
    func getSession() -> AVCaptureSession { session }
}

enum CameraError: Error {
    case noBackCamera, unableToAddInput, unableToAddOutput
}
