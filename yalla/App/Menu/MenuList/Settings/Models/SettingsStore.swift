//
//  SettingsStore.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 05/11/25.
//

import Foundation
import Core
import Combine
import UIKit
import YallaUtils

final class SettingsStore: ObservableObject {
    static let shared = SettingsStore()
    
    private let validLanguageCodes: Set<String> = ["en", "ru"]
    
    func setup() {
        let preferredLanguage = ((UserSettings.shared.isLanguageSelected ?? false) ? UserSettings.shared.language : Locale.preferredLanguages.first) ?? "ru"
        
        debugPrint("Preferred language: \(preferredLanguage)")
        self.theme = UserSettings.shared.theme?.style.rawValue ?? 0
        self.language = validLanguageCodes.contains(preferredLanguage) ? preferredLanguage : "en"
    }
    
    @MainActor
    @Published var theme: Int = 0
    
    @MainActor
    @Published var language: String = "en"
    
    var themeValue: AppTheme {
        switch UserSettings.shared.theme?.style ?? .unspecified {
        case .dark:
            return .dark
        case .light:
            return .light
        case .unspecified:
            return .system
        @unknown default:
            return .system
        }
    }
    
    func setTheme(_ theme: AppTheme) {
        UserSettings.shared.set(interfaceStyle: theme.style)
        UserSettings.shared.theme = theme
        self.theme = theme.style.rawValue
    }
    
    func setLanguage(_ language: String) {
        UserSettings.shared.language = language
        self.language = language
    }
}
