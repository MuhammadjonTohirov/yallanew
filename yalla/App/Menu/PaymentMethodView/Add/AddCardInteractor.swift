//
//  AddCardInteractor.swift
//  yalla
//
//  Created by Claude on 31/10/25.
//

import Foundation
import YallaKit
import IldamSDK
import Core

protocol AddCardInteractorProtocol: Sendable {
    func addCard(cardNumber: String, expiry: String) async throws -> String?
    func verifyCard(key: String, code: String) async throws -> Bool
}

struct AddCardInteractor: AddCardInteractorProtocol {
    func addCard(cardNumber: String, expiry: String) async throws -> String? {
        let result = try await CardService.shared.addCard(
            request: .init(
                cardNumber: cardNumber.replacingOccurrences(of: " ", with: ""),
                expiry: expiry.replacingOccurrences(of: "/", with: "")
            )
        )
        
        return result?.key
    }
    
    func verifyCard(key: String, code: String) async throws -> Bool {
        let result = try await CardService.shared.verifyCard(
            request: .init(key: key, code: code)
        )
        
        return result
    }
}

