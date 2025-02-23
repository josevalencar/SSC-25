//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 19/02/25.
//

import SwiftUI

@available(iOS 17.0, *)
struct IntroductionLevel3: View {
    
    @State private var hasAnimatedNeuronSlide = false
    @State private var showBrianTitle = false
    @State private var showBrianBody = false
    
    private let start = Date()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
                        
            VStack(spacing: 10) {
                NeuralNetworkView(
                    inputLayerCount: 2,
                    hiddenLayers: [3],
                    outputLayerCount: 1,
                    neuronWidth: 40,
                    neuronHeight: 40,
                    neuronSpacing: 60
                )
                .padding(.trailing, 120)
                .padding(.top, 70)
            }
                
                Text("Your brain is full of tiny cells called neurons. Each neuron has three main parts: dendrites that receive signals, an axon that sends them, and a cell body that processes the information. These neurons form a network that decides and learns over time by strengthening their connections.")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                    .padding(.top, 200)
            }
            .padding(.vertical, 30)
        }

}

#Preview {
    if #available(iOS 17.0, *) {
        IntroductionLevel3()
    } else {
        // Fallback on earlier versions
    }
}
