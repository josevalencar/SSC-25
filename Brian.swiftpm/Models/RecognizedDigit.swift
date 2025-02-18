//
//  File.swift
//  Brian
//
//  Created by José Vitor Alencar on 17/02/25.
//

import SwiftUI
import CoreML
import Vision
import UIKit

/// Data structure representing a recognized digit.
struct RecognizedDigit {
    let value: Int
    let confidence: Float
}
