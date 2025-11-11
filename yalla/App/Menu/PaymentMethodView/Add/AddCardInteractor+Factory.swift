//
//  AddCardInteractor+Factory.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 10/11/25.
//

import Foundation
import Core

actor AddCardInteractorFactory {
    static func create() -> any AddCardInteractorProtocol {
        if ProcessInfoEnvironemnt.isMockEnabled {
            AddCardMockInteractor()
        } else {
            AddCardInteractor()
        }
    }
}
