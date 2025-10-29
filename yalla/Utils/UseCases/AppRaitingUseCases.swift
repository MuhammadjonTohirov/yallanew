//
//  AppRatingUseCase.swift
//  Ildam
//
//  Created by Muhammadjon on 04/30/25.
//

import Foundation
import UIKit
import StoreKit
import Core

/// Protocol defining the functionality for app rating
public protocol AppRatingUseCase {
    func setAppStoreID(_ appStoreId: String)
    
    /// Request a review using the system's review prompt
    func requestReview()
    
    /// Open the App Store page directly to the review section
    func openAppStoreReviewPage()
    
    /// Get the App Store URL for the app
    func getAppStoreURL() -> URL?
}

/// Implementation of the AppRatingUseCase protocol
public final class AppRatingUseCaseImpl: AppRatingUseCase {
    
    // MARK: - Properties
    
    /// The App Store ID for your application
    private var appStoreId: String
    
    /// Singleton instance for easy access
    public static let shared = AppRatingUseCaseImpl()
    
    // MARK: - Initialization
    
    /// Initialize with a specific App Store ID
    /// - Parameter appStoreId: The App Store ID for your application
    public init(appStoreId: String = "6741082804") {
        self.appStoreId = appStoreId
        Logging.l(tag: "AppRatingUseCase", "Initialized with App Store ID: \(appStoreId)")
    }
    
    public func setAppStoreID(_ appStoreId: String) {
        self.appStoreId = appStoreId
    }
    
    // MARK: - Public Methods
    
    /// Request a review using the system's review prompt
    /// This is the recommended way to ask for reviews as it respects user preferences
    /// and follows Apple's guidelines
    public func requestReview() {
        Logging.l(tag: "AppRatingUseCase", "Requesting app review")
        openAppStoreReviewPage()
    }
    
    /// Open the App Store page directly to the review section
    /// This is useful when you want to ensure users can leave a review
    /// regardless of system limitations
    public func openAppStoreReviewPage() {
        Logging.l(tag: "AppRatingUseCase", "Opening App Store review page")
        
        guard let url = getAppStoreURL() else {
            Logging.l(tag: "AppRatingUseCase", "Failed to create App Store URL")
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { success in
                Logging.l(tag: "AppRatingUseCase", "App Store URL opened: \(success)")
            }
        } else {
            Logging.l(tag: "AppRatingUseCase", "Cannot open App Store URL")
        }
    }
    
    /// Get the App Store URL for the app
    /// - Returns: URL to the app's page on the App Store with review action
    public func getAppStoreURL() -> URL? {
//        https://apps.apple.com/us/app/yalla-taxi-and-delivery/id6741082804?action=write-review
        let urlString = "https://apps.apple.com/us/app/yalla-taxi-and-delivery/id\(appStoreId)?action=write-review"
        return URL(string: urlString)
    }
}
