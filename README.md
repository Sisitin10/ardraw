# AR Draw Native iOS Xcode Project

This folder contains the complete, native Apple SwiftUI codebase for **AR Draw** (Bundle ID: `com.sisudev.ardraw`). It is fully configured with an Xcode project (`ARTraceAndDraw.xcodeproj`) to build and export `.ipa` files for iOS devices.

## 📁 Directory Overview

- `ARTraceAndDraw.xcodeproj/` - Xcode Project configuration file
- `ARTraceAndDraw/ARTraceAndDrawApp.swift` - Native `@main` SwiftUI application entrypoint
- `ARTraceAndDraw/Info.plist` - iOS Permissions (`NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`)
- `ARTraceAndDraw/Views/ContentView.swift` - Apple SF Symbols SwiftUI `TabView` bar
- `ARTraceAndDraw/Views/ARCameraView.swift` - Live `AVCaptureSession` rear camera feed + gesture overlay
- `ARTraceAndDraw/Views/PictureLibraryView.swift` - Stencil preset gallery
- `ARTraceAndDraw/Views/OutlineStudioView.swift` - Line art stencil controls
- `ARTraceAndDraw/Views/SettingsView.swift` - Interactive device setup guide
- `ARTraceAndDraw/Utils/HapticManager.swift` - `UIImpactFeedbackGenerator` tactile feedback engine

---

## 🛠️ How to Compile & Export `.ipa` in Xcode

### Option 1: Using Xcode UI (Recommended)
1. Open the project:
   ```bash
   open ios/ARTraceAndDraw.xcodeproj
   ```
2. Select your Apple Development Team under **Signing & Capabilities**.
3. Select an iOS device target or **Any iOS Device (arm64)**.
4. Go to **Product > Archive**.
5. Once complete, click **Distribute App** > **Ad Hoc** or **Development** / **TestFlight**.
6. Export the compiled `.ipa` file to your desktop.

### Option 2: Using Command-Line (`xcodebuild`)
To compile an `.ipa` directly from the macOS terminal:

```bash
cd ios

# 1. Clean build directory
xcodebuild clean -project ARTraceAndDraw.xcodeproj -scheme ARTraceAndDraw

# 2. Build Archive
xcodebuild archive \
  -project ARTraceAndDraw.xcodeproj \
  -scheme ARTraceAndDraw \
  -archivePath ./build/ARTraceAndDraw.xcarchive

# 3. Export IPA
xcodebuild -exportArchive \
  -archivePath ./build/ARTraceAndDraw.xcarchive \
  -exportOptionsPlist ./ARTraceAndDraw/Info.plist \
  -exportPath ./build/output
```
The compiled `.ipa` file will be saved in `ios/build/output/ARTraceAndDraw.ipa`.
