////
////  YOLOView.swift
////  Brian
////
////  Created by José Vitor Alencar on 23/02/25.
////
//
//import SwiftUI
//
//struct YOLOView: View {
//    @StateObject private var objectDetector = ObjectDetector()
//    
//    var body: some View {
//        ZStack {
//            // CameraView wraps the UIKit camera preview and sends frames to the detector.
//            CameraView(objectDetector: objectDetector)
//                .edgesIgnoringSafeArea(.all)
//            
//            // Overlay bounding boxes for each detected object.
//            ForEach(objectDetector.detections, id: \.self) { detection in
//                BoundingBoxView(detection: detection)
//            }
//        }
//    }
//}
