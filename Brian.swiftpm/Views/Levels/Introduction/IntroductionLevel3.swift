//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 19/02/25.
//

import SwiftUI

@available(iOS 17.0, *)
struct IntroductionLevel3: View {
    
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
                
                Text("Using this idea, humans designed systems to mimic the way the *brain learn*s. They created layers of *'thinking'* cells that pass signals to each other, **learning** and **improving** over time. These systems can *process* data, *make* decisions, and even *solve* problems, much like how your brain works.")
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
