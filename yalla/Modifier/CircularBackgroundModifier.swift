//
//  File.swift
//  YallaUtils
//
//  Created by Muhammadjon Tohirov on 06/11/25.
//

import Foundation
import SwiftUI
import Core
import YallaUtils

struct CircularBackgroundModifier: ViewModifier {
    var color: Color
    var padding: CGFloat = 8
    
    init(color: Color, padding: CGFloat = 8) {
        self.color = color
        self.padding = padding
    }
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                Circle()
                    .fill(color)
            )
    }
}

struct CapsuleBackgroundModifier: ViewModifier {
    var color: Color
    var padding: CGFloat = 8
    
    init(color: Color, padding: CGFloat = 8) {
        self.color = color
        self.padding = padding
    }
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                Capsule()
                    .fill(color)
            )
    }
}

extension View {
    @ViewBuilder
    func circularBackground(_ enabled: Bool, bgColor: Color = Color.iBackgroundSecondary, padding: CGFloat = 8.scaled) -> some View {
        if enabled {
            self.modifier(CircularBackgroundModifier(color: bgColor, padding: padding))
        } else {
            self
        }
    }
    
    @ViewBuilder
    func capsuleBackground(_ enabled: Bool, bgColor: Color = Color.iBackgroundSecondary, padding: CGFloat = 8.scaled) -> some View {
        if enabled {
            self.modifier(CapsuleBackgroundModifier(color: bgColor, padding: padding))
        } else {
            self
        }
    }
}

#Preview {
    Text("Hi")
        .modifier(CircularBackgroundModifier(color: .red))
}
