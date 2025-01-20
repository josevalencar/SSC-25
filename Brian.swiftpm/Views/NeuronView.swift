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
            Rectangle()
                .ignoresSafeArea()
                .visualEffect { content, proxy in
                    content.colorEffect(
                        ShaderLibrary.neuron(
                            .float2(proxy.size),
                            .float(time)
                        )
                    )
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
