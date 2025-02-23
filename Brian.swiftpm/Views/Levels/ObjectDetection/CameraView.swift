////
////  CameraView.swift
////  Brian
////
////  Created by José Vitor Alencar on 23/02/25.
////
//
//import SwiftUI
//import UIKit
//import AVFoundation
//import CoreImage
//
//struct CameraView: UIViewRepresentable {
//    @ObservedObject var objectDetector: ObjectDetector
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(objectDetector: objectDetector)
//    }
//    
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView()
//        let session = AVCaptureSession()
//        session.sessionPreset = .high
//        
//        guard let device = AVCaptureDevice.default(for: .video),
//              let input = try? AVCaptureDeviceInput(device: device) else {
//            return view
//        }
//        session.addInput(input)
//        
//        // Setup video output.
//        let output = AVCaptureVideoDataOutput()
//        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
//        output.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "camera.frame.processing"))
//        session.addOutput(output)
//        
//        // Configure preview layer.
//        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
//        previewLayer.videoGravity = .resizeAspectFill
//        previewLayer.frame = view.bounds
//        view.layer.addSublayer(previewLayer)
//        
//        // Start the session.
//        session.startRunning()
//        
//        // Keep the preview layer updated with view bounds.
//        view.layer.masksToBounds = true
//        return view
//    }
//    
//    func updateUIView(_ uiView: UIView, context: Context) {
//        DispatchQueue.main.async {
//            if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
//                previewLayer.frame = uiView.bounds
//            }
//        }
//    }
//    
//    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
//        let objectDetector: ObjectDetector
//        private let processingQueue = DispatchQueue(label: "object.detection.queue")
//
//        init(objectDetector: ObjectDetector) {
//            self.objectDetector = objectDetector
//        }
//
//        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//            // Convert sample buffer to CIImage (thread-safe)
//            guard let ciImage = sampleBuffer.toCIImage() else { return }
//
//            processingQueue.async { [weak self] in
//                guard let self = self else { return }
//
//                Task { @MainActor in
//                    await self.objectDetector.detectObjects(in: ciImage)
//                }
//            }
//        }
//    }
//}
//
//// MARK: - Helper: Convert CMSampleBuffer to CIImage
//extension CMSampleBuffer {
//    func toCIImage() -> CIImage? {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(self) else { return nil }
//        return CIImage(cvPixelBuffer: pixelBuffer)
//    }
//}
