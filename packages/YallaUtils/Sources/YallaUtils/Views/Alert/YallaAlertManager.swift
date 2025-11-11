//
//  WindowAlertManager.swift
//  Core
//
//  Created by applebro on 26/04/25.
//

import Combine
import SwiftUI
import UIKit

// Global alert manager that uses a UIWindow to display alerts on top of everything
public class YallaAlertManager: ObservableObject, @unchecked Sendable {
    // Singleton instance
    public static let shared = YallaAlertManager()
    
    @Published public var isPresented: Bool = false
    @Published public var title: String = ""
    @Published public var message: String = ""
    @Published public var buttons: [AlertButton] = []
    @Published public var customContent: AnyView? = nil
    @Published var scale: CGFloat = 0.9

    // UIWindow for displaying the alert on top of everything
    private var alertWindow: UIWindow?
    private var hostingController: UIHostingController<AlertHostView>?
    
    @MainActor
    public var colorScheme: UIUserInterfaceStyle = .light {
        didSet {
            alertWindow?.overrideUserInterfaceStyle = colorScheme
        }
    }
    
    private init() {
        // Initialize with an empty alert
    }
    
    public func showAlert(
        title: String = "",
        message: String = "",
        customContent: AnyView? = nil,
        buttons: [AlertButton]
    ) {
        self.title = title
        self.message = message
        self.buttons = buttons
        self.customContent = customContent
        self.isPresented = true
        Task { @MainActor in
            self.presentAlertWindow()
        }
    }
    
    public func showAlert(
        title: String,
        message: String,
        primaryButtonTitle: String,
        primaryAction: @escaping () -> Void,
        secondaryButtonTitle: String? = nil,
        secondaryAction: (() -> Void)? = nil
    ) {
        var alertButtons: [AlertButton] = [
            PrimaryAlertButton(
                title: primaryButtonTitle,
                action: {
                    primaryAction()
                    self.dismiss()
                }
            )
        ]
        
        if let secondaryButtonTitle = secondaryButtonTitle,
           let secondaryAction = secondaryAction {
            alertButtons.append(
                CancelAlertButton(
                    title: secondaryButtonTitle,
                    action: {
                        secondaryAction()
                        self.dismiss()
                    }
                )
            )
        }
        
        self.showAlert(
            title: title,
            message: message,
            buttons: alertButtons,
        )
    }
    
    @MainActor
    private func presentAlertWindow() {
        guard isPresented else { return }
        
        // Create alert host view
        let alertView = AlertHostView(alertManager: self)
        
        // Create hosting controller for the alert view
        let hostingController = UIHostingController(rootView: alertView)
        hostingController.view.backgroundColor = .clear
        self.hostingController = hostingController
        
        // Create a new window that sits above everything
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        let alertWindow = UIWindow(windowScene: windowScene)
        alertWindow.backgroundColor = .clear
        alertWindow.windowLevel = .alert + 1 // Above system alerts
        alertWindow.rootViewController = hostingController
        alertWindow.rootViewController?.view.alpha = 0
        alertWindow.makeKeyAndVisible()
        alertWindow.overrideUserInterfaceStyle = colorScheme
        self.alertWindow = alertWindow
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut]) {
            alertWindow.rootViewController?.view.alpha = 1
        }
    }
    
    public func dismiss() {
        Task { @MainActor in
            self.scale = 0.9
            self.dismissAlertWindow()
        }
    }
    
    @MainActor
    private func dismissAlertWindow() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
            self.alertWindow?.alpha = 0
        }, completion: {_ in
            self.alertWindow?.isHidden = true
            self.alertWindow = nil
            self.hostingController = nil
            self.isPresented = false
        })
    }
}
