//
//  HomeMapInteractor.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 12/11/25.
//

import Foundation
import IldamSDK
import CoreLocation

protocol HomeMapInteractorProtocol {
    func fetchAddress(at location: CLLocation) async throws -> AddressResponse?
}

struct HomeMapInteractor: HomeMapInteractorProtocol {
    func fetchAddress(at location: CLLocation) async throws -> AddressResponse? {
        try await GetAddressUseCaseWrapper().fetchAddress(at: location.coordinate)
    }
}
