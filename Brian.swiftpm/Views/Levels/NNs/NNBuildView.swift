//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 22/02/25.
//

import SwiftUI

struct NNBuildView: View {
    @State private var inputNeurons: Int = 3
    @State private var hiddenLayersCount: Int = 2
    @State private var neuronsPerHiddenLayer: Int = 4
    @State private var outputNeurons: Int = 2

    var body: some View {
        VStack {
            Text("Play building and visualizing your own neural network!")
//                .font(.title3)
//                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            Spacer()

            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    NeuralNetworkView(
                        inputLayerCount: inputNeurons,
                        hiddenLayers: Array(repeating: neuronsPerHiddenLayer, count: hiddenLayersCount),
                        outputLayerCount: outputNeurons,
                        neuronWidth: 20,
                        neuronHeight: 20,
                        neuronSpacing: 40
                    )
                    .frame(height: CGFloat(100 + (hiddenLayersCount * 100)))
                    .animation(.easeInOut, value: hiddenLayersCount)
                    .padding(.trailing, 80)
                }
                .padding()
            }
            .frame(maxHeight: 400)

            Spacer()

            VStack(spacing: 5) {
                sliderView(title: "Input Neurons", value: $inputNeurons, range: 1...10)
                
                sliderView(title: "Hidden Layers", value: $hiddenLayersCount, range: 1...4)
                
                sliderView(title: "Neurons per Hidden Layer", value: $neuronsPerHiddenLayer, range: 1...10)
                
                sliderView(title: "Output Neurons", value: $outputNeurons, range: 1...5)
            }
        }
        .background(Color.black.ignoresSafeArea())
    }

    private func sliderView(title: String, value: Binding<Int>, range: ClosedRange<Int>) -> some View {
        VStack {
            Text("\(title): \(value.wrappedValue)")
                .foregroundColor(.white)
                .font(.headline)
            Slider(value: Binding<Double>(
                get: { Double(value.wrappedValue) },
                set: { value.wrappedValue = Int($0) }
            ), in: Double(range.lowerBound)...Double(range.upperBound), step: 1)
            .accentColor(.green)
            .padding(.horizontal, 20)
        }
    }
}

struct NNBuildView_Previews: PreviewProvider {
    static var previews: some View {
        NNBuildView()
    }
}
