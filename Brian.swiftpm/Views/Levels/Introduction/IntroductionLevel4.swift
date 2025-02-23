//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 19/02/25.
//

import SwiftUI

@available(iOS 17.0, *)
struct IntroductionLevel4: View {
    
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
                        .frame(height: 480)
                        .padding(.top, -50)
                }
                
                VStack(spacing: 10) {
                    Text("These systems are called ***neural networks***. They form the foundation of **machine learning** and **deep learning**, enabling machines to *learn, adapt, and make decisions*.")
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

#Preview {
    if #available(iOS 17.0, *) {
        IntroductionLevel4()
    } else {
        // Fallback on earlier versions
    }
}
