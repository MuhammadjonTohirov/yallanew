//
//  File.swift
//  YallaUtils
//
//  Created by Muhammadjon Tohirov on 17/10/25.
//

import Foundation
import SwiftUI

public struct SubmitButton<Content: View>: View {
    var action: () -> Void
    var title: (() -> Content)?
    var backgroundColor: Color
    var pressedColor: Color
    var height: CGFloat = 60
    
    private(set) var isLoading: Bool = false
    private(set) var isEnabled: Bool = true
    @State private var isPressed: Bool = false
    
    public init(
        backgroundColor: Color? = nil,
        pressedColor: Color? = nil,
        height: CGFloat = 60,
        label: (() -> Content)?,
        action: @escaping () -> Void
    ) {
        self.action = action
        self.title = label
        self.backgroundColor = backgroundColor ?? Color.init(uiColor: .label)
        self.pressedColor = pressedColor ?? self.backgroundColor.opacity(0.7)
        self.height = height
    }
    
    public var body: some View {
        Button(
            action: {
                (isLoading || !isEnabled) ? () : action()
            },
            label: {
                Color.clear
            }
        )
        .allowsHitTesting(!isLoading && isEnabled)
        .overlay {
            if let t = title?() {
                t.allowsHitTesting(false)
                    .opacity(isLoading ? 0 : 1)
            }
        }
        .buttonStyle(CustomPressEffectButtonStyle.init(
            normalColor: backgroundColor,
            pressedColor: pressedColor
        ))
        .overlay(content: {
            Rectangle()
                .foregroundStyle(
                    Color.white.opacity(!isEnabled ? 0.4 : 0)
                )
                .overlay {
                    ProgressView()
                        .tint(.white)
                        .opacity(isLoading ? 1 : 0)
                        .scaleEffect(1.2)
                }
        })
        .font(.system(size: 14, weight: .semibold))
        .foregroundStyle(Color.white)
        .frame(height: height, alignment: .center)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    public func set(isLoading: Bool) -> Self {
        var v = self
        v.isLoading = isLoading
        return v
    }
    
    public func set(isEnabled: Bool) -> Self {
        var v = self
        v.isEnabled = isEnabled
        return v
    }
}

struct CustomPressEffectButtonStyle: ButtonStyle {
    var normalColor: Color
    var pressedColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? pressedColor : normalColor)
            .foregroundStyle(.white)
            .cornerRadius(10)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}
