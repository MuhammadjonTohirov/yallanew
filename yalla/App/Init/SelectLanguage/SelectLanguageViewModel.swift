//
//  SelectLanguageViewModel.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 20/10/25.
//

import Foundation
import YallaUtils
import Combine
import Core
import SwiftUI

enum SelectLanguageRoute: SceneDestination {
    case permissions
    
    @MainActor
    var scene: some View {
        PermissionsView()
    }
}

actor SelectLanguageViewModel: ObservableObject {
    
    private(set) var navigator: Navigator?
    
    func setNavigator(_ navigator: Navigator?) {
        self.navigator = navigator
    }
    
    
    @MainActor
    func selectLanguage(_ language: String) async throws {
        UserSettings.shared.language = language
        UserSettings.shared.isLanguageSelected = true
        
        await self.navigator?.push(SelectLanguageRoute.permissions)
    }
}
