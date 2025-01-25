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
    
    // For the "introBrian" fade-in text:
    @State private var showName = false
    @State private var showIntro = false
    private let start = Date()
    
    var body: some View {
        ZStack {
            switch item.type {
            case .introBrian:
                introBrianScene
            case .image(let name):
                // Could be an SF Symbol or a custom asset
                Image(systemName: name)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white.shadow(.drop(radius: 10)))
                    .padding(20)
                
            case .shader(let shaderType):
                Rectangle()
                    .overlay(shaderView(shaderType))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 8)
            }
        }
        // Animate the entire ZStack in/out
        .opacity(isActive ? 1 : 0)
        .animation(.easeInOut, value: isActive)
    }
    
    private var introBrianScene: some View {
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
                    Spacer().frame(height: 250)
                    
                    Text("Hi, I’m Brian")
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .opacity(showName ? 1 : 0)
                        .animation(.easeIn(duration: 1), value: showName)
                        .padding()
                    
                    Text(item.text)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(showIntro ? 1 : 0)
                        .animation(.easeIn(duration: 1), value: showIntro)
                        .padding(.horizontal)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            showName = true
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            showIntro = true
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func shaderView(_ shaderType: ShaderType) -> some View {
        switch shaderType {
        case .neuralBlue:
            Text("Blue Neural Shader")
                .foregroundColor(.white)
                .padding()
        case .neuralGreen:
            Text("Green Neural Shader")
                .foregroundColor(.white)
                .padding()
        }
    }
}
