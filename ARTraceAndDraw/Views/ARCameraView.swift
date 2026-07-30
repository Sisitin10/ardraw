//
//  ARCameraView.swift
//  ARTraceAndDraw
//
//  Native SwiftUI AR Camera Overlay View
//

import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    var cameraPosition: AVCaptureDevice.Position = .back
    var zoomLevel: String = "1.0x"

    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
        var session: AVCaptureSession?
    }

    private func setupCamera(session: AVCaptureSession) {
        session.beginConfiguration()
        defer { session.commitConfiguration() }
        
        for input in session.inputs {
            session.removeInput(input)
        }
        
        let device: AVCaptureDevice?
        if cameraPosition == .back && zoomLevel == "0.5x" {
            // Prefer physical ultra-wide camera if available on device
            if let ultraWide = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
                device = ultraWide
            } else {
                device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            }
        } else {
            device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraPosition)
        }
        
        if let device = device,
           let input = try? AVCaptureDeviceInput(device: device),
           session.canAddInput(input) {
            session.addInput(input)
            
            // Apply zoom factor if wide angle fallback is used for 0.5x
            do {
                try device.lockForConfiguration()
                if zoomLevel == "0.5x" && device.deviceType != .builtInUltraWideCamera {
                    let minZoom = device.minAvailableVideoZoomFactor
                    device.videoZoomFactor = minZoom
                } else {
                    device.videoZoomFactor = 1.0
                }
                device.unlockForConfiguration()
            } catch {}
        }
    }

    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        
        let session = AVCaptureSession()
        session.sessionPreset = .high
        setupCamera(session: session)
        
        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
        view.videoPreviewLayer.session = session
        view.session = session
        return view
    }

    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        guard let session = uiView.session else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            setupCamera(session: session)
        }
    }
}

struct FilterModifier: ViewModifier {
    var filterMode: FilterMode

    func body(content: Content) -> some View {
        switch filterMode {
        case .invert:
            content.colorInvert()
        case .highContrast:
            content.contrast(2.0)
        case .lineArt:
            content.colorMultiply(.primary).contrast(1.5)
        case .removeBg:
            content.blendMode(.multiply)
        case .original:
            content
        }
    }
}

struct StencilGraphicView: View {
    var imageName: String
    var uiImage: UIImage?
    var systemIcon: String
    var transform: ImageTransform

    var body: some View {
        Group {
            if let customImg = uiImage {
                Image(uiImage: customImg)
                    .resizable()
                    .scaledToFit()
            } else if let bundleImg = UIImage(named: imageName) {
                Image(uiImage: bundleImg)
                    .resizable()
                    .scaledToFit()
            } else {
                VStack(spacing: 12) {
                    Image(systemName: systemIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 220)
                        .foregroundColor(.blue)
                        .padding(30)
                        .background(
                            Circle()
                                .stroke(Color.blue, lineWidth: 6)
                                .background(Circle().fill(Color.white.opacity(0.85)))
                        )
                }
            }
        }
        .modifier(FilterModifier(filterMode: transform.filterMode))
        .contrast(transform.contrast)
        .brightness(transform.brightness - 1.0)
    }
}

extension View {
    func interactive(_ enabled: Bool = true) -> some View {
        self.hoverEffect(.highlight)
    }
}

struct ARCameraView: View {
    @Binding var transform: ImageTransform
    var selectedImageName: String
    var selectedUIImage: UIImage? = nil
    var selectedSystemIcon: String = "pawprint.fill"
    
    @State private var cameraPosition: AVCaptureDevice.Position = .back
    @State private var zoomLevel: String = "1.0x"
    @State private var currentScale: CGFloat = 1.0
    @State private var currentRotation: Angle = .zero
    @State private var dragOffset: CGSize = .zero
    
    // Function for camera flipping logic
    func flipCamera() {
        HapticManager.shared.selection()
        cameraPosition = (cameraPosition == .back) ? .front : .back
    }
    
