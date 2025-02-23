//
//  Nowadays.swift
//  Brian
//
//  Created by José Vitor Alencar on 23/02/25.
//

import SwiftUI

@available(iOS 17.0, *)
struct NowadaysView: View {
    
    private let start = Date()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 60) {
                TimelineView(.animation) { timeline in
                    let time = start.distance(to: timeline.date)
                    Rectangle()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 8)
                        .visualEffect { content, proxy in
                            content.colorEffect(
                                ShaderLibrary.voidHole(
                                    .float2(proxy.size),
                                    .float(time)
                                )
                            )
                        }
                        .shadow(radius: 8)
                        .frame(height: 100)
                }
                
                VStack(spacing: 10) {
                    Text("Today, AI isn’t just **learning**—it’s *creating*. Neural networks now generate art, music, and stories, blurring the line between human and machine creativity. But with this power comes big questions about **ethics, originality, and responsibility**.")
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
        NowadaysView()
    } else {
        // Fallback on earlier versions
    }
}
