//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 06/02/25.
//

import SwiftUI

struct LevelView: View {
    let level: Level
    
    @Binding var selectedLevel: Int
    @Binding var storyIndex: Int
    
    let isLast: Bool
    let offset: CGFloat
    
    init(level: Level, selectedLevel: Binding<Int>, storyIndex: Binding<Int>, isLast: Bool){
        self.level = level
        self._selectedLevel = selectedLevel
        self._storyIndex = storyIndex
        self.isLast = isLast
        
        let offsets: [CGFloat] = [0, -100, 25, 50, -50, 50]
        offset = offsets[level.id % 6]
    }
    
    
    var body: some View {
        VStack{
            ZStack{
                ZStack {
                    if selectedLevel >= level.id {
                        Circle()
                            .stroke(.gray.opacity(0.3), lineWidth: 7.5)
                        Circle()
                            .trim(from: 0.0, to: selectedLevel > level.id ? 1.0 : CGFloat(storyIndex) / CGFloat(level.stories.count))
                            .stroke(style: .init(lineWidth: 7.5, lineCap: .round))
                            .rotationEffect(.degrees(270))
                            .foregroundStyle(.indigo)
                    }
                }
                .frame(width: 80, height: 80)
                NavigationLink {
                    CustomGameLevelView(level: level, selectedLevel: $selectedLevel, storyIndex: $storyIndex)
                } label: {
                    Image(systemName: selectedLevel >= level.id ? "star.fill" : "lock.fill")
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundStyle(selectedLevel > level.id ? .indigo : selectedLevel < level.id ? .gray : .white)
                }
                .disabled(selectedLevel < level.id)
                .frame(width: 60, height: 60)
                .background(selectedLevel >= level.id ? .green : .gray.opacity(0.3))
                .clipShape(.circle)
            }
            .offset(x: offset)
            .overlay {
                if !isLast {
                    PathView(
                        id: level.id,
                        selectedLevel: selectedLevel,
                        progress: CGFloat(storyIndex) / CGFloat(level.stories.count)
                    )
                    // Ignore touch events in the overlay
                    .allowsHitTesting(false)
                }
            }
        }.frame(maxWidth: .infinity, minHeight: 150)
    }
}

#Preview {
//    LevelView()
}
