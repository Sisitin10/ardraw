//
//  ContentView.swift
//  ARTraceAndDraw
//
//  Main Native SwiftUI Navigation with Apple SF Symbols
//

import SwiftUI

struct ContentView: View {
    @State private var activeTab: TabType = .draw
    @State private var transform = ImageTransform()
    @State private var selectedImageName = "bunny"
    @State private var selectedSystemIcon = "pawprint.fill"
    @State private var selectedUIImage: UIImage? = nil
    
    var body: some View {
        TabView(selection: $activeTab) {
            ARCameraView(
                transform: $transform,
                selectedImageName: selectedImageName,
                selectedUIImage: selectedUIImage,
                selectedSystemIcon: selectedSystemIcon
            )
            .tabItem {
                Label("AR Draw", systemImage: activeTab == .draw ? "camera.fill" : "camera")
            }
            .tag(TabType.draw)
            
            PictureLibraryView(
                selectedImageName: $selectedImageName,
                selectedSystemIcon: $selectedSystemIcon,
                selectedUIImage: $selectedUIImage,
                activeTab: $activeTab
            )
            .tabItem {
                Label("Library", systemImage: activeTab == .library ? "photo.fill" : "photo")
            }
            .tag(TabType.library)
            
            OutlineStudioView(
                transform: $transform,
                selectedUIImage: $selectedUIImage,
                selectedImageName: $selectedImageName,
                selectedSystemIcon: $selectedSystemIcon,
                activeTab: $activeTab
            )
            .tabItem {
                Label("Studio", systemImage: "slider.horizontal.3")
            }
            .tag(TabType.studio)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: activeTab == .settings ? "gearshape.fill" : "gearshape")
                }
                .tag(TabType.settings)
        }
        .tint(Color.blue)
        .onChange(of: activeTab) { _, _ in
            HapticManager.shared.selection()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
