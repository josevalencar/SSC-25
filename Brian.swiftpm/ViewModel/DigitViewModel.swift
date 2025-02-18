//
//  Untitled.swift
//  Brian
//
//  Created by José Vitor Alencar on 17/02/25.
//

import SwiftUI
import CoreML
import Vision
import UIKit

class DigitViewModel: ObservableObject {
    @Published var recognizedDigit: RecognizedDigit?
    @Published var drawings: [[CGPoint]] = []   // Completed lines
    @Published var currentLine: [CGPoint] = []  // The in-progress line

    // 1) Use MLModel instead of MNISTClassifier
    private let model: MLModel

    init() {
        // 2) Load the compiled model manually
        guard let modelURL = Bundle.module.url(forResource: "MNISTClassifier", withExtension: "mlmodelc"),
              let compiledModel = try? MLModel(contentsOf: modelURL)
        else {
            fatalError("Could not load MNISTClassifier.mlmodelc")
        }
        self.model = compiledModel
    }

    func addPointToCurrentLine(_ point: CGPoint) {
        currentLine.append(point)
    }

    func endCurrentLine() {
        // When user lifts their finger, finalize the line
        drawings.append(currentLine)
        currentLine.removeAll()
    }

    func clearDrawing() {
        drawings.removeAll()
        currentLine.removeAll()
        recognizedDigit = nil
    }

    // 3) Convert the SwiftUI drawing into an image, downsize to 28×28,
    //    and pass it to the MLModel via a dictionary feature provider.
    func recognizeDigit(canvasSize: CGSize) {
        let image = renderDrawingAsUIImage(size: canvasSize)

        // Scale image to 28×28 (MNIST's expected size)
        guard let resizedImage = image?.resizeImageTo(size: CGSize(width: 28, height: 28)),
              let pixelBuffer = resizedImage.toPixelBuffer() else {
            return
        }

        do {
            // 4) Prepare the pixelBuffer as an MLFeatureValue
            let inputFeatureValue = MLFeatureValue(pixelBuffer: pixelBuffer)
            
            // The Core ML model likely expects an input feature named "image"
            // (It depends on your actual model. Check the .mlmodel’s description.)
            let provider = try MLDictionaryFeatureProvider(dictionary: [
                "image": inputFeatureValue
            ])
            
            // 5) Run inference with the raw MLModel
            let result = try model.prediction(from: provider)

            // Typically, a classifier model has "classLabel" and "classLabelProbs".
            if let predictedString = result.featureValue(for: "classLabel")?.stringValue,
               let predictedValue = Int(predictedString) {
                
                // Confidence is often in a dictionary keyed by the predicted label
                // under "classLabelProbs".
                if let probsDict = result.featureValue(for: "classLabelProbs")?.dictionaryValue,
                   let confidenceVal = probsDict[predictedString]?.floatValue {
                    
                    recognizedDigit = RecognizedDigit(value: predictedValue,
                                                      confidence: confidenceVal)
                } else {
                    recognizedDigit = RecognizedDigit(value: predictedValue, confidence: 0)
                }
            }
        } catch {
            print("Error during prediction: \(error)")
        }
    }

    // Renders all drawn lines into a UIImage at the given size.
    private func renderDrawingAsUIImage(size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))

            UIColor.black.setStroke()
            context.cgContext.setLineWidth(15)
            context.cgContext.setLineCap(.round)

            // Finished lines
            for line in drawings {
                if let firstPoint = line.first {
                    context.cgContext.move(to: firstPoint)
                    for point in line.dropFirst() {
                        context.cgContext.addLine(to: point)
                    }
                    context.cgContext.strokePath()
                }
            }
            // In-progress line
            if let firstPoint = currentLine.first {
                context.cgContext.move(to: firstPoint)
                for point in currentLine.dropFirst() {
                    context.cgContext.addLine(to: point)
                }
                context.cgContext.strokePath()
            }
        }
    }
}

// MARK: - UIImage Extensions for resizing & pixelBuffer
extension UIImage {
    func resizeImageTo(size targetSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: targetSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func toPixelBuffer() -> CVPixelBuffer? {
        let width = Int(size.width)
        let height = Int(size.height)
        
        let attrs: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ]
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width, height,
            kCVPixelFormatType_OneComponent8,
            attrs as CFDictionary,
            &pixelBuffer
        )
        guard status == kCVReturnSuccess, let pb = pixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pb, [])
        guard let context = CGContext(
            data: CVPixelBufferGetBaseAddress(pb),
            width: width, height: height,
            bitsPerComponent: 8, bytesPerRow: width,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGImageAlphaInfo.none.rawValue
        ) else {
            CVPixelBufferUnlockBaseAddress(pb, [])
            return nil
        }
        
        context.draw(cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(pb, [])
        return pb
    }
}
