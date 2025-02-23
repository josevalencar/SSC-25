//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 19/02/25.
//

import SwiftUI

@available(iOS 17.0, *)
struct IntroductionLevel2: View {
    
    @State private var hasAnimatedNeuronSlide = false
    @State private var showBrianTitle = false
    @State private var showBrianBody = false
    
    private let start = Date()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image("neuron-cell")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 8)
                    .padding()
                    .frame(height: 300)
                
                Text("Your brain is full of tiny cells called neurons. Each neuron has three main parts: dendrites that receive signals, an axon that sends them, and a cell body that processes the information. These neurons form a network that decides and learns over time by strengthening their connections.")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
            }
            .padding(.vertical, 30)
        }
        .onAppear {
        }
    }
    
}

#Preview {
    if #available(iOS 17.0, *) {
        IntroductionLevel2()
    } else {
        // Fallback on earlier versions
    }
}
