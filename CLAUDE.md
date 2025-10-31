# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Structure

This is an iOS SwiftUI application with a local Swift Package Manager (SPM) package structure:

- **Main App**: `yalla/` - The iOS app target with SwiftUI views
  - `yalla/App/` - Main application screens organized by feature
    - `Init/` - Onboarding flow (permissions, language selection, initial loading, auth, OTP)
    - `Home/` - Main home screen with map and ride booking
    - `Main/` - Main navigation container and app-level routing (`MainView`, `MainViewModel`, `AppDestination`)
    - `Menu/` - Side menu features (profile, payment methods, bonus, routes, address selection)
  - `yalla/Resources/` - Assets, localization files (`Localizable.xcstrings`), Info.plist
  - `yalla/Services/` - Business logic layer
    - `Providers/` - Data providers (MeInfoProvider, TaxiOrderConfigProvider)
    - `Models/` - Data models
  - `yalla/Utils/` - Shared utilities
    - `DeepLink/` - Deep linking system (DeepLinkHandler, DeepLinkManager)
    - `Typography/` - Text styles and font definitions
    - `Views/` - Reusable UI components
    - `Modifiers/` - SwiftUI view modifiers
    - `UseCases/` - Business logic use cases

- **Local Packages**: `packages/` - Contains local SPM packages
  - **NetworkMonitor**: Network connectivity monitoring using Network framework
  - **YallaUtils**: Shared utilities (extensions, language support, common views)
  - **YallaStore**: State management and persistence layer with GRDB integration
  - **SwiftMessages**: In-app notifications (local vendored copy)

## Building and Running

### Build Commands
```bash
# Build for Debug
xcodebuild -project yalla.xcodeproj -scheme yalla -configuration Debug build

# Build for Release
xcodebuild -project yalla.xcodeproj -scheme yalla -configuration Release build

# Build specific local package
xcodebuild -project yalla.xcodeproj -scheme NetworkMonitor build
xcodebuild -project yalla.xcodeproj -scheme YallaUtils build
xcodebuild -project yalla.xcodeproj -scheme YallaStore build
xcodebuild -project yalla.xcodeproj -scheme SwiftMessages build

# Build only a specific package without Xcode
swift build --package-path packages/NetworkMonitor
swift build --package-path packages/YallaStore
swift build --package-path packages/YallaUtils

# Open in Xcode
open yalla.xcodeproj
```

### Running Tests
```bash
# Run all tests
xcodebuild test -project yalla.xcodeproj -scheme yalla -destination 'platform=iOS Simulator,name=iPhone 15'

# Run tests for specific package
xcodebuild test -project yalla.xcodeproj -scheme NetworkMonitor -destination 'platform=iOS Simulator,name=iPhone 15'
xcodebuild test -project yalla.xcodeproj -scheme YallaStore -destination 'platform=iOS Simulator,name=iPhone 15'

# Test a package directly
swift test --package-path packages/NetworkMonitor
```

## Architecture Principles

**ViewModel Pattern**: All views should have a corresponding ViewModel and Interactor if required. ViewModels handle UI state and business logic coordination, while Interactors encapsulate domain-specific operations.

**Service Layer**: Business logic lives in `yalla/Services/`:
- `Providers/` - Data access and API integration
- `Models/` - Domain models shared across features

**Navigation System**: Centralized routing via `AppDestination` enum in `Main/ViewModel/AppDestination.swift`:
- Each case maps to a screen (`.loading`, `.home`, `.auth`, etc.)
- `MainViewModel` manages navigation state
- `MainView` coordinates app lifecycle and network monitoring

## Local Package Architecture

### NetworkMonitor Package
Network connectivity monitoring with SwiftUI integration:
- `NetworkMonitor.swift` - Network reachability using NWPathMonitor from Network framework
- `NetworkReachable.swift` - SwiftUI protocol/extension for reactive network state
- Integrated in `MainView` for app-wide connectivity awareness

### YallaUtils Package
Shared utilities and common components:
- `Extensions/` - SwiftUI view and shape extensions
- `Language.swift` - Language management for multilingual support
- `Views/` - Reusable UI components

### YallaStore Package
State management and persistence layer:
- Uses GRDB for local database operations
- `YallaStoreConfig.swift` - Configuration
- `Utils/userDefaultsWrapper.swift` - Property wrapper for UserDefaults

### SwiftMessages Package
Vendored in-app notification system for displaying messages and alerts

## External Dependencies

**Remote Packages** (via Swift Package Manager):
- **YallaKit** (GitHub: MuhammadjonTohirov/yallakit, branch: main)
  - Products: Core, IldamSDK, NetworkLayer, YallaKit
- **SlidingBottomSheet** (GitHub: MuhammadjonTohirov/SlidingBottomSheet, branch: main) - Bottom sheet UI component
- **Firebase iOS SDK** (12.4.0)
  - Products: FirebaseCore, FirebaseCrashlytics, FirebaseMessaging, FirebaseAnalytics
- **Kingfisher** (8.6.0) - Image loading and caching
- **GRDB** (7.8.0) - SQLite toolkit (used by YallaStore)
- **SQBCardScanner** (1.0.5) - Card scanning functionality

**Local Packages**:
- NetworkMonitor, YallaUtils, YallaStore, SwiftMessages (all linked from `packages/`)

## Configuration

**Build Configuration**: `Yalla.xcconfig` contains brand-specific settings:
- `PRODUCT_BUNDLE_IDENTIFIER` - uz.ildam.taxiclient2
- `DISPLAY_NAME` - Yalla
- `BRAND_COLOR` - #3812CE
- `DEEP_LINK_SCHEME` - ildam
- `ASSOCIATED_DOMAINS_*` - Deep link and web credentials for ildam.uz

**Info.plist**: `yalla/Resources/Yalla-Info.plist`

**Localization**: `yalla/Resources/Localizable.xcstrings` (supports en, ru, uz-Latn, uz-Cyrl)

## Platform Requirements

- iOS 16.6+ (deployment target)
- Swift 6.0+
- Xcode 16.0+ (Swift Tools 6.2)
- iPhone only (not iPad/Mac Catalyst)

## Deep Linking

Deep linking system in `yalla/Utils/DeepLink/`:
- **Scheme**: `ildam://` (configured in Yalla.xcconfig)
- **Associated Domains**: ildam.uz, www.ildam.uz (for universal links)
- **Components**: `DeepLinkHandler` and `DeepLinkManager` coordinate deep link routing

## Coding Standards (from AGENTS.md)

**Swift Conventions**:
- 4-space indentation
- Opening braces on same line
- `UpperCamelCase` for types and modules
- `lowerCamelCase` for properties and functions

**Best Practices**:
- Keep view structs lightweight; move state into ViewModels
- Prefer protocol-driven abstractions in packages
- Expose minimal `public` surface areas
- Target >70% test coverage for ViewModels and repositories
- Stub Firebase, GRDB, and SDK dependencies in unit tests
