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
import SwiftMessages
import NetworkLayer

actor PaymentMethodsViewModel: ObservableObject {
    @MainActor
    @Published var cards: [SendableCardItem] = []
    
    @MainActor
    @Published var isLoading: Bool = false
    
    @MainActor
    @Published var isDeleting: Bool = false
    
    @MainActor
    @Published var selectedPaymentMethodId: String? = "cash"
    
    @MainActor
    @Published var addCardView: Bool = false
        
    @MainActor
    @Published var showEditCardSheet: Bool = false
    
    var deletingCardId: String?

    @MainActor
    @Published var showDeleteCardAlert: Bool = false

    @MainActor
    @Published var bonusActive: Bool = false
        
    @MainActor
    var canEdit: Bool {
        !self.cards.isEmpty
    }
    
    @MainActor
    var isCardEnabled: Bool = false
    
    @MainActor
    var isCashEnabled: Bool = true
    
    @MainActor
    var bonus: Float = 0
    
    private var interactor: (any PaymentMethodsInteractorProtocol)
    
    init(interactor: (any PaymentMethodsInteractorProtocol) = PaymentMethodsMockInteractor()) {
        self.interactor = interactor
    }
    
    @MainActor
    private var bonusValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "uz_UZ")
        formatter.maximumFractionDigits = 0
        formatter.decimalSeparator = ""
        formatter.currencySymbol = ""
        let bonusVal = formatter.string(from: NSNumber(value: bonus)) ?? ""
        return bonusVal
    }
    
    @MainActor
    var bonusDescription: String {
        return "you.have.n.cashback".localize(arguments: bonusValue)
    }
    
    @MainActor
    func onAppear() {
        
        Task {
            await self.setIsLoading(true)
            do {
                let _bonus = try await interactor.userInfo()?.balance ?? 0
                let _isCardEnabled = try await interactor.appConfig()?.isCardPaymentEnabled ?? false

                await setBonus(_bonus)
                await setIsCardEnabled(_isCardEnabled)
                try await fetchCards()
            } catch {
                
            }
            
            await self.setIsLoading(false)
        }
    }

    func fetchCards() async throws {
        let _cards = try await interactor.cardList() ?? []
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.cards = _cards
            self.selectedPaymentMethodId = isCardEnabled ? _cards
                .first(where: {$0.isDefault ?? false})?.cardId ?? "cash" : "cash"
        }
    }
    
    // Select a payment method
    func selectPaymentMethod(_ id: String?) async {
        await setIsLoading(true)
        
        do {
            try await interactor.setPaymentMethod(id)
            await MainActor.run {
                self.selectedPaymentMethodId = id
            }
        } catch {
            await MainActor.run {
                Snackbar.show(message: error.serverMessage, theme: .error)
            }
        }
        
        await setIsLoading(false)
    }
    
    @MainActor
    func isMainCard(_ id: String?) -> Bool {
        selectedPaymentMethodId == id
    }
    
    @MainActor
    func toggleEditMode() {
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
    private func setIsCardEnabled(_ isEnabled: Bool) async {
        self.isCardEnabled = isEnabled
    }
    
    @MainActor
    private func setBonus(_ bonus: Float) async {
        self.bonus = bonus
    }
    
    // MARK: DeleteCard

    func deleteCard(_ id: String?) {
        guard let id else { return }
        let _deletingCardId = deletingCardId

        Task.detached { [weak self] in
            guard let self else { return }
            
            if let _deletingCardId, _deletingCardId == id {
                await performDelete(card: _deletingCardId)
                return
            }
            
            await alertForDelete(card: id)
        }
    }
    
    private func performDelete(card id: String) async {
        await setIsDeleting(true)

        deletingCardId = nil

        do {
            if try await interactor.delete(card: id) {
                await MainActor.run {
                    if self.selectedPaymentMethodId == id {
                        Task {
                            await self.selectPaymentMethod("cash")
                        }
                    }
                    
                    if self.cards.count == 1 {
                        self.showEditCardSheet = false
                    }
                    
                    self.cards.removeAll(where: {$0.cardId == id})
                    
                    Snackbar.show(message: "card.delete.success".localize, theme: .success)
                }
            }
        } catch {
            await MainActor.run {
                Snackbar.show(message: error.serverMessage, theme: .success)
            }
        }
        
        await setIsDeleting(false)
    }
    
    private func alertForDelete(card id: String) {
        Task { @MainActor in
            self.showDeleteCardAlert = true
        }
        self.deletingCardId = id
    }
    
    @MainActor
    private func setIsLoading(_ isLoading: Bool) async {
        self.isLoading = isLoading
    }
    
    @MainActor
    private func setIsDeleting(_ isDeleting: Bool) async {
        self.isDeleting = isDeleting
    }
}
