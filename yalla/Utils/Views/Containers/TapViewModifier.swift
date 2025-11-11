//
//  Button+E.swift
//  TestApp
//
//  Created by Muhammadjon Tohirov on 15/07/25.
//

import Foundation
import SwiftUI
import IldamSDK
import YallaUtils
import Core

struct ButtonModifier: ViewModifier {
    var backgroundColor: Color = Color.clear
    var action: () -> Void = {}
    @State private var isPressed = false
    @State private var rect: CGRect = .zero
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        ZStack {
            Button {
                action()
            } label: {
                Rectangle()
                    .foregroundStyle(backgroundColor)
            }
            .background(isPressed ? alternateColor(backgroundColor) : backgroundColor)
            .controlSize(.mini)
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.3)) {
                    isPressed = pressing
                }
            }, perform: {})

            content
                .allowsHitTesting(false)
        }
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

extension View {
    func onTapped(_ background: Color = Color.background, tap: Color? = nil, action: @escaping () -> Void = {}) -> some View {
//        self.modifier(ButtonModifier.init(backgroundColor: background, action: action))
        Button.init {
            action()
        } label: {
            self
        }
        .buttonStyle(HoveredButtonStyle(
            normalColor: background
        ))
        .padding(0)
    }
    
    @ViewBuilder
    func customAlert(isPresented: Binding<Bool>, data: CustomAlertInputData?) -> some View {
        self.customAlert(isPresented: isPresented, title: data?.title ?? "", message: data?.message ?? "", actions: data?.actions ?? [])
    }
}

#Preview {
    Text("Tap to me")
        .foregroundColor(.init(uiColor: .label))
        .onTapped(.init(uiColor: .systemBackground), action: {
            print("GO")
        })
        .frame(width: 200)
        .cornerRadius(10)
}
