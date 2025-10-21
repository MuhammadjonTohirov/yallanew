//
//  OTPField.swift
//  Ildam
//
//  Created by applebro on 28/05/25.
//

import Foundation
import SwiftUI
import Core
import YallaUtils

struct OTPField: View {
    @Binding var text: String
    var numberOfFields: Int

    @FocusState var isFocused: Bool

    private var characters: [String] {
        let chars = Array(text.prefix(numberOfFields)).map { String($0) }
        return chars + Array(repeating: "", count: max(0, numberOfFields - chars.count))
    }

    private var currentIndex: Int {
        min(text.count, numberOfFields - 1)
    }
    
    @State
    private var itemRect: CGRect = .zero

    var body: some View {
        ZStack {
            HStack(spacing: 12) {
                ForEach(0..<numberOfFields, id: \.self) { index in
                    ZStack {
                        RoundedRectangle(cornerRadius: AppParams.Radius.small)
                            .fill(Color.clear)
                            .frame(minHeight: 30)
                            .frame(maxWidth: 60)
                            .readRect(rect: $itemRect)
                            .frame(height: itemRect.width)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppParams.Radius.small)
                                    .stroke(
                                        characters[index].isEmpty && index != currentIndex ? Color.iBorderDisabled : Color.iLabel,
                                        lineWidth: 1
                                    )
                            )

                        Text(characters[index])
                    }
                }
            }

            // Hidden text field for input
            TextField("".localize, text: $text)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .accentColor(.clear)
                .foregroundColor(.clear)
                .disableAutocorrection(true)
                .focused($isFocused)
                .onAppear {
                    DispatchQueue.main.async {
                        isFocused = true
                    }
                }
        }
        .onTapGesture {
            isFocused = true
        }
    }
}
