//
//  PaymentMethodsInteractor.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 31/10/25.
//

import Foundation
import YallaKit

struct SendableCardItem: Sendable {
    var cardId: String?
    var isDefault: Bool?
    var expiry: String?
    var maskedPan: String
    var createdAt: String?
    
    init(cardId: String? = nil, isDefault: Bool? = nil, expiry: String? = nil, maskedPan: String, createdAt: String? = nil) {
        self.cardId = cardId
        self.isDefault = isDefault
        self.expiry = expiry
        self.maskedPan = maskedPan
        self.createdAt = createdAt
    }
    
    init(_ card: CardItem) {
        self.cardId = card.cardId
        self.isDefault = card.isDefault
        self.expiry = card.expiry
        self.maskedPan = card.maskedPan
        self.createdAt = card.createdAt
    }
}

extension SendableCardItem {
    public var type: CardType {
        .init(cardId: self.cardId ?? "cash")
    }
    
    public var miniPan: String {
        "**** " + self.maskedPan.suffix(4).description
    }
}


protocol PaymentMethodsInteractorProtocol: Sendable {
    func userInfo() async throws -> UserInfo?
    func delete(card: String) async throws -> Bool
    func appConfig() async throws -> AppConfig?
    func cardList() async throws -> [SendableCardItem]?
    func setPaymentMethod(_ method: String?) async throws
}

struct PaymentMethodsInteractor: PaymentMethodsInteractorProtocol {
    // set nil for cash
    func setPaymentMethod(_ method: String?) async throws {
        await TaxiOrderConfigProvider.shared.setPayment(type: method ?? "cash")
        
        return await SyncCardsUseCaseImpl.shared.setDefault(cardId: method ?? "cash")
    }
    
    func userInfo() async throws -> UserInfo? {
        MeInfoProvider.shared.userInfo
    }
    
    func delete(card: String) async throws -> Bool {
        try await DeleteCardUseCase().delete(cardId: card)
    }
    
    func appConfig() async throws -> AppConfig? {
        let useCase = AppConfigUseCaseImpl(maxTrial: 4)
        _ = try await useCase.fetchAppConfig()
        
        return useCase.appConfig
    }
    
    func cardList() async throws -> [SendableCardItem]? {
        await SyncCardsUseCaseImpl.shared.syncCards()
        return SyncCardsUseCaseImpl.shared.cards.map(SendableCardItem.init)
    }
}

struct PaymentMethodsMockInteractor: PaymentMethodsInteractorProtocol {
    func setPaymentMethod(_ method: String?) async throws {
        await TaxiOrderConfigProvider.shared.setPayment(type: method ?? "cash")
        try await Task.sleep(for: .milliseconds(500))
    }
    
    func cardList() async throws -> [SendableCardItem]? {
        [
            .init(cardId: UUID().uuidString, isDefault: false, expiry: nil, maskedPan: "**** 1234", createdAt: nil)
        ]
    }
    
    func userInfo() async throws -> UserInfo? {
        MeInfoProvider.shared.userInfo
    }
    
    func delete(card: String) async throws -> Bool {
        try await Task.sleep(for: .milliseconds(500))
        return true
    }
    
    func appConfig() async throws -> AppConfig? {
        .init(mapType: "google", setting: .init(executorLink: nil, facebook: nil, instagram: nil, inviteLinkForFriend: nil, paymentType: ["card", "cash"], privacyPolicyRu: nil, privacyPolicyUz: nil, supportEmail: nil, supportInstagramNickname: nil, supportPhone: nil, supportTelegramNickname: nil, telegramNickname: nil, textAboutAppRu: nil, textAboutAppUz: nil, textForNotServeThisRegionRu: nil, textForNotServeThisRegionUz: nil, youtube: nil), twoGisKey: nil)
    }
}
