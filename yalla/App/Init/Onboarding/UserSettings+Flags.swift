//
//  UserSettings+Flags.swift
//  yalla
//

import Foundation
import Core

extension UserSettings {
    var didShowPermissions: Bool {
        set {
            @codableWrapper(key: "onboarding.permissionsShown", false)
            var value: Bool?

            value = newValue
        }
        
        get {
            @codableWrapper(key: "onboarding.permissionsShown", false)
            var value: Bool?
            
            return value ?? false
        }
    }
    
    var didShowOnboarding: Bool {
        set {
            @codableWrapper(key: "onboarding.onboardingShown", false)
            var value: Bool?
            
            value = newValue
        }
        
        get {
            @codableWrapper(key: "onboarding.onboardingShown", false)
            var value: Bool?
            
            return value ?? false
        }
    }
}
