//
//  File.swift
//  YallaUtils
//
//  Created by Muhammadjon Tohirov on 29/10/25.
//

import Foundation
import SwiftUI

public extension ToolbarContent {
    func sharedBackgroundVisibility(visible: Bool) -> some ToolbarContent {
        if #available(iOS 26.0, *) {
            return self.sharedBackgroundVisibility(visible ? Visibility.visible : .hidden)
        } else {
            return self
        }
    }
}
