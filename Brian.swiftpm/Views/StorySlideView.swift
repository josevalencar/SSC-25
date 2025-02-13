//
//  StorySlideView.swift
//  Brian
//
//  Created by José Vitor Alencar on 25/01/25.
//

import SwiftUI

@available(iOS 17.0, *)
struct StorySlideView: View {
    let item: StoryItem
    let isActive: Bool
    
    private let start = Date()
    
    var body: some View {
        ZStack {
            switch item.type {
                
            case .shader(let shaderType):
                switch shaderType {
                case .neuron:
                    neuronShaderCard
                case .neuralBlue:
                    blueNetworkShaderCard
                        .padding(.top, 10)
                case .neuralGreen:
                    colorNetworkShaderCard
                }
                
            case .image(let name):
                
                Image(name)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white.shadow(.drop(radius: 10)))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 8)
                    .padding(20)
            }
        }
        .opacity(isActive ? 1 : 0)
        .animation(.easeInOut, value: isActive)
    }
    
    private var neuronShaderCard: some View {
        TimelineView(.animation) { timeline in
            let time = start.distance(to: timeline.date)
            
            Rectangle()
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 8)
                .visualEffect { content, proxy in
                    content.colorEffect(
                        ShaderLibrary.brian(
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
        }
    }
    
    private var blueNetworkShaderCard: some View {
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
        }
    }
    
    private var colorNetworkShaderCard: some View {
        TimelineView(.animation) { timeline in
            let time = start.distance(to: timeline.date)
            
            Rectangle()
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 8)
                .visualEffect { content, proxy in
                    content.colorEffect(
                        ShaderLibrary.colorfulNetwork(
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
        }
    }
}
