//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 16/02/25.
//

import SwiftUI

struct PerceptronLevel3: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    Image("perceptron-formula")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 200)
                        .padding(.top, 40)
                    
                    Text("""
**Mathematical Formula:** The output is determined by the *function*.

Where:
• **w** represents the *weights*
• **x** represents the *input features*
• **b** is the *bias*
• **h** is the activation function, such as the *Heaviside step function*
""")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 40)
            }
//            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct PerceptronLevel3_Previews: PreviewProvider {
    static var previews: some View {
        PerceptronLevel3()
    }
}
