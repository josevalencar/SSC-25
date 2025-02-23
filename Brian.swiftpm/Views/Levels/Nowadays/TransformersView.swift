//
//  Transformers.swift
//  Brian
//
//  Created by José Vitor Alencar on 23/02/25.
//

import SwiftUI

@available(iOS 17.0, *)
struct TransformersView: View {
    
    struct Question {
        let text: String
        let options: [String]
        let correctAnswer: String
    }
    
    @State private var questions: [Question] = [
        Question(text: "Neural networks learn from...", options: ["Data", "Magic", "Luck"], correctAnswer: "Data"),
        Question(text: "A perceptron is a simple type of...", options: ["Puzzle", "Trick", "Network"], correctAnswer: "Network"),
        Question(text: "Neural networks can identify...", options: ["Spells", "Images", "Fortunes"], correctAnswer: "Images")
    ]
    
    @State private var selectedAnswers: [String: String] = [:]
    
    var allAnswersCorrect: Bool {
        selectedAnswers.count == questions.count && selectedAnswers.allSatisfy { key, value in
            questions.first { $0.text == key }?.correctAnswer == value
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Complete the phrases correctly!")
                    .foregroundColor(.white)
                    .font(.title2)
                
                VStack(spacing: 5) {
                    ForEach(questions, id: \..text) { question in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(question.text)
                                .foregroundColor(.white)
                                .font(.headline)
                            
                            HStack {
                                ForEach(question.options, id: \..self) { option in
                                    Button(action: {
                                        selectedAnswers[question.text] = option
                                    }) {
                                        Text(option)
                                            .padding()
                                            .background(selectedAnswers[question.text] == option ? (option == question.correctAnswer ? Color.green : Color.red) : Color.gray)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                
                if allAnswersCorrect {
                    Text("The invention of Transformers changes the game. These AI models work just like you did—they don’t just recognize patterns; they understand sequences, remembering context like words in a sentence. This breakthrough powers models like GPT and BERT, making AI better at translating, writing, and even chatting like a human.")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .padding(.top, 20)
                }
            }
            .padding(.vertical, 30)
            .padding(.top, -40)
        }
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        TransformersView()
    } else {
        // Fallback on earlier versions
    }
}

