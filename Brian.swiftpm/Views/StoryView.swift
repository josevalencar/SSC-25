////
////  StoryView.swift
////  Brian
////
////  Created by José Vitor Alencar on 16/01/25.
////
//
//import SwiftUI
//
//@available(iOS 17.0, *)
//struct StoryView: View {
//    @State private var storyItems: [StoryItem] = defaultStoryItems
//    @State private var activeIndex: Int = 0
//    @State private var selectedItem: StoryItem = defaultStoryItems.first!
//    @State private var showNextView = false
//    
//    // For animating the special "Brian" slide only once
//    @State private var hasAnimatedNeuronSlide = false
//    @State private var showBrianTitle = false
//    @State private var showBrianBody = false
//    
//    var body: some View {
//        ZStack {
//            Color.black.ignoresSafeArea()
//            
//            if !showNextView {
//                VStack {
//                    VStack(spacing: 0) {
//                        backButton
//                        
//                        // Slide area (300pt height)
//                        ZStack {
//                            ForEach(storyItems) { item in
//                                StorySlideView(item: item, isActive: (selectedItem.id == item.id))
//                            }
//                        }
//                        .frame(height: 300)
//                        .frame(maxWidth: .infinity)
//                        
//                        Spacer().frame(height: 20)
//                        
//                        dotIndicator
//                            .padding(.bottom, 15)
//                        
//                        // Text area below the slides
//                        if case .shader(.neuron) = selectedItem.type {
//                            neuronTextView
//                        } else {
//                            Text(selectedItem.text)
//                                .foregroundColor(.white)
//                                .multilineTextAlignment(.leading)
//                                .frame(maxWidth: .infinity)
//                                .padding(.horizontal)
//                        }
//                    }
//                    .frame(maxHeight: .infinity, alignment: .top)
//                    
//                    // Next button pinned at bottom
//                    Button {
//                        if selectedItem.id == storyItems.last?.id {
//                            showNextView = true
//                        } else {
//                            updateItem(isForward: true)
//                        }
//                    } label: {
//                        Text(selectedItem.id == storyItems.last?.id ? "Begin" : "Next")
//                            .fontWeight(.semibold)
//                            .foregroundColor(.white)
//                            .frame(width: 250)
//                            .padding(.vertical, 12)
//                            .background(.indigo.gradient, in: .capsule)
//                    }
//                    .padding(.vertical, 40)
//                }
//                .onAppear {
//                    // If we start on the neuron slide and haven't animated yet, do it once
//                    runNeuronAnimationIfNeeded()
//                }
//                .onChange(of: selectedItem.id) { _ in
//                    // If we move to the neuron slide later, animate only if not done before
//                    runNeuronAnimationIfNeeded()
//                }
//            } else {
//                Text("All Done!")
//                    .foregroundColor(.white)
//                    .transition(.opacity)
//            }
//        }
//        .animation(.easeInOut, value: showNextView)
//    }
//    
//    // MARK: - Subviews
//    
//    private var backButton: some View {
//        Button {
//            updateItem(isForward: false)
//        } label: {
//            Image(systemName: "chevron.left")
//                .font(.title3.bold())
//                .foregroundStyle(.white)
//                .contentShape(Rectangle())
//        }
//        .padding(.horizontal)
//        .opacity(canGoBack ? 1 : 0)
//        .frame(maxWidth: .infinity, alignment: .leading)
//    }
//    
//    private var dotIndicator: some View {
//        HStack(spacing: 4) {
//            ForEach(storyItems) { item in
//                Capsule()
//                    .fill(selectedItem.id == item.id ? .white : .gray)
//                    .frame(width: selectedItem.id == item.id ? 25 : 4, height: 4)
//                    .padding(.top, 50)
//            }
//        }
//    }
//    
//    private var canGoBack: Bool {
//        activeIndex > 0
//    }
//    
//    private func updateItem(isForward: Bool) {
//        guard isForward ? (activeIndex < storyItems.count - 1) : (activeIndex > 0) else { return }
//        activeIndex += (isForward ? 1 : -1)
//        selectedItem = storyItems[activeIndex]
//    }
//    
//    /// A subview for the special "Brian" slide: "Hi, I'm Brian" + the item text.
//    /// The title fades in over 1 second, then the text fades in over 3 seconds,
//    /// but only once (we don't re-run when coming back).
//    private var neuronTextView: some View {
//        VStack(spacing: 10) {
//            Text("Hi, I’m Brian")
//                .multilineTextAlignment(.center)
//                .font(.title.bold())
//                .foregroundColor(.white)
//                .opacity(showBrianTitle ? 1 : 0)
//            
//            Text(selectedItem.text)
//                .foregroundColor(.white)
//                .multilineTextAlignment(.leading)
//                .opacity(showBrianBody ? 1 : 0)
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .padding(.horizontal)
//    }
//    
//    /// Animates the "Brian" title/text only once when we land on the neuron slide.
//    private func runNeuronAnimationIfNeeded() {
//        guard case .shader(.neuron) = selectedItem.type, !hasAnimatedNeuronSlide else { return }
//        
//        hasAnimatedNeuronSlide = true
//        showBrianTitle = false
//        showBrianBody = false
//        
//        // Title fades in over 1s, starts after 0.5s
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            withAnimation(.easeIn(duration: 1)) {
//                showBrianTitle = true
//            }
//        }
//        
//        // Body fades in over 3s, starts after 1.5s total
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            withAnimation(.easeIn(duration: 3)) {
//                showBrianBody = true
//            }
//        }
//    }
//}
//
//
//
//@available(iOS 17.0, *)
//#Preview {
//    StoryView()
//}
//
//
