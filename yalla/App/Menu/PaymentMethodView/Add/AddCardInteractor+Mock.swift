//
//  AddCardInteractor+Mock.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 10/11/25.
//

import Foundation

struct AddCardMockInteractor: AddCardInteractorProtocol {
    func addCard(cardNumber: String, expiry: String) async throws -> String? {
        try await Task.sleep(for: .milliseconds(500))
        return UUID().uuidString
    }
    
    func verifyCard(key: String, code: String) async throws -> Bool {
        try await Task.sleep(for: .milliseconds(500))
        return true
    }
}
