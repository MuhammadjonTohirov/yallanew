//
//  BonusesViewModel.swift
//  yalla
//
//  Created by MuhammadAli Yo'lbarsbekov on 30/10/25.
//


import Foundation
import SwiftUI
import Core
import Combine
import YallaUtils
import YallaKit
import SwiftMessages

final class BonusesViewModel: ObservableObject {
    @MainActor
    @Published var bonus: String = ""
    @Published var promocode: String = ""
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var promocodeValue: Double?
    @Published var showPromocodeView: Bool = false

    func onAppear() {
        bonus = UserSettings.shared.userInfo?.balance?.asMoney ?? "0"
    }
    func applyPromocode() {
        Task.detached { [weak self] in
            guard let self else { return }
            
            await showLoading()
            
            do {
                if let result = try await ActivateBonuseUseCase().activate(promoCode: self.promocode), let val = result.value {
//                    await MeInfoProvider.shared.syncUserInfoIfNeeded(force: true)
                
                    await setPromocodeValue(val.double)
                    await presentSuccess()
                    
                } else {
                    let fallback = "Invalid promo code"
                    await presentFailure(message: fallback)
                }
            } catch {
                let message = error.serverMessage.nilIfEmpty ?? "promo.not.exists".localize
                await presentFailure(message: message)
            }
            
            await hideLoading()
        }
    }
   
    @MainActor
    private func showLoading() {
        self.isLoading = true
    }
    
    @MainActor
    private func hideLoading() {
        self.isLoading = false
    }
    
    @MainActor
    private func setPromocodeValue(_ value: Double?) {
        self.promocodeValue = value
    }
    
    @MainActor
    private func presentSuccess() {
        Snackbar.show(message: "promo.applied.successfully", theme: .success)
    }
    
    @MainActor
    private func presentFailure(message: String) {
        Snackbar.show(message: message, theme: .error)
    }
}
