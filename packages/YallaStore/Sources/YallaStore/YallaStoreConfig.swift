//
//  File.swift
//  YallaStore
//
//  Created by Muhammadjon Tohirov on 20/10/25.
//

import Foundation

public struct YallaStoreConfig: Sendable {
    public var suitName: String = "uz.ildam.taxiclient"
}

public struct YallaUserDefaults : Sendable {
    static let shared = YallaUserDefaults()
    
    public var config = YallaStoreConfig()
    
    mutating public func setConfig(_ config: YallaStoreConfig) {
        self.config = config
    }
    
    var userDefaults: UserDefaults {
        UserDefaults(suiteName: config.suitName) ?? .standard
    }
}

public extension YallaUserDefaults {
    static var isFirstLaunch: Bool {
        get {
            @userDefaultsWrapper(key: "isFirstLaunch", true)
            var isFirstLaunch: Bool?
            
            return isFirstLaunch ?? false
        }
        
        set {
            @userDefaultsWrapper(key: "isFirstLaunch", newValue)
            var isFirstLaunch: Bool?
            
            isFirstLaunch = newValue
        }
    }
    
    static var shouldShowInitialPermissionScreen: Bool {
        get {
            @userDefaultsWrapper(key: "isFirstPermissionsShown", false)
            var isFirstPermissionsShown: Bool?
            
            return isFirstPermissionsShown ?? false
        } set {
            @userDefaultsWrapper(key: "isFirstPermissionsShown", newValue)
            var isFirstPermissionsShown: Bool?
            
            isFirstPermissionsShown = newValue
        }
    }
}
