//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 11/02/25.
//

import SwiftUI
import Combine

struct NeuralNetworkView: View {
    var inputLayerCount: Int
    var hiddenLayers: [Int]
    var outputLayerCount: Int
    var neuronWidth: CGFloat
    var neuronHeight: CGFloat
    var neuronSpacing: CGFloat

    @State private var activeLayer: Int = 0
    @State private var timer: AnyCancellable? = nil

    var body: some View {
        VStack {
            Spacer() // Ensures Vertical Centering

            GeometryReader { geometry in
                let totalLayers = 2 + hiddenLayers.count // Input + Hidden + Output
                let layerSpacing = geometry.size.width / CGFloat(totalLayers)

                ZStack {
                    // Ensure Everything is Centered
                    VStack {
                        Spacer()

                        // Neural Network Components
                        ZStack {
                            // Input -> First Hidden Layer
                            if let firstHiddenLayer = hiddenLayers.first {
                                drawConnections(
                                    startLayerCount: inputLayerCount,
                                    endLayerCount: firstHiddenLayer,
                                    startX: layerSpacing,
                                    endX: layerSpacing * 2,
                                    layerIndex: 0
                                )
                            }

                            // Hidden Layers
                            if hiddenLayers.count > 1 {
                                ForEach(Array(hiddenLayers.indices.dropLast()), id: \.self) { index in
                                    drawConnections(
                                        startLayerCount: hiddenLayers[index],
                                        endLayerCount: hiddenLayers[index + 1],
                                        startX: layerSpacing * CGFloat(index + 2),
                                        endX: layerSpacing * CGFloat(index + 3),
                                        layerIndex: index + 1
                                    )
                                }
                            }

                            // Last Hidden Layer -> Output Layer
                            if let lastHiddenLayer = hiddenLayers.last {
                                drawConnections(
                                    startLayerCount: lastHiddenLayer,
                                    endLayerCount: outputLayerCount,
                                    startX: layerSpacing * CGFloat(hiddenLayers.count + 1),
                                    endX: layerSpacing * CGFloat(hiddenLayers.count + 2),
                                    layerIndex: hiddenLayers.count
                                )
                            }

                            // Neurons
                            drawNeurons(count: inputLayerCount, xPos: layerSpacing, layerIndex: 0)

                            ForEach(Array(hiddenLayers.enumerated()), id: \.offset) { index, neurons in
                                drawNeurons(
                                    count: neurons,
                                    xPos: layerSpacing * CGFloat(index + 2),
                                    layerIndex: index + 1
                                )
                            }

                            drawNeurons(count: outputLayerCount, xPos: layerSpacing * CGFloat(hiddenLayers.count + 2), layerIndex: hiddenLayers.count + 1)
                        }
                        .frame(maxWidth: .infinity, alignment: .center) // Fix Centering
                        .padding(.horizontal)
                        .padding(.top, 20) // Avoids clipping

                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // Fix Centering

            Spacer()
        }
        .onAppear {
            startAnimation()
        }
        .onDisappear {
            stopAnimation()
        }
    }

    // MARK: - Draw Connections Between Layers
    private func drawConnections(startLayerCount: Int, endLayerCount: Int, startX: CGFloat, endX: CGFloat, layerIndex: Int) -> some View {
        ForEach(0..<startLayerCount, id: \.self) { startIndex in
            ForEach(0..<endLayerCount, id: \.self) { endIndex in
                Line(
                    start: CGPoint(
                        x: startX,
                        y: neuronSpacing * CGFloat(startIndex) + neuronSpacing / 2
                    ),
                    end: CGPoint(
                        x: endX,
                        y: neuronSpacing * CGFloat(endIndex) + neuronSpacing / 2
                    )
                )
                .stroke(
                    isEdgeActive(fromLayer: layerIndex) ? Color.purple.opacity(0.8) : Color.gray.opacity(0.5),
                    lineWidth: 2
                )
                .animation(.easeInOut(duration: 0.8), value: activeLayer)
            }
        }
    }

    // MARK: - Draw Neurons
    private func drawNeurons(count: Int, xPos: CGFloat, layerIndex: Int) -> some View {
        ForEach(0..<count, id: \.self) { index in
            Circle()
                .fill(isNeuronActive(layer: layerIndex) ? Color.purple : Color.gray)
                .frame(width: neuronWidth, height: neuronHeight)
                .position(x: xPos, y: neuronSpacing * CGFloat(index) + neuronSpacing / 2)
                .animation(.easeInOut(duration: 0.8), value: activeLayer)
        }
    }

    // MARK: - Animation Helpers
    private func isNeuronActive(layer: Int) -> Bool {
        return activeLayer == layer
    }

    private func isEdgeActive(fromLayer: Int) -> Bool {
        return activeLayer == fromLayer
    }

    private func startAnimation() {
        let totalLayers = 2 + hiddenLayers.count
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if activeLayer + 1 < totalLayers {
                    activeLayer += 1
                } else {
                    activeLayer = 0
                }
            }
    }

    private func stopAnimation() {
        timer?.cancel()
        timer = nil
    }
}

// MARK: - Line Shape
struct Line: Shape {
    var start: CGPoint
    var end: CGPoint

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}

// MARK: - Preview
struct NeuralNetworkView_Previews: PreviewProvider {
    static var previews: some View {
        NeuralNetworkView(
            inputLayerCount: 3,
            hiddenLayers: [6, 4, 3],
            outputLayerCount: 2,
            neuronWidth: 30,
            neuronHeight: 30,
            neuronSpacing: 60
        )
        .frame(height: 400)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
