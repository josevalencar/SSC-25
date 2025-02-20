//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 15/02/25.
//

import SwiftUI

struct PerceptronLevel1: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    PerceptronView()
                        .frame(width: 320, height: 300)

                    Text("""
In a lab buzzing with curiosity, Frank Rosenblatt introduces the Perceptron, the first artificial neuron – a fundamental building block in machine learning. This simple machine learns to recognize patterns, primarily used for binary classification tasks.
""")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal,10)

                    Text("""
The Perceptron can be represented in two forms:

• Graphical Representation
• Mathematical Formula
""")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal,10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
    }
}

struct PerceptronLevel1_Previews: PreviewProvider {
    static var previews: some View {
        PerceptronLevel1()
    }
}

