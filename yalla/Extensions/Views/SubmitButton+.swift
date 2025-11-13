//
//  SubmitButton+.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 20/10/25.
//

import Foundation
import YallaUtils
import SwiftUI
import Core

struct SubmitButtonFactory {
    static func primary(title: String, action: @escaping () -> Void) -> SubmitButton<Text> {
        SubmitButton<Text>(
            backgroundColor: Color.iPrimary,
            pressedColor: Color.iPrimaryDark,
            height: 56,
            label: {
                Text(LocalizedStringKey(title))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            },
            action: {
                action()
            }
        )
    }
    
    static func secondary(title: String, action: @escaping () -> Void) -> SubmitButton<Text> {
        SubmitButton<Text>(
            backgroundColor: Color.init(hex: "#101828"),
            pressedColor: Color.label,
            height: 56,
            label: {
                Text(LocalizedStringKey(title))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            },
            action: {
                action()
            }
        )
    }
}

#Preview {
    SubmitButtonFactory.secondary(title: "OK") {
        debugPrint("Come on")
    }
}
