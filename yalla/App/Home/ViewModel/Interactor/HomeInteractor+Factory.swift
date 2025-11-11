//
//  HomeInteractor+Factory.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 10/11/25.
//

import Foundation
import Core

actor HomeInteractorFactory {
    static func create() -> any HomeInteractorProtocol {
        if ProcessInfoEnvironemnt.isMockEnabled {
            HomeMockInteractor()
        } else {
            HomeInteractor()
        }
    }
}
