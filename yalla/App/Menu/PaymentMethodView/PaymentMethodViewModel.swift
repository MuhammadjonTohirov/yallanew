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

actor PaymentMethodsViewModel: ObservableObject {
    @MainActor
    @Published var cards: [CardItem] = []
    
    @MainActor
    @Published var isLoading: Bool = false
    
    @MainActor
    @Published var selectedPaymentMethodId: String? = "cash"
    
    @MainActor
    @Published var addCardView: Bool = false
    
    @MainActor
    @Published var isEditing: Bool = false
    
    @MainActor
    @Published var showEditCardSheet: Bool = false
    
    @MainActor
    @Published var bonusActive: Bool = false
    
    @MainActor
    var pageTitle: String {
        isEditing
        ? "edit.payment.methods".localize
        : "payment.methods".localize
    }
    
    @MainActor
    var pageDescription: String {
        isEditing
        ? "edit.choose.payment".localize
        : "choose.payment".localize
    }
    
    @MainActor
    var canEdit: Bool {
        !self.cards.isEmpty
    }
    
    @MainActor
    var isCardEnabled: Bool = false
    
    @MainActor
    var isCashEnabled: Bool = true
    
    @MainActor
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
    func selectPaymentMethod(_ id: String?) async {
        await MainActor.run {
            if id == "cash" && !isCashEnabled {
                    TaxiOrderConfigProvider.shared.setPayment(type: nil)
                return
            }
        }

        await MainActor.run {
            guard isCardEnabled else { return }
        }
        
        await MainActor.run {
            selectedPaymentMethodId = id
        }

        await MainActor.run {
            self.cards.forEach { item in
                item.isDefault = false
                if item.cardId == id {
                    item.isDefault = true
                }
            }
        }
        
        await SyncCardsUseCaseImpl.shared.setDefault(cardId: id ?? "cash")
        
        await MainActor.run {
            TaxiOrderConfigProvider.shared.setPayment(type: id)
        }
    }
    
    @MainActor
    func toggleEditMode() {
//        isEditing.toggle()
        showEditCardSheet = true
    }
    
    // Open Add Card View
    @MainActor
    func openAddCardView() {
        addCardView = true
    }
    
    @MainActor
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
                        Task {
                            await self.selectPaymentMethod("cash")
                        }
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
