//
//  SettingsViewModel.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 05/11/25.
//

import Foundation
import Combine
import Core
import UIKit

actor SettingsViewModel: ObservableObject {
    @MainActor
    @Published var selectedLanguage: String = "en"
    
    @MainActor
    @Published var theme: AppTheme = .light
    
    @MainActor
    @Published var showLanguage: Bool = false
    
    @MainActor
    @Published var showTheme: Bool = false
    
    @MainActor
    func onAppear() {
        self.selectedLanguage = SettingsStore.shared.language
        self.theme = SettingsStore.shared.themeValue
    }
    
    @MainActor
    func onClickLanguage() {
        showLanguage = true
    }
    
    @MainActor
    func onClickTheme() {
        showTheme = true
    }
    
    @MainActor
    func setSelectLanguage(_ language: String) {
        UserSettings.shared.language = language
        self.selectedLanguage = language
        SettingsStore.shared.language = language
    }
    
    @MainActor
    func setSelectTheme(_ theme: AppTheme) {
        UserSettings.shared.theme = theme
        self.theme = theme
        SettingsStore.shared.theme = theme.style.rawValue
    }
}
