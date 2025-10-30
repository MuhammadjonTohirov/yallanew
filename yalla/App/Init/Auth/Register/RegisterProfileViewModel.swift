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
import NetworkLayer

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
            do {
                guard let username = UserSettings.shared.username, let key = UserSettings.shared.lastOTPKey else {
                    return
                }
                
                if fn.replacingOccurrences(of: " ", with: "").isEmpty {
                    throw NetworkError.custom(message: "first.name.requred".localize, code: 0)
                }
                
                let req = RegistrationRequest(
                    phone: username,
                    givenNames: fn,
                    surname: ln,
                    gender: gender,
                    birthday: birthDate,
                    key: key
                )
                        
                if let result = try await authService.register(request: req) {
                    let hasAccessToken = UserSettings.shared.accessToken?.nilIfEmpty != nil
                        
                    await MainActor.run {
                        if result && hasAccessToken {
                            mainModel?.navigate(to: .main)
                        } else if result {
                            mainModel?.navigate(to: .auth)
                        }
                    }
                }
            } catch {
                await showError(error.serverMessage)
            }
            
            await MainActor.run {
                isLoading = false
            }
        }
    }
    
    @MainActor
    func showError(_ message: String) async {
        // TODO: show error message
        Logging.l(message)
    }
}
