//
//  SelectableButtonContainer.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 17/10/25.
//

import Foundation
import SwiftUI
import YallaUtils
import Core

public struct SelectableButtonContainer<Content: View>: View {
    let action: () -> Void
    let content: () -> Content
    
    @Binding
    var isSelected: Bool
    
    public init(action: @escaping () -> Void, content: @escaping () -> Content, isSelected: Binding<Bool>) {
        self.action = action
        self.content = content
        self._isSelected = isSelected
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            content()
                .frame(maxWidth: .infinity, alignment: .leading)
            Circle()
                .frame(width: 18, height: 18)
                .foregroundStyle(Color.iPrimary)
                .overlay {
                    Image("icon_check")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12)
                        .foregroundStyle(Color.white)
                }
                .opacity(isSelected ? 1 : 0)
                .animation(.spring(duration: 0.4), value: isSelected)
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1, color: .iBorderDisabled, visible: !isSelected)
                .foregroundColor(Color.iBackgroundSecondary)
                .animation(.spring(duration: 0.4), value: isSelected)
                .background(Color.iBackgroundSecondary.opacity(0.05))
        }
        .onClick {
            isSelected.toggle()
        }
    }
}
