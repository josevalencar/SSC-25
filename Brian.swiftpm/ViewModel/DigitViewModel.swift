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
        
        guard let finalMNIST = drawnImage.centerAndScaleMNISTStyle() else {
            print("Failed to preprocess for MNIST.")
            return
        }
        
        debugImage = finalMNIST
        
        guard let pixelBuffer = finalMNIST.toPixelBufferGray() else {
            print("Failed to create pixel buffer.")
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
                    let numericKey = NSNumber(value: predictedInt)
                    recognizedConfidence = (probs[numericKey])?.doubleValue ?? 0.0
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
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            UIColor.black.setStroke()
            context.cgContext.setLineWidth(20) // **Increased thickness**
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
    func resizeImageTo(size targetSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: targetSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// This function transforms a black-on-white drawing into
    /// a standard MNIST style: white digit on black, 28×28, centered, ~20×20 bounding box.
    func centerAndScaleMNISTStyle() -> UIImage? {
        // 1) Find bounding box of non-white pixels
        guard let cropped = self.cropBoundingBoxOfDrawing() else {
            // If there's no drawing, return a blank 28x28 black
            return UIImage.blankMNIST()
        }
        
        // 2) Scale to ~20x20
        let targetDigitSize: CGFloat = 20
        let cropW = cropped.size.width
        let cropH = cropped.size.height
        let maxDim = max(cropW, cropH)
        let scale = targetDigitSize / maxDim
        
        let newW = Int(cropW * scale)
        let newH = Int(cropH * scale)
        guard let scaled = cropped.resizeImageTo(size: CGSize(width: newW, height: newH)) else {
            return nil
        }
        
        // 3) Create a 28x28 black background, center the scaled digit
        let finalSize = CGSize(width: 28, height: 28)
        UIGraphicsBeginImageContextWithOptions(finalSize, false, 1.0)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        // Fill with black
        UIColor.black.setFill()
        ctx.fill(CGRect(origin: .zero, size: finalSize))
        
        // The offset to center it
        let offsetX = (28 - CGFloat(newW)) / 2
        let offsetY = (28 - CGFloat(newH)) / 2
        
        // Now, our scaled is black-on-white => we want to invert to white-on-black
        // We'll do that last. First let's just draw black-on-white
        scaled.draw(in: CGRect(x: offsetX, y: offsetY, width: CGFloat(newW), height: CGFloat(newH)))
        
        // That result is black lines on black background except for the white bounding box
        // So let's grab it
        let intermediate = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // 4) Invert that entire 28x28 so the lines become white and the background black
        guard let final = intermediate?.invertGrayscale28x28() else {
            return intermediate
        }
        
        return final
    }
    
    /// Crops out all the white space. If fully white, returns nil.
    private func cropBoundingBoxOfDrawing() -> UIImage? {
        guard let cgImg = self.cgImage else { return nil }
        
        let width = cgImg.width
        let height = cgImg.height
        let bytesPerPixel = 4
        
        // 1) Draw into RGBA context to read pixels
        guard let colorSpace = cgImg.colorSpace else { return nil }
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * bytesPerPixel,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return nil
        }
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.draw(cgImg, in: rect)
        
        guard let data = context.data?.bindMemory(to: UInt8.self, capacity: width*height*bytesPerPixel) else {
            return nil
        }
        
        // 2) Find bounding box of “non-white” pixels
        var minX = width, maxX = 0
        var minY = height, maxY = 0
        
        for y in 0..<height {
            for x in 0..<width {
                let offset = (y * width + x) * bytesPerPixel
                let r = data[offset + 0]
                let g = data[offset + 1]
                let b = data[offset + 2]
                // let a = data[offset + 3] // alpha if needed
                
                // If it's not near-white, treat it as drawn
                // Adjust threshold if lines are faint
                if r < 250 || g < 250 || b < 250 {
                    if x < minX { minX = x }
                    if x > maxX { maxX = x }
                    if y < minY { minY = y }
                    if y > maxY { maxY = y }
                }
            }
        }
        
        if minX > maxX || minY > maxY {
            // No non-white pixel found => blank
            return nil
        }
        
        let cropWidth = maxX - minX + 1
        let cropHeight = maxY - minY + 1
        
        guard let croppedCG = cgImg.cropping(to: CGRect(x: minX, y: minY, width: cropWidth, height: cropHeight)) else {
            return nil
        }
        
        return UIImage(cgImage: croppedCG)
    }
    
    /// Invert the grayscale of a 28x28 image (assuming black-on-white).
    func invertGrayscale28x28() -> UIImage? {
        guard let cgImg = self.cgImage else { return nil }
        
        let width = 28, height = 28
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGImageAlphaInfo.none.rawValue
        ) else {
            return nil
        }
        
        context.draw(cgImg, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buf = context.data?.bindMemory(to: UInt8.self, capacity: width*height) else {
            return nil
        }
        
        // Invert each pixel
        for i in 0..<(width*height) {
            buf[i] = 255 - buf[i]
        }
        
        guard let invertedCG = context.makeImage() else { return nil }
        return UIImage(cgImage: invertedCG)
    }
    
    /// Creates a blank 28x28 black image
    static func blankMNIST() -> UIImage? {
        let size = CGSize(width: 28, height: 28)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        UIColor.black.setFill()
        ctx.fill(CGRect(origin: .zero, size: size))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    /// Convert an already 28×28, white-on-black UIImage to an 8-bit grayscale pixel buffer
    func toPixelBufferGray() -> CVPixelBuffer? {
        let width = Int(size.width)
        let height = Int(size.height)
        
        let attrs: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ]
        
        var pb: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width, height,
            kCVPixelFormatType_OneComponent8,
            attrs as CFDictionary,
            &pb
        )
        guard status == kCVReturnSuccess, let pixelBuffer = pb else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, [])
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, []) }
        
        guard let context = CGContext(
            data: CVPixelBufferGetBaseAddress(pixelBuffer),
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGImageAlphaInfo.none.rawValue
        ) else {
            return nil
        }
        
        if let cgImg = self.cgImage {
            context.draw(cgImg, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
        return pixelBuffer
    }
}
