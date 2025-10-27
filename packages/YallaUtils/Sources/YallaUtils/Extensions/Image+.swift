//
//  File.swift
//  YallaUtils
//
//  Created by Muhammadjon Tohirov on 27/10/25.
//

import Foundation
import SwiftUI

public extension Image {
    static func icon(_ name: String, color: Color = .init(uiColor: .label), size: CGSize = .init(width: 24, height: 24  )) -> some View {
        Image(name)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundColor(color)
            .frame(width: size.width, height: size.height)
    }
}
