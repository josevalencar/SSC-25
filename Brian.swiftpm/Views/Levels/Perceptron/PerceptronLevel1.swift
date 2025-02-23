//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 15/02/25.
//

import SwiftUI

@available(iOS 17.0, *)
struct PerceptronLevel1: View {
    
    private let start = Date()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                TimelineView(.animation) { timeline in
                    let time = start.distance(to: timeline.date)
                    Rectangle()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 8)
                        .visualEffect { content, proxy in
                            content.colorEffect(
                                ShaderLibrary.blueNetwork(
                                    .float2(proxy.size),
                                    .float(time)
                                )
                            )
                        }
                        .mask {
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .clear, location: 0.0),
                                    .init(color: .black, location: 0.2),
                                    .init(color: .black, location: 0.8),
                                    .init(color: .clear, location: 1.0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                        .shadow(radius: 8)
                        .frame(height: 450)
                        .padding(.top, -50)
                }
                
                VStack(spacing: 10) {
                    Text("""
    In a lab buzzing with curiosity, Frank Rosenblatt introduces the Perceptron, the first artificial neuron – a fundamental building block in machine learning. This simple machine learns to recognize patterns, primarily used for binary classification tasks.
    """)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 30)
        }
        .onAppear {}
    }
}

struct PerceptronLevel1_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 17.0, *) {
            PerceptronLevel1()
        } else {
            // Fallback on earlier versions
        }
    }
}
