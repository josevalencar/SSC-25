//
//  StoryItems.swift
//  Brian
//
//  Created by José Vitor Alencar on 25/01/25.
//

// StoryItems.swift

import SwiftUI

struct StoryItem: Identifiable {
    let id = UUID().uuidString
    let type: StoryContentType
    let text: String
}

enum StoryContentType: Equatable {
    case introBrian
    case image(name: String)
    case shader(ShaderType)
}

enum ShaderType: Equatable {
    case neuralBlue
    case neuralGreen
}

let defaultStoryItems: [StoryItem] = [
    .init(
        type: .introBrian,
        text: "I’m not human, but I’ve learned to think a little like one. Let me show you how humans have taught machines to process, decide, and even create—just like they do."
    ),
    .init(
        type: .image(name: "fossil.shell.fill"),
        text: "Your brain is full of tiny cells called neurons. Each neuron has three main parts: dendrites that receive signals, an axon that sends them, and a cell body that processes the information. These neurons form a network that decides and learns over time by strengthening their connections."
    ),
    .init(
        type: .shader(.neuralBlue),
        text: "Using this idea, humans designed systems to mimic the way the brain learns. They created layers of 'thinking' cells that pass signals to each other, learning and improving over time. These systems can process data, make decisions, and even solve problems, much like how your brain works."
    ),
    .init(
        type: .shader(.neuralGreen),
        text: "These systems are called neural networks. They form the foundation of machine learning and deep learning, enabling machines to learn, adapt, and make decisions. Instead, we use mathematical formulas."
    )
]