    var body: some View {
        ZStack {
            // Live Device Rear/Front Camera Feed
            CameraPreviewView(cameraPosition: cameraPosition, zoomLevel: zoomLevel)
                .ignoresSafeArea()
            
            // Overlay Stencil Graphic with Gestures
            StencilGraphicView(
                imageName: selectedImageName,
                uiImage: selectedUIImage,
                systemIcon: selectedSystemIcon,
                transform: transform
            )
            .opacity(transform.opacity)
            .scaleEffect(max(0.1, transform.scale * currentScale))
            .rotationEffect(Angle(degrees: transform.rotation) + currentRotation)
            .offset(x: transform.x + dragOffset.width, y: transform.y + dragOffset.height)
            .scaleEffect(x: transform.isFlippedHorizontally ? -1 : 1, y: transform.isFlippedVertically ? -1 : 1)
            .gesture(
                SimultaneousGesture(
                    DragGesture()
                        .onChanged { value in
                            guard !transform.isLocked, currentScale == 1.0, currentRotation == .zero else { return }
                            dragOffset = value.translation
                        }
                        .onEnded { value in
                            guard !transform.isLocked, currentScale == 1.0, currentRotation == .zero else { return }
                            let newX = transform.x + value.translation.width
                            let newY = transform.y + value.translation.height
                            transform.x = max(-1000, min(1000, newX))
                            transform.y = max(-1000, min(1000, newY))
                            dragOffset = .zero
                            HapticManager.shared.impact(.light)
                        },
                    SimultaneousGesture(
                        MagnificationGesture()
                            .onChanged { scale in
                                guard !transform.isLocked, scale.isFinite, scale > 0 else { return }
                                currentScale = scale
                            }
                            .onEnded { scale in
                                guard !transform.isLocked, scale.isFinite, scale > 0 else { return }
                                let computed = transform.scale * scale
                                transform.scale = max(0.2, min(8.0, computed.isFinite ? computed : 1.0))
                                currentScale = 1.0
                                HapticManager.shared.impact(.medium)
                            },
                        RotationGesture()
                            .onChanged { angle in
                                guard !transform.isLocked, angle.degrees.isFinite else { return }
                                currentRotation = angle
                            }
                            .onEnded { angle in
                                guard !transform.isLocked, angle.degrees.isFinite else { return }
                                transform.rotation += angle.degrees
                                currentRotation = .zero
                                HapticManager.shared.impact(.medium)
                            }
                    )
                )
            )
            
            // HUD Floating Controls
            VStack {
                HStack {
                    // Lock Stencil Button
                    Button(action: {
                        transform.isLocked.toggle()
                        HapticManager.shared.selection()
                    }) {
                        Image(systemName: transform.isLocked ? "lock.fill" : "lock.open.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(transform.isLocked ? .yellow : .white)
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.glass)
                    .interactive(true)
                    
                    Spacer()
                    
                    // Camera Flip Button
                    Button(action: flipCamera) {
                        Image(systemName: "camera.rotate.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.glass)
                    .interactive(true)
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                
                Spacer()
                
                // Compact Floating Zoom Selector Pill
                HStack {
                    Picker("Zoom", selection: $zoomLevel) {
                        Text("0.5x").tag("0.5x")
                        Text("1.0x").tag("1.0x")
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 110)
                    .glassEffect(.regular)
                    .interactive(true)
                    .onChange(of: zoomLevel) { _, _ in
                        HapticManager.shared.selection()
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 6)
                
                // Opacity Slider Bar
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "eye.fill")
                            .foregroundColor(.white.opacity(0.8))
                        Slider(value: $transform.opacity, in: 0.1...1.0)
                            .tint(Color.blue)
                        Text("\(Int(transform.opacity * 100))%")
                            .font(.system(.caption, design: .rounded, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .glassEffect(.regular)
                    .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
        }
    }
}

