//
//  OutlineStudioView.swift
//  ARTraceAndDraw
//
//  Native SwiftUI Image Stencil Adjustments
//

import SwiftUI

struct OutlineStudioView: View {
    @Binding var transform: ImageTransform
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Line Art Filter")) {
                    Picker("Filter Type", selection: $transform.filterMode) {
                        ForEach(FilterMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: transform.filterMode) { _ in
                        HapticManager.shared.selection()
                    }
                }
                
                Section(header: Text("Adjustments")) {
                    VStack(alignment: .leading) {
                        Text("Contrast: \(String(format: "%.1f", transform.contrast))")
                        Slider(value: $transform.contrast, in: 0.5...2.5)
                            .tint(.blue)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Brightness: \(String(format: "%.1f", transform.brightness))")
                        Slider(value: $transform.brightness, in: 0.5...2.0)
                            .tint(.blue)
                    }
                }
                
                Section {
                    Button(action: {
                        HapticManager.shared.notification(.success)
                        transform.contrast = 1.0
                        transform.brightness = 1.0
                        transform.scale = 1.0
                        transform.rotation = 0.0
                        transform.x = 0
                        transform.y = 0
                    }) {
                        HStack {
                            Spacer()
                            Text("Reset All Transformations")
                                .fontWeight(.semibold)
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Outline Studio")
        }
    }
}
