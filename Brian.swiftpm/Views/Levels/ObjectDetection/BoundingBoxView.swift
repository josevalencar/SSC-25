////
////  BoundingBoxView.swift
////  Brian
////
////  Created by José Vitor Alencar on 23/02/25.
////
//
//import SwiftUI
//
//struct BoundingBoxView: View {
//    var detection: Detection
//    
//    var body: some View {
//        GeometryReader { geometry in
//            let rect = convert(boundingBox: detection.boundingBox, in: geometry.size)
//            ZStack(alignment: .topLeading) {
//                // Draw the bounding box.
//                Rectangle()
//                    .stroke(Color.red, lineWidth: 2)
//                    .frame(width: rect.size.width, height: rect.size.height)
//                    .position(x: rect.midX, y: rect.midY)
//                
//                // Show label and confidence.
//                Text("\(detection.label) \(String(format: "%.2f", detection.confidence))")
//                    .font(.caption)
//                    .foregroundColor(.white)
//                    .padding(4)
//                    .background(Color.red.opacity(0.7))
//                    .position(x: rect.midX, y: max(rect.minY - 10, 10))
//            }
//        }
//    }
//    
//    // Convert the normalized bounding box (with origin at bottom-left) to the view’s coordinate system.
//    func convert(boundingBox: CGRect, in size: CGSize) -> CGRect {
//        // YOLO/Vision bounding boxes are normalized.
//        let width = boundingBox.width * size.width
//        let height = boundingBox.height * size.height
//        let x = boundingBox.minX * size.width
//        // Adjust y since Vision’s coordinate system origin is at the bottom left.
//        let y = (1 - boundingBox.maxY) * size.height
//        return CGRect(x: x, y: y, width: width, height: height)
//    }
//}
