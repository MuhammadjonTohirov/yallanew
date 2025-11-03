# Yalla iOS App - Assets Information

## Overview

This document provides a comprehensive reference for all assets used in the Yalla iOS application, including images, colors, fonts, and other resources.

**Asset Catalog Location**: `yalla/Assets.xcassets`  
**Additional Resources**: `yalla/Resources/`

---

## Table of Contents

1. [Color Assets](#color-assets)
2. [Image Assets](#image-assets)
3. [App Icon](#app-icon)
4. [Fonts](#fonts)
5. [Localization](#localization)
6. [Usage Guidelines](#usage-guidelines)

---

## Color Assets

**Location**: `yalla/Assets.xcassets/colors/`  
**Total Colors**: 11

### Color Palette

| Asset Name | Description | Color Value (Display P3) | Usage |
|-----------|-------------|--------------------------|--------|
| **AccentColor** | App accent color | Default iOS accent | System-wide accent |
| **IPrimary** | Primary brand color | RGB(86, 45, 248) #562DF8 | Primary buttons, highlights |
| **IPrimaryDark** | Dark variant of primary | - | Dark mode primary |
| **IPrimaryLite** | Light variant of primary | - | Subtle primary accents |
| **ILabel** | Primary text label | - | Main text content |
| **iLabelSubtle** | Subtle/secondary text | - | Secondary text, hints |
| **ITextLink** | Text link color | - | Clickable text links |
| **IButtonActiveLabel** | Active button text | - | Button label when active |
| **IBackgroundSecondary** | Secondary background | - | Cards, containers |
| **IBackgroundTertiary** | Tertiary background | - | Nested containers |
| **IBorderDisabled** | Disabled border color | - | Disabled UI elements |

### Color Usage in Code

```swift
// SwiftUI
.foregroundColor(Color("IPrimary"))
.background(Color("IBackgroundSecondary"))

// UIKit
UIColor(named: "IPrimary")
```

**Dark Mode Support**: All colors have dark mode variants defined in their colorset.

---

## Image Assets

**Location**: `yalla/Assets.xcassets/icons/` and `yalla/Assets.xcassets/images/`  
**Total Images**: 62  
**Format**: PNG with 1x, 2x, and 3x variants

### Icons

#### Navigation & UI Controls
| Asset Name | Description | Category |
|-----------|-------------|----------|
| `icon_back` | Back arrow button | Navigation |
| `icon_back_smaller` | Smaller back arrow | Navigation |
| `icon_backarrow` | Alternative back arrow | Navigation |
| `icon_hamburger` | Menu hamburger icon | Navigation |
| `icon_more_rounded` | More options (3 dots) | Navigation |
| `icon_x` | Close/dismiss icon | Controls |
| `icon_check` | Checkmark icon | Controls |
| `icon_trash` | Delete/remove icon | Actions |

#### User & Profile
| Asset Name | Description | Category |
|-----------|-------------|----------|
| `icon_user` | User profile icon | Profile |
| `icon_camera` | Camera icon | Media |
| `icon_gallery` | Gallery icon | Media |
| `icon_gallery_add` | Add to gallery | Media |
| `icon_scan` | QR/document scan | Media |
| `icon_mask` | Mask/face icon | Profile |

#### Communication
| Asset Name | Description | Category |
|-----------|-------------|----------|
| `icon_calling` | Phone call icon | Communication |
| `icon_chat` | Chat/messages icon | Communication |
| `icon_messages` | Messages icon | Communication |
| `icon_notification` | Bell notification icon | Communication |
| `icon_telegramm` | Telegram social icon | Social |

#### Settings & Preferences
| Asset Name | Description | Category |
|-----------|-------------|----------|
| `icon_setting2` | Settings/gear icon | Settings |
| `icon_theme_setting` | Theme settings | Settings |
| `icon_language-square` | Language selection | Settings |
| `icon_sun` | Light theme icon | Theme |
| `icon_moon` | Dark theme icon | Theme |
| `icon_brush` | Customization/theme | Theme |
| `icon_logout` | Logout icon | Account |

#### Location & Map
| Asset Name | Description | Category |
|-----------|-------------|----------|
| `icon_location_tick` | Location confirmed | Location |
| `img_map_pin` | Map location pin | Location |
| `img_pin` | Generic pin icon | Location |

#### Financial & Payment
| Asset Name | Description | Category |
|-----------|-------------|----------|
| `icon_cash3d` | Cash payment 3D icon | Payment |
| `icon_gold_coin` | Gold coin/bonus | Payment |
| `icon_visa` | Visa card logo | Payment Cards |
| `icon_mastercard` | Mastercard logo | Payment Cards |
| `icon_uzcard` | UzCard logo | Payment Cards |
| `icon_humo` | Humo card logo | Payment Cards |
| `icon_atto` | Atto payment | Payment Cards |
| `icon_unionpay` | UnionPay logo | Payment Cards |
| `icon_ticket_discount` | Discount/promo ticket | Promotions |

#### Calendar & Task
| Asset Name | Description | Category |
|-----------|-------------|----------|
| `icon_calendar` | Calendar icon | Scheduling |
| `icon_task` | Task/checklist icon | Tasks |

#### Status & Feedback
| Asset Name | Description | Category |
|-----------|-------------|----------|
| `icon_success_rounded` | Success checkmark (rounded) | Status |
| `icon_error_rounded` | Error icon (rounded) | Status |

#### Country Flags
| Asset Name | Description | Category |
|-----------|-------------|----------|
| `icon_uzbekistan` | Uzbekistan flag | Locale |
| `icon_russia` | Russia flag | Locale |
| `icon_united kingdom` | UK flag | Locale |

#### Branding
| Asset Name | Description | Category |
|-----------|-------------|----------|
| `icon_logo` | Main app logo icon | Brand |
| `icon_logo_flat` | Flat version of logo | Brand |
| `splash_logo` | Splash screen logo | Brand |

### Background Images

| Asset Name | Description | Usage |
|-----------|-------------|-------|
| `img_bg_delivery` | Delivery service background | Service cards |
| `img_bg_intercity` | Intercity travel background | Service cards |
| `img_bg_post` | Postal service background | Service cards |
| `img_bonus_background` | Bonus/rewards background | Promotions |
| `img_address_card_background` | Address card background | Address UI |
| `img_become_driver` | Become driver CTA | Driver recruitment |
| `img_become_driver_bg` | Driver CTA background | Driver recruitment |

### Illustrations & Placeholders

| Asset Name | Description | Usage |
|-----------|-------------|-------|
| `img_bell` | Bell illustration | Notifications |
| `img_delete_user` | Delete user illustration | Account deletion |
| `img_placeholder` | Generic placeholder | Loading states |
| `new_img_no_notifs` | No notifications state | Empty state |
| `image_map_example` | Map example/preview | Map UI |

### Social Media Assets

| Asset Name | Description | Platform |
|-----------|-------------|----------|
| `image_telegramm` | Telegram full image | Social |
| `image_instagramm` | Instagram full image | Social |

### Image Usage in Code

```swift
// SwiftUI
Image("icon_logo")
    .resizable()
    .scaledToFit()

// UIKit
UIImage(named: "icon_back")
```

---

## App Icon

**Location**: `yalla/Assets.xcassets/AppIcon.appiconset/`

### Icon Files
- `app_logo.png` - Primary icon
- `app_logo 1.png` - Variant 1
- `app_logo 2.png` - Variant 2
- `Contents.json` - Asset catalog metadata

**Required Sizes**: iOS automatically generates required sizes from provided assets.

---

## Fonts

**Location**: `yalla/Resources/fonts/`

### Custom Fonts

| Font File | Font Name | Usage |
|-----------|-----------|-------|
| `GL-Nummernschild-Eng.ttf` | GL-Nummernschild-Eng | License plates, special numbers |

**Registration**: Font is registered in `Yalla-Info.plist` under `UIAppFonts` array.

### Typography System

**Location**: `yalla/Utils/Typography/Font+.swift`

The app uses **SF Pro Text** (system font) as the primary typeface with the following scale:

#### Title Styles
```swift
.titleXLargeBold  // SF Pro Text, Bold, 30px
.titleLargeBold   // SF Pro Text, Bold, 22px
.titleBaseBold    // SF Pro Text, Bold, 20px
```

#### Body Styles
```swift
// Large Body
.bodyLargeRegular  // SF Pro Text, Regular, 18px
.bodyLargeMedium   // SF Pro Text, Medium, 18px
.bodyLargeBold     // SF Pro Text, Bold, 18px

// Base Body
.bodyBaseRegular   // SF Pro Text, Regular, 16px
.bodyBaseMedium    // SF Pro Text, Medium, 16px
.bodyBaseBold      // SF Pro Text, Bold, 16px

// Small Body
.bodySmallRegular  // SF Pro Text, Regular, 14px
.bodySmallMedium   // SF Pro Text, Medium, 14px
.bodySmallBold     // SF Pro Text, Bold, 14px

// Caption
.bodyCaptionMedium // SF Pro, Medium, 13px
```

**Font Scaling**: All fonts use `ScreenMetrics.scaledFontSize()` for Dynamic Type support.

### Font Usage Examples

```swift
Text("Hello World")
    .font(.titleLargeBold)

Text("Subtitle text")
    .font(.bodyBaseMedium)
```

---

## Localization

**Location**: `yalla/Resources/Localizable.xcstrings`

### Supported Languages

| Language | Code | Status |
|----------|------|--------|
| English | `en` | ✅ Full support |
| Russian | `ru` | ✅ Full support |
| Uzbek (Latin) | `uz-Latn` | ✅ Full support |
| Uzbek (Cyrillic) | `uz-Cyrl` | ✅ Full support |

### String Catalog Format

The project uses Xcode's **String Catalog** (`.xcstrings`) format for modern localization:
- Automatic string extraction from code
- Context-aware translations
- Pluralization support
- Device-specific variations

### Usage in Code

```swift
// SwiftUI
Text("welcome_message")
    .font(.bodyBaseRegular)

// Programmatic
NSLocalizedString("welcome_message", comment: "Welcome message")
```

---

## Usage Guidelines

### Adding New Assets

#### Colors
1. Open `yalla/Assets.xcassets` in Xcode
2. Right-click → New Color Set
3. Name using `ICapitalizedCamelCase` convention
4. Define both light and dark mode variants
5. Use Display P3 color space for wide color gamut

#### Images
1. Export @1x, @2x, @3x variants (PNG recommended)
2. Add to `yalla/Assets.xcassets/icons/` or appropriate folder
3. Name using `icon_` or `image_` prefix with snake_case
4. Consider SVG for simple icons (single scale)

#### Fonts
1. Add `.ttf` or `.otf` file to `yalla/Resources/fonts/`
2. Register in `Yalla-Info.plist` under `UIAppFonts`
3. Add Font extension in `Font+.swift` if needed

### Naming Conventions

**Colors**: `ICapitalizedCamelCase` (e.g., `IPrimaryDark`)  
**Icons**: `icon_snake_case` (e.g., `icon_back_smaller`)  
**Images**: `image_snake_case` or `img_snake_case` (e.g., `img_bonus_background`)  
**Backgrounds**: `img_bg_` prefix (e.g., `img_bg_delivery`)

### Asset Categories

| Prefix | Purpose | Example |
|--------|---------|---------|
| `icon_` | Small icons (UI elements) | `icon_check` |
| `image_` | Large images/illustrations | `image_telegramm` |
| `img_` | Shortened image prefix | `img_placeholder` |
| `img_bg_` | Background images | `img_bg_delivery` |
| `splash_` | Splash screen assets | `splash_logo` |
| `new_` | Recently added assets | `new_img_no_notifs` |

### Performance Considerations

1. **Image Optimization**
   - Use appropriate resolutions (@1x, @2x, @3x)
   - Compress PNGs without quality loss
   - Consider vector formats for simple icons

2. **Color Performance**
   - Colors are compiled into asset catalog
   - Use semantic colors for theme support
   - Define both light/dark variants

3. **Font Loading**
   - Custom fonts are loaded at app launch
   - Registered in Info.plist
   - Use system fonts when possible for performance

### Accessibility

1. **Dynamic Type**: All font sizes support Dynamic Type scaling via `ScreenMetrics.scaledFontSize()`
2. **Color Contrast**: Ensure WCAG AA compliance (4.5:1 for text)
3. **Icon Sizes**: Minimum touch target 44x44pt
4. **Alternative Text**: Provide accessibility labels for meaningful images

---

## Asset Integration with Design System

### Color System Integration

The color palette integrates with the app's design system:

```swift
// Primary brand color
Color("IPrimary")  // #562DF8 - Used for CTAs, highlights

// Background hierarchy
Color("IBackgroundSecondary")  // Cards, elevated surfaces
Color("IBackgroundTertiary")   // Nested containers

// Text hierarchy
Color("ILabel")        // Primary text
Color("iLabelSubtle")  // Secondary text, hints
Color("ITextLink")     // Interactive text
```

### Icon System

Icons follow consistent sizing:
- Small icons: 16x16pt
- Medium icons: 24x24pt (most common)
- Large icons: 32x32pt
- Touch targets: Minimum 44x44pt

### Typography Scale

Font sizes follow 8pt baseline grid:
- 30px (Title XLarge)
- 22px (Title Large)
- 20px (Title Base)
- 18px (Body Large)
- 16px (Body Base) ← Default body text
- 14px (Body Small)
- 13px (Caption)

---

## Configuration Files

### Info.plist Configuration

**File**: `yalla/Resources/Yalla-Info.plist`

```xml
<!-- Custom Font Registration -->
<key>UIAppFonts</key>
<array>
    <string>GL-Nummernschild-Eng.ttf</string>
</array>

<!-- Supported Interface Orientations -->
<key>UISupportedInterfaceOrientations</key>
<array>
    <string>UIInterfaceOrientationPortrait</string>
</array>

<!-- Media Permissions -->
<key>NSCameraUsageDescription</key>
<string>We need access to the camera to take photos for your profile picture.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to select photos for your profile picture.</string>
```

### Build Configuration

**File**: `Yalla.xcconfig`

```
PRODUCT_BUNDLE_IDENTIFIER = uz.ildam.taxiclient2
DISPLAY_NAME = Yalla
BRAND_COLOR = #3812CE
DEEP_LINK_SCHEME = ildam
```

---

## Asset Audit Summary

### Statistics
- **Total Colors**: 11 (including AccentColor)
- **Total Images**: 62 imagesets
- **Custom Fonts**: 1 (GL-Nummernschild-Eng)
- **App Icons**: 3 variants
- **Localization**: 4 languages (en, ru, uz-Latn, uz-Cyrl)

### Asset Health
✅ All images have @1x, @2x, @3x variants  
✅ All colors have dark mode support  
✅ Fonts properly registered in Info.plist  
✅ Localization using modern String Catalog format  
✅ Consistent naming conventions  

### Recommendations

1. **Audit unused assets**: Review which assets are actively used in code
2. **Optimize image sizes**: Compress large background images
3. **SVG consideration**: Convert simple icons to SF Symbols or SVG where possible
4. **Color semantics**: Consider renaming colors to semantic names (e.g., `primaryButton` vs `IPrimary`)
5. **Documentation**: Add comments to complex color/font usage in design system

---

## Quick Reference

### Most Used Assets

**Colors**:
- `IPrimary` - Primary brand color
- `ILabel` - Main text
- `IBackgroundSecondary` - Cards

**Icons**:
- `icon_back` - Navigation back button
- `icon_check` - Selection indicator
- `icon_x` - Close/dismiss
- `icon_logo` - App branding

**Fonts**:
- `.bodyBaseRegular` - Default body text
- `.titleLargeBold` - Section headers
- `.bodySmallMedium` - Secondary text

---

## Resources

- **Asset Catalog**: `yalla/Assets.xcassets`
- **Resources Folder**: `yalla/Resources/`
- **Typography System**: `yalla/Utils/Typography/Font+.swift`
- **Info.plist**: `yalla/Resources/Yalla-Info.plist`
- **Project Config**: `Yalla.xcconfig`

---

**Last Updated**: 2025-01-28  
**Document Version**: 1.0  
**Maintainer**: Yalla iOS Team
