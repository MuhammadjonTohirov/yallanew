//
//  File.swift
//  YallaUtils
//
//  Created by Muhammadjon Tohirov on 11/11/25.
//

import Foundation
import SwiftUI

public struct HoveredButtonStyle: ButtonStyle {
    public var normalColor: Color
    @Environment(\.colorScheme) var colorScheme
    
    public init(normalColor: Color) {
        self.normalColor = normalColor
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Rectangle()
                    .background(normalColor)
                    .foregroundStyle(configuration.isPressed ? alternateColor(normalColor) : normalColor)
            )
            .foregroundStyle(.white)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
    
    private func alternateColor(_ color: Color) -> Color {
        let uiColor = UIColor(color)
        let cgColor = uiColor.cgColor
        let components = cgColor.components ?? []
        // Get RGBA components from CGColor
        guard components.count >= 3 else {
            return colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1)
        }
        
        
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components.count > 3 ? components[3] : 1.0
        
        // Calculate brightness (luminance)
        let brightness = (red * 0.299 + green * 0.587 + blue * 0.114)
        
        // Consider color scheme for better contrast
        let alteredColor: Color
        
        if colorScheme == .dark {
            // In dark mode, prefer lighter alterations for better visibility
            if brightness < 0.3 {
                // Very dark colors - make them much lighter
                alteredColor = Color(
                    red: min(1, red + 0.9),
                    green: min(1, green + 0.9),
                    blue: min(1, blue + 0.9),
                    opacity: alpha
                )
            } else {
                // Medium/light colors - make them moderately lighter
                alteredColor = Color(
                    red: min(1, red + 0.4),
                    green: min(1, green + 0.4),
                    blue: min(1, blue + 0.4),
                    opacity: alpha
                )
            }
        } else {
            // In light mode, prefer darker alterations
            if brightness > 0.7 {
                // Very light colors - make them much darker
                alteredColor = Color(
                    red: max(0, red - 0.9),
                    green: max(0, green - 0.9),
                    blue: max(0, blue - 0.9),
                    opacity: alpha
                )
            } else {
                // Medium/dark colors - make them moderately darker
                alteredColor = Color(
                    red: max(0, red - 0.4),
                    green: max(0, green - 0.4),
                    blue: max(0, blue - 0.4),
                    opacity: alpha
                )
            }
        }
        
        return alteredColor.opacity(0.2)
    }
}

