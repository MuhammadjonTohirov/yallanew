//
//  DeepLinkHandler.swift
//  Ildam
//
//  Created by Muhammadjon Tohirov on 21/03/25.
//

import Foundation
import SwiftUI
import Core

struct DeepLinkHandler: ViewModifier {
    @StateObject private var deepLinkManager = DeepLinkManager.shared
    @State private var presentedDeepLink: DeepLinkData?
    
    // Environment values - add more as needed for navigation control
    @Environment(\.presentationMode) private var presentationMode
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if let activeDeepLink = deepLinkManager.activeDeepLink {
                    handleDeepLink(deepLink: activeDeepLink)
                }
            }
            .onChange(of: deepLinkManager.activeDeepLink) { newDeepLink in
                if let newDeepLink = newDeepLink {
                    handleDeepLink(deepLink: newDeepLink)
                }
            }
    }
    
    private func handleDeepLink(deepLink: DeepLinkData) {
        Logging.l(tag: "DeepLinkHandler", "Processing deep link: \(deepLink.destination.rawValue)")
        
        // Store the deep link we're handling
        presentedDeepLink = deepLink
        
        // Handle the deep link based on its destination
        // Implementation will vary based on your app's navigation structure
        // You'll need to adapt this to work with your specific navigation setup
        
        // After handling, clear the deep link
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            deepLinkManager.reset()
        }
    }
}

extension View {
    func handleDeepLinks() -> some View {
        self.modifier(DeepLinkHandler())
    }
}
