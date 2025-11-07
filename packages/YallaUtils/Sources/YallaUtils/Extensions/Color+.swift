//
//  File.swift
//  YallaUtils
//
//  Created by Muhammadjon Tohirov on 05/11/25.
//

import Foundation
import SwiftUI

extension Color {
    public static var brandBackground: Color {
        Color(UIColor { tc in
            switch tc.userInterfaceStyle {
            case .dark:
                return .black
            case .light:
                return .white
            default:
                return .systemBackground
            }
        })
    }
}
