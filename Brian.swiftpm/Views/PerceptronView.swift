//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 13/02/25.
//

import SwiftUI

struct PerceptronView: View {
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let inputCount = 5
            let circleSize: CGFloat = 40
            let verticalSpacing = height / CGFloat(inputCount + 1)
            let centerY = height / 2

            ZStack {
//                Color.black.edgesIgnoringSafeArea(.all)
                
                ForEach(0..<inputCount, id: \.self) { index in
                    let yPosition = verticalSpacing * CGFloat(index + 1)
                    
                    Circle()
                        .fill(Color.blue)
                        .frame(width: circleSize, height: circleSize)
                        .overlay(Text("x\(index + 1)").foregroundColor(.black).font(.caption))
                        .position(x: width * 0.15, y: yPosition)
                    
                    Line(start: CGPoint(x: width * 0.15 + circleSize / 2, y: yPosition),
                         end: CGPoint(x: width * 0.45, y: centerY))
                        .stroke(Color.white, lineWidth: 2)
                    
                    Text("w\(index + 1)")
                        .foregroundColor(.white)
                        .font(.caption)
                        .position(x: (width * 0.15 + width * 0.45) / 2, y: (yPosition + centerY) / 2 - 10)
                }
                
                VStack(spacing: 5) {
                    Text("Σ")
                        .foregroundColor(.black)
                        .font(.title)
                        .bold()
                        .frame(width: 50, height: 50)
                        .background(Color.white)
                        .cornerRadius(8)
                    
                    Text("Sum")
                        .foregroundColor(.white)
                        .font(.caption)
                }
                .position(x: width * 0.5, y: centerY)
                
                Line(start: CGPoint(x: width * 0.5 + 25, y: centerY),
                     end: CGPoint(x: width * 0.7 - 25, y: centerY))
                    .stroke(Color.white, lineWidth: 2)
                
                VStack(spacing: 5) {
                    Text("f")
                        .foregroundColor(.black)
                        .font(.title)
                        .bold()
                        .frame(width: 50, height: 50)
                        .background(Color.white)
                        .cornerRadius(8)
                    
                    Text("Activation")
                        .foregroundColor(.white)
                        .font(.caption)
                }
                .position(x: width * 0.7, y: centerY)
                
                Line(start: CGPoint(x: width * 0.7 + 25, y: centerY),
                     end: CGPoint(x: width * 0.9, y: centerY))
                    .stroke(Color.white, lineWidth: 2)
                
                Text("Output")
                    .foregroundColor(.white)
                    .font(.caption)
                    .position(x: width * 0.85, y: centerY - 10)
            }
        }
    }
}

// Preview
struct PerceptronView_Previews: PreviewProvider {
    static var previews: some View {
        PerceptronView()
            .frame(width: 400, height: 500)
    }
}
