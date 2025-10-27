//
//  Snackbar.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 27/10/25.
//

import Foundation
import SwiftMessages
import UIKit
import Core

@MainActor
public enum Snackbar {
    public static func show(title: String? = nil, message: String, theme: Theme, hideAll: Bool = true) {
        DispatchQueue.main.async {
            if hideAll { SwiftMessages.hideAll() }
            SwiftMessages.show(config: barConfiguration(theme), view: barView(title, message, theme))
        }
    }
}

private extension Snackbar {
    static func barConfiguration( _ theme: Theme) -> SwiftMessages.Config {
        var configuration = SwiftMessages.Config()
        configuration.presentationStyle = .top
        configuration.presentationContext = .window(windowLevel: .statusBar)
        configuration.duration = .seconds(seconds: 3)
        configuration.interactiveHide = true

        configuration.haptic = switch theme {
        case .info, .success: .success
        case .warning: .warning
        case .error: .error
        }

        return configuration
    }

    static func barView(_ title: String?, _ message: String, _ theme: Theme) -> MessageView {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.bodyLabel?.text = message
        view.bodyLabel?.textColor = .white
        view.titleLabel?.text = title
        view.buttonTapHandler = { _ in SwiftMessages.hide() }
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 16
        view.configureTheme(theme)
        view.button?.tintColor = .white
        view.button?.backgroundColor = .clear
        view.button?.setTitle(nil, for: .normal)
        
        view.configureTheme(
            backgroundColor: theme.bgColor,
            foregroundColor: theme.frColor,
            iconImage: theme.icon,
        )
        
        view.button?.backgroundColor = .clear
        view.button?.setImage(UIImage(named: "icon_x"), for: .normal)
        view.button?.tintColor = .white
        view.bodyLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return view
    }
}

extension Theme {
    var icon: UIImage? {
        switch self {
        case .success, .info:
            UIImage(named: "icon_success_rounded")!
        case .error, .warning:
            UIImage(named: "icon_error_rounded")!
        }
    }
    
    var bgColor: UIColor {
        switch self {
        case .success, .info:
            UIColor.iPrimary
        case .error, .warning:
            UIColor.systemRed
        }
    }
    
    var frColor: UIColor {
        return .white
    }
}

final class MessageBodyView: MessageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
