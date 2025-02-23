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
            Text("Draw a number from 0-9 in the box below and press Recognize to identify it.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            DrawingCanvas(viewModel: viewModel, canvasSize: canvasSize)
                .frame(width: canvasSize.width, height: canvasSize.height)
                .fixedSize()
            
            if let digit = viewModel.recognizedDigit {
                VStack {
                    Text("Recognized Digit: \(digit)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.indigo)
                    Text(String(format: "Confidence: %.2f", viewModel.recognizedConfidence ?? 0))
                        .font(.subheadline)
                        .foregroundStyle(.indigo)
                }
                .padding()
            }
            
            HStack {
                Button("Recognize") {
                    viewModel.recognizeDigit(canvasSize: canvasSize)
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button("Clear") {
                    viewModel.clearDrawing()
                }
                .padding()
                .background(Color.indigo)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
    }
}

