//
//  PaymentMethodViewModel.swift
//  Ildam
//
//  Created by Sardorbek Saydamatov on 27/11/24.
//

import Foundation
import SwiftUI
import IldamSDK
import Core
import Combine

class PaymentMethodsViewModel: ObservableObject {
    @Published var cards: [CardItem] = []
    @Published var isLoading: Bool = false
    @Published var selectedPaymentMethodId: String? = "cash"
    @Published var addCardView: Bool = false
    @Published var isEditing: Bool = false
    
    var pageTitle: String {
        isEditing
        ? "edit.payment.methods".localize
        : "payment.methods".localize
    }
    
    var pageDescription: String {
        isEditing
        ? "edit.choose.payment".localize
        : "choose.payment".localize
    }
    
    var canEdit: Bool {
        !self.cards.isEmpty
    }
    
    var isCardEnabled: Bool = false
    var isCashEnabled: Bool = true
    
    func onAppear() {
        isCardEnabled = AppConfigUseCaseImpl().appConfig?.isCardPaymentEnabled ?? false
        
        Task {
            await fetchCards()
        }
    }
    
    // Fetch cards
    func fetchCards() async {
        await MainActor.run {
            self.isLoading = true
        }
        await SyncCardsUseCaseImpl.shared.syncCards()
        
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.cards = SyncCardsUseCaseImpl.shared.cards
            self.selectedPaymentMethodId = isCardEnabled ? SyncCardsUseCaseImpl.shared.cards
                .first(where: {$0.isDefault ?? false})?.cardId ?? "cash" : "cash"
            self.isLoading = false
        }
    }
    
    // Select a payment method
    @MainActor
    func selectPaymentMethod(_ id: String?) {
        if id == "cash" && !isCashEnabled {
            TaxiOrderConfigProvider.shared.setPayment(type: nil)
            return
        }
        
        guard isCardEnabled else { return }
        
        selectedPaymentMethodId = id
        
        self.cards.forEach { item in
            item.isDefault = false
            if item.cardId == id {
                item.isDefault = true
            }
        }
        
        Task {
            await SyncCardsUseCaseImpl.shared.setDefault(cardId: id ?? "cash")
            TaxiOrderConfigProvider.shared.setPayment(type: id)
        }
    }
    
    @MainActor
    func toggleEditMode() {
        isEditing.toggle()
    }
    
    // Open Add Card View
    func openAddCardView() {
        addCardView = true
    }
    
    func isSelected(_ id: String?) -> Bool {
        id == selectedPaymentMethodId
    }
    
    @MainActor
    func deleteCard(_ id: String?) {
        guard let id else { return }
        alertForDelete(card: id)
    }
    
    private func performDelete(card id: String) async {
        do {
            if try await DeleteCardUseCase().delete(cardId: id) {
                Task { @MainActor in
                    if self.selectedPaymentMethodId == id {
                        self.selectPaymentMethod("cash")
                    }
                    
                    self.cards.removeAll(where: {$0.cardId == id})
                    self.isEditing = !self.cards.isEmpty
                }
            }
        } catch {
            
        }
    }
    
    @MainActor
    private func alertForDelete(card id: String) {
        GlobalAlertManager.shared.showAlert(
            title: "warning".localize,
            message: "want.to.delete.card".localize,
            buttons: [
                CancelAlertButton(title: "cancel".localize, action: {
                    Task { @MainActor in
                        GlobalAlertManager.shared.dismiss()
                    }
                }),
                
                PrimaryAlertButton(title: "delete".localize, action: { [weak self] in
                    Task {
                        await self?.performDelete(card: id)
                        
                        Task { @MainActor in
                            GlobalAlertManager.shared.dismiss()
                        }
                    }
                })
            ]
        )
    }
}
