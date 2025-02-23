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
                    view: AnyView(IntroductionLevel1())
                ),
                Story(
                    id: 1,
                    title: "1. Introduction",
                    view: AnyView(IntroductionLevel2())
                ),
                Story(
                    id: 2,
                    title: "1. Introduction",
                    view: AnyView(IntroductionLevel3())
                ),
                Story(
                    id: 3,
                    title: "1. Introduction",
                    view: AnyView(IntroductionLevel4())
                )
            ],
            icon: "star.fill"
        ),
        Level(
            id: 1,
            stories: [
                Story(id: 0, title: "2. Architecture Types", view: AnyView(NeuralNetworkSelectionView())),
                Story(id: 1, title: "2. Architecture Types", view: AnyView(NNBuildView())),
            ],
            icon: "livephoto"
        ),
        Level(
            id: 2,
            stories: [
                Story(id: 0, title: "3. The Birth of Perceptron", view: AnyView(PerceptronLevel1())),
                Story(id: 1, title: "3. The Birth of Perceptron", view: AnyView(PerceptronLevel2())),
                Story(id: 2, title: "3. The Birth of Perceptron", view: AnyView(PerceptronLevel4()))
            ],
            icon: "star.fill"
        ),
        Level(
            id: 3,
            stories: [
                Story(id: 0, title: "4. Handwritten Recognition", view: AnyView(DigitRecognitionView())),
            ],
            icon: "livephoto"
        ),
        Level(
            id: 4,
            stories: [
                Story(id: 0, title: "Story E1", view: AnyView(Text("Story C1 Content"))),
                Story(id: 1, title: "Story E2", view: AnyView(Text("Story C2 Content"))),
                Story(id: 2, title: "Story E3", view: AnyView(Text("Story C3 Content")))
            ],
            icon: "star.fill"
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
    }
}
