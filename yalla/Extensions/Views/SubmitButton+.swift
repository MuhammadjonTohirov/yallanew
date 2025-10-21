//
//  SubmitButton+.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 20/10/25.
//

import Foundation
import YallaUtils
import SwiftUI

struct SubmitButtonFactory {
    static func primary(title: String, action: @escaping () -> Void) -> SubmitButton<Text> {
        SubmitButton<Text>(
            backgroundColor: Color.iPrimary,
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
