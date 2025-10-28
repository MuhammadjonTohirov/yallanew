//
//  File.swift
//  YallaUtils
//
//  Created by Muhammadjon Tohirov on 28/10/25.
//

import Foundation
import SwiftUI

public struct SwitchView: View {
    @Binding var isOn: Bool
    var backgroundColor: Color = Color.init(hex: "#562DF8")
    var handleColor: Color = .white
    
    public init(isOn: Binding<Bool>, backgroundColor: Color, handleColor: Color) {
        self._isOn = isOn
        self.backgroundColor = backgroundColor
        self.handleColor = handleColor
    }
    
    private var closedXOffset: CGFloat = -(64-39) / 2
    private var openXOffset: CGFloat = (64-39) / 2
    @State
    private var xOffset: CGFloat = 0
    
    @State
    private var didTap: Bool = false
    
    private var offBackgroundColor: Color {
        backgroundColor.opacity(0.3)
    }
    
    private var bgColor: Color {
        isOn ? backgroundColor : offBackgroundColor
    }

    public var body: some View {
        Capsule()
            .frame(width: 68, height: 28, alignment: .center)
            .foregroundStyle(bgColor)
            .overlay {
                Capsule()
                    .frame(width: 64, height: 24, alignment: .center)
                    .foregroundStyle(bgColor.opacity(0.02))
                    .overlay {
                        Capsule()
                            .frame(width: 39, height: 24, alignment: .center)
                            .foregroundStyle(handleColor)
                            .offset(x: xOffset, y: 0)
                            .allowsHitTesting(false)
                            .shadow(color: Color.black.opacity(0.3), radius: 2)
                    }
                    .allowsHitTesting(false)
            }
            .onTapGesture {
                if didTap { return }
                
                didTap = true

                withAnimation {
                    isOn.toggle()
                    xOffset = isOn ? openXOffset : closedXOffset
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    didTap = false
                }
            }
            .onAppear {
                xOffset = isOn ? openXOffset : closedXOffset
            }
    }
}

private struct SwitchViewPreview: View {
    @State private var isOn: Bool = false
    var body: some View {
        SwitchView(isOn: $isOn, backgroundColor: .black, handleColor: .white)
    }
}

#Preview(body: SwitchViewPreview.init)
