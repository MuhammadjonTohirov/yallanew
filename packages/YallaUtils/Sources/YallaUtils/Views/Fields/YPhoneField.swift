//
//  YPhoneField.swift
//  YuzPay
//
//  Created by applebro on 10/12/22.
//

import Foundation
import SwiftUI

public struct YPhoneField: View, TextFieldProtocol {
    @Binding<String> public var text: String
    private var font: Font

    private var placeholder: String = ""
    private var format: String = "XX XXX-XX-XX"
    private var onEditingChanged: (Bool) -> Void
    private var onCommit: () -> Void
    
    public private(set) var left: () -> any View
    public private(set) var right: () -> any View
    
    public init(
        text: Binding<String>,
        font: Font = .system(size: 14),
        placeholder: String,
        left: (() -> any View)? = nil,
        right: (() -> any View)? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        self.font = font
        self._text = text
        
        self.placeholder = placeholder
        
        self.left = left ?? {
            EmptyView()
        }
        
        self.right = right ?? {
            EmptyView()
        }
        
        self.onEditingChanged = onEditingChanged ?? {_ in}
        self.onCommit = onCommit ?? {}
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            AnyView(left())
            
            textField
                .placeholder(placeholder, when: text.isEmpty)
                .keyboardType(.numberPad)
                .frame(height: 56)
                .font(font)
            
            AnyView(right())
        }
        .onAppear {
            text = text.onlyNumberFormat(with: format)
        }
    }
    
    @ViewBuilder var textField: some View {
        TextField(
            "",
            text: $text,
            onEditingChanged: { changed in
                onEditingChanged(changed)
            },
            
            onCommit: onCommit
        )
        .onChange(of: text) { newValue in
            _text.wrappedValue = newValue.onlyNumberFormat(with: format)
        }
    }
    
    public func set(hintColor: Color) -> YPhoneField {
        return self
    }
    
    public func set(font: Font) -> YPhoneField {
        return self
    }
    
    public func set(format: String) -> YPhoneField {
        return self
    }
    
    public func set(placeholderAlignment align: Alignment) -> YPhoneField {
        return self
    }
    
    public func set(formatter: NumberFormatter) -> YPhoneField {
        return self
    }
    
    public func set(height: CGFloat) -> YPhoneField {
        return self
    }
    
    public func set(haveTitle: Bool) -> YPhoneField {
        return self
    }
    
    public func keyboardType(_ type: UIKeyboardType) -> YPhoneField {
        return self
    }
}

struct YPhoneField_Preview: PreviewProvider {
    static var previews: some View {
        @State var text: String = "935852415"
        
        return VStack {
            YTextField(text: $text, placeholder: "placeholder", isSecure: false)
        }
    }
}
