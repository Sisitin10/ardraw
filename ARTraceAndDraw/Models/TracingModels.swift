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
    public let systemIcon: String
    public let isTransparent: Bool
    public let difficulty: String

    public init(id: String, title: String, category: String, imageName: String, systemIcon: String, isTransparent: Bool, difficulty: String) {
        self.id = id
        self.title = title
        self.category = category
        self.imageName = imageName
        self.systemIcon = systemIcon
        self.isTransparent = isTransparent
        self.difficulty = difficulty
    }
}

public struct PresetData {
    public static let presets: [PresetImage] = [
        PresetImage(id: "1", title: "Cute Bunny", category: "Animals", imageName: "bunny", systemIcon: "pawprint.fill", isTransparent: true, difficulty: "Easy"),
        PresetImage(id: "2", title: "Rose Floral", category: "Botanical", imageName: "rose", systemIcon: "leaf.fill", isTransparent: true, difficulty: "Medium"),
        PresetImage(id: "3", title: "Anime Portrait", category: "Anime", imageName: "anime_face", systemIcon: "face.smiling", isTransparent: true, difficulty: "Hard"),
        PresetImage(id: "4", title: "Vintage Car", category: "Vehicles", imageName: "car", systemIcon: "car.fill", isTransparent: true, difficulty: "Medium"),
        PresetImage(id: "5", title: "Butterfly", category: "Animals", imageName: "butterfly", systemIcon: "sparkles", isTransparent: true, difficulty: "Easy"),
        PresetImage(id: "6", title: "Star Geometric", category: "Shapes", imageName: "star", systemIcon: "star.fill", isTransparent: true, difficulty: "Easy")
    ]
}
