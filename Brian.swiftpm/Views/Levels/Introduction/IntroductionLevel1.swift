//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 19/02/25.
//

import SwiftUI

@available(iOS 17.0, *)
struct IntroductionLevel1: View {
    
    @State private var hasAnimatedNeuronSlide = false
    @State private var showBrianTitle = false
    @State private var showBrianBody = false
    
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
                    
                }.frame(height: 300)
                    
                VStack(spacing: 10) {
                    // Title
                    Text("Hi, I’m Brian")
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .opacity(showBrianTitle ? 1 : 0)
                    
                    // The main text from item
                    Text("I’m not **human**, but I’ve learned to think a little like one. Let me show you how humans have taught machines to process, decide, and even create—just like they do.")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .opacity(showBrianBody ? 1 : 0)
                }
                .padding(.horizontal)            }
            .padding(.vertical, 30)
        }
        .onAppear {
//            runNeuronAnimationIfNeeded()
        }
    }
    
//    private func runNeuronAnimationIfNeeded() {
//        guard case .shader(.neuron) = item.type,
//              !hasAnimatedNeuronSlide else { return }
//        
//        hasAnimatedNeuronSlide = true
//        showBrianTitle = false
//        showBrianBody  = false
//                
//                
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            withAnimation(.easeIn(duration: 1)) {
//                showBrianTitle = true
//            }
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            withAnimation(.easeIn(duration: 3)) {
//                showBrianBody = true
//            }
//        }
//    }
    
}

#Preview {
    if #available(iOS 17.0, *) {
        IntroductionLevel1()
    } else {
        // Fallback on earlier versions
    }
}
