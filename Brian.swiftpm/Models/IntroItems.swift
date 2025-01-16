//
//  IntroItems.swift
//  Brian
//
//  Created by José Vitor Alencar on 15/01/25.
//

import SwiftUI

struct Item: Identifiable {
    var id: String = UUID().uuidString
    var image: String
    var title: String
    var text: String
    
    var scale: CGFloat = 1
    var anchor: UnitPoint = .center
    var offset: CGFloat = 0
    var rotation: CGFloat = 0
    var zindex: CGFloat = 0
    var extraOffset: CGFloat = -350
}

let items: [Item] = [
    .init(
        image: "brain.fill",
        title: "Meet Brian.",
        text: "This app tells the story of how humans have shaped machines to think like our very own minds—an exploration of intelligence come to life.",
        scale: 1
    ),
    .init(
        image: "fossil.shell.fill",
        title: "Unravel AI’s Origins",
        text: "Trace the fascinating tale of artificial intelligence across the ages, from ancient imaginings to modern marvels.",
        scale: 0.6,
        anchor: .topLeading,
        offset: -70,
        rotation: 30
    ),
    .init(
        image: "network",
        title: "Peek Behind the Curtain",
        text: "Dive into the underlying math and science that powers AI—numbers, equations, and a whole lot of brainy brilliance.",
        scale: 0.5,
        anchor: .bottomLeading,
        offset: -60,
        rotation: -35
    ),
    .init(
        image: "lasso.badge.sparkles",
        title: "From Theory to Reality",
        text: "Witness how AI shapes our world—fueling progress in healthcare, art, business, and beyond.",
        scale: 0.4,
        anchor: .bottomLeading,
        offset: -50,
        rotation: 160,
        extraOffset: -120
    ),
    .init(
        image: "scale.3d",
        title: "Play and Explore",
        text: "Experience AI in action as you interact with sound, images, and words—because the best way to learn is by doing.",
        scale: 0.35,
        anchor: .bottomLeading,
        offset: -50,
        rotation: 250,
        extraOffset: -100
    )
]
