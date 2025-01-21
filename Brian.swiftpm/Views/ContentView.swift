import SwiftUI

@available(iOS 17.0, *)
struct ContentView: View {
    @State private var selectedItem: Item = items.first!
    @State private var introItems: [Item] = items
    @State private var activeIndex: Int = 0
    
    @State private var showNextView: Bool = false
    
    var body: some View {
        ZStack {
            if !showNextView {
                VStack(spacing: 0) {
                    Button {
                        updateItem(isForward: false)
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3.bold())
                            .foregroundStyle(.indigo.gradient)
                            .contentShape(.rect)
                    }
                    .padding(15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(selectedItem.id != introItems.first?.id ? 1 : 0)
                    
                    ZStack {
                        ForEach(introItems) { item in
                            AnimatedIconView(item)
                        }
                    }
                    .frame(height: 250)
                    .frame(maxHeight: .infinity)
                    
                    Spacer().frame(height: 20)
                    
                    VStack(spacing: 6) {
                        HStack(spacing: 4) {
                            ForEach(introItems) { item in
                                Capsule()
                                    .fill(selectedItem.id == item.id ? Color.primary : .gray)
                                    .frame(width: selectedItem.id == item.id ? 25 : 4, height: 4)
                            }
                        }
                        .padding(.bottom, 15)
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text(selectedItem.title)
                                .font(.title.bold())
                                .contentTransition(.numericText())
                                .animation(.easeInOut, value: selectedItem.id)
                                .padding(.leading, 5)
                            
                            JustifiedTextView(text: selectedItem.text)
                                .frame(maxWidth: .infinity)
                        }
                        
                        Button {
                            if selectedItem.id == introItems.last?.id {
                                withAnimation {
                                    showNextView = true
                                }
                            } else {
                                updateItem(isForward: true)
                            }
                        } label: {
                            Text(selectedItem.id == introItems.last?.id ? "Begin" : "Next")
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .contentTransition(.numericText())
                                .frame(width: 250)
                                .padding(.vertical, 12)
                                .background(.indigo.gradient, in: .capsule)
                        }
                        
                        Spacer().frame(height: 20)
                    }
                    .multilineTextAlignment(.center)
                    .frame(width: 320)
                    .frame(maxHeight: .infinity)
                }
                .transition(.opacity)
            }
            else {
                NeuronView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: showNextView)
    }
    
    @ViewBuilder
    private func AnimatedIconView(_ item: Item) -> some View {
        let isSelected = selectedItem.id == item.id
        
        Image(systemName: item.image)
            .font(.system(size: 80))
            .foregroundStyle(.white.shadow(.drop(radius: 10)))
            .blendMode(.overlay)
            .frame(width: 120, height: 120)
            .background(.indigo.gradient, in: RoundedRectangle(cornerRadius: 32))
            .rotationEffect(.init(degrees: -item.rotation))
            .scaleEffect(isSelected ? 1.1 : item.scale, anchor: item.anchor)
            .offset(x: item.offset)
            .rotationEffect(.init(degrees: item.rotation))
            .zIndex(isSelected ? 2 : item.zindex)
    }
    
    private func updateItem(isForward: Bool) {
        guard isForward ? activeIndex != introItems.count - 1 : activeIndex != 0 else { return }
        
        var fromIndex: Int
        var extraOffset: CGFloat
        
        if isForward {
            activeIndex += 1
        } else {
            activeIndex -= 1
        }
        
        if isForward {
            fromIndex = activeIndex - 1
            extraOffset = introItems[activeIndex].extraOffset
        } else {
            extraOffset = introItems[activeIndex].extraOffset
            fromIndex = activeIndex + 1
        }
        
        for index in introItems.indices {
            introItems[index].zindex = 0
        }
        
        Task { [fromIndex, extraOffset] in
            withAnimation(.bouncy(duration: 1)) {
                introItems[fromIndex].scale = introItems[activeIndex].scale
                introItems[fromIndex].rotation = introItems[activeIndex].rotation
                introItems[fromIndex].anchor = introItems[activeIndex].anchor
                introItems[fromIndex].offset = introItems[activeIndex].offset
                introItems[activeIndex].offset = extraOffset
                introItems[fromIndex].zindex = 1
            }
            
            try? await Task.sleep(for: .seconds(0.1))
            
            withAnimation(.bouncy(duration: 0.9)) {
                introItems[activeIndex].scale = 1
                introItems[activeIndex].rotation = .zero
                introItems[activeIndex].anchor = .center
                introItems[activeIndex].offset = .zero
            }
            
            selectedItem = introItems[activeIndex]
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    ContentView()
}
