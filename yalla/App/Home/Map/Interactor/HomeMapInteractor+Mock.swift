//
//  HomeMapInteractor+Mock.swift
//  yalla
//
//  Created by Muhammadjon Tohirov on 12/11/25.
//

import Foundation
import IldamSDK
import CoreLocation

struct HomeMapMockInteractor: HomeMapInteractorProtocol {
    func fetchAddress(at location: CLLocation) async throws -> AddressResponse? {
        try await Task.sleep(for: .milliseconds(200))
        return .init(id: 0, lat: 40.392502, lng: 71.767258, name: "Oilaviy Klinika 2")
    }
}
