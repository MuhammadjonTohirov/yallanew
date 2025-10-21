//
//  DeepLinkManager.swift
//  Ildam
//
//  Created by Muhammadjon Tohirov on 21/03/25.
//

import Foundation
import SwiftUI
import Core
import FirebaseAnalytics
import Combine

enum DeepLinkDestination: String {
    case home
    case orderDetails
    case profile
    case settings
    case history
    case places
    
    // Add other destinations as needed
}

struct DeepLinkData: Equatable, Sendable {
    let destination: DeepLinkDestination
    let parameters: [String: String]
    
    init(destination: DeepLinkDestination, parameters: [String: String] = [:]) {
        self.destination = destination
        self.parameters = parameters
    }
    
    static func == (lhs: DeepLinkData, rhs: DeepLinkData) -> Bool {
        lhs.destination == rhs.destination &&
        lhs.parameters == rhs.parameters
    }
}

actor DeepLinkManager: ObservableObject {
    @MainActor
    static let shared = DeepLinkManager()
    
    @MainActor
    var activeDeepLink: DeepLinkData?
    
    init() {}
    
    @discardableResult
    func handleDeepLink(url: URL) -> Bool {
        Logging.l(tag: "DeepLinkManager", "Handling deep link: \(url.absoluteString)")
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return false
        }
        
        // Extract path and query parameters
        let path = components.path.trimmingCharacters(in: .init(charactersIn: "/"))
        var parameters = [String: String]()
        
        if let queryItems = components.queryItems {
            for item in queryItems {
                parameters[item.name] = item.value
            }
        }
        
        // Process the path
        guard let destination = DeepLinkDestination(rawValue: path) else {
            Logging.l(tag: "DeepLinkManager", "Unknown deep link path: \(path)")
            return false
        }
        
        // Set the active deep link
        Task { @MainActor in
            await set(activeDeepLink: DeepLinkData(destination: destination, parameters: parameters))
        }
        return true
    }
    
    @MainActor
    func set(activeDeepLink: DeepLinkData) async {
        self.activeDeepLink = activeDeepLink
    }
    
    @MainActor
    func reset() {
        activeDeepLink = nil
    }
    
    // Helper method to handle deep link URL strings
    func handleDeepLink(urlString: String) -> Bool {
        guard let url = URL(string: urlString) else {
            return false
        }
        return handleDeepLink(url: url)
    }
    
    func handleDeepLinkAnalytics(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else { return }
        
        // Extract all UTM parameters
        var params: [String: Any] = [:]
        
        // Standard UTM parameters
        let utmSource = queryItems.first(where: { $0.name == "utm_source" })?.value
        let utmId = queryItems.first(where: { $0.name == "utm_id" })?.value
        let utmCompany = queryItems.first(where: { $0.name == "utm_company" })?.value
        let utmDate = queryItems.first(where: { $0.name == "utm_date" })?.value
        let utmComment = queryItems.first(where: { $0.name == "utm_comment" })?.value
        let utmLink = queryItems.first(where: { $0.name == "utm_link" })?.value
        
        // Add extracted parameters to our analytics payload
        if let utmSource = utmSource { params["utm_source"] = utmSource }
        if let utmId = utmId { params["utm_id"] = utmId }
        if let utmCompany = utmCompany { params["utm_company"] = utmCompany }
        if let utmDate = utmDate { params["utm_date"] = utmDate }
        if let utmComment = utmComment { params["utm_comment"] = utmComment }
        if let utmLink = utmLink { params["utm_link"] = utmLink }
        
        // Add additional context data
        params["timestamp"] = Date().timeIntervalSince1970
        params["app_version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
        
        // Only log if we have at least some UTM data
        if !params.isEmpty {
            Analytics.logEvent("utm_tracking", parameters: params)
            print("UTM Data sent to Firebase Analytics: \(params)")
        }
    }
}
