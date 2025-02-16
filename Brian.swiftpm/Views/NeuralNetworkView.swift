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
    var hiddenLayerCount: Int
    var outputLayerCount: Int
    var neuronWidth: CGFloat
    var neuronHeight: CGFloat
    var neuronSpacing: CGFloat
    
    @State private var activeLayer: Int = 0
    @State private var isAnimating: Bool = false
    @State private var timer: AnyCancellable? = nil
    
    var body: some View {
        GeometryReader { geometry in
            let layerSpacing = geometry.size.width / 4
            let neuronSpacing: CGFloat = neuronSpacing
            
            ZStack {
                // Input -> Hidden Layer Connections
                ForEach(0..<inputLayerCount, id: \.self) { inputIndex in
                    ForEach(0..<hiddenLayerCount, id: \.self) { hiddenIndex in
                        Line(start: CGPoint(
                            x: layerSpacing,
                            y: neuronSpacing * CGFloat(inputIndex) + neuronSpacing / 2),
                             end: CGPoint(
                                x: layerSpacing * 2,
                                y: neuronSpacing * CGFloat(hiddenIndex) + neuronSpacing / 2))
                            .stroke(isEdgeActive(fromLayer: 0) ? Color.purple.opacity(0.8) : Color.gray.opacity(0.5), lineWidth: 2)
                            .animation(.easeInOut(duration: 0.8), value: activeLayer)
                    }
                }
                
                // Hidden -> Output Layer Connections
                ForEach(0..<hiddenLayerCount, id: \.self) { hiddenIndex in
                    ForEach(0..<outputLayerCount, id: \.self) { outputIndex in
                        Line(start: CGPoint(
                            x: layerSpacing * 2,
                            y: neuronSpacing * CGFloat(hiddenIndex) + neuronSpacing / 2),
                             end: CGPoint(
                                x: layerSpacing * 3,
                                y: neuronSpacing * CGFloat(outputIndex) + neuronSpacing / 2))
                            .stroke(isEdgeActive(fromLayer: 1) ? Color.purple.opacity(0.8) : Color.gray.opacity(0.5), lineWidth: 2)
                            .animation(.easeInOut(duration: 0.8), value: activeLayer)
                    }
                }
                
                // Input Layer Neurons
                ForEach(0..<inputLayerCount, id: \.self) { index in
                    Circle()
                        .fill(isNeuronActive(layer: 0) ? Color.purple : Color.gray)
                        .frame(width: neuronWidth, height: neuronHeight)
                        .position(x: layerSpacing, y: neuronSpacing * CGFloat(index) + neuronSpacing / 2)
                        .animation(.easeInOut(duration: 0.8), value: activeLayer)
                }
                
                // Hidden Layer Neurons
                ForEach(0..<hiddenLayerCount, id: \.self) { index in
                    Circle()
                        .fill(isNeuronActive(layer: 1) ? Color.purple : Color.gray)
                        .frame(width: neuronWidth, height: neuronHeight)
                        .position(x: layerSpacing * 2, y: neuronSpacing * CGFloat(index) + neuronSpacing / 2)
                        .animation(.easeInOut(duration: 0.8), value: activeLayer)
                }
                
                // Output Layer Neurons
                ForEach(0..<outputLayerCount, id: \.self) { index in
                    Circle()
                        .fill(isNeuronActive(layer: 2) ? Color.purple : Color.gray)
                        .frame(width: neuronWidth, height: neuronHeight)
                        .position(x: layerSpacing * 3, y: neuronSpacing * CGFloat(index) + neuronSpacing / 2)
                        .animation(.easeInOut(duration: 0.8), value: activeLayer)
                }
            }
            .onAppear {
                startAnimation()
            }
            .onDisappear {
                stopAnimation()
            }
        }
    }
    
    private func isNeuronActive(layer: Int) -> Bool {
        return activeLayer == layer
    }
    
    private func isEdgeActive(fromLayer: Int) -> Bool {
        return activeLayer == fromLayer
    }
    
    private func startAnimation() {
        let totalLayers = 3
        
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

struct NeuralNetworkView_Previews: PreviewProvider {
    static var previews: some View {
        NeuralNetworkView(
            inputLayerCount: 3,
            hiddenLayerCount: 4,
            outputLayerCount: 2,
            neuronWidth: 40, // Custom width for preview
            neuronHeight: 40, // Custom height for preview
            neuronSpacing: 60
        )
            .frame(height: 400)
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
