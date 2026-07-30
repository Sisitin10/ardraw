//
//  SettingsView.swift
//  ARTraceAndDraw
//
//  Native SwiftUI Setup & Instructions
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Tracing Setup Guide")) {
                    HStack(spacing: 16) {
                        Image(systemName: "iphone.radiowaves.left.and.right")
                            .font(.title)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("1. Stand your Phone")
                                .fontWeight(.semibold)
                            Text("Prop your device up on a cup or phone stand over paper.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                    
                    HStack(spacing: 16) {
                        Image(systemName: "hand.draw.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("2. Look at Screen & Trace")
                                .fontWeight(.semibold)
                            Text("Look into your screen while guiding your pen on paper.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                Section(header: Text("Permissions")) {
                    HStack {
                        Label("Camera Access", systemImage: "camera.fill")
                        Spacer()
                        Text("Authorized")
                            .foregroundColor(.green)
                            .font(.subheadline)
                    }
                }
                
                Section(header: Text("About App")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0 (Native SwiftUI)")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Framework")
                        Spacer()
                        Text("AVFoundation + SwiftUI")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings & Guide")
        }
    }
}
