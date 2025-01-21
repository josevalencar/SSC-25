//
//  NeuronIntro.swift
//  Brian
//
//  Created by José Vitor Alencar on 16/01/25.
//

import SwiftUI

@available(iOS 17.0, *)
struct NeuronView: View {
    @State private var showName = false
    @State private var showIntro = false
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
                
                VStack() {
                    Spacer().frame(height: 400)
                    Text("Hi, I'm Brian")
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .opacity(showName ? 1 : 0)
                        .animation(.easeIn(duration: 1), value: showName)
                        .padding()
                    
                    Text("I'm a neural network simulating how our brain processes information. I'll guide you from my birth to where I am now.")
                            .foregroundColor(.white)
                            .opacity(showIntro ? 1 : 0)
                            .animation(.easeIn(duration: 1), value: showIntro)
                            .padding()
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showName = true
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation {
                            showIntro = true
                        }
                    }
                
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

