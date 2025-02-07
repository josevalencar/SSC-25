//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 04/02/25.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedLevel = 0
    @State private var questionIndex = 0
    
    let levels: [Level] = [
        Level(id: 0, questions: [
            Question(question: "What color is the sky?", possibleAnswers: ["Blue", "Green", "Red"], answerIndex: 0),
            Question(question: "Which animal barks?", possibleAnswers: ["Car", "Dog", "Bird"], answerIndex: 1),
            Question(question: "What do you drink in the morning?", possibleAnswers: ["Juice", "Milk", "Water"], answerIndex: 1),
        ]),
        
        Level(id: 1, questions: [
            Question(question: "What color is the sky?", possibleAnswers: ["Blue", "Green", "Red"], answerIndex: 0),
            Question(question: "Which animal barks?", possibleAnswers: ["Car", "Dog", "Bird"], answerIndex: 1),
            Question(question: "What do you drink in the morning?", possibleAnswers: ["Juice", "Milk", "Water"], answerIndex: 1),
        ]),
        
        Level(id: 2, questions: [
            Question(question: "What color is the sky?", possibleAnswers: ["Blue", "Green", "Red"], answerIndex: 0),
            Question(question: "Which animal barks?", possibleAnswers: ["Car", "Dog", "Bird"], answerIndex: 1),
            Question(question: "What do you drink in the morning?", possibleAnswers: ["Juice", "Milk", "Water"], answerIndex: 1),
        ]),
        
    ]
    
    var body: some View {
        NavigationView {
            LevelsProgressView(levels: levels, selectedLevel: $selectedLevel, questionIndex: $questionIndex)
                .navigationTitle("Timeline Progress")  
        }
    }
}

#Preview {
    HomeView()
}
