//
//  SelectAddressInteractor+Factory.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 12/11/25.
//

import Foundation

enum SelectAddressInteractorFactory {
    static func create() -> any SelectAddressInteractorProtocol {
        if ProcessInfoEnvironemnt.isMockEnabled {
            SelectAddressMockInteractor()
        } else {
            SelectAddressInteractor()
        }
    }
}
