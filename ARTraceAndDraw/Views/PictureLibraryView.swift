//
//  PictureLibraryView.swift
//  ARTraceAndDraw
//
//  Native SwiftUI Stencil Gallery
//

import SwiftUI

struct PictureLibraryView: View {
    @Binding var selectedImageName: String
    @Binding var activeTab: TabType
    
    let presets: [PresetImage] = [
        PresetImage(id: "1", title: "Cute Bunny", category: "Animals", imageName: "bunny", isTransparent: true, difficulty: "Easy"),
        PresetImage(id: "2", title: "Rose Floral", category: "Botanical", imageName: "rose", isTransparent: true, difficulty: "Medium"),
        PresetImage(id: "3", title: "Anime Portrait", category: "Anime", imageName: "anime_face", isTransparent: true, difficulty: "Hard"),
        PresetImage(id: "4", title: "Vintage Car", category: "Vehicles", imageName: "car", isTransparent: true, difficulty: "Medium"),
    ]
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(presets) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            ZStack(alignment: .topTrailing) {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color(uiColor: .secondarySystemBackground))
                                    .aspectRatio(1, contentMode: .fit)
                                
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray.opacity(0.4))
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
                            activeTab = .draw
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Stencil Library")
        }
    }
}
