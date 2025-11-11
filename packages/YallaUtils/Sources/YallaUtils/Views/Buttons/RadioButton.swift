//
//  RadioButton.swift
//  Ildam
//
//  Created by applebro on 27/11/23.
//

import Foundation
import SwiftUI

public struct RadioButton: View {
    let title: String
    let isSelected: Bool
    let checkmarkColor: Color
    let titleColor: Color
    let action: () -> Void
    
    public init(title: String, isSelected: Bool, titleColor: Color = Color.init(uiColor: .label), checkmarkColor: Color, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.checkmarkColor = checkmarkColor
        self.titleColor = titleColor
        self.action = action
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(titleColor)
            
            Spacer()
            
            Circle()
                .fill(isSelected ? checkmarkColor : checkmarkColor.opacity(0.25))
                .frame(width: 24, height: 24)
                .overlay(
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                        .opacity(isSelected ? 1 : 0)
                )
        }
        .overlay(content: {
            Rectangle()
                .foregroundStyle(.white.opacity(0.01))
                .opacity(0.02)
        })
        .onClick(perform: action)
    }
}

extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}
