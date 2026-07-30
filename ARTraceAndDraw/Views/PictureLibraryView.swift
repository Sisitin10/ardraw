//
//  PictureLibraryView.swift
//  ARTraceAndDraw
//
//  Native SwiftUI Stencil Gallery
//

import SwiftUI

struct PictureLibraryView: View {
    @Binding var selectedImageName: String
    @Binding var selectedSystemIcon: String
    @Binding var selectedUIImage: UIImage?
    @Binding var activeTab: TabType
    
    @State private var showingImagePicker = false
    
    let presets = PresetData.presets
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Custom Photo Import Banner
                    Button(action: {
                        HapticManager.shared.selection()
                        showingImagePicker = true
                    }) {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.15))
                                    .frame(width: 48, height: 48)
                                Image(systemName: "photo.badge.plus.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Import from Photos Library")
                                    .font(.system(.headline, design: .rounded))
                                    .foregroundColor(.primary)
                                Text("Choose any picture or sketch from your iPhone camera roll")
                                    .font(.system(.caption, design: .default))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.gray)
                        }
                        .padding(16)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(16)
                    }
                    
                    // Stencil Presets Header
                    HStack {
                        Text("Template Presets")
                            .font(.title3.weight(.bold))
                        Spacer()
                    }
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(presets) { item in
                            VStack(alignment: .leading, spacing: 8) {
                                ZStack(alignment: .topTrailing) {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color(uiColor: .secondarySystemBackground))
                                        .aspectRatio(1, contentMode: .fit)
                                    
                                    Image(systemName: item.systemIcon)
                                        .font(.system(size: 48))
                                        .foregroundColor(.blue.opacity(0.8))
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    
                                    Text(item.difficulty)
                                        .font(.system(size: 10, weight: .bold))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Capsule().fill(Color.blue.opacity(0.2)))
                                        .foregroundColor(.blue)
                                        .padding(8)
                                }
                                
                                Text(item.title)
                                    .font(.system(.body, design: .default, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Text(item.category)
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                            .onTapGesture {
                                HapticManager.shared.selection()
                                selectedImageName = item.imageName
                                selectedSystemIcon = item.systemIcon
                                selectedUIImage = nil
                                activeTab = .draw
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Stencil Library")
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedUIImage) { pickedImage in
                    selectedImageName = "custom_imported"
                    selectedSystemIcon = "photo.fill"
                    activeTab = .draw
                }
            }
        }
    }
}
