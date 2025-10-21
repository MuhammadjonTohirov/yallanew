//
//  YRoundedTextField.swift
//  UnitedUIKit
//
//  Created by applebro on 12/10/23.
//

import Foundation
import SwiftUI

public struct YRoundedTextField<Content: View>: View {
    @FocusState var isFocused: Bool
    var textField: () -> Content
    var onFocusChanged: ((Bool) -> Void)?
    
    var borderColor: Color = .secondary
    
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
                    YTextFieldBorderStyle()
                        .set(borderColor: isFocused ? .gray : borderColor)
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

extension YRoundedTextField {
    func set(borderColor: Color) -> Self {
        var v = self
        v.borderColor = borderColor
        return v
    }
}
