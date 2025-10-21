//
//  File.swift
//  YallaUtils
//
//  Created by Muhammadjon Tohirov on 17/10/25.
//

import Foundation
import SwiftUI

public extension Shape {
    func stroke(lineWidth: CGFloat = 1, color: Color, visible: Bool) -> some View {
        Group {
            if visible {
                self.stroke(
                    lineWidth: lineWidth,
                )
                .foregroundStyle(color)
            } else {
                self
            }
        }
    }
}
