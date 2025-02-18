//
//  DigitRecognition.swift
//  Brian
//
//  Created by José Vitor Alencar on 17/02/25.
//

import SwiftUI

struct DigitRecognitionView: View {
    @StateObject private var viewModel = DigitViewModel()
    
    // The size of your drawing canvas in the UI
    let canvasSize = CGSize(width: 300, height: 300)
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Handwritten Digit Recognition")
                .font(.headline)
            
            // 1) The interactive drawing canvas
            DrawingCanvas(viewModel: viewModel, canvasSize: canvasSize)
                .frame(width: canvasSize.width, height: canvasSize.height)
                .border(Color.gray, width: 1)
            
            // 2) Buttons for Recognize & Clear
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
            
            // 3) Show the recognized digit & confidence
            if let digit = viewModel.recognizedValue {
                Text("Recognized Digit: \(digit)")
                    .font(.title2)
                    .foregroundColor(.gray)
                Text(String(format: "Confidence: %.2f", viewModel.recognizedConfidence ?? 0))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                Text("Draw a digit above, then tap 'Recognize'")
                    .foregroundColor(.gray)
            }

            
            // 4) Show a debug preview of the 28x28 image
            if let debugImg = viewModel.debugImage {
                Text("Model Input Preview (28×28) [Pre-Inversion?]")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Image(uiImage: debugImg)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .border(Color.white, width: 1)
            }
            
            Spacer()
        }
        .padding()
    }
}
