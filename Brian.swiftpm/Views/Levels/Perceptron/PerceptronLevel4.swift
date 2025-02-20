//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 16/02/25.
//

import SwiftUI

struct PerceptronLevel4: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 100) {
                    NeuralNetworkView(
                        inputLayerCount: 5,
                        hiddenLayerCount: 12,
                        outputLayerCount: 5,
                        neuronWidth: 10,
                        neuronHeight: 10,
                        neuronSpacing: 20
                    )
                    .frame(width: 350, height: 200)
                    .background(Color.black.edgesIgnoringSafeArea(.all))
                    .padding(.top, 40)
                    
                    Text("""
A notable application is the **recognition of handwritten digits**. By training **MLPs** (Multilayer Perceptrons) on datasets like **MNIST**, which contains thousands of images of numbers **0 through 9**, machines can accurately interpret and classify these digits, resulting in **784 (28x28 pixel image)** inputs, each pixel being calculated by an artificial neuron.
""")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .frame(width: 350, alignment: .leading)
                }
            }
        }
    }
}

struct PerceptronLevel4_Previews: PreviewProvider {
    static var previews: some View {
        PerceptronLevel4()
    }
}
