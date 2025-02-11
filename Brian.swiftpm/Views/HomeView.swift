//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 04/02/25.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedLevel = 0
    @State private var storyIndex = 0
    
    let levels: [Level] = [
            Level(
                id: 0,
                stories: [
                    Story(id: 0, title: "Story A1", view: AnyView(Text("Story A1 Content"))),
                    Story(id: 1, title: "Story A2", view: AnyView(Text("Story A2 Content"))),
                    Story(id: 2, title: "Story A3", view: AnyView(Text("Story A3 Content")))
                ]
            ),
            Level(
                id: 1,
                stories: [
                    Story(id: 0, title: "Story B1", view: AnyView(Text("Story B1 Content"))),
                    Story(id: 1, title: "Story B2", view: AnyView(Text("Story B2 Content"))),
                    Story(id: 2, title: "Story B3", view: AnyView(Text("Story B3 Content")))
                ]
            ),
            Level(
                id: 2,
                stories: [
                    Story(id: 0, title: "Story C1", view: AnyView(Text("Story C1 Content"))),
                    Story(id: 1, title: "Story C2", view: AnyView(Text("Story C2 Content"))),
                    Story(id: 2, title: "Story C3", view: AnyView(Text("Story C3 Content")))
                ]
            )
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
    HomeView()
}
