//
//  File.swift
//  YallaUtils
//
//  Created by Muhammadjon Tohirov on 17/10/25.
//

import Foundation
import SwiftUI

public extension View {
    func onClick(perform action: @escaping () -> Void) -> some View {
        Button(action: action) {
            self
        }
        .buttonStyle(.plain)
    }
}
