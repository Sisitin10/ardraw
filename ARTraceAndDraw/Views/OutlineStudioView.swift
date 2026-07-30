//
//  OutlineStudioView.swift
//  ARTraceAndDraw
//
//  Native SwiftUI Image Stencil Adjustments
//

import SwiftUI
import Vision
import CoreImage

struct OutlineStudioView: View {
    @Binding var transform: ImageTransform
    @Binding var selectedUIImage: UIImage?
    @Binding var selectedImageName: String
    @Binding var selectedSystemIcon: String
    @Binding var activeTab: TabType
    
    @State private var showingImagePicker = false
    @State private var originalUIImage: UIImage? = nil
    @State private var isProcessingBG = false
    @State private var hasRemovedBG = false
    
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
                    .onChange(of: transform.filterMode) { _, _ in
                        HapticManager.shared.selection()
                    }
                }
                
                Section(header: Text("Vision AI Background Removal")) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Isolate subjects instantly using Apple Vision Framework")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 12) {
                            Button(action: {
                                HapticManager.shared.impact(.medium)
                                performBackgroundRemoval()
                            }) {
                                HStack(spacing: 8) {
                                    if isProcessingBG {
                                        ProgressView()
                                            .tint(.primary)
                                    } else {
                                        Image(systemName: "wand.and.stars")
                                            .font(.system(size: 16, weight: .bold))
                                    }
                                    Text(isProcessingBG ? "Processing..." : "Remove BG (Vision)")
                                        .fontWeight(.bold)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 14)
                            }
                            .buttonStyle(.glass)
                            .disabled(isProcessingBG)
                            
                            if hasRemovedBG || originalUIImage != nil {
                                Button(action: {
                                    HapticManager.shared.notification(.success)
                                    if let orig = originalUIImage {
                                        selectedUIImage = orig
                                    }
                                    originalUIImage = nil
                                    hasRemovedBG = false
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "arrow.uturn.backward")
                                            .font(.system(size: 14, weight: .bold))
                                        Text("Revert Original")
                                            .fontWeight(.semibold)
                                    }
                                    .foregroundColor(.red)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                }
                                .buttonStyle(.glass)
                            }
                        }
                    }
                    .padding(.vertical, 4)
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
    
    private func performBackgroundRemoval() {
        let inputImage: UIImage?
        if let selected = selectedUIImage {
            inputImage = selected
        } else {
            let config = UIImage.SymbolConfiguration(pointSize: 200, weight: .bold)
            inputImage = UIImage(systemName: selectedSystemIcon, withConfiguration: config)
        }
        
        guard let source = inputImage else { return }
        if originalUIImage == nil {
            originalUIImage = selectedUIImage ?? source
        }
        
        isProcessingBG = true
        
        removeVisionBackground(from: source) { result in
            isProcessingBG = false
            if let transparentImage = result {
                selectedUIImage = transparentImage
                hasRemovedBG = true
                HapticManager.shared.notification(.success)
            } else {
                HapticManager.shared.notification(.error)
            }
        }
    }
    
    private func removeVisionBackground(from image: UIImage, completion: @escaping (UIImage?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        if #available(iOS 17.0, *) {
            let request = VNGenerateForegroundInstanceMaskRequest()
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                    guard let result = request.results?.first else {
                        DispatchQueue.main.async { completion(nil) }
                        return
                    }
                    let maskPixelBuffer = try result.generateMaskedImage(
                        ofInstances: result.allInstances,
                        from: handler,
                        croppedToInstancesExtent: false
                    )
                    let ciImage = CIImage(cvPixelBuffer: maskPixelBuffer)
                    let context = CIContext()
                    if let resultCGImage = context.createCGImage(ciImage, from: ciImage.extent) {
                        let processed = UIImage(cgImage: resultCGImage)
                        DispatchQueue.main.async { completion(processed) }
                        return
                    }
                } catch {
                    print("Vision error: \(error)")
                }
                DispatchQueue.main.async { completion(nil) }
            }
        } else {
            completion(nil)
        }
    }
}
