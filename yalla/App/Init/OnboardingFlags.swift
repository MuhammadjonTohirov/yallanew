//
//  OnboardingFlags.swift
//  yalla
//
//  Lightweight flags to drive first-run navigation
//

import Foundation

enum OnboardingFlags {
    private static let permissionsShownKey = "onboarding.permissionsShown"
    
    static var didShowPermissions: Bool {
        get { UserDefaults.standard.bool(forKey: permissionsShownKey) }
        set { UserDefaults.standard.set(newValue, forKey: permissionsShownKey) }
    }
}

