//
//  OutlineStudioView.swift
//  ARTraceAndDraw
//
//  Native SwiftUI Image Stencil Adjustments
//

import SwiftUI

struct OutlineStudioView: View {
    @Binding var transform: ImageTransform
    @Binding var selectedUIImage: UIImage?
    @Binding var selectedImageName: String
    @Binding var selectedSystemIcon: String
    @Binding var activeTab: TabType
    
    @State private var showingImagePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Photo Source")) {
                    Button(action: {
                        HapticManager.shared.selection()
                        showingImagePicker = true
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.15))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.blue)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Select Photo from iPhone Library")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                Text("Pick any photo or drawing from your camera roll")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "photo.badge.plus")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 4)
                    
                    if let uiImage = selectedUIImage {
                        HStack(spacing: 12) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Loaded Custom Photo")
                                    .font(.subheadline.weight(.semibold))
                                Text("Ready for line art extraction")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    } else {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.blue.opacity(0.1))
                                    .frame(width: 70, height: 70)
                                Image(systemName: selectedSystemIcon)
                                    .font(.system(size: 30))
                                    .foregroundColor(.blue)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Preset: \(selectedImageName.capitalized)")
                                    .font(.subheadline.weight(.semibold))
                                Text("Tap above to replace with photo")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
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
                        HapticManager.shared.impact(.medium)
                        activeTab = .draw
                    }) {
                        HStack {
                            Spacer()
                            Label("Start Tracing in AR Canvas", systemImage: "camera.fill")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .listRowBackground(Color.clear)
                    
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
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedUIImage) { _ in
                    selectedImageName = "custom_photo"
                    selectedSystemIcon = "photo.fill"
                    HapticManager.shared.notification(.success)
                }
            }
        }
    }
}
