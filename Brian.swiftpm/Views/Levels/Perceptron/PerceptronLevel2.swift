//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 15/02/25.
//

import SwiftUI

struct PerceptronLevel2: View {
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    PerceptronView()
                        .frame(width: 320, height: 300)

                    Text(try! AttributedString(markdown: "**This a graphical representation of a perceptron:** the **artificial neuron** receives a set of *weighted inputs* (w1x1 + w2x2 + … + wnxn) plus a constant *bias (B)*. This **weighted sum** is then fed into an *activation function* that produces an output for the node."))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
    }
}

struct PerceptronLevel2_Previews: PreviewProvider {
    static var previews: some View {
        PerceptronLevel2()
    }
}
