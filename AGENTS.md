# Repository Guidelines

## Project Structure & Module Organization
- `yalla/` hosts the iOS app; `App/` covers feature flows (`Home`, `Init`, `Main`), `Extensions/` and `Utils/` surface shared SwiftUI helpers, while `Resources/` and `Assets.xcassets` store localized data.  
- `packages/` holds Swift Package Manager modules (`BottomSheet`, `NetworkMonitor`, `YallaStore`, `YallaUtils`), each with a `Sources/` tree for reusable components. Use sibling `Tests/` directories when adding coverage.  
- `Yalla.xcconfig` centralises build settings; keep environment overrides in private xcconfig layers. The `yalla.xcodeproj` project ties the app target to these packages.

## Build, Test, and Development Commands
- `xcodebuild -project yalla.xcodeproj -scheme yalla -destination 'platform=iOS Simulator,name=iPhone 15' build` compiles the app and validates target wiring.  
- `xcodebuild -project yalla.xcodeproj -scheme yalla -destination 'platform=iOS Simulator,name=iPhone 15' test` executes UI and unit tests once targets are defined.  
- `swift build --package-path packages/YallaStore` (or another package path) checks package-only changes without reopening Xcode.

## Coding Style & Naming Conventions
- Follow standard Swift conventions: 4-space indentation, opening braces on the same line, `UpperCamelCase` for types and modules, `lowerCamelCase` for properties and functions.  
- Keep view structs lightweight; move state into view models (see `App/Home`).  
- Prefer protocol-driven abstractions in packages; expose minimal `public` surface areas.  
- Format via Xcode auto-indent and document formatter rules alongside xcconfig notes.

## Testing Guidelines
- Add XCTest targets alongside each new module (`YallaStoreTests`, `BottomSheetTests`, etc.) and mirror the `Sources/` tree under `Tests/`.  
- Stub Firebase, GRDB, and SDK dependencies with lightweight protocols to avoid network or database access in unit tests.  
- Target >70% coverage for view models and repositories; snapshot complex layouts in `App/Home/Views`.  
- Run `xcodebuild … test` or `swift test --package-path packages/<ModuleName>` before pushing.

## Commit & Pull Request Guidelines
- Use short, imperative commit subjects (e.g., “Add network reachability monitor”); group related file updates into a single commit.  
- Reference issue IDs in the body when applicable and note migration steps for Firebase or database changes.  
- Pull requests should include a concise summary, affected modules, simulator screenshots for UI updates, and a checklist of manual verifications; request reviews from owners of touched modules and wait for CI green before merging.

## Security & Configuration Tips
- Never commit credentials; load secrets through environment-specific xcconfig files ignored by git.  
- Confirm Firebase setup by matching `GoogleService-Info.plist` bundle IDs and document any entitlement changes in the PR description.  
- Audit third-party SDK updates in packages via CHANGELOG review before upgrading versions.
