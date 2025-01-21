//
//  NeuronIntro.swift
//  Brian
//
//  Created by José Vitor Alencar on 16/01/25.
//

import SwiftUI

@available(iOS 17.0, *)
struct NeuronView: View {
    private let start = Date()

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = start.distance(to: timeline.date)
            
            ZStack {
                Rectangle()
                    .ignoresSafeArea()
                    .visualEffect { content, proxy in
                        content.colorEffect(
                            ShaderLibrary.brian(
                                .float2(proxy.size),
                                .float(time)
                            )
                        )
                    }
                
                VStack {
                    Spacer()
                    Text("Hello from the Neuron View!")
                        .foregroundColor(.white)
                        .padding()
                }
            }
        }
    }
}

@available(iOS 17.0, *)
struct NeuronView_Previews: PreviewProvider {
    static var previews: some View {
        NeuronView()
    }
}

