//
//  HomeMapInteractor+Factory.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 12/11/25.
//

import Foundation

enum HomeMapInteractorFactory {
    static func create() -> any HomeMapInteractorProtocol {
        if ProcessInfoEnvironemnt.isMockEnabled {
            HomeMapMockInteractor()
        } else {
            HomeMapInteractor()
        }
    }
}
