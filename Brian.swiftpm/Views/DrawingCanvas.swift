//
//  DrawingCanvas.swift
//  Brian
//
//  Created by José Vitor Alencar on 17/02/25.
//

import SwiftUI

struct DrawingCanvas: View {
    @ObservedObject var viewModel: DigitViewModel
    let canvasSize: CGSize
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // White background
                Color.white
                
                // Draw each finished line
                ForEach(0..<viewModel.drawings.count, id: \.self) { index in
                    Path { path in
                        let line = viewModel.drawings[index]
                        guard let first = line.first else { return }
                        path.move(to: first)
                        for point in line.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    .stroke(Color.black, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                }
                
                // Draw the in-progress line
                Path { path in
                    guard let first = viewModel.currentLine.first else { return }
                    path.move(to: first)
                    for point in viewModel.currentLine.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                .stroke(Color.black, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        // Convert coordinate space from gesture to our canvas
                        let point = CGPoint(x: value.location.x, y: value.location.y)
                        // Add to the current line
                        viewModel.addPointToCurrentLine(point)
                    }
                    .onEnded { value in
                        viewModel.endCurrentLine()
                    }
            )
        }
        .frame(width: canvasSize.width, height: canvasSize.height)
        .border(Color.gray, width: 1)
    }
}
