//
//  Popup+Actions.swift
//  Core
//
//  Created by Muhammadjon Tohirov on 03/03/25.
//

import Foundation
import SwiftUI

public protocol AlertButton {
    var title: String { get }
    var detail: String? { get }
    var action: () -> Void { get }
    var backgroundColor: Color { get }
    var titleColor: Color { get }
    var borderColor: Color { get }
}

// Button Action Structure
public struct PrimaryAlertButton: AlertButton {
    public let title: String
    public var detail: String?
    public var backgroundColor: Color
    public var titleColor: Color
    public var borderColor: Color
    public let action: () -> Void

    public init(
        title: String,
        detail: String? = nil,
        borderColor: Color = .clear,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
        self.detail = detail
        self.backgroundColor = .init(hex: "#562DF8")
        self.titleColor = .white
        self.borderColor = borderColor
    }
}

public struct CancelAlertButton: AlertButton {
    public let title: String
    public var detail: String?
    public let action: () -> Void
    public var backgroundColor: Color
    public var titleColor: Color
    public var borderColor: Color
    
    public init(
        title: String,
        detail: String? = nil,
        backgroundColor: Color = .clear,
        titleColor: Color = .init(uiColor: .label),
        borderColor: Color = Color.init(uiColor: .separator),
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
        self.detail = detail
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.titleColor = titleColor
    }
}
