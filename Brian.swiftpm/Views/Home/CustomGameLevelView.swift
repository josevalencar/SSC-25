//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 10/02/25.
//

import SwiftUI

struct CustomGameLevelView: View {
    let level: Level
    
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedLevel: Int
    @Binding var storyIndex: Int
    
    init(level: Level, selectedLevel: Binding<Int>, storyIndex: Binding<Int>){
        self.level = level
        self._selectedLevel = selectedLevel
        self._storyIndex = storyIndex
    }
    
    var body: some View {
        ZStack {
            
            Color.black.ignoresSafeArea()

            VStack(spacing: 30) {
                let currentStory = level.stories[storyIndex]
                
                currentStory.view
                
                HStack {
                    Button("Previous") {
                        handlePrevious()
                    }
                    .disabled(storyIndex == 0)
                    
                    Spacer()
                    
                    Button("Continue") {
                        handleContinue()
                    }
                }
            }
            .padding()
            .navigationTitle("\(level.stories[storyIndex].title)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Back")
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Text("\(storyIndex + 1) / \(level.stories.count)")
                        .font(.system(size: 11))
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .background(.indigo)
                        .clipShape(Circle())
                }
            }
        }
        
    }
    
    func handlePrevious() {
        if storyIndex > 0 {
            storyIndex -= 1
        }
    }
    
    
    func handleContinue() {
        storyIndex += 1
        
        if storyIndex >= level.stories.count {
            dismiss()
            
            if selectedLevel == level.id {
                selectedLevel += 1
            }
            
            storyIndex = 0
        }
    }
    
}

#Preview {
    //    CustomGameLevelView()
}
