//
//  WindowAlertManager+.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 11/11/25.
//

import Foundation
import YallaUtils
import Core
import UIKit

public func showWindowAlert(
    title: String,
    message: String,
    primaryButtonTitle: String,
    secondaryButtonTitle: String? = nil,
    primaryAction: @escaping () -> Void,
    secondaryAction: (() -> Void)? = nil
) {
    YallaUtils.YallaAlertManager.shared.showAlert(
        title: title,
        message: message,
        primaryButtonTitle: primaryButtonTitle,
        primaryAction: primaryAction,
        secondaryButtonTitle: secondaryButtonTitle,
        secondaryAction: secondaryAction
    )
}

extension YallaUtils.YallaAlertManager {
    
}
