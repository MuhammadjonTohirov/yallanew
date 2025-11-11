//
//  HomeInteractor.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 10/11/25.
//

import Foundation
import NetworkLayer
import Core

protocol HomeInteractorProtocol: Sendable {
    func hasUser() async -> Bool
    func syncUserInfo() async
}

struct HomeInteractor: HomeInteractorProtocol {
    func hasUser() async -> Bool {
        UserSettings.shared.accessToken?.nilIfEmpty != nil
    }
    
    func syncUserInfo() async {
        do {
            try await MeInfoProvider.shared.syncUserInfo()
        } catch {
            let isAuthFailed = (error as? NetworkError)?.code == 401
            
            if isAuthFailed {
                UserSettings.shared.accessToken = nil
                UserSettings.shared.refreshToken = nil
                UserSettings.shared.tokenExpireDate = nil
                UserSettings.shared.lastActiveDate = nil
                UserSettings.shared.lastOTPKey = nil
                UserSettings.shared.session = nil
            }
        }
    }
}
