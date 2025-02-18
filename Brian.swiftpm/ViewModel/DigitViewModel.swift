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
    // MARK: - Drawing State
    
    @Published var drawings: [[CGPoint]] = []
    @Published var currentLine: [CGPoint] = []
    
    // MARK: - Recognition Results
    
    @Published var recognizedValue: Int?
    @Published var recognizedConfidence: Float?
    
    // MARK: - Debug Image
    
    /// The final 28×28 image we feed the model (black on white)
    @Published var debugImage: UIImage?
    
    // MARK: - Core ML Model
    
    private let model: MLModel
    
    init() {
        // Adjust for your environment:
        //  - If it's a regular Xcode app, use Bundle.main
        //  - If it's a SwiftPM/Playgrounds approach, use Bundle.module
        guard let modelURL = Bundle.main.url(forResource: "MNISTClassifier", withExtension: "mlmodelc") else {
            fatalError("Could not find MNISTClassifier.mlmodelc in the bundle.")
        }
        
        do {
            self.model = try MLModel(contentsOf: modelURL)
            print("Loaded MNISTClassifier from \(modelURL.lastPathComponent)")
        } catch {
            fatalError("Error loading MNISTClassifier: \(error)")
        }
    }
    
    // MARK: - Drawing Interaction
    
    func addPointToCurrentLine(_ point: CGPoint) {
        currentLine.append(point)
    }
    
    func endCurrentLine() {
        drawings.append(currentLine)
        currentLine.removeAll()
    }
    
    func clearDrawing() {
        drawings.removeAll()
        currentLine.removeAll()
        recognizedValue = nil
        recognizedConfidence = nil
        debugImage = nil
    }
    
    // MARK: - Recognition Flow
    
    func recognizeDigit(canvasSize: CGSize) {
        print("Starting recognition…")
        
        // 1) Render user drawing as UIImage (black strokes on white)
        guard let image = renderDrawingAsUIImage(size: canvasSize) else {
            print("Failed to render drawing.")
            return
        }
        
        // 2) Resize to 28×28 (no inversion, no bounding box)
        guard let resized = image.resizeImageTo(size: CGSize(width: 28, height: 28)) else {
            print("Failed to resize image to 28×28.")
            return
        }
        
        // Show exactly what we feed the model
        debugImage = resized
        
        // 3) Convert that 28×28 UIImage to a pixel buffer
        guard let pixelBuffer = resized.toPixelBuffer() else {
            print("Failed to create pixel buffer.")
            return
        }
        
        // 4) Run the model
        do {
            let featureVal = MLFeatureValue(pixelBuffer: pixelBuffer)
            let provider = try MLDictionaryFeatureProvider(dictionary: ["image": featureVal])
            let result = try model.prediction(from: provider)
            
            // 5) Extract result from "classLabel" (likely Int64) & "labelProbabilities"
            if let classVal = result.featureValue(for: "classLabel")?.int64Value {
                let predictedInt = Int(classVal)
                
                if let probsDict = result.featureValue(for: "labelProbabilities")?.dictionaryValue {
                    let key = String(predictedInt) // e.g. "0"..."9"
                    let conf = probsDict[key]?.floatValue ?? 0.0
                    recognizedValue = predictedInt
                    recognizedConfidence = conf
                    print("Predicted digit: \(predictedInt), confidence: \(conf)")
                } else {
                    recognizedValue = predictedInt
                    recognizedConfidence = 0.0
                    print("Predicted digit: \(predictedInt), no probabilities dict.")
                }
            } else {
                print("Could not parse classLabel as Int64.")
            }
        } catch {
            print("Prediction error: \(error)")
        }
    }
    
    // MARK: - Render User Drawing
    
    /// Renders all lines as black strokes on a white background, at the given canvas size
    private func renderDrawingAsUIImage(size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            // White background
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            // Black stroke
            UIColor.black.setStroke()
            context.cgContext.setLineWidth(15)
            context.cgContext.setLineCap(.round)
            
            // Draw finished lines
            for line in drawings {
                guard let first = line.first else { continue }
                context.cgContext.move(to: first)
                for pt in line.dropFirst() {
                    context.cgContext.addLine(to: pt)
                }
                context.cgContext.strokePath()
            }
            
            // Draw in-progress line
            if let first = currentLine.first {
                context.cgContext.move(to: first)
                for pt in currentLine.dropFirst() {
                    context.cgContext.addLine(to: pt)
                }
                context.cgContext.strokePath()
            }
        }
    }
}

extension UIImage {
    /// Resizes the image to the target CGSize
    func resizeImageTo(size targetSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: targetSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Converts the UIImage into a single-channel (grayscale) CVPixelBuffer
    /// No color inversion, no bounding box. Just raw draw.
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
            kCVPixelFormatType_OneComponent8, // 8-bit grayscale
            attrs as CFDictionary,
            &pixelBuffer
        )
        guard status == kCVReturnSuccess, let pb = pixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pb, [])
        defer { CVPixelBufferUnlockBaseAddress(pb, []) }
        
        guard let context = CGContext(
            data: CVPixelBufferGetBaseAddress(pb),
            width: width, height: height,
            bitsPerComponent: 8,
            bytesPerRow: width,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGImageAlphaInfo.none.rawValue
        ) else {
            return nil
        }
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        // Draw black-on-white image directly
        context.draw(self.cgImage!, in: rect)
        
        // No inversion
        return pb
    }
}
