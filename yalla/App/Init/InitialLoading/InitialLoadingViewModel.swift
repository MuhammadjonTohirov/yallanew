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
            
            var isLanguageSelected: Bool {
                UserSettings.shared.isLanguageSelected ?? false
            }

            await MainActor.run {
                if !isLanguageSelected {
                    mainModel?.navigate(to: .language)
                    
                    return
                }
                
                mainModel?.navigate(to: .home)
            }
        }
    }
}
