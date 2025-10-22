//
//  YRoundedTextField.swift
//  UnitedUIKit
//
//  Created by applebro on 12/10/23.
//

import Foundation
import SwiftUI
import YallaUtils

public struct YRoundedTextField<Content: View>: View {
    @FocusState var isFocused: Bool
    var textField: () -> Content
    var onFocusChanged: ((Bool) -> Void)?
    
    var borderColor: Color = .red
    
    public init(
        focused: Bool = false,
        textField: @escaping () -> Content
    ) {
        self.textField = textField
        self.isFocused = focused
    }
    
    public var body: some View {
        VStack(alignment: .trailing) {
            textField()
                .onTapGesture {
                    isFocused = true
                }
                .modifier(
                    YTextFieldBorderStyle(
                        padding: 0,
                        borderRadius: 10,
                        borderColor: borderColor,
                        backgroundColor: .clear
                    )
                    .set(borderColor: borderColor)
                )
                .focused($isFocused)
                .onChange(of: isFocused) { val in
                    onFocusChanged?(val)
                }
        }
    }
    
    public func set(onFocusChanged: @escaping (Bool) -> Void) -> some View {
        var v = self
        v.onFocusChanged = onFocusChanged
        return v
    }
}

public extension YRoundedTextField {
    func set(borderColor: Color) -> Self {
        var v = self
        v.borderColor = borderColor
        return v
    }
}
