//
//  AlexNetView.swift
//  Brian
//
//  Created by José Vitor Alencar on 23/02/25.
//

import SwiftUI

@available(iOS 17.0, *)
struct AlexNetView: View {
    
    @State private var isAnimating = true
    
    private let start = Date()
    
    @State private var progress: CGFloat = 0.0
    let layers = [2, 3, 3, 1]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                VStack {

                     ZStack {
                         NeuralNetworkView(
                             inputLayerCount: 2,
                             hiddenLayers: [3],
                             outputLayerCount: 1,
                             neuronWidth: 20,
                             neuronHeight: 20,
                             neuronSpacing: 40
                         )
                         .frame(height: 300)

                         Image(systemName: "dog.fill")
                             .font(.system(size: 30))
                             .foregroundColor(.white)
                             .offset(x: -80 + (progress * 30), y: -80)

                         if progress > 0.9 {
                             Text("Dog")
                                 .font(.title)
                                 .bold()
                                 .offset(x: 180, y: -90)
                                 .foregroundStyle(.white)
                                 .opacity(progress)
                         }
                     }
                     .frame(width: 220, height: 350)
                     .padding(.trailing, 105)
                 }
                 .onAppear {
                     withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: false)) {
                         progress = 1.0
                     }
                 }
                
                Text("Enter **AlexNet**, a special type of a **convolutional neural network (CNN)**. Think of it like a *super-powered eye* for machines, spotting *patterns* in images just like we do. It stuns the world by crushing the ImageNet competition, proving that deep learning can help machines truly **'see'**.")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 38)
            }
            .padding(.vertical, 30)
        }
        .onAppear {
        }
    }
    
}

#Preview {
    if #available(iOS 17.0, *) {
        AlexNetView()
    } else {
        // Fallback on earlier versions
    }
}
