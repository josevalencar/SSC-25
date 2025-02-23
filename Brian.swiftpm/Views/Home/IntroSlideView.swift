//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 11/02/25.
//

import SwiftUI

@available(iOS 17.0, *)
struct IntroSlideView: View {
    let item: StoryItem
    
    @State private var hasAnimatedNeuronSlide = false
    @State private var showBrianTitle = false
    @State private var showBrianBody = false
    
    private let start = Date()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                if case .shader(.neuron) = item.type {
                    neuronShaderCard
                        .frame(height: 300)
                    
                    brianTextView
                }
                else {

                    slideContent
                        .frame(height: 300)
                    
                    Text(item.text)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical, 30)
        }
        .onAppear {
            runNeuronAnimationIfNeeded()
        }
    }
    
    // MARK: - Different Cases for item.type

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
    
    private var slideContent: some View {
        switch item.type {
        case .shader(.neuralBlue):
            return AnyView(blueNetworkShaderCard)
        case .shader(.neuralGreen):
            return AnyView(colorNetworkShaderCard)
        case .shader(.neuron):
            return AnyView(EmptyView()) // handled above
        case .image(let name):
            return AnyView(
                Image(name)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 8)
                    .padding()
            )
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
    
    private var brianTextView: some View {
        VStack(spacing: 10) {
            // Title
            Text("Hi, I’m Brian")
                .font(.title.bold())
                .foregroundColor(.white)
                .opacity(showBrianTitle ? 1 : 0)
            
            // The main text from item
            Text(item.text)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .opacity(showBrianBody ? 1 : 0)
        }
        .padding(.horizontal)
    }
    
    private func runNeuronAnimationIfNeeded() {
        guard case .shader(.neuron) = item.type,
              !hasAnimatedNeuronSlide else { return }
        
        hasAnimatedNeuronSlide = true
        showBrianTitle = false
        showBrianBody  = false
                
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeIn(duration: 1)) {
                showBrianTitle = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeIn(duration: 3)) {
                showBrianBody = true
            }
        }
    }
}

