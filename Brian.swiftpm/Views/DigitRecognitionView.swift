//
//  DigitRecognition.swift
//  Brian
//
//  Created by José Vitor Alencar on 17/02/25.
//

import SwiftUI

struct DigitRecognitionView: View {
    @StateObject private var viewModel = DigitViewModel()
    
    // Adjust to an appropriate size that fits your layout
    let canvasSize = CGSize(width: 300, height: 300)
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Handwritten Digit Recognition")
                .font(.headline)
            
            DrawingCanvas(viewModel: viewModel, canvasSize: canvasSize)
            
            HStack {
                Button("Recognize") {
                    viewModel.recognizeDigit(canvasSize: canvasSize)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button("Clear") {
                    viewModel.clearDrawing()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            if let digit = viewModel.recognizedDigit {
                Text("Recognized Digit: \(digit.value)")
                    .font(.title2)
                    .padding(.top, 8)
                Text(String(format: "Confidence: %.2f", digit.confidence))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                Text("Draw a digit above, then tap 'Recognize'")
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
    }
}
