//
//  InitialLoadingViewModel.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 15/10/25.
//

import Foundation
import Combine
import Core
import YallaUtils

actor InitialLoadingViewModel: ObservableObject {
    private var didAppear: Bool = false
        
    func onAppear() {
        if didAppear {
            return
        }
        
        didAppear = true
        
        Task {
            _ = await NotificationPermissionManager.shared.checkStatus()

            let isLanguageSelected = UserSettings.shared.isLanguageSelected ?? false
            let didShowPermissions = await UserSettings.shared.didShowPermissions
            let didShowOnboarding = await UserSettings.shared.didShowOnboarding
//            let hasAccessToken = UserSettings.shared.accessToken?.nilIfEmpty != nil
            
            await MainActor.run {
                if let isForTest = ProcessInfo.processInfo.environment["testUI"], isForTest.lowercased() == "yes" {
                    print("isForTest value: \(isForTest)")
                    mainModel?.navigate(to: .test)

                    return
                }

                if !isLanguageSelected {
                    mainModel?.navigate(to: .language)
                    return
                }
                
                if !didShowPermissions {
                    mainModel?.navigate(to: .permissions)
                    return
                }
                
                if !didShowOnboarding {
                    mainModel?.navigate(to: .onboarding)
                    return
                }
//
//                if !hasAccessToken {
//                    mainModel?.navigate(to: .auth)
//                    return
//                }
                mainModel?.navigate(to: .home)
            }
        }
    }
}
