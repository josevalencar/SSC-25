//
//  DigitRecognition.swift
//  Brian
//
//  Created by José Vitor Alencar on 17/02/25.
//

import SwiftUI

struct DigitRecognitionView: View {
    @StateObject private var viewModel = DigitViewModel()
    let canvasSize = CGSize(width: 300, height: 300)
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Handwritten Digit Recognition")
                .font(.headline)
            
            DrawingCanvas(viewModel: viewModel, canvasSize: canvasSize)
                .frame(width: canvasSize.width, height: canvasSize.height)
                .border(Color.gray, width: 1)
            
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
                Text("Recognized Digit: \(digit)")
                    .font(.title2)
                Text(String(format: "Confidence: %.2f", viewModel.recognizedConfidence ?? 0))
                    .font(.subheadline)
            }
            
            if let debugImg = viewModel.debugImage {
                Text("Processed Input (28×28)")
                    .font(.footnote)
                Image(uiImage: debugImg)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .border(Color.white, width: 1)
            }
        }
        .padding()
    }
}
