//
//  YTextField.swift
//  YuzPay
//
//  Created by applebro on 08/12/22.
//

import Foundation
import SwiftUI

public struct YTextValidator {
    var filter: (_ text: String) -> Bool
    
    public init(filter: @escaping (_: String) -> Bool) {
        self.filter = filter
    }
}

public struct YTextField: View, TextFieldProtocol {
    private var placeholder: String = ""
    private var isSecure: Bool = false
    
    var keyboardType: UIKeyboardType = .default
    var height: CGFloat = 56
    var haveTitle: Bool = false

    @Binding<String> public var text: String
    @State private var hintOpacity: Double = 0
    @State private var zStackAlignment: Alignment = .leading
    @State private var hintFontSize: CGFloat = 13
    @State private var hintColor: Color = Color(.secondaryLabel)
    @State private var formatter: NumberFormatter?
    @State private var passwordVisible: Bool = false
    @State private var oldValue: String = ""
    
    private var font: Font = {
        .system(size: 14, weight: .medium)
    }()
    
    private var contentType: UITextContentType = .name
    private var autoCapitalization: TextInputAutocapitalization = .sentences
    
    private var onEditing: (Bool) -> Void
    private var onCommit: () -> Void
    
    private var format: String?
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    private var validator: YTextValidator = .init { _ in
        return true
    }
    
    private var placeholderAlignment: Alignment = .leading
    private var topupHintColor: Color = Color(.secondaryLabel)
    private var placeholderColor: Color = Color(uiColor: .placeholderText)
    private(set) public var left: () -> any View
    private(set) public var right: () -> any View
    
    public init(
        text: Binding<String>,
        placeholder: String,
        isSecure: Bool = false,
        contentType: UITextContentType = .nickname,
        autoCapitalization: TextInputAutocapitalization = .sentences,
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
        
        self.isSecure = isSecure
        self.contentType = contentType
        self.autoCapitalization = autoCapitalization
        self.onEditing = onEditingChanged ?? {_ in}
        self.onCommit = onCommit ?? {}
        
        self.passwordVisible = isSecure
        self.oldValue = text.wrappedValue
    }
    
    public init(text: Binding<String>, placeholder: String, validator: YTextValidator) {
        self.init(text: text, placeholder: placeholder)
        self.validator = validator
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            AnyView(left())
            
            ZStack(alignment: zStackAlignment) {
                Text(placeholder)
                    .padding(.top, 3)
                    .font(.system(
                        size: 12,
                        weight: .regular)
                    )
                    .foregroundColor(hintColor)
                    .opacity(hintOpacity)
                    .zIndex(0)
                
                textField
                    .placeholder(
                        placeholder,
                        when: text.isEmpty,
                        alignment: placeholderAlignment,
                        color: .secondary
                    )
                    .tint(colorScheme == .dark ? .white : .black)
                    .keyboardType(keyboardType)
                    .textContentType(contentType)
                    .frame(height: height)
                    .textInputAutocapitalization(autoCapitalization)
                    .font(font)
                    .onChange(of: text) { newValue in
                        let isDeleting = newValue.count < oldValue.count
                        
                        @MainActor
                        func doFormat(_ str: String) {
                            if let _format = format {
                                _text.wrappedValue = str.onlyNumberFormat(with: _format)
                            }
                            
                            self.rearrangeHint()
                            self.onEditing(true)
                        }
                        
                        if !isDeleting {
                            guard validator.filter(newValue), !isDeleting else {
                                doFormat(oldValue)
                                return
                            }
                        }
                        
                        doFormat(newValue)
                        self.oldValue = newValue
                    }
                    .zIndex(1)
            }
            .padding(.trailing, 2)

            rightView
        }
        
        .onAppear {
            rearrangeHint()
        }
    }
    
    @ViewBuilder var rightView: some View {
        if right() is EmptyView && isSecure {
            Button(action: {
                self.passwordVisible.toggle()
            }, label: {
                Image(passwordVisible ? "icon_open_eye" : "icon_close_eye")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                    .padding(AppParams.Padding.medium)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color.init(uiColor: .secondaryLabel))
                    }
                    .padding(AppParams.Padding.small / 2)
            })
            
        }
        else {
            AnyView(right())
                .padding(AppParams.Padding.small / 2)
        }
    }
    
    @ViewBuilder var textField: some View {
        if !passwordVisible && isSecure {
            SecureField(String.empty, text: $text, onCommit: onCommit)
        } else {
            _textField
        }
    }
    
    private var _textField: TextField<Text> {
        if let formatter {
            return TextField(String.empty, value: $text, formatter: formatter, onEditingChanged: onEditing, onCommit: onCommit)
        } else {
            return TextField(String.empty, text: $text, onEditingChanged: onEditing, onCommit: onCommit)
        }
    }
    
    private func rearrangeHint() {
        if !haveTitle {
            return
        }
        
        withAnimation(.easeIn(duration: 0.2)) {
            if !text.isEmpty {
                zStackAlignment = .topLeading
                hintFontSize = 12
                hintColor = topupHintColor
                hintOpacity = 1
            } else {
                zStackAlignment = .leading
                hintFontSize = 16
                hintColor = placeholderColor
                hintOpacity = 0
            }
        }
    }
}

public extension YTextField {
    func set(hintColor: Color) -> YTextField {
        var view = self
        view.topupHintColor = hintColor
        return view
    }
    
    func set(font: Font) -> YTextField {
        var view = self
        view.font = font
        return view
    }
    
    func set(format: String) -> YTextField {
        var view = self
        view.format = format
        return view
    }
    
    func set(placeholderAlignment align: Alignment) -> YTextField {
        var view = self
        view.placeholderAlignment = align
        return view
    }
    
    func set(formatter: NumberFormatter) -> YTextField {
        let view = self
        view.formatter = formatter
        return view
    }
}

public extension YTextField {
    func keyboardType(_ type: UIKeyboardType) -> YTextField {
        var view = self
        view.keyboardType = type
        return view
    }
    
    func set(height: CGFloat) -> YTextField {
        var view = self
        view.height = height
        return view
    }
    
    func set(haveTitle: Bool) -> YTextField {
        var view = self
        view.haveTitle = haveTitle
        return view
    }
}


struct YTextField_Preview: PreviewProvider {
    static var previews: some View {
        @State var text: String = "1123"
        return VStack {
            YTextField(text: $text, placeholder: "placeholder", isSecure: false)
                .set(haveTitle: true)
        }
    }
}
