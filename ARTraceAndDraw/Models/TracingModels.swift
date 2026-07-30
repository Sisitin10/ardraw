//
//  TracingModels.swift
//  ARTraceAndDraw
//
//  Created for iOS Xcode Compilation
//

import SwiftUI

public enum TabType: Hashable {
    case draw
    case library
    case studio
    case settings
}

public struct ImageTransform {
    var x: CGFloat = 0
    var y: CGFloat = 0
    var scale: CGFloat = 1.0
    var rotation: Double = 0.0
    var opacity: Double = 0.6
    var isLocked: Bool = false
    var isFlippedHorizontally: Bool = false
    var isFlippedVertically: Bool = false
    var filterMode: FilterMode = .original
    var brightness: Double = 1.0
    var contrast: Double = 1.0
}

public enum FilterMode: String, CaseIterable, Identifiable {
    case original = "Original"
    case lineArt = "Line Art"
    case removeBg = "Transparent"
    case invert = "Invert"
    case highContrast = "High Contrast"
    
    public var id: String { rawValue }
}

public struct PresetImage: Identifiable, Hashable {
    public let id: String
    public let title: String
    public let category: String
    public let imageName: String
    public let isTransparent: Bool
    public let difficulty: String
}
