//
//  HomeInteractor+Mock.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 10/11/25.
//

import Foundation
import NetworkLayer
import Core

struct HomeMockInteractor: HomeInteractorProtocol {
    func hasUser() async -> Bool {
        true
    }
    
    func syncUserInfo() async {
        do {
            try await Task.sleep(for: .milliseconds(200))
            try await MeInfoProvider.shared.syncUserInfo()
        } catch {
            UserSettings.shared.accessToken = nil
            UserSettings.shared.refreshToken = nil
            UserSettings.shared.tokenExpireDate = nil
            UserSettings.shared.lastActiveDate = nil
            UserSettings.shared.lastOTPKey = nil
            UserSettings.shared.session = nil
        }
    }
}
