//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 04/02/25.
//

import SwiftUI

@available(iOS 17.0, *)
struct HomeView: View {
    @State private var selectedLevel = 0
    @State private var storyIndex = 0
    
    let levels: [Level] = [
        Level(
            id: 0,
            stories: [
                Story(
                    id: 0,
                    title: "1. Introduction",
                    view: AnyView(IntroSlideView(item: firstLevelStoryItems[0]))
                ),
                Story(
                    id: 1,
                    title: "1. Introduction",
                    view: AnyView(IntroSlideView(item: firstLevelStoryItems[1]))
                ),
                Story(
                    id: 2,
                    title: "1. Introduction",
                    view: AnyView(IntroSlideView(item: firstLevelStoryItems[2]))
                ),
                Story(
                    id: 3,
                    title: "1. Introduction",
                    view: AnyView(IntroSlideView(item: firstLevelStoryItems[3]))
                )
            ]
        ),
        Level(
            id: 1,
            stories: [
                Story(id: 0, title: "2. The Birth of Perceptron", view: AnyView(PerceptronLevel1())),
                Story(id: 1, title: "2. The Birth of Perceptron", view: AnyView(PerceptronLevel2())),
                Story(id: 2, title: "2. The Birth of Perceptron", view: AnyView(PerceptronLevel3())),
                Story(id: 2, title: "2. The Birth of Perceptron", view: AnyView(PerceptronLevel4()))
            ]
        ),
        Level(
            id: 2,
            stories: [
                Story(id: 0, title: "3. Handwritten Recognition", view: AnyView(Text("Right the digits and let the AI do it for you."))),
            ]
        ),
        Level(
            id: 3,
            stories: [
                Story(id: 0, title: "Story D1", view: AnyView(DigitRecognitionView())),
                Story(id: 1, title: "Story D2", view: AnyView(Text("Story C2 Content"))),
                Story(id: 2, title: "Story D3", view: AnyView(Text("Story C3 Content")))
            ]
        ),
        Level(
            id: 4,
            stories: [
                Story(id: 0, title: "Story E1", view: AnyView(Text("Story C1 Content"))),
                Story(id: 1, title: "Story E2", view: AnyView(Text("Story C2 Content"))),
                Story(id: 2, title: "Story E3", view: AnyView(Text("Story C3 Content")))
            ]
        ),
    ]

    
    var body: some View {
        NavigationView {
            LevelsProgressView(
                levels: levels,
                selectedLevel: $selectedLevel,
                storyIndex: $storyIndex
            )
            .navigationTitle("Timeline Progress")
        }
        .tint(.indigo)
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        HomeView()
    } else {
        // Fallback on earlier versions
    }
}
