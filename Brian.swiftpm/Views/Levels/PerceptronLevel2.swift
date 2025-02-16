//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 15/02/25.
//

import SwiftUI

struct PerceptronLevel2: View {
    
    var styledText: Text {
        let part1 = Text("Graphical Representation: ").bold()
        let part2 = Text("\n\nthe ")
        let part3 = Text("artificial neuron").bold()
        let part4 = Text(" receives a set of ")
        let part5 = Text("weighted inputs").italic()
        let part6 = Text(" (w1x1 + w2x2 + … + wnxn) plus a constant ")
        let part7 = Text("bias (B)").italic()
        let part8 = Text(". This ")
        let part9 = Text("weighted sum").bold()
        let part10 = Text(" is then fed into an ")
        let part11 = Text("activation function").italic()
        let part12 = Text(" that produces an output for the node.")
        
        return part1 + part2 + part3 + part4 + part5 + part6 + part7 + part8 + part9 + part10 + part11 + part12
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    PerceptronView()
                        .frame(width: 320, height: 300)

                    styledText
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

struct PerceptronLevel2_Previews: PreviewProvider {
    static var previews: some View {
        PerceptronLevel2()
    }
}

