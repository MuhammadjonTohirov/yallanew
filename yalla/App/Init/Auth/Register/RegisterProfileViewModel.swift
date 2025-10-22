//
//  RegisterProfileViewModel.swift
//  Ildam
//
//  Created by applebro on 09/12/23.
//

import Foundation
import IldamSDK
import Core
import Combine

actor RegisterProfileViewModel: ObservableObject {
    let authService = AuthService()
    @MainActor
    @Published var shouldShowAlert: Bool = false
    
    @MainActor
    @Published var isLoading: Bool = false
    
    @MainActor
    func register(fn: String, ln: String, birthDate: String, gender: Gender) {
        isLoading = true
        Task {
            guard let username = UserSettings.shared.username, let key = UserSettings.shared.lastOTPKey else {
                return
            }
            
            let req = RegistrationRequest(
                phone: username,
                givenNames: fn,
                surname: ln,
                gender: gender,
                birthday: birthDate,
                key: key
            )
            
            if let result = await authService.register(request: req) {
                let hasAccessToken = UserSettings.shared.accessToken?.nilIfEmpty != nil
                
                await MainActor.run {
                    if result && hasAccessToken {
                        mainModel?.navigate(to: .main)
                    } else if result {
                        mainModel?.navigate(to: .auth)
                    }
                }
            } else {
                
            }
            
            await MainActor.run {
                isLoading = false
            }
        }
    }
}

extension RegistrationRequest: @retroactive @unchecked Sendable {
    
}
