//
//  YPhoneField.swift
//  YuzPay
//
//  Created by applebro on 10/12/22.
//

import Foundation
import SwiftUI
import Core

struct YPhoneField: View, TextFieldProtocol {
    @Binding<String> var text: String
    
    private var placeholder: String = ""
    private var format: String = "XX XXX-XX-XX"
    private var onEditingChanged: (Bool) -> Void
    private var onCommit: () -> Void
    
    private(set) var left: () -> any View
    private(set) var right: () -> any View
    
    init(
        text: Binding<String>,
        placeholder: String,
        left: (() -> any View)? = nil,
        right: (() -> any View)? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        
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
    
    var body: some View {
        HStack(spacing: 0) {
            AnyView(left())
            
            textField
                .placeholder(placeholder, when: text.isEmpty)
                .keyboardType(.numberPad)
                .frame(height: 56)
                .font(.inter(.regular, size: 14))

            AnyView(right())
        }
        .onAppear {
            text = text.onlyNumberFormat(with: format)
        }
    }
    
    @ViewBuilder var textField: some View {
        TextField(
            "".localize,
            text: $text,
            onEditingChanged: { changed in
                onEditingChanged(changed)
                print("\(changed) \(text)")
            },
            
            onCommit: onCommit
        )
        .onChange(of: text) { newValue in
            _text.wrappedValue = newValue.onlyNumberFormat(with: format)
        }
    }
    
    func set(hintColor: Color) -> YPhoneField {
        return self
    }
    
    func set(font: Font) -> YPhoneField {
        return self
    }
    
    func set(format: String) -> YPhoneField {
        return self
    }
    
    func set(placeholderAlignment align: Alignment) -> YPhoneField {
        return self
    }
    
    func set(formatter: NumberFormatter) -> YPhoneField {
        return self
    }
    
    func set(height: CGFloat) -> YPhoneField {
        return self
    }
    
    func set(haveTitle: Bool) -> YPhoneField {
        return self
    }
    
    func keyboardType(_ type: UIKeyboardType) -> YPhoneField {
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
