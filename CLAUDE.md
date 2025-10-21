# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Structure

This is an iOS SwiftUI application with a local Swift Package Manager (SPM) package structure:

- **Main App**: `yalla/` - The iOS app target with SwiftUI views
  - `yalla/App/` - Main application screens organized by feature
    - `Init/` - Onboarding flow (permissions, language selection, initial loading)
    - `Home/` - Main home screen
    - `Main/` - Main navigation container and app-level routing
  - `yalla/Resources/` - Assets, localization, configuration files
  - `yalla/Utils/` - Shared utilities, view components, typography, deep linking

- **Local Packages**: `packages/` - Contains local SPM packages
  - **BottomSheet**: Custom bottom sheet component library
  - **NetworkMonitor**: Network connectivity monitoring
  - **YallaUtils**: Shared utilities (extensions, language support, common views)
  - **YallaStore**: State management layer

## Building and Running

### Build Commands
```bash
# Build for Debug
xcodebuild -project yalla.xcodeproj -scheme yalla -configuration Debug build

# Build for Release
xcodebuild -project yalla.xcodeproj -scheme yalla -configuration Release build

# Build specific local package
xcodebuild -project yalla.xcodeproj -scheme BottomSheet build
xcodebuild -project yalla.xcodeproj -scheme NetworkMonitor build
xcodebuild -project yalla.xcodeproj -scheme YallaUtils build
xcodebuild -project yalla.xcodeproj -scheme YallaStore build

# Open in Xcode
open yalla.xcodeproj
```

### Running Tests
```bash
# Run all tests
xcodebuild test -project yalla.xcodeproj -scheme yalla -destination 'platform=iOS Simulator,name=iPhone 15'

# Run tests for specific package
xcodebuild test -project yalla.xcodeproj -scheme BottomSheet -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Local Package Architecture

### BottomSheet Package
SwiftUI component library providing customizable bottom sheet with modular architecture:

**Core Architecture**
All views should have viewmodel and interactor if required.

**Core Components**:
- `BottomSheet.swift` - Main component wrapping views with bottom sheet overlay
- `BottomSheetView/` - Internal view implementation
- `Models/` - Core data models (BottomSheetPosition, BottomSheetConfiguration, BottomSheetWidth)

**Position System** (`BottomSheetPosition`):
- `.hidden` - Sheet hidden
- `.dynamic[Bottom|Top]` - Content-sized height
- `.relative[Bottom|Top](CGFloat)` - Percentage-based height (0.0-1.0)
- `.absolute[Bottom|Top](CGFloat)` - Fixed pixel height

**Configuration** (`BottomSheetConfiguration`):
- Builder pattern with chainable setters (`.setAnimation()`, `.setDragIndicatorShown()`, etc.)
- Modular view modifiers in `BottomSheet+ViewModifiers/`:
  - Drag behaviors: DragGesture, ContentDrag, SwipeToDismiss, FlickThrough
  - Visual: DragIndicator, BackgroundBlur, CustomBackground, CloseButton
  - Layout: Resizable, SheetWidth, FloatingIPadSheet, AccountingForKeyboardHeight, Threshold
  - Interaction: AppleScrollBehavior, TapToDismiss
  - Callbacks: OnDismiss

**Usage Pattern**:
```swift
someView.bottomSheet(
    bottomSheetPosition: $position,
    switchablePositions: [.absolute(300), .absolute(600)],
    configuration: .init()
        .setAnimation(.spring())
        .setDragIndicatorShown(true),
    headerContent: { /* optional header */ },
    mainContent: { /* sheet content */ }
)
```

### NetworkMonitor Package
Network connectivity monitoring with SwiftUI integration:
- `NetworkMonitor.swift` - Main monitor using Network framework
- `NetworkReachable.swift` - SwiftUI protocol/extension for reactive network state
- `UIApplication+.swift` - UIApplication extensions

### YallaUtils Package
Shared utilities and common components:
- `Extensions/` - SwiftUI view and shape extensions
- `Language.swift` - Language management
- `Views/` - Reusable UI components (SubmitButton, etc.)

### YallaStore Package
State management layer (TBD - currently minimal implementation)

## External Dependencies

**Remote Packages** (via Swift Package Manager):
- **YallaKit** (GitHub: MuhammadjonTohirov/yallakit, branch: main)
  - Products: Core, IldamSDK, NetworkLayer, YallaKit
- **Firebase iOS SDK** (≥12.4.0)
  - Products: FirebaseCore, FirebaseCrashlytics, FirebaseMessaging, FirebaseAnalytics
- **Kingfisher** (≥8.6.0) - Image loading/caching

**Local Packages**:
- BottomSheet, NetworkMonitor, YallaUtils, YallaStore (all linked from `packages/`)

## Configuration

**Build Configuration**: `Yalla.xcconfig` contains brand-specific settings:
- Bundle identifier, display name, app icon
- Deep link schemes and associated domains
- Brand colors and configuration keys

**Info.plist**: `yalla/Resources/Yalla-Info.plist`

**Localization**: `yalla/Resources/Localizable.xcstrings` (supports en, ru, uz, uz-Cyrl)

## Platform Requirements

- iOS 16.6+ (deployment target)
- Swift 6.0+
- Xcode 16.0+ (Swift Tools 6.2)
- iPhone only (not iPad/Mac Catalyst)

## Architecture Patterns

**State Management**:
- SwiftUI `@State`, `@Binding`, `@ObservedObject` patterns
- ViewModel pattern for screens (e.g., `HomeViewModel`, `InitialLoadingViewModel`)
- Future: YallaStore package for centralized state

**Navigation**:
- `AppDestination` enum defines app-wide navigation targets
- SwiftUI navigation with programmatic routing

**Modular Design**:
- Feature-based organization (Init, Home, Main)
- Reusable components in Utils and local packages
- Separation of concerns between UI, business logic, and utilities

**Deep Linking**:
- `DeepLinkHandler` and `DeepLinkManager` in `yalla/Utils/DeepLink/`
- Scheme: `ildam://` (configured in Yalla.xcconfig)
