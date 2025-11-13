//
//  Popup+Extension.swift
//  Core
//
//  Created by Muhammadjon Tohirov on 03/03/25.
//

import Foundation
import SwiftUI

// Extension for View to make using the modifier easier
public extension View {
    func customPopup<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(PupupAlert(isPresented: isPresented, content: content))
    }
    
    func customAlert(
        title: String,
        message: String,
        primaryButtonTitle: String,
        secondaryButtonTitle: String,
        isPresented: Binding<Bool>,
        onPrimaryAction: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) -> some View {
        self.customPopup(isPresented: isPresented) {
            PopupView<EmptyView>(
                title: title,
                message: message,
                buttons: [
                    PrimaryAlertButton(
                        title: primaryButtonTitle,
                        action: {
                            isPresented.wrappedValue = false
                            onPrimaryAction?()
                        }
                    ),
                    CancelAlertButton(
                        title: secondaryButtonTitle,
                        action: {
                            isPresented.wrappedValue = false
                            onCancel?()
                        }
                    )
                ]
            )
        }
    }
    
    func customAlert(isPresented: Binding<Bool>, title: String, message: String?, actions: [AlertButton]) -> some View {
        self.customPopup(isPresented: isPresented) {
            PopupView<EmptyView>(
                title: title,
                message: message ?? "",
                buttons: actions
            )
        }
    }
}
