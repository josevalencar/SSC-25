//
//  StoryItems.swift
//  Brian
//
//  Created by José Vitor Alencar on 25/01/25.
//

import SwiftUI

//struct StoryItem: Identifiable {
//    let id = UUID().uuidString
//    let type: StoryContentType
//    let text: String
//}
//
//enum StoryContentType: Equatable {
//    case image(name: String)
//    case shader(ShaderType)
//}
//
//enum ShaderType: Equatable {
//    case neuron
//    case neuralBlue
//    case neuralGreen
//}
//
//let defaultStoryItems: [StoryItem] = [
//    .init(
//        type: .shader(.neuron),
//        text: "I’m not human, but I’ve learned to think a little like one. Let me show you how humans have taught machines to process, decide, and even create—just like they do."
//    ),
//    .init(
//        type: .image(name: "neuron-cell"),
//        text: "Your brain is full of tiny cells called neurons. Each neuron has three main parts: dendrites that receive signals, an axon that sends them, and a cell body that processes the information. These neurons form a network that decides and learns over time by strengthening their connections."
//    ),
//    .init(
//        type: .shader(.neuralBlue),
//        text: "Using this idea, humans designed systems to mimic the way the brain learns. They created layers of 'thinking' cells that pass signals to each other, learning and improving over time. These systems can process data, make decisions, and even solve problems, much like how your brain works."
//    ),
//    .init(
//        type: .shader(.neuralGreen),
//        text: "These systems are called neural networks. They form the foundation of machine learning and deep learning, enabling machines to learn, adapt, and make decisions. Instead, we use mathematical formulas."
//    )
//]

// Suppose you still have something like:
struct StoryItem: Identifiable {
    let id: Int
    let type: StoryItemType
    let text: String
}

enum StoryItemType {
    case shader(ShaderType)
    case image(String)
}

enum ShaderType {
    case neuron
    case neuralBlue
    case neuralGreen
}

// Some sample data:
let firstLevelStoryItems: [StoryItem] = [
    StoryItem(id: 0, type: .shader(.neuron),     text: "I’m not human, but I’ve learned to think a little like one. Let me show you how humans have taught machines to process, decide, and even create—just like they do."),
    StoryItem(id: 1, type: .image("neuron-cell"),  text: "Your brain is full of tiny cells called neurons. Each neuron has three main parts: dendrites that receive signals, an axon that sends them, and a cell body that processes the information. These neurons form a network that decides and learns over time by strengthening their connections."),
    StoryItem(id: 2, type: .shader(.neuralBlue), text: "Using this idea, humans designed systems to mimic the way the brain learns. They created layers of 'thinking' cells that pass signals to each other, learning and improving over time. These systems can process data, make decisions, and even solve problems, much like how your brain works."),
    StoryItem(id: 3, type: .shader(.neuralGreen),text: "These systems are called neural networks. They form the foundation of machine learning and deep learning, enabling machines to learn, adapt, and make decisions. Instead, we use mathematical formulas."),
]
