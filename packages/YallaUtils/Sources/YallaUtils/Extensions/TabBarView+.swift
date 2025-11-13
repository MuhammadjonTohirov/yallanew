//
//  File.swift
//  YallaUtils
//
//  Created by Muhammadjon Tohirov on 07/11/25.
//

import Foundation
import SwiftUI

public extension TabViewStyle {
    static func page(indexDisplayMode: PageTabViewStyle.IndexDisplayMode = .automatic) -> PageTabViewStyle {
        PageTabViewStyle(indexDisplayMode: indexDisplayMode)
    }
}
