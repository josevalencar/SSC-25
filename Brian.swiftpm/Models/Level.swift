//
//  Level.swift
//  Brian
//
//  Created by José Vitor Alencar on 06/02/25.
//

struct Level: Identifiable {
    let id: Int
    let questions: [Question]
    static func==(lhs: Level, rhs: Level) -> Bool { lhs.id == rhs.id }
}

struct Question {
    let question: String
    let possibleAnswers: [String]
    let answerIndex: Int
}
