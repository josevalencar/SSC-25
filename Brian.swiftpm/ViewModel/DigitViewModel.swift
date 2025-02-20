//
//  Untitled.swift
//  Brian
//
//  Created by José Vitor Alencar on 17/02/25.
//

import SwiftUI
import CoreML
import UIKit
import CoreVideo

class DigitViewModel: ObservableObject {
    @Published var drawings: [[CGPoint]] = []
    @Published var currentLine: [CGPoint] = []
    
    @Published var recognizedDigit: String?
    @Published var recognizedConfidence: Double?
    @Published var debugImage: UIImage?
    
    private let model: MLModel
    
    init() {
        guard let modelURL = Bundle.main.url(forResource: "MNISTClassifier", withExtension: "mlmodelc") else {
            fatalError("Could not find MNISTClassifier.mlmodelc in the bundle.")
        }
        do {
            self.model = try MLModel(contentsOf: modelURL)
            print("Loaded MNIST Model Successfully")
        } catch {
            fatalError("Error loading MLModel: \(error)")
        }
    }
    
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
        recognizedDigit = nil
        recognizedConfidence = nil
        debugImage = nil
    }
    
    func recognizeDigit(canvasSize: CGSize) {
        guard let drawnImage = renderDrawingAsUIImage(size: canvasSize) else {
            print("Failed to render drawing.")
            return
        }
        
        debugImage = drawnImage
        
        guard let pixelBuffer = drawnImage.pixelBufferScaledTo28x28() else {
            print("Failed to preprocess image.")
            return
        }
        
        do {
            let inputVal = MLFeatureValue(pixelBuffer: pixelBuffer)
            let provider = try MLDictionaryFeatureProvider(dictionary: ["image": inputVal])
            let result = try model.prediction(from: provider)
            
            if let classInt64 = result.featureValue(for: "classLabel")?.int64Value {
                let predictedInt = Int(classInt64)
                recognizedDigit = String(predictedInt)
                
                if let probs = result.featureValue(for: "labelProbabilities")?.dictionaryValue {
                    recognizedConfidence = (probs[NSNumber(value: predictedInt)])?.doubleValue ?? 0.0
                } else {
                    recognizedConfidence = 0.0
                }
                
                print("Predicted: \(recognizedDigit ?? "?"), Confidence: \(recognizedConfidence ?? 0.0)")
            }
        } catch {
            print("Model Prediction Error: \(error)")
        }
    }
    
    private func renderDrawingAsUIImage(size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            UIColor.black.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            UIColor.white.setStroke()
            context.cgContext.setLineWidth(20)
            context.cgContext.setLineCap(.round)
            
            for line in drawings {
                guard let first = line.first else { continue }
                context.cgContext.move(to: first)
                for pt in line.dropFirst() {
                    context.cgContext.addLine(to: pt)
                }
                context.cgContext.strokePath()
            }
        }
    }
}

// MARK: - UIImage Extensions

extension UIImage {
    func pixelBufferScaledTo28x28() -> CVPixelBuffer? {
        let targetSize = CGSize(width: 28, height: 28)
        
        let attrs: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ]
        
        var pixelBuffer: CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault,
                            Int(targetSize.width),
                            Int(targetSize.height),
                            kCVPixelFormatType_OneComponent8,
                            attrs as CFDictionary,
                            &pixelBuffer)
        
        guard let finalBuffer = pixelBuffer, let cgImage = self.cgImage else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(finalBuffer, [])
        defer { CVPixelBufferUnlockBaseAddress(finalBuffer, []) }
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        guard let context = CGContext(
            data: CVPixelBufferGetBaseAddress(finalBuffer),
            width: Int(targetSize.width),
            height: Int(targetSize.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(finalBuffer),
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.none.rawValue
        ) else {
            return nil
        }
        
        context.setFillColor(UIColor.black.cgColor)
        context.fill(CGRect(origin: .zero, size: targetSize))
        
        let drawRect = CGRect(origin: .zero, size: targetSize)
        context.draw(cgImage, in: drawRect)
        
        return finalBuffer
    }
}
