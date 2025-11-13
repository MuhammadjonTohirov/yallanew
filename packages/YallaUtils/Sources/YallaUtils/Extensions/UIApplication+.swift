//
//  File.swift
//  SlidingBottomSheet
//
//  Created by Muhammadjon Tohirov on 10/10/25.
//

import Foundation
import UIKit


extension UIApplication {
    
    var safeArea: UIEdgeInsets {
        guard let activeView = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first else {
            return .zero
        }
        
        return activeView.safeAreaInsets
    }
    
    var screenFrame: CGRect {
        guard let activeView = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first else {
            return .zero
        }
        
        return activeView.frame
    }
    
    var safeAreaFrame: CGRect {
        guard let activeView = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first else {
            return .zero
        }
        
        return activeView.safeAreaLayoutGuide.layoutFrame
    }
    
    var statusBarHeight: CGRect {
        guard let activeView = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first else {
            return .zero
        }
        
        return activeView.windowScene?.statusBarManager?.statusBarFrame ?? .zero
    }
    
    var hasDynamicIsland: Bool {
        safeArea.top > 51
    }
    
    var colorScheme: UIUserInterfaceStyle {
        guard let activeView = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first else {
            return .light
        }
        
        return activeView.overrideUserInterfaceStyle
    }
    
    func dismissKeyboard() {
        guard let activeView = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first else {
            return
        }
        

        activeView.endEditing(true)
    }
}

