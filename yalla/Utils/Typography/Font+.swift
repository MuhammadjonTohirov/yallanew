//
//  Font+.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 17/10/25.
//

import Foundation
import SwiftUI

extension Font {
    // MARK: - Title
    /// Title / XLarge — SF Pro Text, Bold, 30px
    static var titleXLargeBold: Font {
        .system(size: ScreenMetrics.scaledFontSize(30), weight: .bold, design: .default)
    }
    /// Title / Large — SF Pro Text, Bold, 22px
    static var titleLargeBold: Font {
        .system(size: ScreenMetrics.scaledFontSize(22), weight: .bold, design: .default)
    }
    /// Title / Base — SF Pro Text, Bold, 20px
    static var titleBaseBold: Font {
        .system(size: ScreenMetrics.scaledFontSize(20), weight: .bold, design: .default)
    }

    // MARK: - Body
    /// Body / Caption — SF Pro, Medium, 13px (intended 120% line height)
    static var bodyCaptionMedium: Font {
        .system(size: ScreenMetrics.scaledFontSize(13), weight: .medium, design: .default)
    }

    /// Body / Large / Regular — SF Pro Text, Regular, 18px (intended 120%)
    static var bodyLargeRegular: Font {
        .system(size: ScreenMetrics.scaledFontSize(18), weight: .regular, design: .default)
    }
    /// Body / Large / Medium — SF Pro Text, Medium, 18px (intended 120%)
    static var bodyLargeMedium: Font {
        .system(size: ScreenMetrics.scaledFontSize(18), weight: .medium, design: .default)
    }
    /// Body / Large / Bold — SF Pro Text, Bold, 18px (intended 120%)
    static var bodyLargeBold: Font {
        .system(size: ScreenMetrics.scaledFontSize(18), weight: .bold, design: .default)
    }

    /// Body / Base / Regular — SF Pro Text, Regular, 16px (intended 130%)
    static var bodyBaseRegular: Font {
        .system(size: ScreenMetrics.scaledFontSize(16), weight: .regular, design: .default)
    }
    /// Body / Base / Medium — SF Pro Text, Medium, 16px (intended 120%)
    static var bodyBaseMedium: Font {
        .system(size: ScreenMetrics.scaledFontSize(16), weight: .medium, design: .default)
    }
    /// Body / Base / Bold — SF Pro Text, Bold, 16px (intended 90%)
    static var bodyBaseBold: Font {
        .system(size: ScreenMetrics.scaledFontSize(16), weight: .bold, design: .default)
    }

    /// Body / Small / Regular — SF Pro Text, Regular, 14px (intended 110%)
    static var bodySmallRegular: Font {
        .system(size: ScreenMetrics.scaledFontSize(14), weight: .regular, design: .default)
    }
    /// Body / Small / Medium — SF Pro Text, Medium, 14px (intended 110%)
    static var bodySmallMedium: Font {
        .system(size: ScreenMetrics.scaledFontSize(14), weight: .medium, design: .default)
    }
    /// Body / Small / Bold — SF Pro Text, Bold, 14px (intended 110%)
    static var bodySmallBold: Font {
        .system(size: ScreenMetrics.scaledFontSize(14), weight: .bold, design: .default)
    }
}
