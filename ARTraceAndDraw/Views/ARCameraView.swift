//
//  ARCameraView.swift
//  ARTraceAndDraw
//
//  Native SwiftUI AR Camera Overlay View
//

import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }

    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        
        let session = AVCaptureSession()
        session.sessionPreset = .high
        
        if let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
           let input = try? AVCaptureDeviceInput(device: backCamera),
           session.canAddInput(input) {
            session.addInput(input)
            DispatchQueue.global(qos: .userInitiated).async {
                session.startRunning()
            }
        }
        view.videoPreviewLayer.session = session
        return view
    }

    func updateUIView(_ uiView: VideoPreviewView, context: Context) {}
}

struct ARCameraView: View {
    @Binding var transform: ImageTransform
    var selectedImageName: String
    
    @State private var currentScale: CGFloat = 1.0
    @State private var currentRotation: Angle = .zero
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            // Live Device Rear Camera Feed
            CameraPreviewView()
                .ignoresSafeArea()
            
            // Overlay Stencil Graphic with Gestures
            Image(selectedImageName)
                .resizable()
                .scaledToFit()
                .opacity(transform.opacity)
                .scaleEffect(transform.scale * currentScale)
                .rotationEffect(Angle(degrees: transform.rotation) + currentRotation)
                .offset(x: transform.x + dragOffset.width, y: transform.y + dragOffset.height)
                .scaleEffect(x: transform.isFlippedHorizontally ? -1 : 1, y: transform.isFlippedVertically ? -1 : 1)
                .gesture(
                    SimultaneousGesture(
                        DragGesture()
                            .onChanged { value in
                                guard !transform.isLocked else { return }
                                dragOffset = value.translation
                            }
                            .onEnded { value in
                                guard !transform.isLocked else { return }
                                transform.x += value.translation.width
                                transform.y += value.translation.height
                                dragOffset = .zero
                                HapticManager.shared.impact(.light)
                            },
                        SimultaneousGesture(
                            MagnificationGesture()
                                .onChanged { scale in
                                    guard !transform.isLocked else { return }
                                    currentScale = scale
                                }
                                .onEnded { scale in
                                    guard !transform.isLocked else { return }
                                    transform.scale *= scale
                                    currentScale = 1.0
                                    HapticManager.shared.impact(.medium)
                                },
                            RotationGesture()
                                .onChanged { angle in
                                    guard !transform.isLocked else { return }
                                    currentRotation = angle
                                }
                                .onEnded { angle in
                                    guard !transform.isLocked else { return }
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
                    Button(action: {
                        transform.isLocked.toggle()
                        HapticManager.shared.selection()
                    }) {
                        Image(systemName: transform.isLocked ? "lock.fill" : "lock.open.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(transform.isLocked ? .yellow : .white)
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        transform.isFlippedHorizontally.toggle()
                        HapticManager.shared.selection()
                    }) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                
                Spacer()
                
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
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 100)
            }
        }
    }
}
