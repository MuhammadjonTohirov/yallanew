//
//  WaveEffectModifier.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 23/10/25.
//

import Foundation
import SwiftUI
import Core

struct WaveEffectModifier: ViewModifier {
    @State
    private var objectSize: CGRect = .zero
    
    private var initialWidth: CGFloat {
        objectSize.width * 1.6
    }
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var fromColor: Color {
        if colorScheme == .dark {
            return .init(hex: "#2B2C37")
        } else {
            return .init(hex: "#F2F2F2")
        }
    }
    
    private var toColor: Color {
        if colorScheme == .dark {
            return .init(hex: "#21222B")
        } else {
            return .white
        }
    }
    
    var largeningPercentage: CGFloat = 0.6
    var waveCount: Int = 5

    func body(content: Content) -> some View {
        content
            .readRect(rect: $objectSize)
            .background {
                fiveLayerCircularBackground()
            }
    }
    
    private func fiveLayerCircularBackground() -> some View {
        ZStack {
            ForEach(0..<waveCount, id: \.self) {
                self.circleBackground(layerIndex: $0)
                    .zIndex(5 - $0.f)
            }
        }
    }
    
    private func circleBackground(layerIndex: Int) -> some View {
        let id = layerIndex.f + 1
        let width = initialWidth + layerIndex.f * (initialWidth * largeningPercentage)
        let start = width
        let end = width - (width * 0.7)
        
        debugPrint(id, width, start, end)
        return Circle()
            .frame(width: width, height: width)
            .foregroundStyle(
                RadialGradient(colors: [fromColor, toColor], center: .center, startRadius: start, endRadius: end)
            )
    }
}

struct WaveEffectModifierPreview: View {
    @State
    private var objectSize: CGRect = .zero
    
    var body: some View {
        Image("icon_x")
            .readRect(rect: $objectSize)
            .background()
            .cornerRadius(objectSize.width / 2, corners: .allCorners)
            .modifier(WaveEffectModifier())
    }
    
}

#Preview {
    ZStack {
        Color.secondaryBackground.ignoresSafeArea()
        WaveEffectModifierPreview()
    }
}
