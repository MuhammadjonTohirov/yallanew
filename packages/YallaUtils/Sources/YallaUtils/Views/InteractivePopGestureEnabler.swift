//
//  InteractivePopGestureEnabler.swift
//  YallaUtils
//
//  Created by Muhammadjon Tohirov on 20/10/25.
//

import Foundation
import SwiftUI
import UIKit

public struct InteractivePopGestureEnabler: UIViewControllerRepresentable {
    public init() {}
    
    public func makeUIViewController(context: Context) -> UIViewController {
        Controller()
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    private final class Controller: UIViewController, UIGestureRecognizerDelegate {
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            guard let nav = navigationController,
                  let pop = nav.interactivePopGestureRecognizer else { return }
            // Ensure the gesture works even when the back button is hidden
            pop.isEnabled = true
            pop.delegate = self
            // Optional: keep the bar hidden but gesture alive
            // nav.setNavigationBarHidden(true, animated: false)
        }
        // Allow the gesture when there is a previous VC
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            navigationController?.viewControllers.count ?? 0 > 1
        }
    }
}

public extension View {
    func enableInteractivePopGesture() -> some View {
        background(InteractivePopGestureEnabler())
    }
    
    func hideBackButton() -> some View {
        navigationBarBackButtonHidden(true)
            .enableInteractivePopGesture()
    }
}
