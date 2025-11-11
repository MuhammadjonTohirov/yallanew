//
//  HomeViewModel+Sync.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 10/11/25.
//

import Foundation
import NetworkLayer

extension HomeViewModel {
    func syncPrerequisitesIfNeeded() {
        Task.detached { [weak self] in
            guard let self else { return }
            do {
                if await self.interactor.hasUser() {
                    try await self.syncUserInfo()
                }
            } catch {
                if (error as? NetworkError)?.code == 401 {
                    // token is expired 
                }
            }
        }
    }
    
    private func syncUserInfo() async throws {
        try await MeInfoProvider.shared.syncUserInfo()
    }
}
