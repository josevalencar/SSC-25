//
//  SwiftUIView.swift
//  Brian
//
//  Created by José Vitor Alencar on 07/02/25.
//

import SwiftUI

struct LevelsProgressView: View {
    
    let levels: [Level]
    @Binding var selectedLevel: Int
    @Binding var questionIndex: Int
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0){
                ForEach(levels) { level in
                    LevelView(level: level, selectedLevel: $selectedLevel, questionIndex: $questionIndex, isLast: level == levels.last ?? level)
                }
            }
        }
    }
}

#Preview {
//    LevelsProgressView()
}
