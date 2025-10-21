// ScreenMetrics.swift

import SwiftUI
import Core

public enum ScreenMetrics {
    // Your Figma reference size
    static let referenceWidth: CGFloat = 402
    static let referenceHeight: CGFloat = 874

    // Choose the dimension to scale by. Width is recommended for consistency.
    static func scaleFactor(using size: CGSize = UIApplication.shared.screenFrame.size) -> CGFloat {
        // Use portrait width regardless of orientation for stability
        let currentWidth = min(size.width, size.height)
        let refWidth = min(referenceWidth, referenceHeight)
        // Clamp to 1 so we only scale down on smaller screens
        return min(1.0, currentWidth / refWidth)
    }

    static func scaledFontSize(_ designSize: CGFloat, using size: CGSize = UIApplication.shared.screenFrame.size) -> CGFloat {
        designSize * scaleFactor(using: size)
    }
    
    static func scaleWidth(_ width: CGFloat, using size: CGSize = UIApplication.shared.screenFrame.size) -> CGFloat {
        width * scaleFactor(using: size)
    }
    
    static func scaleHeight(_ height: CGFloat, using size: CGSize = UIApplication.shared.screenFrame.size) -> CGFloat {
        height * scaleFactor(using: size)
    }
}

extension CGFloat {
    var scaled: CGFloat {
        ScreenMetrics.scaledFontSize(self)
    }
}

extension Int {
    var scaled: CGFloat {
        CGFloat(self).scaled
    }
}

extension Double {
    var scaled: CGFloat {
        CGFloat(self).scaled
    }
}
