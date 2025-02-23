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
                Color.white
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
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
                        let point = CGPoint(x: value.location.x, y: value.location.y)
                        viewModel.addPointToCurrentLine(point)
                    }
                    .onEnded { value in
                        viewModel.endCurrentLine()
                    }
            )
        }
        .frame(width: canvasSize.width, height: canvasSize.height)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

