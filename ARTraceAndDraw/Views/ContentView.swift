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
    
    var body: some View {
        TabView(selection: $activeTab) {
            ARCameraView(transform: $transform, selectedImageName: selectedImageName)
                .tabItem {
                    Label("AR Draw", systemImage: activeTab == .draw ? "camera.fill" : "camera")
                }
                .tag(TabType.draw)
            
            PictureLibraryView(selectedImageName: $selectedImageName, activeTab: $activeTab)
                .tabItem {
                    Label("Library", systemImage: activeTab == .library ? "photo.fill" : "photo")
                }
                .tag(TabType.library)
            
            OutlineStudioView(transform: $transform)
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
        .onChange(of: activeTab) { _ in
            HapticManager.shared.selection()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
