//
//  NeuronIntro.swift
//  Brian
//
//  Created by José Vitor Alencar on 16/01/25.
//

// StoryView.swift

import SwiftUI

@available(iOS 17.0, *)
struct StoryView: View {
    /// Our “slide” data:
    @State private var storyItems: [StoryItem] = defaultStoryItems
    @State private var activeIndex: Int = 0
    @State private var selectedItem: StoryItem = defaultStoryItems.first!
    
    /// If you want to push a new view after finishing the last slide:
    @State private var showNextView = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            if !showNextView {
                VStack(spacing: 0) {
                    // Optional back button:
                    Button {
                        updateItem(isForward: false)
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                            .contentShape(.rect)
                    }
                    .padding(15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(canGoBack ? 1 : 0)
                    
                    // The "slide" area
                    ZStack {
                        ForEach(storyItems) { item in
                            StorySlideView(item: item, isActive: (selectedItem.id == item.id))
                        }
                    }
                    .frame(height: 300)
                    .frame(maxHeight: .infinity)
                    
                    Spacer().frame(height: 20)
                    
                    // The text + next button
                    VStack(spacing: 8) {
                        // Dot indicator
                        HStack(spacing: 4) {
                            ForEach(storyItems) { item in
                                Capsule()
                                    .fill(selectedItem.id == item.id ? .white : .gray)
                                    .frame(width: selectedItem.id == item.id ? 25 : 4, height: 4)
                            }
                        }
                        .padding(.bottom, 15)
                        
                        // The text for this slide
                        // For the introBrian slide, the text "fade in" is
                        // actually handled inside StorySlideView.
                        // But we can still show text here if you prefer a simpler approach.
//                        if selectedItem.type != .introBrian {
//                            Text(selectedItem.text)
//                                .foregroundColor(.white)
//                                .multilineTextAlignment(.center)
//                                .frame(maxWidth: .infinity)
//                                .padding(.horizontal)
//                        }
                        
                        // Next or Begin
                        Button {
                            if selectedItem.id == storyItems.last?.id {
                                showNextView = true
                            } else {
                                updateItem(isForward: true)
                            }
                        } label: {
                            Text(selectedItem.id == storyItems.last?.id ? "Begin" : "Next")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 250)
                                .padding(.vertical, 12)
                                .background(.indigo.gradient, in: .capsule)
                        }
                        
                        Spacer().frame(height: 20)
                    }
                    .frame(width: 320)
                    .frame(maxHeight: .infinity)
                }
            } else {
                // Show something after finishing
                Text("All Done!")
                    .foregroundColor(.white)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: showNextView)
    }
    
    private var canGoBack: Bool {
        activeIndex > 0
    }
    
    private func updateItem(isForward: Bool) {
        guard isForward ? (activeIndex < storyItems.count - 1) : (activeIndex > 0)
        else { return }
        
        if isForward {
            activeIndex += 1
        } else {
            activeIndex -= 1
        }
        selectedItem = storyItems[activeIndex]
    }
}

@available(iOS 17.0, *)
#Preview {
    StoryView()
}


