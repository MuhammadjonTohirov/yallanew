//
//  File.swift
//  YallaUtils
//
//  Created by Muhammadjon Tohirov on 17/10/25.
//

import Foundation
import SwiftUI

public var isIOS26: Bool {
    if #available(iOS 26.0, *) {
        return true
    } else {
        return false
    }
}

public extension View {
    func onClick(perform action: @escaping () -> Void) -> some View {
        Button(action: action) {
            self
        }
        .buttonStyle(.plain)
    }
}


public extension View {
    func placeholder(
        _ text: String,
        when shouldShow: Bool,
        alignment: Alignment = .leading, color: Color = Color.init(uiColor: .label).opacity(0.47)) -> some View {
            placeholder(when: shouldShow, alignment: alignment) { Text(text).foregroundColor(color) }
        }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    func keyboardDismissable() -> some View {
        self.toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                HStack {
                    EmptyView()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button(action: {UIApplication.shared.dismissKeyboard()}, label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                            .foregroundStyle(Color.init(uiColor: .label))
                    })
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
    }
    
    func scrollable(axis: Axis.Set = .vertical, showIndicators: Bool = false) -> some View {
        self.modifier(ScrollableModifier(axis: axis, indicators: showIndicators))
    }
    
    func horizontal(alignment: Alignment) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vertical(alignment: Alignment) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
}
