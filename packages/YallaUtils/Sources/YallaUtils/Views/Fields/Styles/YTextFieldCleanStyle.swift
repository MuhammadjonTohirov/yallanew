//
//  YTextFieldCleanStyle.swift
//  UnitedUIKit
//
//  Created by applebro on 09/10/23.
//

import SwiftUI

public struct YTextFieldBorderStyle: ViewModifier {
    var padding: CGFloat = 0
    var borderRadius: CGFloat = 10
    var borderColor: Color = .init(uiColor: .placeholderText)
    var backgroundColor: Color = .init(uiColor: .secondarySystemBackground).opacity(0.2)
    
    public init(padding: CGFloat = 0, borderRadius: CGFloat = 10, borderColor: Color = .init(uiColor: .placeholderText), backgroundColor: Color = .init(uiColor: .secondarySystemBackground).opacity(0.2)) {
        self.padding = padding
        self.borderRadius = borderRadius
        self.borderColor = borderColor
        self.backgroundColor = backgroundColor
    }
    
    public func body(content: Content) -> some View {
        content
            .padding(.leading, padding)
            .background(
                RoundedRectangle(cornerRadius: borderRadius)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(borderColor)
                    .background(content: {
                        RoundedRectangle(cornerRadius: borderRadius)
                            .foregroundStyle(backgroundColor)
                    })
                    .padding(.horizontal, 1)
            )
    }
    
    public func set(borderColor: Color) -> Self {
        var v = self
        v.borderColor = borderColor
        return v
    }
}
