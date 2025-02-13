//
//  Level.swift
//  Brian
//
//  Created by José Vitor Alencar on 06/02/25.
//

import SwiftUICore

struct Level: Identifiable {
    let id: Int
    let stories: [Story]
}

struct Story: Identifiable {
    let id: Int
    let title: String
    let view: AnyView
}

