//
//  PaymentMethods+Factory.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 10/11/25.
//

import Foundation
import Core

actor PaymentMethdosInteractorFactory {
    static func create() -> any PaymentMethodsInteractorProtocol {
        if ProcessInfoEnvironemnt.isMockEnabled {
            PaymentMethodsMockInteractor()
        } else {
            PaymentMethodsInteractor()
        }
    }
}
