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
    var height: CGFloat = 60
    
    private(set) var isLoading: Bool = false
    private(set) var isEnabled: Bool = true
    @State private var isPressed: Bool = false
    
    public init(
        backgroundColor: Color? = nil,
        height: CGFloat = 60,
        label: (() -> Content)?,
        action: @escaping () -> Void
    ) {
        self.action = action
        self.title = label
        self.backgroundColor = backgroundColor ?? Color.init(uiColor: .label)
        self.height = height
    }
    
    public var body: some View {
        Button(
            action: {
                (isLoading || !isEnabled) ? () : action()
            },
            label: {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .foregroundStyle(backgroundColor)
            }
        )
        .overlay {
            if let t = title?() {
                t.allowsHitTesting(false)
            }
        }
        .buttonStyle(.plain)
        .overlay(content: {
            Rectangle()
                .foregroundStyle(
                    Color.white.opacity((isLoading || !isEnabled) ? 0.4 : 0)
                )
                .overlay {
                    HStack {
                        Spacer()
                        
                        ProgressView()
                            .foregroundStyle(Color.white)
                            .opacity(isLoading ? 1 : 0)
                    }
                    .padding(.horizontal, 16)
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
