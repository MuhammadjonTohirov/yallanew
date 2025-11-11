//
//  Popup+View.swift
//  Core
//
//  Created by applebro on 14/04/25.
//

import Foundation
import SwiftUI

// Dialog content view with support for multiple buttons
struct PopupView<Content: View>: View {
    let title: String
    let message: String
    let buttons: [AlertButton]
    @ViewBuilder let customContent: Content?
    public init(
        title: String,
        message: String,
        buttons: [AlertButton],
        content: (() -> Content)? = nil
    ) {
        self.title = title
        self.message = message
        self.buttons = buttons
        self.customContent = content?()
    }
    
    // Legacy support for primary/secondary buttons
    public init(
        title: String,
        message: String,
        primaryButtonTitle: String,
        primaryAction: @escaping () -> Void,
        secondaryButtonTitle: String? = nil,
        secondaryAction: (() -> Void)? = nil,
        content: (() -> Content)? = nil
    ) {
        var alertButtons: [AlertButton] = [
            PrimaryAlertButton(
                title: primaryButtonTitle,
                action: primaryAction
            )
        ]
        
        if let secondaryButtonTitle = secondaryButtonTitle,
           let secondaryAction = secondaryAction {
            alertButtons.append(
                CancelAlertButton(
                    title: secondaryButtonTitle,
                    action: secondaryAction
                )
            )
        }
        
        self.title = title
        self.message = message
        self.buttons = alertButtons
        self.customContent = content?()
    }
    
    public var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .padding(.top, 24)
                .foregroundStyle(Color.init(uiColor: .label))
                .visibility(!title.isEmpty)
            
            Text(message)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .visibility(!message.isEmpty)
            
            if let customContent = customContent {
                customContent
                    .padding(.horizontal, 20)
            }
            
            HStack(spacing: 12) {
                ForEach(buttons, id: \.title) { button in
                    Button(action: button.action) {
                        Text(button.title)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(button.titleColor)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60) // Using your scale helper
                    }
                    .buttonStyle(HoveredButtonStyle(normalColor: button.backgroundColor))
                    .cornerRadius(16)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .fixedSize(horizontal: false, vertical: true)
        
    }
}

