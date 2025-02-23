//
//  ObjectDetector.swift
//  Brian
//
//  Created by José Vitor Alencar on 23/02/25.
//

import Foundation
import AVFoundation
import Vision
import CoreML
import SwiftUI

// Struct to represent a detection.
struct Detection: Hashable {
    let boundingBox: CGRect  // Normalized coordinates (0-1)
    let label: String
    let confidence: VNConfidence
}

@MainActor
class ObjectDetector: ObservableObject {
    @Published var detections: [Detection] = []
    
    private var visionModel: VNCoreMLModel?
    private var requests: [VNCoreMLRequest] = []
    
    init() {
        setupDetector()
    }

    // ✅ Load the compiled model
    private func setupDetector() {
        guard let modelURL = Bundle.main.url(forResource: "YOLOv3TinyFP16", withExtension: "mlmodelc") else {
            fatalError("Could not find YOLOv3TinyInt8LUT.mlmodelc in the bundle.")
        }
        
        print("Loading model from: \(modelURL.path)")

        do {
            let model = try MLModel(contentsOf: modelURL)
            self.visionModel = try VNCoreMLModel(for: model)

            let recognitionRequest = VNCoreMLRequest(model: self.visionModel!, completionHandler: detectionDidComplete)
            self.requests = [recognitionRequest]

            print("✅ YOLO Model Loaded Successfully")
        } catch {
            fatalError("🚨 Error loading MLModel: \(error)")
        }
    }

    private func detectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {  // Ensure UI updates are on the main thread
            guard let results = request.results as? [VNRecognizedObjectObservation] else { return }
            let newDetections: [Detection] = results.compactMap { observation in
                guard let topLabel = observation.labels.first else { return nil }
                return Detection(
                    boundingBox: observation.boundingBox,
                    label: topLabel.identifier,
                    confidence: topLabel.confidence
                )
            }
            self.detections = newDetections
        }
    }

    // ✅ Perform object detection on camera frames
    func detectObjects(in sampleBuffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        do {
            try handler.perform(self.requests)
        } catch {
            print("🚨 Vision request failed: \(error)")
        }
    }
}

